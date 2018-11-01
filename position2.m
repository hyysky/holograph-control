%% Î»ÖÃÅĞ±ğº¯Êı
function output = position2(az,el,az_real,el_real)
if abs(az-az_real)<=0.0006 && abs(el-el_real)<=0.0003
    output = 1;
else
    output = 0;
end