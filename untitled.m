a = 2*pi*(rand(10));
R = 2;
r = R * sqrt(rand());
X = arrayfun(@(x) cos(x), a); 
Y = arrayfun(@(x) sin(x), a);
figure;
plot(X, Y)