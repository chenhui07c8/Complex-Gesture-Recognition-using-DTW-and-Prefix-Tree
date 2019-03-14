function [c_all, info_all, G_flag] = Alg_Only_Letter(round, output, c_all, info_all);
    
load Tree_nodes.mat;
letter_char = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];


    if(round == 1)
        c_all_num = find(output(:,3)<10); 
        info = output(c_all_num,1);
        info_all = [];
        for i = 1:length(c_all_num)
            node_num = Tree_view( letter_char(info(i)) );
            if(~isempty(node_num))
                c_all = [c_all string(letter_char(info(i)))];
                if(node(node_num).type == 2)
                    flag = 0;
                elseif(node(node_num).type == 4 && (isempty(node(node_num).child))) % leaf
                    flag = 1;
                elseif(node(node_num).type == 4) % both
                    temp = [output(c_all_num(i),2) output(c_all_num(i),4)-output(c_all_num(i),3) output(c_all_num(i),4) 0]; % info_all distance,coverage,stop,flag
                    info_all = [info_all; temp];
                    c_all = [c_all string(letter_char(info(i)))];
                    flag = 1;
                end
            temp = [output(c_all_num(i),2) output(c_all_num(i),4)-output(c_all_num(i),3) output(c_all_num(i),4) flag]; % info_all distance,coverage,stop,flag
            info_all = [info_all; temp];
            end
        end    
    end
    
    if(round ~=1)
        
        c_current = []; % current candidate
        info_current = [];
        for i = 1:length(c_all) % first letter
            if(info_all(i,end) == 1) % stop flag is true.
                info_current = [info_current; info_all(i,:)];
                c_current = [c_current c_all(i)];
            else
                stop = info_all(i,3);       % 
                current = Tree_view(char(c_all(i)));
                next = node(current).child;
                c_next = find(output(:,3) >= stop & output(:,3) <= (stop+20));
                % letter_char(output(c_next,1))
                info2 = output(c_next,:);

                for j = 1:length(next)      % for loop for the second letter candidate
                    next_letter = char(node(next(j)).value);
                    last_letter = next_letter(length(next_letter));
                    candi_next = find((letter_char(info2(:,1))==last_letter));
                    flag = 0;
                    if(isempty(candi_next))
                        info_temp = [];
                    else
                        for next_i = 1:length(candi_next)
                            info_temp = info2(candi_next(next_i),:);
                            node_num = Tree_view( char(next_letter) );
                            if(node(next(j)).type == 4  && ( isempty(node(node_num).child)) )
                                flag = 1;
                            elseif(node(next(j)).type == 4)
                                temp = info_all(i,:) + [info_temp(2) info_temp(4)-info_temp(3) 0 0];
                                temp(3) = info_temp(4);
                                c_current = [c_current string(next_letter)];
                                info_current = [info_current;temp];
                                flag = 1;
                            else            
                                flag = 0;
                            end
                            % update
                            temp = info_all(i,:) + [info_temp(2) info_temp(4)-info_temp(3) 0 flag];
                            temp(3) = info_temp(4);
                            c_current = [c_current string(next_letter)];
                            info_current = [info_current;temp];
                        end
                    end
                end
            end
        end

        c_all = c_current;
        info_all = info_current;
    end
    if(isempty(info_all) )
        G_flag = 1;
    else
        G_flag = sum(info_all(:,end))/length(c_all);
    end
    
end