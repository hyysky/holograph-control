%%向相关器串口发送指令
function  regval = writereg(s,n,v)
%UNTITLED2 此处显示有关此函数的摘要
%   此处显示详细说明
    regval = [];
    rbtxt =[];
    fprintf(s,'');
    pause(0.1);
    fprintf(s,'dw 0x%x = 0x%x\r',[n*4,v]);%,'async');
    pause(0.1);
%     while s.BytesAvailable>0
%         rbtxt = fscanf(s);
%         comdix = strfind(rbtxt,'=');
%         if comdix
%             regval = rbtxt
%             break;
%         end
%     end
    
%     comidx = strfind(rbtxt,'=');
%     if (comidx)
%         regval = sscanf(rbtxt(comidx+4:end-2),'%x');
%    end
end

