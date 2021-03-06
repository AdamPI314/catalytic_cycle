%% global settings
file_dir = fullfile(fileparts(mfilename('fullpath')));

% markers = {'+' , 'o' , '*' , 'x' , 'square' , 'diamond' , 'v' , '^' , '>' , '<' , 'pentagram' , 'hexagram' , '.', 'none'};
markers = {'+' , 'o' , '*' , 'x' , 'square' , 'diamond' , 'v' , '^' , '>' , '<' , 'pentagram' , 'hexagram' , '.'};
spe_idx = '60';
atom_f = 'HA4';
spe_name = 'nR';
tau = 0.777660157519;
end_t = '0.9';

%% for contour plot
% fn_2d_f1 = fullfile(file_dir, '..', ['Merchant_f_2d_S61_C_0.9_100000000_10000_100.csv']);
fn_2d_f1 = fullfile(file_dir, '..', ['Merchant_f_2d_S60_HA4_0.9_100000000_10000_100.csv']);

n_path1 = 100;
delimiter1 = ',';
formatStr1 = '%f%f%f';
for i=1:n_path1
    formatStr1 = strcat(formatStr1, '%f');
end
formatStr1 = strcat(formatStr1, '%[^\n\r]');
formatSpec1 = char(formatStr1);
% Open the text file.
fileID1 = fopen(fn_2d_f1,'r');
dataArray1 = textscan(fileID1, formatSpec1, 'Delimiter', delimiter1, 'EmptyValue', NaN,  'ReturnOnError', false);
% Close the text file.
fclose(fileID1);
f_mat1 = [dataArray1{1:end-1}];
t01 = f_mat1(:, 1); 
tf1 = f_mat1(:, 2);
% convert time to seconds
for i = 1:length(t01)
    t01(i) = t01(i) * tau;
    tf1(i) = tf1(i) * tau;
end
% path index
offset1 = 2;
path_idx1 = linspace(1+3, n_path1, n_path1-1+1-3);
for i = 1:length(path_idx1)
    if i==1
        f_value1 = f_mat1(:, offset1 + path_idx1(i));
    else
        f_value1 = f_value1 + f_mat1(:, offset1 + path_idx1(i));
    end    
end
% construct 3d surface
xlin1 = linspace(min(t01), max(t01), 25);
ylin1 = linspace(min(tf1), max(tf1), 25);
[X1,Y1] = meshgrid(xlin1, ylin1);
f1 = scatteredInterpolant(t01, tf1, f_value1);
Z1 = f1(X1,Y1);
% update Z
for i = 1:length(X1)    
    for j = i+1:length(X1)
        Z1(i,j) = nan;
    end
end

%% read pathway data
% fn_2d_f2 = fullfile(file_dir, ['Merchant_f_2d_S61_C_0.9_100000000_10000_100', '.csv']);
fn_2d_f2 = fullfile(file_dir, ['Merchant_f_2d_S60_HA4_0.9_100000000_10000_100', '.csv']);

n_path2 = 100;
delimiter2 = ',';
formatStr2 = '%f%f%f';
for i=1:n_path2
    formatStr2 = strcat(formatStr2, '%f');
end
formatStr2 = strcat(formatStr2, '%[^\n\r]');
formatSpec2 = char(formatStr2);
fileID2 = fopen(fn_2d_f2,'r');
dataArray2 = textscan(fileID2, formatSpec2, 'Delimiter', delimiter2, 'EmptyValue', NaN,  'ReturnOnError', false);
fclose(fileID2);
f_mat2 = [dataArray2{1:end-1}];
t02 = f_mat2(:, 1);
tf2 = f_mat2(:, 2);
% delta t
tf2 = tf2 - t02;
offset2 = 2;
% path index
path_idx2 = linspace(1+3, n_path2, n_path2-1+1-3);
delta_t_vec2 = [1.2859087486111409e-06, 0.001285908748611141, 0.01285908748611141, 0.1285908748611141, 0.3214771871527852, 0.6429543743055705];
y_label_str2 = '$\sum_{i=4}^{100}{\chi_{i}^{nR}}$';
title_p2 = '$iR$';
%% interpolation
for i = 1:length(path_idx2)
    if i==1
        f_value2 = f_mat2(:, offset2 + path_idx2(i));
    else
        f_value2 = f_value2 + f_mat2(:, offset2 + path_idx2(i));
    end    
end
% construct 3d surface
xlin2 = linspace(min(t02), max(t02), 25);
ylin2 = linspace(min(tf2), max(tf2), 25);
[X2,Y2] = meshgrid(xlin2, ylin2);
f2 = scatteredInterpolant(t02, tf2, f_value2);
% x axis
X_tmp2 = X2(1, :);

