clear all;
close all;
clc;

% reads spectrum data from file into N x 2 array via gui interface
[FileName, PathName, FilterIndex] = uigetfile('*.txt');
origSpectralData = dlmread(strcat(PathName,FileName));
% origSpectralData = dlmread('Minerals\Clintonite__R070196__Raman__785.txt');

% x is the column vector of raman shifts
x = origSpectralData(:,1);

% y is the column vector of intensities
y = origSpectralData(:,2);

xfilt = x;
yfilt = sgolayfilt(y, 2, 21);

[x1, y1] = firstDeriv(xfilt, yfilt);

noise = std(y1);
peaksx = [];
peaksy = [];
currMaxValid = false; currMax = 0;
currZeroPt = 2;
for i = 2:length(y1)
     if and(y1(i) > noise, not(currMaxValid))
        currMaxValid = true;
        currMax = y1(i);
     elseif and(y1(i-1) >= 0, y1(i) < 0)
         currZeroPt = i+1;
     elseif and(currMaxValid, y1(i) > y1(i-1))
        if currMax - y1(i-1) > 1.5*noise
            peaksx(end+1) = x1(currZeroPt-1);
            peaksy(end+1) = abs(currMax - yfilt(i-1));
        end
        currMaxValid = false;
     end
end

subplot(3, 1, 1);
plot(xfilt, yfilt);
% xlim([100 x(end)]);

subplot(3, 1, 2);
plot(x1, y1);
% xlim([100 x(end)]);

subplot(3, 1, 3);
scatter(peaksx, peaksy);
% xlim([100 x(end)]);

% [shifts, heights] = computePeaks(x, y);
% 
% subplot(2, 1, 1);
% plot(x, y);
% xlim([x(1) x(end)]);
% 
% subplot(2, 1, 2);
% scatter(shifts, heights);
% xlim([x(1) x(end)]);