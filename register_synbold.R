#subs <- c("03", "04", "05", "06", "07", "08", "09", "10", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24")
#subs <- c("03", "04")
subs <- c("05", "06", "07", "08", "09", "10", "13", "14", "15", "16", "17", "18", "19", "20", "21", "22", "23", "24")

for (sub in subs) {
    moving <- antsImageRead(paste0("/Volumes/data1/T1_and_Complex_seq/0", sub, "/func_mean.nii.gz"), dimension = 3) # mean BOLD image
    sub_files <- list.files(paste0("/Volumes/data1/T1_and_Complex_seq/0", sub), full.names = FALSE) # Match regexp to get both T1's
    structurals <- grep("^s[0-9]+toms.*$", sub_files, value = TRUE)
    fixed <- paste0("/Volumes/data1/T1_and_Complex_seq/0", sub, "/", structurals[1]) # Again take first structural scan, non-NORM one
    fixed <- antsImageRead(fixed)
    reg <- antsRegistration(fixed = fixed, moving = moving, typeofTransform = "SyNBold") # SyNBold
    file.copy(reg$fwdtransforms, c(paste0("/Users/lab/Downloads/ants_registrations/", sub, "/synbold/epi_to_t1_0GenericAffine.mat"), paste0("/Users/lab/Downloads/ants_registrations/", sub, "/synbold/epi_to_t1_1Warp.nii.gz")))
    file.copy(reg$invtransforms, c(paste0("/Users/lab/Downloads/ants_registrations/", sub, "/synbold/invwarp_t1_to_epi_0GenericAffine.mat"), paste0("/Users/lab/Downloads/ants_registrations/", sub, "/synbold/invwarp_t1_to_epi_1InverseWarp.nii.gz")))
}