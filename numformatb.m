%% 数据格式转换函数2
function [output]=numformatb(input)
% if input>=0&&input<=1
if input>=0
    output=strcat('0',num2str(input,'%.3f'));
% elseif input<0&&input>=-1
elseif input<0
    output=strcat('-',num2str(abs(input),'%.3f'));
else
    msgbox('数据格式错误！');
    return;
end