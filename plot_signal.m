function plot_signal(simOut,signal,signal_name,title_name)

logsout = simOut.logsout;

% Find the specific signal
mySignal = logsout.get(signal);

% Extract time and data
time = mySignal.Values.Time;
data = mySignal.Values.Data;

plot(time, data);
xlabel('Time (s)');
ylabel(signal_name);
title(title_name);

end

