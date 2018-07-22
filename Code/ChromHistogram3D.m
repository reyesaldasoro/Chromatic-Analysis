function ChromHistogram3D(finalResults,numFig,figTitle)

%function ChromHistogram3D(finalResults,numFig,figTitle)
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

%clear I_* rr* gg* bb* xd* yd* zd* T_* surf* h1 h2 axes1 xxx yyy zzz ss vv hh
 
chrom3D_im1                     = finalResults;
[numSat,numHue,numVal]          = size(chrom3D_im1);

%chrom3D_im1=removeImageOutliers(chrom3D_im1,5);
chrom3D_im1                     = convn(chrom3D_im1,gaussF(3,3,3),'same');

[xxx,yyy,zzz]                   = meshgrid(1:numHue,1:numSat,1:numVal);
[hh,ss]                         = meshgrid(linspace(0,1,numHue),linspace(0,1,numVal));
vv                              = ones(numVal,numHue);
for k=1:numVal
    I_HSV(:,:,1)=hh;I_HSV(:,:,2)=ss;I_HSV(:,:,3)=vv*k/numVal;
    I_RGB=hsv2rgb(I_HSV);
    rr(:,:,k)=I_RGB(:,:,1);
    gg(:,:,k)=I_RGB(:,:,2);
    bb(:,:,k)=I_RGB(:,:,3);
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% First figure  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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



hold on
xdata1=repmat(linspace(1,numHue,numHue),[numSat,1]); 
ydata1=repmat(linspace(1,numSat,numSat)',[1,numHue]);
zdata1=0.5+0.5*numHue*ones(numSat,numHue);

xdata2=repmat(linspace(1,numHue,numHue),[numSat,1]); 
ydata2=0.5+0.5*numSat*ones(numHue,numVal);
zdata2=repmat(linspace(1,numVal,numVal)',[1,numHue]);

xdata3=0.5+0.5*numHue*ones(numSat,numVal);
ydata3=repmat(linspace(1,numSat,numSat),[numVal,1]);
zdata3=repmat(linspace(1,numVal,numVal)',[1,numHue]);

%T_HSV(:,:,1)=xdata1;
%T_HSV(:,:,2)=ydata1;
%T_HSV(:,:,3)=0.9;
%T_RGB=hsv2rgb(T_HSV);
axes1 = gca;



surf1 = surf(  xdata1,ydata1,zdata1,'facecolor',0.7*[1 1 1],'EdgeColor','none','Parent',axes1 ); %#ok<NASGU>
surf2 = surf(  xdata2,ydata2,zdata2,'facecolor',0.7*[1 1 1],'EdgeColor','none','Parent',axes1 ); %#ok<NASGU>
surf3 = surf(  xdata3,ydata3,zdata3,'facecolor',0.9*[1 1 1],'EdgeColor','none','Parent',axes1 ); %#ok<NASGU>


 alpha(0.5)


scatter3(xxx(chrom3D_im1>0),yyy(chrom3D_im1>0),zzz(chrom3D_im1>0),6+15*log(1+chrom3D_im1(chrom3D_im1>0)),[rr(chrom3D_im1>0) gg(chrom3D_im1>0) bb(chrom3D_im1>0) ],'filled');%,'markeredgecolor',0.5*[1 1 1]);


%h2=gca;
set(axes1 , 'fontsize',labelSize-2);
%view(150,11);axis tight
%view(28,57);axis tight
%view(38,67);
axis tight
view(150,40)
grid on


%h1=gca;

set(axes1 ,'xtick',(0:8:numHue),'xticklabel',360*(0:8:numHue)/numHue,'ytick',(0:8:numSat),'yticklabel',(0:8:numSat)/numSat,'ztick',(0:8:numVal),'zticklabel',(0:8:numVal)/numVal)
axis([1 numHue 1 numSat 1 numVal])
%xlabel('Hue','fontsize',labelSize)
%ylabel('Saturation','fontsize',labelSize)
%zlabel('Value','fontsize',labelSize)
%title(figTitle,'fontsize',titSize)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Second figure  %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%

