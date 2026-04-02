clc; clear; close all;

% -----------------------------
% PARAMETERS
% -----------------------------
c = 320;
m = 0.002;
h = 0.05;
T_env = 25;

k_const = 5;   % power scaling factor

% Field values
B_values = [0.5, 1.0, 1.5, 2.0];

% Time
dt = 0.01;
t_end = 5;
t = 0:dt:t_end;

% -----------------------------
% FIGURE 1: TIME RESPONSE
% -----------------------------
figure;
hold on;

for k = 1:length(B_values)

    B = B_values(k);

    T = zeros(size(t));
    T(1) = T_env;

    for i = 2:length(t)

        P = k_const * B^2;

        dTdt = (P - h*(T(i-1) - T_env)) / (m*c);
        T(i) = T(i-1) + dTdt * dt;
    end

    plot(t, T, 'LineWidth', 2, ...
        'DisplayName', ['B = ', num2str(B)]);
end

xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Induction Heating');
legend;
grid on;

% -----------------------------
% FIGURE 2: CONTROL GRAPH
% -----------------------------
B_range = linspace(0.2, 2.0, 10);
T_ss = zeros(size(B_range));

for k = 1:length(B_range)

    B = B_range(k);

    P = k_const * B^2;
    T_ss(k) = T_env + P / h;
end

figure;
plot(B_range, T_ss, 'o-', 'LineWidth', 2);
xlabel('Magnetic Field Strength B');
ylabel('Steady-State Temperature (°C)');
title('Induction Heating: Temperature vs Magnetic Field');
grid on;