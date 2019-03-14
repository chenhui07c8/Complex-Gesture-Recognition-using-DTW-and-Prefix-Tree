% interpolate the original sequence to get a new sequence with length 'len' 
function output = Alg_linear_interpolation(input,len)
    xa = 0:(length(input)-1);
    xi = 0:1:(len-1);
    xi = xi*(length(xa)-1)/(length(xi)-1);
    output = interp1q(xa',input,xi');








end