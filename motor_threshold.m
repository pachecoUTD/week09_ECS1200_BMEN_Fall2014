%% Setup
% Before running this code, connect to the Arduino using the command
% a = arduino('COM3');
% Note: your COM port number may be different

%% Get ready to record / start motors
seconds_to_record = 20;
pause_time = 0.1;

fprintf('Ready to record. Press enter to start recording...');
pause
fprintf('\n');
% Save the current time
time0 = now;

%% Initialize motors and assign ID to variable name
initialize_motor5
motorID_A = 1;

% Set motor speed
motorSpeed = 255;
motor5 = motorController(a, motor5, motorID_A, 'speed', motorSpeed);

% This command runs motor 'motorID' forward.
motor_direction = 'forward';
motor5 = motorController(a, motor5, motorID_A, motor_direction);

%% initialize etime and data vectors and start recording data
etime = []; 
dataADC = [];

figure(1);clf;
hold on;
while ((now-time0)*24*3600) < seconds_to_record
    
    % read potentiometer signal from analog channel 1
    dataV = analogRead(a, 1);
    timeV = now;

    % update data vector using array concatenation
    dataADC = [dataADC dataV];
    
    % update etime vector using array concatenation
    etime = [etime (timeV-time0)*24*3600];

    % plot the data you have collected so far
    figure(1);
    plot(etime, dataADC);
    axis([0 seconds_to_record 0 1023]);
    xlabel('Time (sec)');
    ylabel('Raw ADC units');
    title('Potentiometer signal');
    grid on; box on; 

    % force Matlab to update the plot
    drawnow;

    if (dataV < 200) || (dataV > 800)
        % Issue a 'release' command to stop the motor
        motor5 = motorController(a, motor5, motorID_A, 'release');
    else 
        % Keep the motor running in the same direction or it if it stopped
        % start it up again
        motor5 = motorController(a, motor5, motorID_A, motor_direction);
    end

    % pause for fixed time
    pause(pause_time);
         
end
motor5 = motorController(a, motor5, motorID_A, 'release');










