%% 斜轴-方位轴坐标与俯仰-方位轴坐标转化函数
function [AZ1,EL1]=transform(AZ2,EL2)
EL1 = acosd(1-2*sin(EL2*pi/180));
AZ1 = AZ2-atand(sqrt(2*sin(EL2*pi/180)/(1-sin(EL2*pi/180))));
end