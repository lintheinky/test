%% if函数
clear;
clc;

a = 10;
b = 20;
c = 15;

if a > b
    if a > c
        max = a;
    else
        max = c;
    end
else
    if b > c
        max = b;
    else
        max = c;
    end
end

%% switch函数
clear;
clc;

season = randi([1,4])
switch season
    case 1
        disp("春季");
    case 2
        disp("夏季");
    case 3
        disp("秋季");
    otherwise
        disp("冬季");
end


if season == 1
    disp("Spring");
elseif season == 2
    disp("Summer");
elseif season == 3
    disp("Autumn");
elseif season == 4
    disp("Winter");
end


%% 循环结构for-end和while-end
clear;
clc;

x = 1:6;
res_sum = 0;
for i = x
    res_sum = res_sum + i;
end

% 求闰年
leap_year_num = 0;
for i = 1:9999
    if((mod(i,4) == 0)&&(mod(i,100) ~= 0))||(mod(i,400) == 0)
       leap_year_num = leap_year_num + 1;
    end
end
leap_year_num

f(1) = 1;
f(2) = 1;
n = 2;
while f(n) <= 99999
    n = n + 1;
    f(n) = f(n-1) + f(n-2);
end


% 
% for i = 1:10
%     if mod(i,2) == 0
%         continue;
%     end
%     i
% end


n = 703;
is_prime = 1;
for i = 2:n-1
    if mod(n,i) == 0
        is_prime = 0;
        break;
    end
end
is_prime

%% 练习，1-9999中有几个闰年；99999秒是多少小时多少分钟多少秒

% 1
for i = 1:9999
    if (mod(i,4) == 0)&&(mod(i,100) ~= 0)||(mod(i,400) == 0)
        a = a + 1;
    end
end
a


% 2
a = floor(99999/3600)
b = floor(mod(99999,3600)/60)
c = 99999 - 60*b - 3600*a


