clc; clear; close all;

% -----------------------------
% PARAMETERS
% -----------------------------
R = 2.0;
c = 320;
m = 0.002;
h = 0.05;
T_env = 25;

C = 0.01;

% Voltage values
V0_values = [5, 10, 15, 20];

% Time
dt = 0.0005;
t_end = 2;
t = 0:dt:t_end;

% -----------------------------
% FIGURE 1: TIME RESPONSE
% -----------------------------
figure;
hold on;

for k = 1:length(V0_values)

    V0 = V0_values(k);

    T = zeros(size(t));
    T(1) = T_env;

    for i = 2:length(t)

        I = (V0 / R) * exp(-t(i)/(R*C));
        P = I^2 * R;

        dTdt = (P - h*(T(i-1) - T_env)) / (m*c);
        T(i) = T(i-1) + dTdt * dt;
    end

    plot(t, T, 'LineWidth', 2, ...
        'DisplayName', ['V0 = ', num2str(V0)]);
end

xlabel('Time (s)');
ylabel('Temperature (°C)');
title('Pulsed Heating (Capacitor Discharge)');
legend;
grid on;

% -----------------------------
% FIGURE 2: CONTROL GRAPH
% -----------------------------
V0_range = linspace(2, 20, 10);
T_peak = zeros(size(V0_range));

for k = 1:length(V0_range)

    V0 = V0_range(k);
    T = T_env;

    for i = 2:length(t)

        I = (V0 / R) * exp(-t(i)/(R*C));
        P = I^2 * R;

        dTdt = (P - h*(T - T_env)) / (m*c);
        T = T + dTdt * dt;
    end

    T_peak(k) = T;
end

figure;
plot(V0_range, T_peak, 'o-', 'LineWidth', 2);
xlabel('Initial Voltage V_0 (V)');
ylabel('Peak Temperature (°C)');
title('Pulsed Heating: Peak Temperature vs Voltage');
grid on;