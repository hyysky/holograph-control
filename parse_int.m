
%%  数据类型转换
function res = parse_int( data )
    res_temp=0;
    res_temp1=0;
    res_temp2=0; 
    if data(8)<128
        for i=8:-1:1
           res_temp = data(i)*256^(i-1)+res_temp;
        end 
        res =  res_temp;
    elseif data(8)>=128
        for i=8:-1:5
            res_temp1 = res_temp1*256+data(i);
        end
            res1 = -1*bitcmp(res_temp1,'uint32');
        for i=4:-1:1
            res_temp2 = res_temp2*256+data(i);
        end
            res2 = -1*bitcmp(res_temp2,'uint32'); 
        res = res1*256^4+res2;
    end
end