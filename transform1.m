%% 俯仰-方位轴坐标与斜轴-方位轴坐标转化函数
function [AZ,EL]=transform1(AZ1,EL1)
EL = asind((sin(EL1*pi/360))^2);
AZ = AZ1+atand(sqrt(2)*tan(EL1*pi/180/2));
end