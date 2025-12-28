clear;
clc;

% 数据准备
sakura_coords = [
    31.5350, 121.3712; 
    31.0812, 121.1857;
    31.1456, 121.4403;
    31.2289, 121.4605;
    31.2701, 121.4498;
    31.3058, 121.4416;
    31.2721, 121.4830;
    31.3214, 121.5515];

sakura_names = {
    '顾村公园'; '辰山植物园'; '上海植物园'; '静安雕塑公园';
    '大宁灵石公园'; '彭浦新村站'; '鲁迅公园'; '共青森林公园'
};

start_coords = [30.9150, 121.4230]; 

start_name = '上师大奉贤校区';

% 3类层次聚类
a = 111;
dist_matrix = pdist2(sakura_coords, sakura_coords, 'euclidean') * a;
start_dist = pdist2(start_coords, sakura_coords, 'euclidean') * a;
Z = linkage(squareform(dist_matrix), 'ward');
cluster_num = 3;
idx = cluster(Z, 'MaxClust', cluster_num); 

% 聚类图可视化
figure('Name','3类聚类可视化');
colors = lines(cluster_num);

for i = 1:cluster_num
    idx_i = find(idx==i);
    scatter(sakura_coords(idx_i,2), sakura_coords(idx_i,1), 80, colors(i,:), 'filled', 'MarkerEdgeColor','k');
    hold on;
end
scatter(start_coords(2), start_coords(1), 150, 'red', 'pentagram', 'filled', 'MarkerEdgeColor','k');

for i = 1:length(sakura_names)
    text(sakura_coords(i,2)+0.005, sakura_coords(i,1), sakura_names{i}, 'FontSize',8);
end
text(start_coords(2)+0.005, start_coords(1), start_name, 'FontSize',8, 'Color','red');

xlabel('经度(°E)');
ylabel('纬度(°N)');
title('上海赏樱地点3类聚类分布');
legend({'第1类', '第2类', '第3类'}, 'Location','best');
grid on;
axis equal;
hold off;

% 最优天数
day_count = 0;
fprintf('3类聚类行程天数明细：\n');
for i = 1:cluster_num
    n = length(find(idx==i));
    if n == 1
        d = 1;
    else
        d = ceil(n / 2);
    end
    day_count = day_count + d;
    fprintf('第%d类（%d个元素）：%d天\n', i, n, d);
end
fprintf('-------------------------\n');
fprintf('3类聚类下，最优路线需要：%d天\n', day_count);


% 5天行程规划
% 格式：[第几天, 出发地(0=起点/数字=地点索引), 目的地1, 目的地2(0=无), 当日终点]
travel_plan = [
    1, 0, 3, 4, 5;
    2, 5, 5, 6, 7;
    3, 7, 7, 8, 0;
    4, 0, 1, 0, 0;
    5, 0, 2, 0, 0];

% 5天行程分图可视化
cluster_colors = lines(cluster_num);

day_colors = [0,0,1; 0,1,0; 1,0,0; 0.7,0,0.7; 0,0.8,0.8];
day_lines = {'--','--','--','--','--'};

