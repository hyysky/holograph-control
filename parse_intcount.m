function res = parse_intcount( data )
res_temp =0;
for i=1:1:length(data);
       res_temp = data(i)*256^(i-1)+res_temp;
end
res = res_temp;