function res = parse_intcountrx( data )
    i=0;
    res_temp=0;
    for i=length(data):-1:1;
       res_temp = data(i)*256^(i-1)+res_temp;
    end 
    if res_temp>9.2234e+18
        res = -1*bitcmp(res_temp,'uint64');
    else 
        res =  res_temp;
    end
end