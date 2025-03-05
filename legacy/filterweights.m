% Filter wights
% Low-pass smoothing
hLP1 = 1/9* [ 1 1 1; 1 1 1; 1 1 1];
hLP2 = 1/10*[ 1 1 1; 1 2 1; 1 1 1];
hLP3 = 1/16*[ 1 2 1; 2 4 2; 1 2 1];
hLP4 = 1/273*[ 1 4 7 4 1; 4 16 26 16 4; 7 26 41 26 7; 4 16 26 16 4;  1 4 7 4 1 ];
% Horizontal and vertical edge detection:
hS1 = [ 1 2 1; 0 0 0; -1 -2 -1 ];       % Sobel 1 horizontal lines
hS2 = [ 1 0 -1; 2 0 -2; 1 0 -1];        % Sobel 2 vertical lines
hP1 = [ 1 1 1; 0 0 0; -1 -1 -1];        % Prewitt 1 horizontal lines
hP2 = [ 1 0 -1; 1 0 -1; 1 0 -1];        % Prewitt 2 vertical lines
% Diagonal edge detection:
hR1 = [ 1 0; 0 -1 ];                    % Roberts 1 diagonal \
hR2 = [ 0 1; -1 0 ];                    % Roberts 2 diagonal /
hG1 = [ 1 1 1; 1 -2 -1; 1 -1 -1 ];      % gradient 1 diagonal \
hG2 = [ 1 1 1; -1 -2 1; -1 -1 1 ];      % gradient 2 diagonal /
% Double differentiation - edge detection in all directions:
hL1 = [ 0 -1 0; -1 4 -1; 0 -1 0 ];      % laplasian 1 X
hL2 = [ 1 -2 1; -2 4 -2; 1 -2 1 ];      % laplasjan 2 X
hL3 = [ -1 -1 -1; -1 8 -1; -1 -1 -1 ];  % laplasjan 3 X
hL4 = [ -1 -1 -1 -1 -1; -1 -1 -1 -1 -1; -1 -1 24 -1 -1; -1 -1 -1 -1 -1; -1 -1 -1 -1 -1 ];
hL5 = [ 0 0 1 0 0; 0 1 2 1 0; 1 2 -16 2 1; 0 1 2 1 0; 0 0 1 0 0];
hL6 = [ 0 1 1 2 2 2 1 1 0; 1 2 4 5 5 5 4 2 1; 1 4 5 3 0 3 5 4 1;...
        2 5 3 -12 -24 -12 3 5 2; ...
        2 5 0 -24 -40 -24 0 5 2; ...
        2 5 3 -12 -24 -12 3 5 2; ...
        1 4 5 3 0 3 5 4 1; 1 2 4 5 5 5 4 2 1; 0 1 1 2 2 2 1 1 0 ];
