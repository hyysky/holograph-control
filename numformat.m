%% 数据格式转换函数1
function [output]=numformat(input)
if input>=0&&input<10
    output=strcat('000',num2str(input,'%.4f'));
elseif input>=10&&input<100
    output=strcat('00',num2str(input,'%.4f'));
elseif input>=100&&input<1000
    output=strcat('0',num2str(input,'%.4f'));
elseif input<0&&input>-10
    output=strcat('-00',num2str(abs(input),'%.4f'));
elseif input<=-10&&input>-100
    output=strcat('-0',num2str(abs(input),'%.4f'));
elseif input<=-100&&input>-1000
    output=num2str(input,'%.4f');
else
    msgbox('数据格式错误！');
    return;
end