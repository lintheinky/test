clear;
clc;
% 蒙特卡洛求二维曲线极值
% y = sin(x) + 0.2x - 0.01x^2
fun = @(x) sin(x) + 0.2*x - 0.01*x.^2;

x_min = -20;
x_max = 20;
N = 3000;
find_max = true;  % true找最大值，false找最小值

rng(42); % 固定随机种子
x_sample = x_min + (x_max - x_min)*rand(N, 1);
y_sample = fun(x_sample);

if find_max
    [best_y, idx] = max(y_sample);
    label = '最大值';
else
    [best_y, idx] = min(y_sample);
    label = '最小值';
end
best_x = x_sample(idx);

% 可视化
x_plot = linspace(x_min, x_max, 1000);
y_plot = fun(x_plot);

figure('Color', 'w');
plot(x_plot, y_plot, 'b-', 'LineWidth', 2, 'DisplayName', '目标函数曲线');
hold on;
scatter(x_sample, y_sample, 15, 'r', 'filled', 'DisplayName', '采样点');
scatter(best_x, best_y, 150, 'g', 'Marker', '*', 'LineWidth', 2, 'DisplayName', label);

xlabel('x'); ylabel('y');
title(sprintf('蒙特卡洛法求二维曲线%s\n极值点：x=%.3f, y=%.3f', label, best_x, best_y));
grid on;
legend('Location', 'best');