function [T1,T2,Flair,Lesion] = load_data(FileSource)
if strcmp(FileSource,'brainWeb')
    [Flair,scaninfo] = loadminc('pd_ai_msles2_1mm_pn3_rf20.mnc');
    [T2,scaninfo] = loadminc('t2_ai_msles2_1mm_pn3_rf20.mnc');
    [T1,scaninfo] = loadminc('t1_ai_msles2_1mm_pn3_rf20.mnc');
    [Lesion,scaninfo] = loadminc('phantom_1.0mm_msles2_wml.mnc');
else
    [ T2, info ] = readnrrd('CHB_train_Case01_T2.nhdr');
    [ T1, info ] = readnrrd('CHB_train_Case01_T1.nhdr');
    [ Lesion, info ] = readnrrd('CHB_train_Case01_lesion.nhdr');
    [ Flair, info ] = readnrrd('CHB_train_Case01_FLAIR.nhdr');
    T1=double(T1);
    T2=double(T2);
    Flair=double(Flair);
end

