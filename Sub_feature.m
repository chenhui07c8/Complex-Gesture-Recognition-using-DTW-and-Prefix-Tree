function [ori,seq] = Sub_feature(ref,div_win,active_coe)
% active_coe = 0.5 
    count = 1;    
    ori = [];
    len = length(ref);
    seq_ind = 1:div_win:(len);
    t1 = 1;
    t2 = t1 + div_win;
    while(t2 < len)
        
        while(norm(ref(:,t2)-ref(:,t1))<=active_coe)
            t2 = t2 + div_win - 2;
            if(t2 > len)
                break;
            end
        end
        
        if(t2 > len)    
            break;
        else
            angle_temp = atan2((ref(2,t2)-ref(2,t1)),(ref(1,t2)-ref(1,t1)))*180/pi;
            ori = [ori [cos(angle_temp/180*pi);sin(angle_temp/180*pi)]];
            seq(count) = ceil(mod((angle_temp+45/2)+360,360)/45);
            count = count + 1;
        
            seq = nonzeros(seq)';
        end
        
        t1 = t2;
        t2 = t1 + div_win;
        
    end
    
    


end
    