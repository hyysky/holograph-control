%% 天线数据处理函数
function [dataProacom,dataSaveAnt,ADeckAng,EDeckAng]=processacom(strRec,AZCENTER,ELCENTER,ROWnum)
i = 0;
dataProacom = [];
dataSaveAnt = [];
str = strRec;
a='*/RTREQ';
while strncmp('*/RTREQ',str,7)
     n=strfind(str,a);
    if length(str(n:end))>=35 
        iswhole = (str(n+1)==47);
        if iswhole
            i = i+1;
            data = str(n+8:n+33);
            S=regexp(data,',','split');
            ADeckAng=str2double(char(S(1)));
            EDeckAng=str2double(char(S(2)));
            Count=str2double(char(S(3)));
            [ADeckAng,EDeckAng] = transform1(ADeckAng,EDeckAng);
            dAZ = ADeckAng-AZCENTER;
            dEL = EDeckAng-ELCENTER;
            dataProacom(i,:) = [Count,ROWnum,dAZ,dEL];
            dataSaveAnt(i,:) = [Count,ADeckAng,EDeckAng];
            str = str(n+35:end);
        else
            str = str(n+1:end);
        end
    else
        str = str(n:end);
    end
end