close all;
clear all;
clc;
%% Initialization
% load letter_duration_final.mat;
load word_data_01.mat; % 6 is Bayan
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
result = zeros(1,100);
%% word prediction
close all
for number = 89
    frame_max = 60;
    frame_min = 20;
    candi_show = 20;
    start = 1;
    G_flag = zeros(1,candi_show);
    dis_all = ones(1,100)*1000;
    w0 = word_all{number};
    rx = w0;
    % plot_2d(w0(1,:),w0(2,:),16)
    x_size = (max(w0(1,:))-min(w0(1,:)))/12*1.5;
    y_size = (max(w0(2,:))-min(w0(2,:)))/18*1.5;
    coe = max(x_size,y_size)*0.8;
    [ori_rx,seq_rx] = Sub_feature(rx,div_win,coe);

    length(ori_rx)
    rounds = 1;
    thres_rounds = [20 30 30 30 30 30 30 30]*10;
    candi_rounds = [5 5 5 5 5 5 5 5];

    %% round 1
    tic
    while(sum(G_flag) ~= length(G_flag))

        Run_mainpart;
        G_dis
        G_current
        G_pos
        G_flag
    end
    toc

    % extra efforts to improve the accuracy.
    %
    % 

    final_word = G_current(1);
    final_word
    if( final_word == string(word_ref{number}) )
        result(number) = 1;
    end
    
end





