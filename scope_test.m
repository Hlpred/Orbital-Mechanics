simOut = sim('Hohmann_outbound_sim.slx', 'ReturnWorkspaceOutputs', 'on');

logsout = simOut.logsout;

% Find the specific signal
mySignal = logsout.get('mars_dist'); % Replace 'SignalName' with your logged signal name

% Extract time and data
time = mySignal.Values.Time;
data = mySignal.Values.Data;

% Plot if needed
plot(time, data);
xlabel('Time (s)');
ylabel('Signal Value');
title('Logged Signal Output');
