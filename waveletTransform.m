n = 512;

%Load image
folder = 'F:\BE - VIII\Project\Malignant\ISIC-images\ISIC-images\UDA-1';
file = 'ISIC_0000145.jpg'
fullFileName = fullfile(folder, file);
I =imread(fullFileName); %syn_16_20_3.bmp'); %syn_new_9.bmp'); %gel270415_2_3.bmp');%spots1.bmp');%syn6_513_1024_.bmp'); %iitgel1-1.bmp');%002cell.png');%somasekar1 (12)1.tif');%007cell.png');%dsc04575.png');%b10nature_trees000.png');%gel1tiff_orig.tiff');%image16_gauss35salt10.bmp'); %image16_gauss40.bmp'); %syn_new_9.bmp'); %spatho1.bmp');%002cell.png');%syn_16_20_3.bmp'); %100_0109.png'); 

I=imresize(I,[n n]);
%I=I(1:n,1:n);
%ground truth image if available
Igt=I; %imread('syn_new_9_gtbt1.bmp');%syn_13_gt.bmp'); %syn_new_9_gtbt1.bmp');%syn_new_9_gt1.bmp');%syn_13_gt.bmp'); %imread('image16_gt1.bmp'); %I;%
In=I;
%set parameters
% set 0 following parameter for general images
IsGelImage=1;      %tell if it is 2D gel images/ or images with blob like objects for extra processing of binary image with prior knowledge of radius of smallest spot
IsObjectLighter=0; %set 1 if the objects are lighter than background, otherwise set 0
if (IsGelImage == 0)
	
	KernelBandwidth_h =1;      % this parameter depends upon the contents of the image and noise. For a similar type of image, it will not vary and values can be found out through experimetns by varying it between 1 to 10.
	ContrastThreshold_Th = 6;   % low value means detect low contrast objects
	MorphSmoothRad=1;   %morphological disk radius set to 1 if image is noisy, other wise it can be set to 0.
	smallRadiusofSpot=0;  % required in case of 2D gel image.
    
else
     %%2d gel images 
	KernelBandwidth_h =6;      % this parameter depends upon the contents of the image and noise. For a similar type of image, it will not vary and values can be found out through experimetns by varying it between 1 to 10.
	ContrastThreshold_Th = 6;   % high value means detect high contrast objects
	MorphSmoothRad=3;   %morphological disk radius set to smaller than small radius of spot.(optional)
	smallRadiusofSpot=5;  % required in case of 2D gel image.
end
	NoOfScales_J=6;      % scale factor in quincunx case is sqrt(2)
	NeighbourhoodDistance_RN = 2;
% saving parameters in temp variables
disksigma=KernelBandwidth_h;
diskr =2*KernelBandwidth_h+1; %floor(smallR);
smallR =NeighbourhoodDistance_RN; %neighbourhood distance
MeanDiff= ContrastThreshold_Th/255; %since image gray values are normalized between 0 to 1 in this coding
se2=strel('disk',smallRadiusofSpot);
cvM=In;
if(size(In,3)>1)
    M=rgb2gray(In); %%%M=histeq(M);
    %M=I(:,:,1);
    cvM=In;
else
    M=In;
    cvM=M;
    clear In;
    In(:,:,1)=M;In(:,:,2)=M;In(:,:,3)=M;
end
OriginalI=In;
I=In;
M=double(M); 
M =M./255;% rescale(M);
OriginalM=M;
if(size(Igt,3)>1)
    Mgt=rgb2gray(Igt);
else
    Mgt=Igt;
end
Mgt=double(Mgt);
% if(size(In,3)>1)
%     M=double(rgb2gray(In))./255;
% else
%     M=double(In)./255;
% end
M=double(M);
%prediction of noise amount in noise, no use for our method, only for
%information
jy1=imfilter(M,[1 -1;-1 1]);
sigman=median(abs(jy1(:)))/0.6745*255   %since value is normalized between 0 and 1   
if(max(M(:))>1)
    M=M./max(M(:));
end
%pause
figure, imshow((M));title(' M');%pixval on;
%estimating kernel bandwidth only for information
display 'according to Silverman rule of thumb estimaed kernel bandwidth is '
mmed =abs(M - median(abs(M(:))));
mmed =mmed.*255;
h0 = 1.06 * (512 * 512)^(-1/5) * ( median( mmed(:)))/0.6745 
% mmed=mmed(:);
% h0 = std(mmed)
% h0= sqrt(1/(512*512-1)*sum(mmed.*mmed))
%Quincunx decomposition
display 'following portion will use function of Toolbox Wavelets by Gabriel Peyre'
display 'download it from the matlab central : http://www.mathworks.com/matlabcentral/fileexchange/5104-toolbox-wavelets'
tic
J=15;
options.null = 0;
options.primal_vm =2; %since wavelet is the second derivative of a smoothing function
options.dual_vm =2;
% Forward transform
fprintf('Computing quincunx wavelet transform ... ');
%tic
%[MW Mlow] = ashu_quicunx_low(M,J1+1,options); % our implementation
MW=perform_quicunx_wavelet_transform_ti(M,1,options); 
y1= MW(:,:,1);
y2=MW(:,:,2);
y3=MW(:,:,3); y4= MW(:,:,4); y5=MW(:,:,5);y6=MW(:,:,6);%y7=MW(:,:,7);
%y8=MW(:,:,8); y9= MW(:,:,9); y10=MW(:,:,10);y11=MW(:,:,11);y12=MW(:,:,12);
display 'density calculation'
%tic
mu2=1; %density function of -ve coefficients
mu5=1; %density function of +ve coefficients
h2=fspecial('gaussian',[diskr diskr],disksigma);
for i=1:1:NoOfScales_J
        yy=MW(:,:,i);
        yy(yy>0)=0;
        yy(yy<0)=1;    % just for -ve coefficients
        m1=imfilter(yy,h2);
        mu2=mu2.*m1;
        
        yy=MW(:,:,i); yy(yy<0)=0; yy(yy>0)=1;
        m5=imfilter(yy,h2);
        mu5=mu5.*m5;       
