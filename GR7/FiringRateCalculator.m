%% FiringRateCalculator

%% ����� ���� ��� prompt
[filename, pathname] = uigetfile('.mat', 'MultiSelect', 'on');
if isequal(filename,0)
    return;
end
Paths = strcat(pathname,filename);
if (ischar(Paths))
    Paths = {Paths};
    filename = {filename};
end

clearvars pathname

%% �� ���Ϻ��� �����͸� �ҷ��� �� �ʴ� spike�� ���� ����
data = cell(numel(Paths),1);
for f = 1 : numel(Paths)
    load(Paths{f});
    neuronname = filename{f};
    timestamp = table2array(SU(:,1));
    timerange = floor(timestamp(end)); % �� �ð� �ٷ� ���������� �����͸� ����ؼ� �ʴ� firingrate Ƚ���� ����.
    spikes = zeros(timerange,1);
    for ts = 1 : timerange
        spikes(ts,1) = sum(and(timestamp<ts, timestamp>=ts-1));
    end
    data{f,1} = spikes;
    histdat = histogram(spikes,0:100);
    data{f,2} = histdat.Values;
    data{f,3} = mean(spikes);
    data{f,4} = median(spikes);
    data{f,5} = mode(spikes);
    clearvars SU
    fprintf('%d / %d �Ϸ�\n',f, numel(Paths));
end

accumhist = zeros(1,100);
for i = 1 : numel(Paths)
    accumhist = accumhist + data{i,2};
end

figure(1);
bar(accumhist(1:10));
title('Accum_histogram');

figure(2);
histogram([data{:,3}],0:10);
title('Mean');

figure(3);
histogram([data{:,4}],0:10);
title('Median');

figure(4);
histogram([data{:,5}],0:10);
title('Mode');
