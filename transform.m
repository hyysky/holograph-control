%% б��-��λ�������븩��-��λ������ת������
function [AZ1,EL1]=transform(AZ2,EL2)
EL1 = acosd(1-2*sin(EL2*pi/180));
AZ1 = AZ2-atand(sqrt(2*sin(EL2*pi/180)/(1-sin(EL2*pi/180))));
end