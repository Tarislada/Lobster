% runthis �� automation

% Automation
loc0 = 'C:\VCF\Lobster\data\rawdata\';
loc1 = dir(loc0);
loc2 = {loc1.name};
loc2 = loc2(3:end);

%% Save Data Location
savepath = 'C:\VCF\Lobster\data\processedData\NeuronProfile\';

for i = 1 : numel(loc2) % ��� ������ ���ؼ�
    if ~contains(loc2{i}, 'suc') % suc ������ ��� �ȵ���
        %% Neuron.mat ���ϸ���Ʈ �ڵ� ����
        filename_raw = dir(strcat(loc0,loc2{i},'\*.mat'));
        filename_raw = {filename_raw.name};
        filename = filename_raw(1:end-1); %UNIT ���� ����

        pathname = strcat(loc0,loc2{i},'\');

        Paths = strcat(pathname,filename);
        if (ischar(Paths))
            Paths = {Paths};
            filename = {filename};
        end
        %% �� Unit data ���� timewindow�� ���� �����͸� �̾Ƴ�.
        for f = 1 : numel(Paths) % ������ ������ Unit Data�� ���ؼ�...
            %% parse filename
            filename_date = filename{f}(strfind(filename{1},'GR7-')+6:strfind(filename{1},'GR7-')+9);
            temp1 = strfind(filename{f},'_');
            temp2 = strfind(filename{f},'.mat');
            filename_cellnum = filename{f}(temp1(end)+1:temp2-1);

            filename_ = strcat(filename_date,'_',filename_cellnum);
            
            %% Run
            
            %% A2
            ts = A2function(Paths{f},strcat(savepath,filename_));
            fprintf('A2 Complete\n');

            %% EVENT data ��� ���� �� �ҷ�����
            if exist(strcat(pathname,'EVENTS'),'dir') == 7 % ���� ��ġ�� EVENTS ������ ����
                targetdir = strcat(pathname,'EVENTS');
            else
                targetdir = uigetdir('','Select EVENT Folder'); % ���� ��ġ�� EVENT ������ ������ ����ڿ��� ���.
                if isequal(targetdir,0)
                    return;
                end
            end

            [TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF]=GambleRatsBehavParser(targetdir);
            [ParsedData, Trials, IRs, Licks, Attacks ] = BehavDataParser(targetdir);
            AnalyticValueExtractor; % Avoid Escape ����

            %% TRON�� TROF�� Avoid�� Escape�ĸ� �������� ����
            TRON_A = [];
            TROF_A = [];
            TRON_E = [];
            TROF_E = [];

            for tr = 1 : numel(TRON) % ��� trial �� ���ؼ�
                if behaviorResult(tr) == 'A'
                    TRON_A = [TRON_A;TRON(tr)];
                    TROF_A = [TROF_A;TROF(tr)];
                elseif behaviorResult(tr) == 'E'
                    TRON_E = [TRON_E;TRON(tr)];
                    TROF_E = [TROF_E;TROF(tr)];
                end
            end

            %% Avoid�� �ش��ϴ� �� ���� A3�� ����.
            TRON = TRON_A;
            TROF = TROF_A;
            A3function(ts, TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF,strcat(savepath,filename_,'_2.png'));

            %% Escape�� �ش��ϴ� ���� A3�� ����.
            TRON = TRON_E;
            TROF = TROF_E;
            A3function(ts, TRON, TROF, IRON, IROF, LICK, LOFF, ATTK, ATOF,strcat(savepath,filename_,'_3.png'));
            fprintf('Avoid : %d | Escape : %d | Total : %d\n',sum(behaviorResult == 'A'), sum(behaviorResult == 'E'), numel(behaviorResult));   
            

            clearvars -except loc0 loc1 loc2 i savepath f Paths filename pathname;
        end
    end
end