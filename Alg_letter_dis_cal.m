function [candi_node,distance,position] = Alg_letter_dis_cal(current,ori_rx,ori_ref,start,candi_show)

% candi_num = 5;
% first_search = 1
% start = 25
 
    load word_ref.mat;
    load connection.mat;
    load vocab.mat;
    load Tree_nodes.mat;
    letter_char = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];       % translate into char
    current_node = Tree_view(current);
    % Tree_view([])
    next_ind = node(current_node).child;
    next_char = node(current_node).child_char;
    template = [];
    letter = [];
    for i = 1:length(next_ind)
        child_temp = char(node(current_node).child_char(i));
        letter_temp = child_temp(length(current)+1);
        template = [template letter_temp];
        letter(i) = find(letter_char == template(i));
        % letter_char(letter)
    end
    
    val = ones(1,length(next_ind))*1000;
    pos = zeros(1,length(next_ind));
    
    if(isempty(current))    % round 1
        for letter_i = 1:length(letter)
%             letter = find(letter_char == template(letter_i));
            con = [];
            R = warping_mat(ori_rx(:,start:end),ori_ref{letter(letter_i)});
            [val(letter_i) pos(letter_i)] = cost_cal(R);
        end
    elseif(length(current)>=1)
        % vocab_char
%         template = vocab{find(letter_char==current(length(current))),length(current)+1};
%         letter_char(template)
        for letter_i = 1:length(letter)
            con = connection{find(letter_char==current(length(current))),letter(letter_i)};
            temp = ori_ref{letter(letter_i)};
%             R = warping_mat([ori_rx(1:2,:)],[ori_ref{8}]);
            R = warping_mat([ori_rx(:,start:end)],[con con con temp(1:2,1:2)]);
%             figure;image(R,'CDataMapping','scaled');caxis([0.0,0.5]);title('Similarity Matrix');grid on;
                
            temp = find(R(1:end-3,1)<0.2);
            if(~isempty(temp))
                    start2 = start + temp(1);
            else
                    start2 = start;
            end
                R = warping_mat(ori_rx(:,start2:end),[con con con ori_ref{letter(letter_i)}]);
    %             figure;image(R,'CDataMapping','scaled');caxis([0.0,0.5]);title('Similarity Matrix');grid on;
                [val(letter_i) pos(letter_i)] = cost_cal(R);
        end
    end
    
    % figure;plot(pos);title('position')
    % figure;plot(val);title('value')
    [Y,I] = sort(val);
    if(length(I)<candi_show)
        candidate = letter(I);
        distance = val(I);
        position = pos(I)+start;
        candi_node = next_char(I);
    else
        candidate = letter(I(1:candi_show));
        distance = val(I(1:candi_show));
        position = pos(I(1:candi_show))+start;
        candi_node = next_char(I(1:candi_show));
    end
end