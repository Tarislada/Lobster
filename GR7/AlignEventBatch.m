% Automation
loc0 = 'C:\VCF\Lobster\data\rawdata\';
loc1 = dir(loc0);
loc2 = {loc1.name};
loc2 = loc2(3:end);

for i = 1 : numel(loc2) % ��� ������ ���ؼ�
    if contains(loc2{i}, 'suc') % suc ������ ���
        isSuc = true;
    else % suc �����Ͱ� �ƴ϶��
        isSuc = false;
    end
    
    filename_raw = dir(strcat(loc0,loc2{i},'\*.mat'));
    filename_raw = {filename_raw.name};
    filename = filename_raw(1:end-1);
    
    pathname = strcat(loc0,loc2{i},'\');
    
    Paths = strcat(pathname,filename);
    if (ischar(Paths))
        Paths = {Paths};
        filename = {filename};
    end
    
    targetfiles = true;
    
    AlignEvent;
    
    clearvars -except loc0 loc1 loc2 i;
end
        
