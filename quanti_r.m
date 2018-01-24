function [lq_data,nlq_data]=quanti_r(data,bitsq,zeroLevel)
%----------------------------------------------------
%------  Author :   Constantino Carlos Reyes-Aldasoro
%------             PHD     the University of Warwick
%------  Supervisor :   Abhir Bhalerao    -----------
%------  18 October 2001 ----------------------------
%----------------------------------------------------
%------   [lq_data,nlq_data]=quanti_r(data,bitsq)
%------   quantise data to a certain number of levels
%------   input  : data  the image to quantise
%------            n number of  bits for the quantisition
%------   output : lq_data  linear quantising of the image
%------            nlq_data  nonlinear quantising of the image

%------ no input data is received, error -------------------------
if nargin<1  help quanti_r; lq_data=[]; return; end;

%------ no quantisation bits input, then asume 1 bit
if nargin==1     bitsq=1;  end;

% [lins,cols,levels]=size(data);
% desvdata=round(std2(data));

maxdata=max(max(max(data)));
if exist('zeroLevel')
    mindata=0;
else
    mindata=min(min(min(data)));
end

%------ case of all zeros, return from here
if (maxdata==0&mindata==0); lq_data=data; nl_qdata=data; return; end

%------ case of constant intensity, return from here
if mindata==maxdata; lq_data=data; nl_qdata=data; return; end

%------ case of values between 0 and 1, enlarge because the 'round' does not work for small numbers
if maxdata<=1  
    lq_data=(round(data*(2^bitsq-1)))/(2^bitsq-1); 
    nl_qdata=data; return; 
end
% if maxdata==1  
%     delta=1e-10;
%     lq_data=(floor((data-delta)*2^bitsq))/(2^bitsq-1); 
%     nl_qdata=data; return; 
% end

%if maxdata==1  lq_data=(floor(data*2^bitsq))/(2^bitsq); nl_qdata=data; return; end


maxbits=ceil(log2(maxdata-mindata));        %------ number of bits that describe the data

%------ makes sure that the levels remains possible
if bitsq>=maxbits                           %------ this means that the data has LESS levels than those of the bitsq
   lq_data=data; return;  % bitsq=maxbits-1;%------ leave it just like that
end;
if bitsq==0                        %------ this means that the data has LESS levels than those of the bitsq
   lq_data=data; return;  % bitsq=maxbits-1;%------ leave it just like that
end;

%step=(maxdata-mindata)/(2^n-1);
%------  Step can needs to be a real value (i.e. decimal values) in order to
%------  get the actual number of levels!

step=((maxdata-mindata)/(2^bitsq-1));


%------ linear quantising------ 
%??????? floor or round ?????????????
lq_data=round(mindata+step*round((data-mindata)/step));


%q_data=0.001+desvdata*fix(data*n/desvdata);

% %------ non-linear quantising------ 
% sg_data=sign(data);
% abs_data=(abs(data));
% max_absdata=max(max(max(abs_data)));
% nl_data= 10.^(abs_data/max_absdata);
% maxnldata=max(max(max(nl_data)));
% minnldata=min(min(min(nl_data)));
% nlstep=(maxnldata-minnldata)/(2^(bitsq-1)-1);
% nlq_data=0.2*max_absdata*sg_data.*log10(1+nlstep*fix(nl_data/nlstep));


   