end
%normalize values
    mu2=mu2./max(mu2(:));
    mu5=mu5./max(mu5(:));
    
%toc
seg=double(mu2>mu5);
e=edge(seg,'roberts',0);
mm1=I;%mm=floor(255*M);
mm=I(:,:,1);mm(e>0)=255;mm1(:,:,1)=mm;mm=I(:,:,2);mm(e>0)=0;mm1(:,:,2)=mm;mm=I(:,:,3);mm(e>0)=0;mm1(:,:,3)=mm;figure,imshow(mm1),title('edge on mu2>mu5');
 bb3=(mu2>mu5); %select darker objects
 if(IsObjectLighter==1)
     bb3=(mu5>mu2); %select lighter objects
 end
 bb3=imfill(bb3,'holes');  %filling holes to merge plateau regions into its surrounding object regions. 
if(IsGelImage==1)
    bb3=imfill(bb3,'holes');  %filling holes to merge plateau regions into its surrounding object regions.  
    bb3=imopen(bb3,se2);      %filtering with morphological disk to discard noisy objects
					%filtering is done with erosion followed by dilation i.e. opening. article needs to be corrected.
end
e=edge(bb3,'roberts',0);
mm1=I;%mm=floor(255*M);
mm=I(:,:,1);mm(e>0)=255;mm1(:,:,1)=mm;mm=I(:,:,2);mm(e>0)=0;mm1(:,:,2)=mm;mm=I(:,:,3);mm(e>0)=0;mm1(:,:,3)=mm;figure,imshow(mm1);title('edge after opening');
Savebb3=bb3;
%Region Refinement 
bb4=zeros(size(bb3));
bb5=bb4;
L=bwlabel(bb3);
Lbg=bwlabel(1-bb3);
MM1=medfilt2(M);
for i=1:max(L(:))
   [rr rc]=find(L==i);
   %%Following condition is needed for numerical implementation/ for calling k-means.
   if(length(rr)< smallR*smallR) %%noisy pixels only, less than size of object. may create problem for matlab k-means
       %continue;
   end
   rr3=rr;
   rc3=rc;
   for j=1:smallR
       for k=1:smallR
           rr1=(rr+j); rr2=(rr-j);
           rr3 = [rr3; rr1; rr2; rr;  rr; rr1; rr2; rr2; rr1]; %rr=unique(rr);
           rc1=(rc+k); rc2=(rc-k);
           rc3=  [rc3; rc1; rc2; rc1; rc2; rc; rc;  rc1; rc2]; %rc=unique(rc);
       end
    end
   idx=find(rr3>0 & rr3<=size(bb3,1) & rc3>0 & rc3<=size(bb3,2));
   rr=rr3(idx);
   rc=rc3(idx);
   idx=sub2ind(size(bb3),rr,rc); idx=unique(idx);
   l1=L(idx); %bdpixel=bb4(idx);
   idx1=find((l1==0  )| l1==i ); idx=idx(idx1);
   mm=M(idx); mm=mm(:); c1=0;c2=0; idx2=1;idx3=1;
   
    %[u v]=kmeans(mm,2,'Start',[min(mm); max(mm)], 'Maxiter', 1000); c1=v(1); c2=v(2);[c3 c4]=min(v); idx2=find(u==c4); 
    % sometimes matlab 7.0 kmeans with above parameters does not give
    % perfect cluster in the sence that pixel with salt and pepper noise makes their own clusters. this thing can be observed
    %by uncommenting fprintf codeline below.
    %instead of above matlab kmeans implementation, following version of
    %kmenas available on matlab central is used for simplicty, convergance and
    %speed. Download it from :
    %http://in.mathworks.com/matlabcentral/fileexchange/24616-kmeans-clustering/content/kmeans/kmeans.m 
    % and rename it as litekmeans.m to distinguish it from matlab kmeans
    % 
    
    u =litekmeans(mm',2);u=u(:); id1=find(u==1);c1=sum(mm(id1))/length(id1); id2=find(u==2); c2=sum(mm(id2))/length(id2);[c3 c4]=min([c1 c2]); idx2=find(u==c4); 
   
    
    [c5 c6]=max([c1 c2]); idx3=find(u==c6); 
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %The above implementation of k-means (litekmeans) is used in our experiment.
    % UNCOMMENT following lines if you are using MATLAB 7.0 kmeans
    %fprintf('c1 = %f, c2=%f length(idx2)= %d, length(idx3)=%d\n',c1,c2,length(idx2), length(idx3));
    %if(c1 == 0)   %cluster is formed with only a few noisy pixels
    %    idx2=idx3;
    %end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%	
	
   if(IsObjectLighter==1)
       idx4=idx2;idx2=idx3;idx3=idx4;
   end
    
   if( abs(c1-c2)> MeanDiff)
       bb4(idx(idx2))=1;
       bb5(idx(idx3))=1;
   end
   %i
end
%%%%%%%%%%%Region Refinement contd.
bb5=double(bb4==0);
bbb5=bb5;
L=bwlabel(bb4);
L1=bwlabel(bb5);
L2=bwlabel(imdilate((bb5),strel('disk',1))); %include adjacent pixels to find out adjacent regions
se=strel('disk', smallR);
bb6=imdilate(bb5,se);
ll1=unique(L2(:));
for i=1:length(ll1)
   idx=find(ll1(i)==L2);
   idx1=find(ll1(i)==L2 & L1~=0);
   c1=mean(M(idx1));
   idx2=find(ll1(i)==L2 & bb4>0);
   if(length(idx2)<1)
       continue;
   end
   %display i
   ll2=L(idx2); ll2=unique(ll2(:)); 
   if(length(ll2)>1)
    ll2=ll2(1);
   end
   idx3=find(L==ll2 & bb6 >0); %surronding foreground region
   c2=mean(M(idx3));
   if(abs(c1-c2) < MeanDiff)
       bb4(idx1)=1;
       bb5(idx1)=0;
       %display i
   end
end
    
e=edge(bb4,'roberts',0);
mm1=I;%mm=floor(255*M);
mm=I(:,:,1);mm(e>0)=255;mm1(:,:,1)=mm;mm=I(:,:,2);mm(e>0)=0;mm1(:,:,2)=mm;mm=I(:,:,3);mm(e>0)=0;mm1(:,:,3)=mm;figure,imshow(mm1);title('after segmenting with c1 and c2');
if(IsGelImage==1)
    bb4=imfill(bb4,'holes'); %there should be no hole within spot, even condition in above loop fail to merge them.
end
%%%% due to k means clustering and noise, some pixel in segmented regions
%%%% may be scattered, so refine them
if(MorphSmoothRad>0)
    se1=strel('disk',MorphSmoothRad); bb5=imopen(bb4>0,se1); bb5=imclose(bb5,se1);bb4=bb4.*bb5;
end
bminima=zeros(size(M));
 se=strel('disk',smallRadiusofSpot);
if IsGelImage==1
   %%%overlapped spots 
   M1=medfilt2(M);
   rm1= imregionalmax ( bwdist(~bb4));
   rm1=imdilate(rm1,se);
%    rm1=imerode(rm1,se);
%    rm1=imdilate(rm1,se);
    for i=1:size(M,1)
        for j=1:size(M,2)
            isminima=1;
            for k= max(1, i-smallRadiusofSpot):min(size(M,1),i+smallRadiusofSpot)
                for l= max(1, j-smallRadiusofSpot):min(size(M,2),j+smallRadiusofSpot)
                    if((i-k)^2 + (j-l)^2) <= smallRadiusofSpot
                        if M1(i,j)> M1(k,l)
                            isminima=0;
                        end
                    end
                end
            end
            bminima(i,j)=isminima;
        end
    end
    figure, imshow(bminima);
    
    %taking only spot's minima
    bminima=bminima.*imerode(bb4,se);
    L=bwlabel(bminima);
    L1=L.*(rm1>0);
    L1=unique(L1(:));
    bm1=zeros(size(M));
    for i=1:length(L1)
        if(L1(i)==0)
            continue;
        else
            bm1(L==L1(i))=1;
        end
    end
    bminima =bm1;
    %removing adjacent redundant minima
   
    
    %%%%bminima=imerode(bminima,se);
    bminima=imdilate(bminima,se);
    figure, imshow(bminima);
    %applying the watershed
    [M1 M2]=gradient(bb4);
    M1=sqrt(M1.*M1 + M2.*M2);
    M1(bminima==1)=-Inf;
    L=watershed(M1);
    L=double(L).* double(bb4>0); %%% 
    bb4=(L>0);
    
    
end
seg=bb4;
toc
e=bwperim(seg, 8); %edge(seg,'roberts',0);%edge(double(seg),'log',0,.5);%
I=I;
mm1=I;%mm=floor(255*M);
mm=I(:,:,1);mm(e>0)=max(255, max(max(I(:,:,1))));mm1(:,:,1)=mm;mm=I(:,:,2);mm(e>0)=0;mm1(:,:,2)=mm;mm=I(:,:,3);mm(e>0)=0;mm1(:,:,3)=mm;figure,imshow(mm1),title('final');
display 'thanks'