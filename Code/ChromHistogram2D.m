function ChromHistogram2D(chrom3D_im1,numFig,figTitle)
%function ChromHistogram2D(finalResults,numFig,figTitle)
% a function to plot a 3D cloud of points from a Chromaticity
% histogram analysis. The input 'finalResults', is a 3D N x N x N matrix
% where the data of Hue, Saturation and Value have been previously obtained
% with chromaticAnalysis.m. 'numFig' can be a number of the figure to plot
% the data or a handle to a subplot (optional). 'figTitle' is a string with the title
% of the figure (optional).
 

if ~exist('numFig','var'); 
    numFig                      = 3; 
end
if ~exist('figTitle','var'); 
    figTitle                    ='3D Chromaticity Cloud : m  _{ HSV}(h,s,v)  ';
end

[numSat,numHue,numVal]          =size(chrom3D_im1);

if numVal>1
    %chrom3D_im1=removeImageOutliers(chrom3D_im1,5);
    %chrom3D_im1=convn(chrom3D_im1,gaussF(3,3,3),'same');
    chrom2D_im1=sum(double(chrom3D_im1),3);
    chrom2D_im1=chrom2D_im1./sum(chrom2D_im1(:));
else
    chrom2D_im1=chrom3D_im1./sum(chrom3D_im1(:));
    
end




% chrom1D_im1=sum(chrom2D_im1);
% chrom1D_im1=chrom1D_im1./sum(chrom1D_im1);


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% First figure  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Second figure  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%


if ishandle(numFig)
    typeHandle                      = get(numFig,'type');
    if strcmp(typeHandle(1:3),'fig')
        figure(numFig);%subplot(142);
        clf;
        labelSize                       = 11;
        titSize                         = 12;        
    else    
        subplot(numFig)
        cla;
        labelSize                       = 9;
        titSize                         = 10;
    end
else
    figure(numFig);%subplot(142);
    clf;
    labelSize                       = 11;
    titSize                         = 12;
%     try
%         close (numFig)
%     catch
%         q=1;
%     end
end


% try
%     close (numFig)
% catch
%     q=1;
% end
% figure(numFig);%subplot(143);
% labelSize=11;
% titSize=13;



%zdata1=(log10(1+chrom2D_im1));
zdata1=((1e-6+chrom2D_im1));


%%
xdata1=repmat(linspace(0,360,numHue),[numSat,1]); 
ydata1=repmat(linspace(0,1,numSat)',[1,numHue]);
%zdata2=zeros(numSat,numHue)+0.01;
zdata2=zeros(numSat,numHue)+1e-6;
%%
T_HSV(:,:,1)=xdata1/360;
T_HSV(:,:,2)=ydata1;
T_HSV(:,:,3)=0.9;
T_RGB=hsv2rgb(T_HSV);
axes1 = gca;
set(axes1, 'fontsize',labelSize-2,   'ZTick',[1 10 100 1000]*1e-5,...
  'ZTickLabel',['1 e-5';'1 e-4';'1 e-3';'1 e-2']          ,...
  'Parent',gcf);
axis(axes1,[0 360 0 1 0 max(zdata1(:))*1.1]);
stepTick=numHue/8;
set(axes1,'xtick',[1 360*(stepTick:stepTick:numHue)/numHue],'xtickLabel',[0 360*(stepTick:stepTick:numHue)/numHue])
set(axes1,'zscale','log')
xlabel(axes1,'Hue','fontsize',labelSize);
ylabel(axes1,'Saturation','fontsize',labelSize);
zlabel(axes1,'Relative Frequency','fontsize',labelSize);
view(axes1,[-20 120]);
grid(axes1,'on');
hold(axes1,'all');
 
%% Create mesh
mesh1 = mesh(xdata1,...
  ydata1,zdata1,...
  'FaceAlpha',0.5,'edgecolor','k','facecolor','none',...
  'Parent',axes1);
 
%% Create surf
surf1 = surf(...
  xdata1,ydata1,...
  zdata2,T_RGB,...
  'EdgeColor','none',...
  'Parent',axes1);
 
view(159,60);
title(figTitle,'fontsize',titSize)
%title('(c)','fontsize',titSize)