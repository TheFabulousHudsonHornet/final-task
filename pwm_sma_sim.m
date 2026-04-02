clc; clear; close all;

% -----------------------------
% PARAMETERS
% -----------------------------
R = 2.0;            % Resistance (Ohms)
I = 2.0;            % Current (A)
c = 320;            % Specific heat (J/kgK)
m = 0.002;          % Mass (kg)
h = 0.05;           % Heat loss coefficient
T_env = 25;         % Ambient temperature (°C)

% Phase transformation parameters
T_s = 50;           % Start temperature
T_f = 65;           % Finish temperature
L = 20000;          % Latent heat (J/kg)

% Time settings
dt = 0.01;
t_end = 10;
t = 0:dt:t_end;

% Duty cycles
D_values = [0.1, 0.3, 0.5, 0.7, 0.9];

% -----------------------------
% FIGURE 1: LINEAR MODEL
% -----------------------------
figure;
hold on;

for k = 1:length(D_values)

    D = D_values(k);

    T = zeros(size(t));
    T(1) = T_env;

    for i = 2:length(t)

        % Average power
        P = D * I^2 * R;

        % Linear thermal model
        dTdt = (P - h*(T(i-1) - T_env)) / (m*c);

        T(i) = T(i-1) + dTdt * dt;
    end

    plot(t, T, 'LineWidth', 2, ...
        'DisplayName', ['D = ', num2str(D)]);
end

yline(T_s, '--', 'T_s');
yline(T_f, '--', 'T_f');

xlabel('Time (s)');
ylabel('Temperature (°C)');
title('PWM Heating (Linear Model)');
legend;
grid on;

% -----------------------------
% FIGURE 2: PHASE MODEL
% -----------------------------
figure;
hold on;

for k = 1:length(D_values)

    D = D_values(k);

    T = zeros(size(t));
    T(1) = T_env;

    xi = 0; % phase fraction

    for i = 2:length(t)

        P = D * I^2 * R;

        if T(i-1) >= T_s && T(i-1) <= T_f

            dxi_dt = P / (m * L);
            xi = min(1, xi + dxi_dt * dt);

            dTdt = (P - h*(T(i-1) - T_env) - m*L*dxi_dt) / (m*c);

        else
            dTdt = (P - h*(T(i-1) - T_env)) / (m*c);
        end

        T(i) = T(i-1) + dTdt * dt;
    end

    plot(t, T, 'LineWidth', 2, ...
        'DisplayName', ['D = ', num2str(D)]);
end

yline(T_s, '--', 'T_s');
yline(T_f, '--', 'T_f');

xlabel('Time (s)');
ylabel('Temperature (°C)');
title('PWM Heating with Phase Transformation');
legend;
grid on;