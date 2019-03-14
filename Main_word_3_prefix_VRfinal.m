close all;
clear all;
clc;
%% Initialization
load connection.mat;
load Tree_nodes.mat;
letter_char = ['ABCDEFGHIJKLMNOPQRSTUVWXYZ'];       % translate into char
load D_dtw.mat;
load letter_duration.mat
load word_ref.mat;
div_win = 5;
div_thres = 1.5;
ori_ref = cell(1,26);
for letter = 1:26
    x1 = Alg_linear_interpolation(D_dtw(letter,1:200)',round(time_mean(letter)*100))';
    x2 = Alg_linear_interpolation(D_dtw(letter,201:400)',round(time_mean(letter)*100))';
    ref = [x1;x2];
    [ori_ref{letter},seq_ref] = Sub_feature(ref,div_win,1.5);
end

accuracy = zeros(8,3);
%% word prediction
for file_ind = 1:8
    result1 = zeros(1,100);
    result2 = zeros(1,100);
    result3 = zeros(1,100);
    file_name = ['word_data_0' num2str(file_ind) '.mat'];
    load(file_name);
    % classify each word
    for number = 1:100
        display(['file_ind: ' num2str(file_ind) ' | word_ind: ' num2str(number)]);
        interval_max = [10 20];
        start = 1;
        w0 = word_all{number};
        word_len(number) = length(w0);
        rx = w0;
        % preprocessing
        x_size = (max(w0(1,:))-min(w0(1,:)))/12*1.5;
        y_size = (max(w0(2,:))-min(w0(2,:)))/18*1.5;
        coe = max(x_size,y_size)*0.8;
        [ori_rx,seq_rx] = Sub_feature(rx,div_win,coe);
        output = Alg_word3_estimation(ori_rx, ori_ref,0.6);
        [Y,I] = sort(output(:,3));
        out_seq = output(I,:);
        letter_char(out_seq(:,1));
        % only letter
        rounds = 1;
        c_all = [];
        info_all = [];
        G_flag = 0;
        % Com-Filter Algorithm
        while( G_flag ~= 1)
            [c_all, info_all, G_flag] = Alg_Only_Letter(rounds, output, c_all, info_all);
            rounds = rounds + 1;
            c_all;
        end
        if(~isempty(c_all))
            score = info_all(:,1)./(info_all(:,2)).^2*100;
            [Y, I] = sort(score);
            c_final = c_all(I);
            s_final = score(I);
            [C,IA,IC] = unique(c_all(I),'first');
            [Y, I2] = sort(IA);

            if(c_final(1) == string(word_ref{number})) 
                result1(number) = 1;
            end
            if(length(c_final)>=2)
                if(c_final(1) == string(word_ref{number}) || c_final(2) == string(word_ref{number})) 
                    result2(number) = 1;
                end
            else
                result2(number) = result1(number);
            end
            if(length(c_final)>=3)
                if(c_final(1) == string(word_ref{number}) || c_final(2) == string(word_ref{number}) || c_final(3) == string(word_ref{number})) 
                    result3(number) = 1;
                end
            else
                result3(number) = result2(number);
            end
        end

    end
    accuracy(file_ind,:) = [sum(result1); sum(result2); sum(result3)];
end
% sum(result1)
% sum(result2)
% sum(result3)
accuracy
mean(accuracy)



