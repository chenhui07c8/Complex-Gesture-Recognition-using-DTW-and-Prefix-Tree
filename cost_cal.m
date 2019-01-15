function [a,b] = cost_cal(R)

    S = ones(size(R))*10000;
    S(1,1) = R(1,1);
    S(2,1) = R(1,1) + R(2,1);
    S(1,2) = R(1,1) + R(1,2);
    [M,N] = size(R);

    Left=2;Right=N;Top=2;Down=M;
    for i = Top:Down
        for j = Left:Right
            cost = R(i,j);
            [a,b] = min([S(i-1,j) S(i-1,j-1) S(i,j-1)]);
            S(i,j) = cost + a;
        end
    end
    [a,b] = min(S(:,end));



end