[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

targetdir = uigetdir();

for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    A2_GR_singleUnit_anlyzer_JH;
    A3_GR_PSTH_v2_JH;
end