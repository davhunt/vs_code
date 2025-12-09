function [] = display_brocas_decoding_results()

    fprintf(['Decoding accuracies using ROIs:\n'])
    for sub = [1 2 3 4 5 6 7 8 9 10 13 14 15 16 17 18 19 20 21 22 23 24]
    %for sub = [1 2]
        sub = sprintf('%02d', sub);
        %acc44 = 0; acc45 = 0; acc47 = 0;
        %for roi = ['BA44','BA45','BA47']
        out_msg = [];
        for roi = ["BA44", "BA45", "BA47"]
            acc = 0;
            for r = 1:10
                B = load(['/Volumes/data1/Complex_seq_analysis/0' sub '/MVPA/durations_unsmoothed_native/TDT_results_brocas/' char(roi) '/TDT_results_rep' num2str(r, '%02d') '/res_accuracy_minus_chance.mat'],'results');
                acc = acc + B.results.accuracy_minus_chance.output;
            end
            out_msg = [out_msg '      ' sprintf(['Sub %s with %s: %f%%'], sub, roi, (acc/10)+50)];
            %fprintf(['Sub %s with %s: %f%%\n'], sub, roi, (acc/10)+50)            
        end
        disp(out_msg)
    end
end
