
function output = Alg_word_split_estimation(word0,candidate)
    load letter_duration.mat;
    load word_data_05.mat; % 6 is Bayan
    % load D_letter_r2_1021.mat;
    load D_letter_r.mat;
    load word_ref.mat; 
    duration = time_mean;
    letter_char = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ']; 
    word_len = length(word0);
    
    p = ones(1,length(candidate));
    for candi_i = 1:length(candidate)
        word_temp = word_ref{candidate(candi_i)};
        word0(1,:) = word0(1,:)-mean(word0(1,:));
        word0(2,:) = word0(2,:)-mean(word0(2,:));
        x0 = word0(1,:);
        y0 = word0(2,:);

        letter_len = zeros(1,length(word_temp)+1);
        temp_ind = zeros(1,length(word_temp));
        for i = 1:length(word_temp)
            temp_ind(i) = find(letter_char == word_temp(i));
            letter_len(i+1) = duration(temp_ind(i)) + letter_len(i);
        end
        segment = [1 round(letter_len(2:end)/letter_len(end)*word_len)];

    %     plot_2d(x0(segment(1):segment(2)),y0(segment(1):segment(2)),15);
    %     plot_2d(x0(segment(2):segment(3)),y0(segment(2):segment(3)),15);
    %     plot_2d(x0(segment(3):segment(4)),y0(segment(3):segment(4)),15);
        
        for i = 1:length(temp_ind)
            letter_i = temp_ind(i);
            D_single = D_letter_r(1+(letter_i-1)*21:21+(letter_i-1)*21,:);
            p1 = x0(segment(i):segment(i+1));
            p2 = y0(segment(i):segment(i+1));
            x_p = Alg_linear_interpolation(p1',200);
            y_p = Alg_linear_interpolation(p2',200);
            x_p = x_p - mean(x_p);
            y_p = y_p - mean(y_p);
            temp = [x_p' y_p'];
            temp = temp/sqrt(sum(temp.^2));
            result = temp*D_single';
            % figure;plot(result)
            [a0 b0] = max(result);

            temp = find(D_single(b0,1:200)~=0);
            area = round([temp(1) temp(end)]/200*length(p1));
            area;
            result = [a0 area];
            p(candi_i) = p(candi_i)*a0;
        end
        p(candi_i) = (p(candi_i)*(length(temp_ind)))^(1)*1/10;
%         p(candidate) = p(candidate)/length(temp_ind);

    end
    [a0 b0] = max(p);
    output = candidate(b0);

end