for day=1:5
    figure('Name',sprintf('第%d天行程',day),'Position',[100+100*day,200,800,600]);
    hold on; 
    grid on; 
    axis equal; 
    axis([121.15,121.6,30.9,31.6]);
    for i=1:length(sakura_coords)
        c = cluster_colors(idx(i),:);
        scatter(sakura_coords(i,2), sakura_coords(i,1), 120, c, 'o', 'filled',...
                'MarkerEdgeColor','k', 'LineWidth',2);
        text(sakura_coords(i,2)+0.005, sakura_coords(i,1), sakura_names{i},...
             'FontSize',10, 'FontWeight','bold');
    end
    
    scatter(start_coords(2), start_coords(1), 200, [1,0,0], 'pentagram', 'filled',...
            'MarkerEdgeColor','k', 'LineWidth',2);
    text(start_coords(2)-0.02, start_coords(1), start_name, 'FontSize',11, 'Color','red', 'FontWeight','bold');
    
    % 当日行程路线
    dep_idx = travel_plan(day,2);
    dest1_idx = travel_plan(day,3);
    dest2_idx = travel_plan(day,4);
    end_idx = travel_plan(day,5);
    if dep_idx == 0
        dep_x = start_coords(2);
        dep_y = start_coords(1);
    else
        dep_x = sakura_coords(dep_idx,2);
        dep_y = sakura_coords(dep_idx,1);
    end
    
    % 出发地到目的地1
    dest1_x = sakura_coords(dest1_idx,2);
    dest1_y = sakura_coords(dest1_idx,1);
    plot([dep_x, dest1_x], [dep_y, dest1_y], 'Color', day_colors(day,:),...
         'LineWidth',4, 'LineStyle',day_lines{day}, 'Marker','o', 'MarkerSize',6);

    % 目的地1到目的地2
    if dest2_idx ~= 0
        dest2_x = sakura_coords(dest2_idx,2);
        dest2_y = sakura_coords(dest2_idx,1);
        plot([dest1_x, dest2_x], [dest1_y, dest2_y], 'Color', day_colors(day,:),...
             'LineWidth',4, 'LineStyle',day_lines{day}, 'Marker','o', 'MarkerSize',6);
    end


    % 目的地2到终点
    if end_idx ~= dep_idx
        if end_idx ~= 0
            end_x = sakura_coords(end_idx,2);
            end_y = sakura_coords(end_idx,1);
            plot([dest2_x, end_x], [dest2_y, end_y], 'Color', day_colors(day,:),...
                'LineWidth',4, 'LineStyle',day_lines{day}, 'Marker','o', 'MarkerSize',6);
        else
            end_x = start_coords(1,2);
            end_y = start_coords(1,1);
            plot([dest2_x, end_x], [dest2_y, end_y], 'Color', day_colors(day,:),...
                'LineWidth',4, 'LineStyle',day_lines{day}, 'Marker','o', 'MarkerSize',6);
        end
    end
    
    title(sprintf('第%d天赏樱行程',day),'FontSize',16, 'FontWeight','bold', 'Margin',20);
    xlabel('经度(°E)','FontSize',12);
    ylabel('纬度(°N)','FontSize',12);
    legend_labels = {'第1类聚类','第2类聚类','第3类聚类','起点',sprintf('第%d天行程',day)};
    h1 = scatter(0,0,120,cluster_colors(1,:),'o','filled');
    h2 = scatter(0,0,120,cluster_colors(2,:),'o','filled');
    h3 = scatter(0,0,120,cluster_colors(3,:),'o','filled');
    h4 = scatter(0,0,200,[1,0,0],'pentagram','filled');
    h5 = plot(0,0,'Color',day_colors(day,:),'LineWidth',4,'LineStyle',day_lines{day});
    legend([h1,h2,h3,h4,h5], legend_labels, 'Location','best', 'FontSize',10);
    
    hold off;
end


% 计算公交费用
function cost = bus_fee(distance)
    if distance <= 0
        cost = 0;
    elseif distance <= 6
        cost = 3;
    else
        extra_km = distance - 6;
        extra_cost = ceil(extra_km / 10);
        cost = 3 + extra_cost;
    end
end

daily_cost = zeros(1,5);
total_cost = 0;
fprintf('==================== 5天行程费用明细 ====================\n');


for day=1:5
    dep_idx = travel_plan(day,2);
    dest1_idx = travel_plan(day,3);
    dest2_idx = travel_plan(day,4);
    end_idx = travel_plan(day,5);
    
    % 出发地到目的地1_cost1
    if dep_idx == 0
        d1 = start_dist(1,dest1_idx);
    else
        d1 = dist_matrix(dep_idx,dest1_idx);
    end
    cost1 = bus_fee(d1);
    
    % 目的地1到目的地2_cost2
    cost2 = 0;
    if dest2_idx ~= 0
        d2 = dist_matrix(dest1_idx,dest2_idx);
        cost2 = bus_fee(d2);
    end

    % 住宿费_cost3
    cost3 = 0;
    if end_idx ~= 0
        cost3 = 400;
    end
    
    % 目的地1/2到终点_cost4
    if end_idx == 0
        d_return = start_dist(1,dest1_idx);
        cost4 = bus_fee(d_return);
    else
        d_return = dist_matrix(dest2_idx,end_idx);
        cost4 = bus_fee(d_return);
    end
    
    % 当日总费用
    daily_cost(day) = cost1 + cost2 + cost3 + cost4;
    total_cost = total_cost + daily_cost(day);
    if dep_idx == 0
        dep_name = start_name;
    else
        dep_name = '无';
    end
    
    dest1_name = sakura_names{dest1_idx};
    
    if  dest2_idx == 0 
        dest2_name = start_name;
    else
        dest2_name = sakura_names{dest2_idx};
    end

    if  end_idx == 0 && day ~= 3
        end_name = '无';
    elseif day == 3
        end_name = start_name;
    else
        end_name = sakura_names{end_idx};
    end

    fprintf('第%d天：%s→%s→%s→%s + 住宿费：%d | 费用：%d元:%d-%d-%d-%d\n',...
        day, dep_name, dest1_name, dest2_name, end_name, cost3, daily_cost(day),cost1,cost2,cost3,cost4);
end

fprintf('--------------------------------------------------------\n');
fprintf('5天行程总费用：%d元\n', total_cost);
fprintf('========================================================\n');