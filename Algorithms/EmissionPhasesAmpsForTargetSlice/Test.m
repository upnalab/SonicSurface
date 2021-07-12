targetfile = 'target_a.png';

targetAmp = double( rgb2gray( imread(targetfile) ) );
targetAmp = targetAmp / max(max(targetAmp)); %normalize

%these are the paremeters for SonicSurface
[amps, phases, ampSlice] = calcEmissionForTargetAmpSlice(targetAmp, 0.16, 50, 0.16, 40000,340,0.01, 0, 32);

%Plot the target and the obtained image
subplot(2,1,1);
imagesc( targetAmp );
title('target');
subplot(2,1,2);
imagesc( ampSlice );
title('obtained');

%Output the mean square error
targetAmp = targetAmp ./ max(max(targetAmp)); %normalize
ampSlice = ampSlice ./ max(max(ampSlice));
mse = sum(sum( (targetAmp-ampSlice).^2 )) ./ numel(ampSlice);
disp( mse );

