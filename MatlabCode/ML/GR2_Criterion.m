%% CriterionSelector
[Neurons, Neuron_names] = loadAlignedData();
numNeuron = numel(Neurons);


%% Get fr and z data
CheckList = zeros(numNeuron,3);
for f = 1 : numNeuron
    CheckList(f,1) = Neurons{f}.FR_trial;
    CheckList(f,2) = max(abs(Neurons{f}.IRON));
    CheckList(f,3) = max(abs(Neurons{f}.IROF));
end

%% Constants
minimumFR = 0.2;
minimumZ = 2;

%% MakeList
% Col1 : �� ��ȣ
% Col2 : ������
% Col3 : �������� �� ��������
% Col4 : IRON�� �������ú� 
% Col5 : IROF�� �������ú�
list = cell(numNeuron,3);
for i = 1 : numNeuron    
    list{i,1} = i;
    list{i,2} = Neuron_names;
    list{i,3} = 0;
    list{i,4} = 0;
    list{i,5} = 0;
end
clearvars t1 t2

%% Mark Criterion Selected data
for i = 1 : numNeuron
    if CheckList(i,1) > minimumFR
        if CheckList(i,2) > minimumZ % is IRON responsive 
            list{i,3} = 1;
            list{i,4} = 1;
        end
        if CheckList(i,3) > minimumZ % is IROF responsive
            list{i,3} = 1;
            list{i,5} = 1;
        end
    end
end
