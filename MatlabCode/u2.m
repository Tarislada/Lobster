function  = u2(varargin)
%% draw plot with horizontal scroll bar



%% Parse varargin
numArgin = length(varargin);
if numArgin == 1 % data only
    data = varargin;
elseif rem(numArgin,2) == 1 % n*pairs + data == odd number
    data = varargin(1);
    for pair = reshape(varargin(2:end),2,[])
        pname = lower(pair{1}); % case insensitive
        if any(strcmp(pname,possiblePname))
            
    end
    
    
    
else
    error('Please check propertyName/propertyValue pairs');
end



