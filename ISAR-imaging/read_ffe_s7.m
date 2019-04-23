function  read_ffe_s7(num_sam,pol)
% Description: read  the *.txt  file of Feko situ. 7.
% Input parameters:
%          num_sam - the number samples in frequency, elevation, and
%          azimuth:  [Ne,Na,Nf]=[俯角，方位角，频率]
%          pol - polarized type,{'H','V'} 极化类型
%%
[FileName,PathName]   = uigetfile('*.txt', 'Select the FEKO data file to open'); %选择文件
fid = fopen([PathName,FileName], 'r');
FileName = strtok(FileName,'.');
%%
Ne = num_sam(1);          % Number of elevation samples
Na = num_sam(2);          % Number of azimuth samples
Nf = num_sam(3);          % Number of frequency samples
%%
fname = strtok(FileName,'.');
%%
N = Ne*Na*Nf;
data = textread('farfield.txt');
% 1"Theta"  2"Phi"  3"Re(Etheta)"   4"Im(Etheta)"   5"Re(Ephi)"
%6"Im(Ephi)"    7"RCS(Theta)"   8"RCS(Phi)" 9"RCS(Total)"
if Ne == 1
    E_theta_r = reshape(data(:,3),Na,Nf);           % Real component
    E_theta_i = reshape(data(:,4),Na,Nf);           % Imaginary component
    E_phi_r = reshape(data(:,5),Na,Nf);             % Real component
    E_phi_i = reshape(data(:,6),Na,Nf);             % Imaginary component
    RCS_theta=reshape(data(:,7),Na,Nf);             %RCS theta
    RCS_phi=reshape(data(:,8),Na,Nf);               %RCS phi
else
    E_theta_r = reshape(data(:,3),Ne,Na,Nf);        % Real component
    E_theta_i = reshape(data(:,4),Ne,Na,Nf);        % Imaginary component
    E_phi_r = reshape(data(:,5),Ne,Na,Nf);          % Real component
    E_phi_i = reshape(data(:,6),Ne,Na,Nf);          % Imaginary component
    RCS_theta=reshape(data(:,7),Na,Nf);             %RCS theta
    RCS_phi=reshape(data(:,8),Na,Nf);               %RCS phi
end
E_theta = E_theta_r + 1i*E_theta_i;
E_phi = E_phi_r + 1i*E_phi_i;
if pol == 'H'
    phdata = struct('HV',E_theta,'HH',E_phi,'RCS_HH',RCS_phi,...
        'RCS_HV',RCS_theta);
    HV = E_theta;
    HH = E_phi;
    RCS_HH=RCS_phi;
    RCS_HV=RCS_theta;
    save(fname,'HV','HH','RCS_HV','RCS_HH');
else
    phdata = struct('VV',E_theta,'VH',E_phi,'RCS_VH',RCS_phi,...
        'RCS_VV',RCS_theta);
    VV = E_theta;
    VH = E_phi;
    RCS_VH=RCS_phi;
    RCS_VV=RCS_theta;
    save(fname,'VV','VH','RCS_VH','RCS_VV');
end
save(fname,'phdata');                               % 生成mat文件

fclose(fid);
