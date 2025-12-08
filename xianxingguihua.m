%% 线性规划
f = [40; 30];% 目标函数系数 (注意：linprog默认求最小值)
A = [1, 1;2, 1];% 不等式约束系数矩阵
b = [6; 10];% 不等式约束右侧值 %不等式默认小于等于
Aeq = [];% 等式约束系数矩阵
beq = [];% 等式约束右侧值
lb = [1; 1];% 变量下界
ub = [];% 变量上界
[x, fval, exitflag] = linprog(f, A, b, Aeq, beq, lb, ub);% 求解线性规划
% 求解最大值时，+负号
% [x, fval, exitflag] = linprog(-f, A, b, Aeq, beq, lb, ub);




if exitflag > 0
    fprintf('最优解找到！\n');
    fprintf('x1 = %.4f\n', x(1));
    fprintf('x2 = %.4f\n', x(2));
    fprintf('最优目标函数值 = %.4f\n', fval);% 注意求解最大值时取负号
else
    fprintf('未找到最优解，退出标志: %d\n', exitflag);
end