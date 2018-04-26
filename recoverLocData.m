function [ recoveredLocData ] = recoverLocData( originalLocData )
% tracking loss�� ���� ������ �ս� �κ��� �ֺ� �����͸� ���� �����ؼ� �籸��.
    % ���� ���캻 �ٿ� ������ tracking�� ����� ��� X �����ʹ� -1, Y �����ʹ� 481�� ���� ���ϰ� �ȴ�.
    % �̷��� ���� �߰��� �����ϰ� �Ǹ� �� ���� �����͸� ���� �����ؼ� loss�� ���� �κ��� ������ �����͸� ����Ѵ�.
    % ���� �κ� �� ���� �������� ���̰� ũ�� ������ ����Ѵ�.
    % @Knowblesse 2018
    
    % argument :
    % originalLocData cell(2,2);
    
    
    %% CONSTANTS 
    % �������� �������� ������ ������ �ش�.
    X_RANGE = [0,350];
    Y_RANGE = [100,600];
    
    %% Check Data Format
    type = whos('originalLocData');
    
    if ~strcmp(type.class, 'cell') && isequal(type.size,[2,2])
        error('Wrong type argument');
    end
    
    %% Check Loss point
    dataLength = size(originalLocData{1},1); % ���� �������� ũ��
    points_1 = [];
    points_2 = [];
    
    wrongFlag_1 = false;
    wrongFlag_2 = false;
    
    for i = 1 : dataLength % ��� �����Ϳ� ���ؼ�
        % Loss point 1 ( ������ XY )
        if ~and(...
                and(X_RANGE(1)<originalLocData{1}(i),originalLocData{1}(i) < X_RANGE(2)),...
                and(Y_RANGE(1)<originalLocData{2}(i),originalLocData{2}(i) < Y_RANGE(2))...
                )
            % X ��ǥ�� X_RANGE �ȿ� ���� �ʰų�, Y ��ǥ�� Y_RANGE �ȿ� ���� ������ ƨ�����.
            if wrongFlag_1 == false
                wrongFlag_1 = true;
                points_1 = [points_1;[i,0]];
            end
        % No Loss Point 1
        else
            if wrongFlag_1 == true
                wrongFlag_1 = false;
                points_1(end,2) = i-1;
            end
        end
        % Loss point 2 ( �ʷϻ� XY )
        if ~and(...
                and(X_RANGE(1)<originalLocData{3}(i),originalLocData{3}(i) < X_RANGE(2)),...
                and(Y_RANGE(1)<originalLocData{4}(i),originalLocData{4}(i) < Y_RANGE(2))...
                )
            % X ��ǥ�� X_RANGE �ȿ� ���� �ʰų�, Y ��ǥ�� Y_RANGE �ȿ� ���� ������ ƨ�����.
            if wrongFlag_2 == false
                wrongFlag_2 = true;
                points_2 = [points_2;[i,0]];
            end
        % No Loss Point 2
        else
            if wrongFlag_2 == true
                wrongFlag_2 = false;
                points_2(end,2) = i-1;
            end
        end
    end
    
    
    % �ʹݿ� tracking�� �ȵǰ� �ִ� ������ �����ʹ� ó������ tracking�� �� �������� ��ü
    recoveredLocData = originalLocData;
    recoveredLocData{1}(1:points_1(1,2)) = recoveredLocData{1}(points_1(1,2)+1); 
    recoveredLocData{2}(1:points_1(1,2)) = recoveredLocData{2}(points_1(1,2)+1); 
    recoveredLocData{3}(1:points_2(1,2)) = recoveredLocData{3}(points_2(1,2)+1); 
    recoveredLocData{4}(1:points_2(1,2)) = recoveredLocData{4}(points_2(1,2)+1); 
    warning(['���� LED�� ó�� ',num2str(points_1(1,2)), ' ���� ����Ʈ�� tracking���� ���Ͽ����ϴ�.']);
    warning(['�ʷ� LED�� ó�� ',num2str(points_2(1,2)), ' ���� ó�� ����Ʈ�� tracking���� ���Ͽ����ϴ�.']);
    
    points_1(1,:) = [];
    points_2(1,:) = [];
    
    %% Compensation
    %TODO ���߿��� �� ������ ���� ������� �� �����ĳִ°� �ƴ϶� interp1 �Լ��� ������Ű�� ����� ���� ��
    for i = 1 : size(points_1,1)-1 % Red LED tracking ��ģ ���� ����������
        if abs(points_1(i,2) - points_1(i,1)) > 100
            warning(['tracking�� ��Ⱓ ������������.  index : ', num2str(abs(points_1(i,1) - points_1(i,2))), ' points']);
        end
        for l = 1 : 2
            compensateData = originalLocData{l}(points_1(i,1)-1) + round((originalLocData{l}(points_1(i,2)+1) - originalLocData{l}(points_1(i,1)-1)) / 2 );
            recoveredLocData{l}(points_1(i,1):points_1(i,2)) = compensateData;
        end
    end
    for i = 1 : size(points_2,1)-1 % Green LED tracking ��ģ ���� ���������� �� ���������� 
        if abs(points_2(i,2) - points_2(i,1)) > 100
            warning(['tracking�� ��Ⱓ ������������.  index : ', num2str(abs(points_2(i,1) - points_2(i,2))), ' points']);
        end
        for l = 3 : 4
            compensateData = originalLocData{l}(points_2(i,1)-1) + round((originalLocData{l}(points_2(i,2)+1) - originalLocData{l}(points_2(i,1)-1)) / 2 );
            recoveredLocData{l}(points_2(i,1):points_2(i,2)) = compensateData;
        end
    end
    % points �� ���� ������ ������ �κ��� ���� ���� �κ��̹Ƿ�, ���󰡱� ������ ������ �����ش�.
    recoveredLocData{1}(points_1(end,1):end) = recoveredLocData{1}(points_1(end,1)-1);
    recoveredLocData{2}(points_1(end,1):end) = recoveredLocData{2}(points_1(end,1)-1);
    recoveredLocData{3}(points_2(end,1):end) = recoveredLocData{3}(points_2(end,1)-1);
    recoveredLocData{4}(points_2(end,1):end) = recoveredLocData{4}(points_2(end,1)-1);

end
