%% Î»ÖÃÅĞ±ğº¯Êı
function output = position(az,az_real)
if abs(az-az_real)<=0.5
    output = 1;
else
    output = 0;
end