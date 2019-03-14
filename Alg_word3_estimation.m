% get the state DTW of the word, return: 1-word ind; 2-distance; 3,4-start,stop point. 

function output = Alg_word3_estimation(ori_rx, ori_ref, thres_candi)
output = [];
max_candi = 3;
% thres_candi = 0.25;
win_candi = 6;

for letter = 1:26
    template = ori_ref{letter};
    R = warping_mat(ori_rx,ori_ref{letter});
    [val pos] = cost_cal(R);

    len_candi = round(length(ori_ref{letter})*0.3);
    % figure;image(R,'CDataMapping','scaled');caxis([0.0,0.5]);title('Similarity Matrix');grid on;
    % max(max(R))
    % function [a,b] = cost_cal(R);
    S = ones(size(R))*10000;
    P = zeros(size(S));
    [M N] = size(R);
    P(1,:) = 1;
    P(:,1) = 1:M;
    S(:,1) = R(:,1);
    % figure;plot(R(:,1))
    %
    for i = 2:N
        S(1,i) = S(1,i-1) + R(1,i);
    end
    % S(1,:)
    Left=2;Right=N;Top=2;Down=M;
    for i = Top:Down
        for j = Left:Right
            cost = R(i,j);
    %  if(cost>8) cost = 10000; end
            [a,b] = min([S(i-1,j) S(i-1,j-1) S(i,j-1)]);
            temp_p = [P(i-1,j) P(i-1,j-1) P(i,j-1)];
            P(i,j) = temp_p(b);
            S(i,j) = cost + a;
        end
    end

    % figure;image(S,'CDataMapping','scaled');caxis([0.0,3.5]);title('Similarity Matrix');grid on;
    % figure;plot(S(:,end))
    % figure;plot(P(:,end))
    dis_final = S(:,end);
    for i = 1:max_candi
        [a,b] = min(dis_final);
        temp = [letter a P(b,end) b a/(b-P(b,end))];
        
        if(temp(end) < thres_candi)
    %         if(temp(4)-temp(3)>len_candi)
        	output = [output;temp];
    %         end
        	dis_final(max(1,b-win_candi):min(length(dis_final),b+win_candi)) = 20;
            % figure;plot(dis_final)
        end
    end

end
length(output);
% figure;plot(output(:,1),output(:,2),'o')
%%

end













