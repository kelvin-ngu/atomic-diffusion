% Part 4: 2D Model + Energy Barrier + Electric Field
tic

% clear all previous variables
clearvars

% Create 5 figures in advance
f1 = figure;
f2 = figure;
f3 = figure;
f4 = figure;
f5 = figure;

% Introduce parameters
nsites = 300; % Number of lattice sites
nsteps = 150; % Number of steps
ntrials = 7000; % Number of trials
E = 50; % Energy
T_min = 10;
T_max = 1000;
d = 5; % Temperature interval, d

% Introduce electric field values
Wvec = [10, 50, 100];   

% create for loop to investigate displacement under each W value condition
for q = 1 : length(Wvec)                  
    W = Wvec(q);

    % Initial position
    start_pos = [nsites/2, nsites/2];
    T = T_min;
    
    % Pre-allocate array
    n = (T_max - T_min)/d;             % n is the number of data points
    xdisp = zeros(ntrials, 1);         % displacement in x-direction
    ydisp = zeros(ntrials, 1);         % displacement in x-direction
    xmean = zeros(n, 1);               % mean x displacement
    ymean = zeros(n, 1);               % mean y displacement
    dispmean = zeros(n, 1);            % mean total displacement
    disprms = zeros(n, 1);             % rms total displacement
    dispstd = zeros(n, 1);             % standard deviation of total displacement
    temp = zeros(n, 1);                % temperature

    % Outer loop to investigate the effect of temperature
    for p = 1 : n
        % Trial loop
        for t = 1 : ntrials
            % Initialize position
            pos = start_pos;
            
            % Pre-compute acceptance probability of in y-direction
            % under effects of E, T and W
            ay = exp(-E/T); % no effect in y-direction

            % Generate random directions in advance
            dir = randi([1, 4], nsteps, 1);
            
            % Iterate over steps
            for m = 1 : nsteps
                % Compute new position
                switch dir(m)
                    case 1 % move left
                        new_pos = pos - [1, 0];
                        ax = exp(-(E - W)/T); % W favours movement in leftwards direction
                    case 2 % move right
                        new_pos = pos + [1, 0]; % W restricts movement in rightwards direction
                        ax = exp(-(E + W)/T);
                    case 3 % move down
                        new_pos = pos - [0, 1];
                    case 4 % move up
                        new_pos = pos + [0, 1];
                end
                
                % Compute acceptance probabilities
                if new_pos(1) ~= pos(1)
                    a = ax; % if x-position changes, consider ax
                else
                    a = ay; % if x-position does not change, consider ay
                end
                
                % Accept or reject move
                if rand() < a
                    pos = new_pos;
                end
            end
            % Compute final displacement and store in array
            xdisp(t) = start_pos(1) - pos(1);
            ydisp(t) = start_pos(2) - pos(2);
        end
        temp(p) = T;
        xmean(p) = mean(xdisp);
        ymean(p) = mean(ydisp);
        disp = sqrt(xdisp.^2 + ydisp.^2);
        dispmean(p) = mean(disp);
        disprms(p) = rms(disp);
        dispstd(p) = std(disp);
        T = T + d;
    end

    figure(f1);
    hold on
    plot(temp, xmean, '.');
    xlabel('Temperature, T');
    ylabel('Mean of x-displacement');
    title('Effect of Temperature on x-displacement');
    legend('W1 = 10', 'W2 = 50', 'W3 = 100');
    hold off

    figure(f2);
    hold on
    plot(temp, ymean, '.');
    ylim([-4, 4]);
    xlabel('Temperature, T');
    ylabel('Mean of y-displacement');
    title('Effect of Temperature on y-displacement');
    legend('W1 = 10', 'W2 = 50', 'W3 = 100');
    hold off

    figure(f3);
    hold on
    plot(temp, dispmean, '.');
    xlabel('Temperature, T');
    ylabel('Mean of Total Displacement, r');
    title('Effect of Temperature on Total Displacement Mean');
    legend('W1 = 10', 'W2 = 50', 'W3 = 100');
    hold off

    figure(f4);
    hold on
    plot(temp, disprms, '.');
    xlabel('Temperature, T');
    ylabel('RMS of Total Displacement, r');
    title('Effect of Temperature on Total Displacement RMS');
    legend('W1 = 10', 'W2 = 50', 'W3 = 100');
    hold off

    figure(f5);
    hold on
    plot (temp, dispstd,'.');
    title('Effect of Temperature on Standard Deviation of Displacement');  
    xlabel('Temperature, T');             
    ylabel('Standard Devation of Total Displacement, r');
    legend('W1 = 10', 'W2 = 50', 'W3 = 100');
    hold off
end
toc