function output = Tree_view(test)

% Tree_view('BECAUSE')
% test = 'BECAUSE';
load Tree_nodes.mat;
if(isempty(test))
    output = 1;
else
    for j = 1:length(test)
        if(j==1)
            current = 1;
        else
            current = next;
        end
        str_now = string(test(1:j));
        next = node(current).child( find( node(current).child_char == str_now )  ); % update node
        if(j == length(test))
            break;
        end
    end
    output = next;
end

end