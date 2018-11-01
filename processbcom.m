function [dataProbcom,dataSaveAnt,ADeckAng,EDeckAng]=processbcom(strRec,AZCENTER,ELCENTER,ROWnum)
i = 0;%已解析数据行数
str = strRec;
dataProbcom = [];
dataSaveAnt = [];
while find(str==235,1)
    n = find(str==235,1);
    if length(str(n:end))>=20
        iswhole = (str(n+1) == 203);
        if iswhole
            i = i+1;
            data1(i,:) = str(n:n+19);
            ADeckAng = parse_intant(data1(i,3:6));
            EDeckAng = parse_intant(data1(i,11:14));
            Count = parse_intcount(data1(i,16:18));
            [ADeckAng,EDeckAng] = transform1(ADeckAng,EDeckAng);
            dAZ = ADeckAng-AZCENTER;
            dEL = EDeckAng-ELCENTER;
            dataProbcom(i,:) = [Count,ROWnum,dAZ,dEL];
            dataSaveAnt(i,:) = [Count,ADeckAng,EDeckAng];
            str = str(n+20:end);
        else
            str = str(n+1:end);
        end
    else
        str = str(n:end);
    end
end