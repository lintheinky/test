clear;
clc;
close all;
% 假设一个初始矩阵，通过替换部分元素来优化某个目标函数
% 这里以最小化矩阵所有元素与目标值（比如0.5）的差异为例

matrixSize = [5, 5];
initialMatrix = rand(matrixSize);
targetValue = 0.5;  % 矩阵元素接近的目标值


T_initial = 100;
T_end = 1e-6;
coolingRate = 0.95;
maxIter = 1000;
maxReject = 100;

% 目标函数
% 计算当前矩阵与目标值的差异（Frobenius范数）
costFunction = @(matrix) norm(matrix - targetValue, 'fro')^2;

% 邻域生成函数
% 替换矩阵中的部分元素
neighborFunction = @(matrix) generateNeighbor(matrix);

% 初始化
currentMatrix = initialMatrix;
currentCost = costFunction(currentMatrix);
bestMatrix = currentMatrix;
bestCost = currentCost;

T = T_initial;
iteration = 0;
rejectCount = 0;
costHistory = [];
temperatureHistory = [];

% 模拟退火主循环
while T > T_end && rejectCount < maxReject
    for k = 1:maxIter
        % 生成新解（替换矩阵中的一些元素）
        newMatrix = neighborFunction(currentMatrix);
        newCost = costFunction(newMatrix);
        
        % 计算成本差异
        deltaCost = newCost - currentCost;
        
        % Metropolis准则
        if deltaCost < 0 || exp(-deltaCost/T) > rand()
            % 接受新解
            currentMatrix = newMatrix;
            currentCost = newCost;
            rejectCount = 0;
            
            % 更新最优解
            if currentCost < bestCost
                bestMatrix = currentMatrix;
                bestCost = currentCost;
            end
        else
            % 拒绝新解
            rejectCount = rejectCount + 1;
        end
        
        % 记录历史
        iteration = iteration + 1;
        costHistory(iteration) = bestCost;
        temperatureHistory(iteration) = T;
    end
    
    T = T * coolingRate;
    
    % 显示进度
    if mod(iteration, 100) == 0
        fprintf('迭代: %d, 温度: %.4f, 最优成本: %.6f\n', ...
                iteration, T, bestCost);
    end
end

% 结果展示
fprintf('\n=== 模拟退火完成 ===\n');
fprintf('总迭代次数: %d\n', iteration);
fprintf('最终温度: %.6f\n', T);
fprintf('初始成本: %.6f\n', costFunction(initialMatrix));
fprintf('最优成本: %.6f\n', bestCost);
fprintf('矩阵平均元素值: %.4f (目标值: %.4f)\n', ...
        mean(bestMatrix(:)), targetValue);

% 可视化
figure('Position', [100, 100, 1200, 400]);

% 子图1: 初始矩阵
subplot(1, 3, 1);
imagesc(initialMatrix);
colorbar;
title(sprintf('初始矩阵\n成本: %.4f', costFunction(initialMatrix)));
xlabel('列'); ylabel('行');
axis square;

% 子图2: 优化后矩阵
subplot(1, 3, 2);
imagesc(bestMatrix);
colorbar;
title(sprintf('优化后矩阵\n成本: %.4f', bestCost));
xlabel('列'); ylabel('行');
axis square;

% 子图3: 收敛曲线
subplot(1, 3, 3);
yyaxis left;
semilogy(costHistory, 'b-', 'LineWidth', 1.5);
ylabel('成本 (对数坐标)', 'Color', 'b');
xlabel('迭代次数');

yyaxis right;
semilogy(temperatureHistory, 'r-', 'LineWidth', 1.5);
ylabel('温度 (对数坐标)', 'Color', 'r');
title('收敛曲线');
grid on;
legend('成本', '温度');

% 矩阵元素统计
fprintf('\n=== 矩阵元素统计 ===\n');
fprintf('初始矩阵 - 最小值: %.4f, 最大值: %.4f, 平均值: %.4f\n', ...
        min(initialMatrix(:)), max(initialMatrix(:)), mean(initialMatrix(:)));
fprintf('优化矩阵 - 最小值: %.4f, 最大值: %.4f, 平均值: %.4f\n', ...
        min(bestMatrix(:)), max(bestMatrix(:)), mean(bestMatrix(:)));

% 邻域生成函数定义
function newMatrix = generateNeighbor(matrix)
    % 这个函数生成当前矩阵的一个邻居
    % 策略：随机选择矩阵中的一些元素进行替换
    
    newMatrix = matrix;
    [rows, cols] = size(matrix);
    
    % 随机决定要替换的元素数量（1到矩阵总元素数的10%）
    maxChanges = max(1, round(numel(matrix) * 0.1));
    numChanges = randi([1, maxChanges]);
    
    for i = 1:numChanges
        % 随机选择位置
        row = randi([1, rows]);
        col = randi([1, cols]);
        
        % 随机生成新值（在0-1范围内）
        % 您可以修改这里来适应您的特定问题
        perturbation = 0.1 * (rand() - 0.5);  % 小扰动
        newValue = matrix(row, col) + perturbation;
        
        % 确保新值在合理范围内（0-1）
        newValue = max(0, min(1, newValue));
        
        % 替换元素
        newMatrix(row, col) = newValue;
    end
end