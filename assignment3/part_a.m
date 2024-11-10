load('BFVdata_assignment3.mat');

% plot the signal
figure;
plot(t, BFVdu);
title('Entire Signal: BFVdu');
xlabel('Time (seconds)');
ylabel('Blood Flow Velocity (m/s)');