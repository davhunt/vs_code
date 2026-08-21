function run_language_lss(spreadsheetFile, sheetName, subjID, windowTag, ...
                          runNiftiPattern, outRoot, TR)
% run least-squares-separate GLM beta estimation for sentence reading task
% Mumford, Jeanette A., et al. "Deconvolving BOLD activation in event-related designs for multivoxel 
% pattern classification analyses." Neuroimage 59.3 (2012): 2636-2643.
% from https://github.com/LukasNeugebauer/least_squares_separate/blob/master/least_squares_separate.m
% Reads the master spreadsheet, selects one subject and one window tag,
% builds run-wise inputs for least_squares_separate.m, runs LSS, and
% renames the resulting beta images using sentence_ID.
%
% INPUTS
%   spreadsheetFile : full path to Excel workbook
%   sheetName       : sheet to read (e.g. 'SPM_Events')
%   subjID          : subject identifier as stored in the spreadsheet (not zero-padded)
%   analysisTag     : 'AP', 'ORCA', or 'AGR'
%   windowTag       : e.g. 'whole_sentence', 'postNP', 'fixed4', 'windowType1'
%   runNiftiPattern : sprintf-style pattern for preprocessed block files
%                    Example:
%                    "/Volumes/data1/Implicit_Learning/Sentence_reading/0%s/block%d_merged.nii.gz"
%                    where %s=subjID and %d=block number
%   outRoot         : output folder root for beta maps
%   TR              : repetition time in seconds
%
% EXPECTED SPREADSHEET COLUMNS
%   subject
%   scanner_sequence_number
%   trial
%   sentence_ID
%   pair_number_alphabetical
%   grammar_type
%   grammaticality
%   <windowTag>_onset
%   <windowTag>_duration
%
% NOTES
%.  - 'windowTag' determines the column to get onsets and durations from, determines what is considered
%         the duration of the stimulus, want to match up between contrasting conditions to ensure no systematic
%         biases
%   - 'BlockOrder' is your run-like unit.
%         ^^ 1 through 4 here, simpler than alternating between 5-8 and 6-9 for odd/even subjects
%   - pair_id is extracted from pair_number_alphabetical column
%   - The LSS implementation accepts VY and onsets as cell arrays with one
%     cell per run/block when multiple runs are used.

    arguments
        spreadsheetFile (1,1) string
        sheetName       (1,1) string
        subjID          (1,1) string
        windowTag       (1,1) string
        runNiftiPattern (1,1) string
        outRoot         (1,1) string
        TR              (1,1) double
    end

    if exist('spm_vol', 'file') ~= 2
        error('SPM is not on the MATLAB path.');
    end

    if exist('least_squares_separate', 'file') ~= 2
        error('least_squares_separate.m is not on the MATLAB path.');
    end

    % Read the Excel spreadsheet
    T = readtable(spreadsheetFile, "Sheet", sheetName);

    requiredCols = ["subject","scanner_sequence_number","trial","sentence_ID","pair_number_alphabetical","grammar_type","grammaticality", ...
                    windowTag + "_onset",windowTag + "_duration"];

    missingCols = setdiff(requiredCols, string(T.Properties.VariableNames));
    if ~isempty(missingCols)
        error("Missing required column(s): %s", strjoin(missingCols, ", "));
    end

    T.subject        = string(T.subject);
    T.sentence_ID  = string(T.sentence_ID);
    T.grammar_type    = string(T.grammar_type);
    T.grammaticality = string(T.grammaticality);
    T.pair_id = string(T.pair_number_alphabetical);
    onsetVar = windowTag + "_onset";
    durVar   = windowTag + "_duration";

    subjString = sprintf("%02d", str2num(subjID)); % later filepaths require two digit subject IDs
    T = T(T.subject == subjID, :);
    if isempty(T)
        error('No rows matched subject=%s.', subjID);
    end

    % Group by block
    blocks = unique(T.scanner_sequence_number, 'stable');
    nBlocks = numel(blocks);

    VY       = cell(1, nBlocks);
    VY_files = cell(1, nBlocks);
    onsets   = cell(1, nBlocks);
    nuisance = cell(1, nBlocks);
    head_motion_rps = dir(sprintf('/Volumes/data1/Implicit_Learning/Sentence_reading/0%s/rp_*.txt',subjString));
    if size(head_motion_rps,1) ~= nBlocks
        error('Number of rp_* files %d does not match number of blocks %d',size(head_motion_rps,1),nBlocks);
    end

    betaMeta = table(); % store metadata in table, use in renaming beta files

    % Build run/block-wise LSS inputs
    betaCounter = 0;
    for b = 1:nBlocks
        blockID = blocks(b);
        Tb = T(T.scanner_sequence_number == blockID, :);

        % Sort by onset because least_squares_separate names betas in onset order within each run/block.
        % So beta orders will not match up with row order in Excel file but that's ok
        % Check .csv file in folder to see which trials = which betas
        [~, ord] = sort(Tb.(onsetVar), 'ascend');
        Tb = Tb(ord, :);

        % Load the preprocessed fMRI volumes for this block.
        % The LSS code wants VY as the spm_vol output. For multiple runs, VY is a cell array with one entry per run/block.
        VY_files{b} = char(sprintf(runNiftiPattern, subjString, b)); % blockX_merged.nii.gz
        VY{b} = spm_vol(char(sprintf(runNiftiPattern, subjString, b)));

        % grand mean scale (each) run to 100
        g = zeros(numel(VY{b}),1);
        for t = 1:numel(VY{b})
            g(t) = spm_global(VY{b}(t));
        end
        gSF(b) = 100 / mean(g);

        if isfield(VY{b}, 'dat')
            VY{b} = rmfield(VY{b}, 'dat'); % script doesn't like 'dat' (only GZIPPED niftis?)
        end

        % Build the onset/duration structure array expected by LSS.
        trialOnsets = Tb.(onsetVar);
        trialDur    = Tb.(durVar);

        % LSS function wants onsets and durations in 'onsets' struct
        onsets{b} = arrayfun(@(o,d) struct('onset', o, 'duration', d), ...
                             trialOnsets, trialDur);

        % Add head motion nuisance regressors, make sure they match up with # volumes in each fMRI block
        nuisance{b} = load(sprintf('/Volumes/data1/Implicit_Learning/Sentence_reading/0%s/%s', subjString, head_motion_rps(b).name));
        if size(nuisance{b}, 1) ~= numel(VY{b})
            error(['Motion file for block %d has %d rows, but the fMRI block contains %d volumes.'], ...
                      blockID, size(nuisance{b}, 1), numel(VY{b}));
        end

        % Metadata table for bookkeeping and renaming.
        nTrials = height(Tb);
        betaIdx  = (betaCounter + 1) : (betaCounter + nTrials);

        tmpMeta = table();
        tmpMeta.subject         = repmat(Tb.subject(1), nTrials, 1);
        tmpMeta.block           = repmat(Tb.scanner_sequence_number(1), nTrials, 1);
        tmpMeta.trial           = Tb.trial;
        tmpMeta.pair_id         = Tb.pair_id;
        tmpMeta.sentence_ID   = Tb.sentence_ID;
        tmpMeta.grammar_type    = Tb.grammar_type;
        tmpMeta.grammaticality  = Tb.grammaticality;
        tmpMeta.windowTag       = repmat(string(windowTag), nTrials, 1);
        tmpMeta.window_onset    = trialOnsets;
        tmpMeta.window_duration = trialDur;
        tmpMeta.beta_index      = betaIdx(:);

        betaMeta = [betaMeta; tmpMeta];
        betaCounter = betaCounter + nTrials;
    end

    subjOutDir = fullfile(outRoot, subjString, windowTag);
    if ~exist(subjOutDir, 'dir')
        mkdir(subjOutDir);
    end

    % Save inputs used for this run.
    %save(fullfile(subjOutDir, sprintf('%s_%s_%s_lss_inputs.mat', subjID, analysisTag, windowTag)), ...
    %     'VY', 'onsets', 'nuisance', 'TR', 'subjID', 'analysisTag', 'windowTag', 'betaMeta','-v7.3');
    save(fullfile(subjOutDir, sprintf('sub-%s_%s_lss_inputs.mat', subjID, windowTag)), ...
         'VY_files', 'onsets', 'nuisance', 'TR', 'subjID', 'windowTag', 'betaMeta');


    writetable(betaMeta, fullfile(subjOutDir, sprintf('sub-%s_%s_beta_metadata.csv', subjID, windowTag)));

    % https://github.com/LukasNeugebauer/least_squares_separate/blob/master/least_squares_separate.m
    least_squares_separate(VY, onsets, char(subjOutDir), TR, 'nuisance', nuisance, 'gSF', gSF);
    % added optional global scaling factor to function

    % Rename beta files using sentence_ID
    rename_lss_betas(subjOutDir, betaMeta, subjString, windowTag);

    fprintf('Done: %s | %s\n', subjID, windowTag);
end

function rename_lss_betas(subjOutDir, betaMeta, subjString, windowTag)

    % Renames LSS outputs from lss_beta_####.nii to the sentence IDs, for clarification
    % This assumes the output beta order matches betaMeta.beta_index.

    betaFiles = dir(fullfile(subjOutDir, 'lss_beta_*.nii'));

    if isempty(betaFiles)
        warning('No LSS beta files found in %s, LSS failed.', subjOutDir);
        return;
    end

    % Sort by file name because the names are zero-padded.
    [~, ord] = sort({betaFiles.name});
    betaFiles = betaFiles(ord);

    if numel(betaFiles) ~= height(betaMeta)
        warning(['Found %d beta files but %d metadata rows, skipping rename step.'], numel(betaFiles), height(betaMeta));
        return;
    end

    for k = 1:numel(betaFiles)
        oldPath = fullfile(subjOutDir, betaFiles(k).name);
        newPath = fullfile(subjOutDir, sprintf('beta_%s', betaMeta.sentence_ID(k)) + ".nii");
        if exist(newPath, 'file')
            warning('Target file already exists, skipping: %s', newPath);
            continue;
        end
        movefile(oldPath, newPath);
    end
end
