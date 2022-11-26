

% uinp = '20-30'
str1 = split(uinp,',')';
nrang = length(str1);
rang = [];
if nrang > 1
    for i = 1:nrang
        str2 = split(str1{i},'-')';
        if length(str2)==2
            rang = [rang; str2double(str2{1}) str2double(str2{2})];
        else
            rang = [rang; str2double(str2{1}) str2double(str2{1})];
        end
        clear str2;
    end
%     rangc = [];
    rangc = 1:rang(1,1)-1;
    for i = 1:nrang-1
        rangc = [rangc rang(i,2)+1:rang(i+1,1)-1];
    end
    rangc = [rangc rang(i+1,2)+1:sx]
elseif nrang == 1
    str2 = split(str1{1},'-')';
    if length(str2)==2
        rang = [rang; str2double(str2{1}) str2double(str2{2})];
    else
        rang = [rang; str2double(str2{1}) str2double(str2{1})];
    end
%     rangc = [];
    rangc = 1:rang(1,1)-1;
    if rang(1,2) < sx
        rangc = [rangc rang(1,2)+1:sx]
    end
end
