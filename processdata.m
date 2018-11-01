%% 数字相关器数据处理
function  [dataPro,numPro,strRec] = processdata(strRec,numPro)
i = 0;%已解析数据行数
str = strRec;
dataPro = [];
while find(str==10,1)
    n = find(str==10,1);
    if length(str(n:end))>=40
        iswhole = (str(n+1) == 13) & (str(n+39) == 65);
        if iswhole
            i = i+1;
            data1(i,:) = str(n:n+39);
            Idx = parse_intcountrx(data1(i,3:6));
            %fprintf('Idx :%d\n',Idx);
            Asi = parse_int(data1(i,7:14));
            %fprintf('Asi :%d\n',Asi);
            Ari = parse_int(data1(i,15:22));
            %fprintf('Ari :%d\n',Ari);
            Ic = parse_int(data1(i,23:30));
            %fprintf('Ic :%d\n',Ic);
            Qc = parse_int(data1(i,31:38));
            %fprintf('Qc :%d\n',Qc);
            Pha = atan2d(Qc,Ic);
            dataPro(i,:) = [Idx,Asi,Ari,Ic,Qc,Pha];
            numPro = numPro+1;
            str = str(n+40:end);
        else
            str = str(n+1:end);
        end
    else
          str = str(n:end);
          break;
    end
end
strRec = str;