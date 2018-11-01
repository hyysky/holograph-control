%%  数据类型转换
function res = parse_intant( data )
    i=0;
    res_temp=0;
    for i=1:1:length(data);
       res_temp = data(i)*256^(i-1)+res_temp;
    end 
    if res_temp> 2.1475e+09
        res = -1*bitcmp(res_temp-1,'uint32');
    else 
        res =  res_temp;
    end
    res = res/10000;
end