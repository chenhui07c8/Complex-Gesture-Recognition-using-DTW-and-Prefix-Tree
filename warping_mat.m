function output = warping_mat(ori_rx,ori_ref)

%     x0 = [rx(1:200);rx(201:400)];
    x0 = ori_rx;
    w0 = ori_ref;
%     [ref(1:200);ref(201:400)];
    output = zeros(length(x0),length(w0));
    for i = 1:length(x0)    % row indicates received signal
        for j = 1:length(w0)
            u = [w0(:,j)',0]';v = [x0(:,i)',0]';
            output(i,j) = atan2d(norm(cross(u,v)),dot(u,v))/180;
%         t1 = w0(1,:) - x0(1,i); % column indicates ref signal
%         t2 = w0(2,:) - x0(2,i);
%         output(i,:) = sqrt(t1.^2 + t2.^2);
        end
    end

end