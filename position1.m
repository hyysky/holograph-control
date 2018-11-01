%% Î»ÖÃÅÐ±ðº¯Êý
function output = position1(azend,azstart,az_real)
if (az_real >= azstart-0.3) && (az_real <= azend+0.3)
    output = 1;
else
    output = 0;
end