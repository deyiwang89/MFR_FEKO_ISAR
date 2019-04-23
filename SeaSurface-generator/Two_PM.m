function out=Two_PM(U,K)

if (K==0.0) out=K;
else
    tmp=2.0*pi*2.0*pi*8.1e-3/4.0/pi/abs(K)^4;
    out=tmp*exp(-0.74*9.81*9.81/K/K/U^4);
end
