
current = [];
Dis = [];
Pos = [];
Can = {};
if(rounds == 1)
    if(length(ori_rx)<frame_max)
        ori_rx_temp = ori_rx;
    else
        ori_rx_temp = ori_rx(:,1:frame_max);
    end
    [candidate,distance,position] = Alg_letter_dis_cal(current,ori_rx_temp,ori_ref,start,candi_show);
    Can = candidate;
    Dis = distance;
    Pos = position;
else
    for i = 1:length(G_current)
    %     candidate(i)
        current = G_current{i}; 
        if(G_flag(i)==1)
            Can = [Can G_current(i)];
            Dis = [Dis G_dis(i)];
            Pos = [Pos 0];
        else
            if(length(ori_rx)-G_pos(i)<60)
                ori_rx_temp = ori_rx;
            else
                ori_rx_temp = ori_rx(:,1:G_pos(i)+60);
            end
    % start =G_pos(i)+1
            [candidate,distance,position] = Alg_letter_dis_cal(current,ori_rx_temp,ori_ref,G_pos(i)+1,5);
            Dis_temp = distance + G_dis(i);
            Can = [Can candidate];
            Dis = [Dis Dis_temp];
            Pos = [Pos position];
        end
    %     letter_char(candidate2)
    %     distance(i)+distance2
    end
end

 
% first update
if(length(find(Dis<thres_rounds(rounds))) ~= 0)
    G_current = Can;
    G_dis = Dis;
    G_pos = Pos;
    G_pos( find(length(ori_rx)-G_pos < frame_min)) = 0;
    G_flag = (G_pos==0);
    % check leaves
    % Tree_view('A') node(10)
    for i = 1:length(G_current)
        temp = Tree_view(char(G_current(i)));
        if( (node(temp).type ~= 4) && G_flag(i)==1 )
            Dis(i) = 1000;
        end
        if(node(temp).type == 4 && G_flag(i) == 0)
            if( isempty(node(temp).child) )
                if(length(ori_rx)-G_pos(i)<=30)  % special case for leaves
                    G_flag(i) = 1;
                    G_pos(i) = 0;
                else
                    Dis(i) = 100;
                    G_flag(i) = 1;
                    G_pos(i) = 0;
                end
            else % if have children, duplicate one.
            	Dis = [Dis Dis(i)];
                Pos = [Pos Pos(i)];
                Can = [Can Can(i)];
                G_flag = [G_flag G_flag(i)];
                if(length(ori_rx)-G_pos(i)<=30)  % special case for leaves
                    G_flag(i) = 1;
                    G_pos(i) = 0;
                else
                    Dis(i) = 100;
                    G_flag(i) = 1;
                    G_pos(i) = 0;
                    
                end
            end
        
            
            
        end
    end   
    Flag = G_flag;
% update globle variables. 
        [Y,I] = sort(Dis);
        active_len = length(find(Dis<thres_rounds(rounds)));
        if(active_len<candi_rounds(rounds) && active_len>=1)
            G_current = Can(I(1:active_len));
            G_dis = Dis(I(1:active_len));
            G_pos = Pos(I(1:active_len));
            G_flag = Flag(I(1:active_len));
        else
            G_current = Can(I(1:candi_rounds(rounds)));
            G_dis = Dis(I(1:candi_rounds(rounds)));
            G_pos = Pos(I(1:candi_rounds(rounds))); 
            G_flag = Flag(I(1:candi_rounds(rounds))); 
        end
        rounds = rounds + 1;
else
	G_flag = ones(size(G_flag));
% end
end