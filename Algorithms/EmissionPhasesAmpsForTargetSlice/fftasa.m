%this functions has been copied from FOCUS, so reference it properly
%it is basically to calculate slices of a wavefield when an emission slice
%is given. It uses the spectral propagator, based on angular spectrum
%theory.

function [fftpress] = fftasa(p0,z,medium,N,delta,f0)
% Usage:
% [fftpress] = fftasa(p0,z,medium,N,delta,sign);
% Input parameter:
% p0 - matrix of size [nx,ny], input complex pressure
% z - location of the plane
% medium -> soundspeed and attenuationdBcmMHz
% N - FFT grid number.
% delta - scalar,spatial sampling interval in m.
% Output parameter:
% fftpress - matrix of size [nx,ny], calculated pressure.
wavelen=medium.soundspeed/f0;
dBperNeper = 20 * log10(exp(1));
attenuationNeperspermeter=medium.attenuationdBcmMHz/dBperNeper*100*f0/ 1e6;

fftpressz0 = fft2(p0,N,N);

wavenum = 2*pi/wavelen;
if mod(N,2) % odd number
    kx = [(-N/2-0.5):1:(N/2-1.5)]*wavelen/(N*delta);
    ky = [(-N/2-0.5):1:(N/2-1.5)]*wavelen/(N*delta);
else % even number
    kx = [(-N/2):1:(N/2-1)]*wavelen/(N*delta);
    ky = [(-N/2):1:(N/2-1)]*wavelen/(N*delta);
end

[kxspace,kyspace] = meshgrid(kx,ky);
kxsq_ysq = fftshift(kxspace.^2 + kyspace.^2);
kzspace = wavenum*sqrt(1 - kxsq_ysq);
        
% Basic spectral propagator
if z>0
    H = conj(exp(1j*z.*kzspace));
else
    H = exp(-1j*z.*kzspace).*(kxsq_ysq<=1);
end

%% attenuation
if attenuationNeperspermeter>0
    evans_mode = sqrt(kxsq_ysq)<1;
    H =H.*exp(- attenuationNeperspermeter * delz./cos(asin(sqrt(kxsq_ysq))).*evans_mode).*evans_mode;
end

%% angular threshold
D = (N-1)*delta;
thres = sqrt(0.5*D^2/(0.5*D^2+z^2));
filt = (sqrt(kxsq_ysq) <= thres);
H = H.*filt;

fftpress = ifft2(fftpressz0.*H,N,N);