%% plot
fig = figure();
n_xaxis = 2;
x_ratio = 1.0;
y_ratio = 1.0/3.0;
spacex = 0.01;
spacey = 0.02;
spacebottom = 0.05;
xpos = [0.15 0.95];
ypos = [0.07, 0.50, 0.50, 0.95];

% %##########################################################################
% % Panel 2
% %##########################################################################
iax = 1; % Or whichever
x0=xpos(1); y0=ypos((length(ypos)/2 - iax)*2 + 1); spanx=xpos(2) - xpos(1); spany=ypos((length(ypos)/2 - iax)*2 + 1 + 1) - ypos((length(ypos)/2 - iax)*2 + 1);
%% [left bottom width height]
pos = [x0 y0 spanx spany];
subplot('Position',pos);

% reduce number of s.f. in coutour plot
contour(X1,Y1,Z1, 20, 'ShowText', 'on');
hold on;
axis tight;
%% settings
set(gca,'GridLineStyle','--');
% xlabel('$t$ (seconds)', 'Interpreter','latex', 'FontSize', 20);
ylabel('$t_f$ (seconds)', 'Interpreter','latex', 'FontSize', 20);
% xlim([0, tau*str2double(end_t)]);
% ylim([0, tau*str2double(end_t)]);
grid on;
xticklabels([]);

%% text
a_x1 = gca;
t_x1 = a_x1.XLim(1) + 0.525*(a_x1.XLim(2) - a_x1.XLim(1));
t_y1 = a_x1.YLim(1) + 0.278*(a_x1.YLim(2) - a_x1.YLim(1));
text(t_x1, t_y1, [spe_name, '@ $t$' char(10) 'stop path@ $t_f$' char(10) '$t_f > t$'], 'Interpreter','latex', 'FontSize', 20);

%##########################################################################
% Panel 2
%##########################################################################
iax = 2; % Or whichever
x0=xpos(1); y0=ypos((length(ypos)/2 - iax)*2 + 1); spanx=xpos(2) - xpos(1); spany=ypos((length(ypos)/2 - iax)*2 + 1 + 1) - ypos((length(ypos)/2 - iax)*2 + 1);
%% [left bottom width height]
pos = [x0 y0 spanx spany];
subplot('Position',pos);

%% plot
N2 = length(delta_t_vec2);
colors2 = lines(N2);
% colors = colorcube(N);
str_name2 = cell(N2,1);
for i=1:N2
    str_name2{i, 1} = strcat('$\delta$t=', num2str(delta_t_vec2(i)*tau,'%1.1e\n'));
end

H2 = gobjects(N2);

for idx=1:N2
    % delta
    delta_t2 = ones(1, length(X_tmp2));
    delta_t2 = delta_t2.* delta_t_vec2(idx);
    Z_tmp2 = f2(X_tmp2, delta_t2);
    % check data
    for i=1:length(X_tmp2)
        if X_tmp2(i) + delta_t2(i) > str2double(end_t)
            Z_tmp2(i) = nan;
        end
    end
    H2(idx) = plot(X_tmp2 * tau, Z_tmp2, 'LineWidth', 2, 'color', colors2(idx, :), ...
        'marker', markers{1, mod(idx-1, length(markers))+ 1}); hold on;
    hold on;
end


%% settings
set(gca,'GridLineStyle','--');
xlabel('$t$ (seconds)', 'Interpreter','latex', 'FontSize', 20);
ylabel(y_label_str2, 'Interpreter','latex', 'FontSize', 20);
% ylabel(y_label_str, 'FontSize', 20);
% xlim([0, tau*str2double(end_t)]);
xlim([0, max(X_tmp2 * tau)]);
% ylim([0, tau*str2double(end_t)]);

% title(title_p2, 'Interpreter','latex', 'FontSize', 20);
grid on;
a_x2 = gca;
t_x2 = a_x2.XLim(1) + 0.325*(a_x2.XLim(2) - a_x2.XLim(1));
t_y2 = a_x2.YLim(1) + 0.625*(a_x2.YLim(2) - a_x2.YLim(1));
text(t_x2, t_y2, [spe_name, '@ $t$' char(10) 'stop path@ t+$\delta t$'], 'Interpreter','latex', 'FontSize', 20);

%%  legend
leg_h2 = legend(str_name2, 'Interpreter','latex');
set(leg_h2, 'FontSize', 12, 'Box', 'off');

%##########################################################################
% Figure size
%##########################################################################
x0=10;
y0=10;
width=400;
height=650;
set(gcf,'units','points','position',[x0,y0,width,height]);

%% save to file
figname = strcat('2d_Merchant_f_spur_cycle_', end_t, '_S', spe_idx, '_v4_delta_t_2_in_1_v2.png');
print(fig, fullfile(file_dir, figname), '-r200', '-dpng');


