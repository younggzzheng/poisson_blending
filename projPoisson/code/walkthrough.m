% walkthrough script, with visualizations, as shown on the project handout.
% written by James Hays

t = [5 4 0 0 0 0 2 4];
M = [0 0 1 1 1 1 0 0];
M = logical(M);
figure
plot(t(1:2), 'LineWidth', 3); hold; plot(7:8,t(7:8), 'LineWidth', 3);
axis('equal'); axis([1 8 -2 6])

% v(1) - t(2) = 0; %left border
% v(2) - v(1) = 0;
% v(3) - v(2) = 0;
% v(4) - v(3) = 0;
% t(7) - v(4) = 0; %right border

%the values of t are already known, so we can write
% v(1) -    4 = 0;
% v(2) - v(1) = 0;
% v(3) - v(2) = 0;
% v(4) - v(3) = 0;
%    2 - v(4) = 0;

%now let's rewrite this in matrix form and have Matlab solve it for us.
A = [ 1  0  0  0; ...
     -1  1  0  0; ...
      0 -1  1  0; ...
      0  0 -1  1; ...
      0  0  0 -1];
  
b = [4; 0; 0; 0; -2];
  
v = A\b;
t_out = zeros(size(t));
t_out(~M) = t(~M);
t_out( M) = v;
figure
plot(t_out, 'LineWidth', 3); axis([1 8 -2 6])

%now introduce more complex equation

%and those are the four values that we need to put under our mask. In the
%1d case, the ends up just being a linear interpolation between the pixels
%at the edge of the mask.

s = [5 6 7 2 4 5 7 3];
figure
plot(s, 'LineWidth', 3); axis([1 8 0 9])

% v(1) - t(2) = s(3) - s(2);
% v(2) - v(1) = s(4) - s(3);
% v(3) - v(2) = s(5) - s(4);
% v(4) - v(3) = s(6) - s(5);
% t(7) - v(4) = s(7) - s(6);

%plugging in known values
% v(1) -    4 =  1;
% v(2) - v(1) = -5;
% v(3) - v(2) =  2;
% v(4) - v(3) =  1;
%    2 - v(4) =  2;

%in matrix form

A = [ 1  0  0  0; ...
     -1  1  0  0; ...
      0 -1  1  0; ...
      0  0 -1  1; ...
      0  0  0 -1];
  
b = [5; -5; 2; 1; 0];
  
v = A\b;
t_out = zeros(size(t));
t_out(~M) = t(~M);
t_out( M) = v;
figure
plot(t_out, 'LineWidth', 3); axis([1 8 -2 6])