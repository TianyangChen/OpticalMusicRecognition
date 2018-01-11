function playmusic(A) 
ScaleTable = [1/2 9/16 5/8 2/3 3/4 5/6 15/16 ... 
1 9/8 5/4 4/3 3/2 5/3 9/5 15/8 ... 
2 9/4 5/2 8/3 3 10/3 15/4 4]; 
fs = 44100; % sample rate 
f0 = 2*146.8; % reference frequency 
d = trans(A,ScaleTable,f0); 
d = d/max(d); 
save('music','d') 
sound(d,fs); 
end 

function y = trans(A,ScaleTable,f0) 
[a b] = size(A); 
B = sum(A); 
y = zeros(1,B(3)*16*5513); 
for i = 1:a 
if i == 1 
start =1; 
end1 = A(1,3)*16*5513; 
else 
start = end1+1; 
end1 = start + A(i,3)*16*5513 - 1; 
end 
y(start:end1) = getyinfu(A(i,:),ScaleTable,f0); 
end 
end 

function y = getyinfu(H,ScaleTable,f0) 
if H(1) == 0 
[temp k] = size(t(H(3))); 
y = zeros(1,k); 
else 
y = mod(H(3)).*cos(2*pi*ScaleTable(H(2)*7+H(1))*f0*t(H(3))); 
end 
end 

function y = t(p) 
y = linspace(0,16*p*0.125,16*p*5513); 
end 

function y = mod(p) 
a = t(p); 
y = sin(pi*a/a(end)); 
end

