function [amps, phases, ampSlice] = calcEmissionForTargetAmpSlice(targetAmpSlice, dist, iters, sliceSize,freq,soundSpeed,emitterSize, ampRes, phaseRes)
%targetAmpSlice: a matrix containing the target amplitude, should be square, and width a power of 2
%dist: distance from the emitter slice to the target slice 
%iters: iterations of the algorithm
%sliceSize: side of the emission and target slice 
%freq: of the waves
%soundSpeed: the propagation speed
%emitterSize: the diameter of the emitters
%ampRes: amplitude resolution. 0 = no amplitude control
%phaseRes: phase resolution

[w,h] = size(targetAmpSlice);
assert( w == h );
assert( 2^nextpow2(w) == w );

target = zeros(w,h);
emission = zeros(w,h);
nEmittersPerSide = floor(sliceSize / emitterSize);
nEmitters = nEmittersPerSide*nEmittersPerSide;
emitterPx = w/nEmittersPerSide;

%amplitude mask: a grid of circles that represent the emitters
mask = zeros(w,h);
emPx2 = emitterPx*emitterPx/4;
for ix=1:w
    for iy=1:h
        diffX = ix - (floor(ix/emitterPx)*emitterPx + emitterPx/2);
        diffY = iy - (floor(iy/emitterPx)*emitterPx + emitterPx/2);
        if (diffX*diffX + diffY*diffY < emPx2) %distance to its center
            mask(ix,iy) = 1;
        end
    end
end

medium = {};
medium.soundspeed = soundSpeed;
medium.attenuationdBcmMHz = 0; %for air we could use 1.61

for ii=1:iters
    %stamp targetAmpSlice into target. We retain the phases though.
    target = targetAmpSlice .* exp(1i * angle(target) );
    
    %backpropagate targetSlice back to emissionSlice
    emission = fftasa(target,-dist,medium, w,sliceSize/w,freq);

    %apply constraints on the emission slice
    amp = abs(emission);
    phase = angle(emission);
    %downscale to average the pixels occupied by each emitters into 1 pixel each
    downAmp = imresize(amp, [nEmittersPerSide, nEmittersPerSide], 'bilinear');
    downPhase = imresize(phase, [nEmittersPerSide, nEmittersPerSide], 'bilinear');
    %discretize amp and phase
    if ampRes == 0
        downAmp = downAmp .* 0 + 1; %set all to ones
    else
        downAmp = fix( downAmp*ampRes )/ampRes;
    end
    if phaseRes == 0
        downPhase = downPhase .* 0; %set all to zeros
    else
        downPhase = fix( downPhase/pi*phaseRes )*pi/phaseRes;
    end
    %upscale using nearest so that the amp/phase is the same in all the pixels occupied by one emitter
    amp = imresize(downAmp, [w, h], 'nearest');
    phase = imresize(downPhase, [w, h], 'nearest');
    %apply Mask to emission, i.e. the circular shape of the emitters.
    amp = amp .* mask;
    %combine amp and phase into its complex representation
    emission = amp .* exp(1i * phase );
    
    %propagate emission to target
    target = fftasa(emission,dist,medium, w,sliceSize/w,freq);
end

  ampSlice = abs(target);
  
  %extract amps and phases for each emitter  
  amps = zeros(1,nEmitters);
  phases = zeros(1,nEmitters);
  index = 1;
  for ix=1:nEmittersPerSide
    for iy=1:nEmittersPerSide
        centerX = round(ix*emitterPx - emitterPx/2);
        centerY = round(iy*emitterPx - emitterPx/2);
        %get the emission amp/phase at the center of the emitter
        em = emission(centerX, centerY);
        amps(index) = abs(em);
        phases(index) = angle(em);
        index = index+1;
    end
  end
  
end