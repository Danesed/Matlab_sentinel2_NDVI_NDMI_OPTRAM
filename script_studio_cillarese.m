tic
%% Lettura files
% B04 FILES
B04Pattern = fullfile('/Users/danilod/Documents/MATLAB/TVA/Cillarese immagini/test/B04S/*.jp2'); % Change to whatever pattern you need.
B04files = dir(B04Pattern);
for k = 1 : length(B04files)
    baseFileName = B04files(k).name;
    fullFileName = fullfile(B04files(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
 
    B04list{k} = imread(fullFileName);
    %imshow(imageArray);  % Display image.
    Datelist{k} = baseFileName(8:15);
end
fprintf('\n')
 
for k = 1 : length(B04files)
    fprintf('Now clipping %s\n',B04files(k).name);
    B04list{k} = B04list{k}(8980:10980,4000:6000);
    
    fprintf('Now converting %s\n',B04files(k).name);
    B04list{k} = single(B04list{k});
    
    fprintf('Now calculating .5 and .95 percentile of %s\n',B04files(k).name);
    B04list_05{k} = prctile(reshape(B04list{k},1, numel(B04list{k})), 5);
    B04list_95{k} = prctile(reshape(B04list{k},1, numel(B04list{k})),95);
end
fprintf('\n');
 
%B08 FILES
 
B08Pattern = fullfile('/Users/danilod/Documents/MATLAB/TVA/Cillarese immagini/test/B08S/*.jp2'); % Change to whatever pattern you need.
B08files = dir(B08Pattern);
for k = 1 : length(B08files)
    baseFileName = B08files(k).name;
    fullFileName = fullfile(B08files(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
    B08list{k} = imread(fullFileName);
    %imshow(imageArray);  % Display image.
end
fprintf('\n');
 
 
for k = 1 : length(B08files)
    fprintf('Now clipping and converting %s\n',B08files(k).name);
    B08list{k} = B08list{k}(8980:10980,4000:6000);
    B08list{k} = single(B08list{k});
    
    B08list_05{k} = prctile(reshape(B08list{k},1, numel(B08list{k})), 5);
    B08list_95{k} = prctile(reshape(B08list{k},1, numel(B08list{k})),95);
end
fprintf('\n')
 
%B11 FILES
 
B11Pattern = fullfile('/Users/danilod/Documents/MATLAB/TVA/Cillarese immagini/test/B11S/*.jp2'); % Change to whatever pattern you need.
B11files = dir(B11Pattern);
for k = 1 : length(B11files)
    baseFileName = B11files(k).name;
    fullFileName = fullfile(B11files(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    % Now do whatever you want with this file name,
    % such as reading it in as an image array with imread()
    B11list{k} = imread(fullFileName);
    %imshow(imageArray);  % Display image.
end
fprintf('\n')
 
for k = 1 : length(B11files)
    fprintf('Now clipping and converting %s\n',B11files(k).name);
    B11list{k} = B11list{k}(8980:10980,4000:6000);
    B11list{k} = single(B11list{k});
    B11list_05{k} = prctile(reshape(B11list{k},1, numel(B11list{k})), 5);
    B11list_95{k} = prctile(reshape(B11list{k},1, numel(B11list{k})),95);
end
fprintf('\n')
 
 
%% calcolo ndvi
 
for k = 1 : length(B04files)
    fprintf('Now calculating NDVI %s\n',B04files(k).name);
    NDVI_list{k} = (B08list{k}-B04list{k})./(B08list{k}+B04list{k});
end
fprintf('\n')
 
%calcolo ndmi
 
for k = 1 : length(B11files)
    fprintf('Now calculating NDMI %s\n',B11files(k).name);
    NDMI_list{k} = (B08list{k}-B11list{k})./(B08list{k}+B11list{k});
end
 
%% filtro il mare, usando banda B08
 
for k = 1 : length(B08files)
    fprintf('Now masking out water \n');
    Sea_Mask_list{k} = (B08list{k}>1400);
    NDVI_list{k} = (NDVI_list{k}.*Sea_Mask_list{k});
    NDMI_list{k} = (NDMI_list{k}.*Sea_Mask_list{k});
end
fprintf('\n')
 
 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
 
%% montage(NDVI_list);
 
 
fprintf('Now creating montage of NDVI \n');
 
for k = 1 : length(B11files)
    
figure('Position',[100 100 1650 450])
A1 = axes('Position',[0.025 0.1 0.4 0.8]);
imagesc(B04list{k},[B04list_05{k} B04list_95{k}])
title('650 nm')
colormap(A1,'Gray'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
A2 = axes('Position',[0.325 0.1 0.4 0.8]);
imagesc(B08list{k},[B08list_05{k} B08list_95{k}])
title('850 nm')
colormap(A2,'Gray'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.625 0.1 0.4 0.8]);
imagesc(NDVI_list{k},[0 1])
title(B04files(k).date)
colormap(A3,'turbo'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
hold on;
temp=['1_NDVI_calculation_',num2str(k),'.png']; 
saveas(gca,temp);
 
end
 
 
%montage(NDMI_list);
 
fprintf('Now creating montage of NDMI \n');
for k = 1 : length(B11files)
    
figure('Position',[100 100 1650 450])
A1 = axes('Position',[0.025 0.1 0.4 0.8]);
imagesc(B11list{k},[B11list_05{k} B11list_95{k}])
title('1610 nm')
colormap(A1,'Gray'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
A2 = axes('Position',[0.325 0.1 0.4 0.8]);
imagesc(B08list{k},[B08list_05{k} B08list_95{k}])
title('850 nm')
colormap(A2,'Gray'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.625 0.1 0.4 0.8]);
imagesc(NDMI_list{k},[-1 1])
title(B04files(k).date)
colormap(A3,'parula'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
hold on;
temp=['2_NDMI_calculation_',num2str(k),'.png']; 
saveas(gca,temp);
 
end
 
 
 
 
%% CROPPING ON CROPS
 
for k = 1 : length(B04files)
    fprintf('Now clipping NDVI and NDMI on sample crops \n');
    NDVI_list_crop{k} = NDVI_list{k}(1200:1550,450:750);
    NDMI_list_crop{k} = NDMI_list{k}(1200:1550,450:750);
end
 
 
 
 
 
 
%% segmentazione con centroidi
 
%%% FOR media centroidi 
 
 
for k = 1 : length(B04files)
fprintf('Now masking and smoothing crops with NDVI over 0.5 \n');
NDVI_list_crop_over05_logic{k} = (NDVI_list_crop{k})>0.5;
NDVI_list_crop_over05{k} = NDVI_list_crop_over05_logic{k} .* NDVI_list_crop{k};
 
%crea maschera oltre 5 pixel
se = strel('square',5);
NDVI_list_crop_over05_smooth{k} = imopen(NDVI_list_crop_over05_logic{k},se);
NDVI_list_crop_over05_logic_smooth{k} = imopen(NDVI_list_crop_over05_logic{k},se);
end
 
%%%media centroidi
for k = 1 : length(B04files)
    figure
s = regionprops(NDVI_list_crop_over05_logic_smooth{k},NDVI_list_crop_over05{k},{'Centroid','PixelValues','BoundingBox','Area'});
props_list{k}=s;
numObj{k} = numel(s);
imshow(NDVI_list_crop_over05{k})
 
%imshow(labeloverlay(Campo_crop_esempio,BWfinal))
 
title('Mean value of NDVI on sample crops')
hold on
for j = 1:numObj{k}
    
    props_list{k}(j).mean = mean(double(props_list{k}(j).PixelValues));
    if props_list{k}(j).Area>20
    text(props_list{k}(j).Centroid(1),props_list{k}(j).Centroid(2), ...
        sprintf('%2.5f', props_list{k}(j).mean), ...
        'EdgeColor','b','Color','r');
    end
end
hold off
end
 
%%%mostra media per ogni campo
for k = 1 : length(B04files)
figure
bar(1:numObj{k},[props_list{k}.mean])
xlabel('Region Label Number')
ylabel('Man value of NDVI on sample crops')
end
%%% fine media con centroidi
 
%% extra histogram
% plot histogramma media, crop ndmi, ndmi completo
%{
for k = 1 : length(B04files)
    
figure('Position',[100 100 1650 450])
 
A1 = axes('Position',[0.05 0.1 0.4 0.8]);
[counts, grayLevels] = imhist(NDVI_list_crop{k}, 300);
bar(grayLevels, counts, 'BarWidth', 0.95);
 
title('NDMI mean values')
colormap(A1,'parula')
set(gca,'FontSize',14)
axis auto tight
colorbar('location','southoutside','Ticks',[],'TickLabels',{''});
 
 
A2 = axes('Position',[0.375 0.1 0.4 0.8]);
imagesc(NDMI_list_crop{k},[-1 1])
title(NDMI_mean(k))
colormap(A2,'parula')
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.625 0.1 0.4 0.8]);
imagesc(NDMI_list{k},[-1 1])
title(B04files(k).date)
colormap(A3,'parula'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
hold on;
temp=['6_NDMI_hist_',num2str(k),'.png']; 
saveas(gca,temp);
end
%}
 
%% media vecchia
%{
%mean value of ndvi for cropped area
for k = 1 : length(B04files)
    fprintf('Now calculating mean value of NDVI and NDMI on crops \n');
    NDVI_mean{k} = mean(mean(NDVI_list_crop{k}));
    NDMI_mean{k} = mean(mean(NDMI_list_crop{k})); 
end
 
%grafico andamento media
Y = cell2mat(NDVI_mean);
X = datetime(Datelist, 'InputFormat', 'yyyyMMdd');
 
 
% plot grafico media, crop ndvi, ndvi completo
for k = 1 : length(B04files)
    
figure('Position',[100 100 1650 450])
A1 = axes('Position',[0.05 0.1 0.4 0.8]);
plot(X,Y,'B--O');
title('NDVI mean value over time')
colormap(A1,'Gray')
set(gca,'FontSize',14)
axis auto tight
 
A2 = axes('Position',[0.375 0.1 0.4 0.8]);
imagesc(NDVI_list_crop{k},[0 1])
title(NDVI_mean(k))
colormap(A2,'turbo')
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.625 0.1 0.4 0.8]);
imagesc(NDVI_list{k},[0 1])
title(B04files(k).date)
colormap(A3,'turbo'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
hold on;
temp=['3_NDVI_plot_',num2str(k),'.png']; 
saveas(gca,temp);
end
 
 
%conversione per plotting
Y2 = cell2mat(NDMI_mean);
 
% plot grafico media, crop ndmi, ndmi completo
%{
for k = 1 : length(B04files)
    
figure('Position',[100 100 1650 450])
A1 = axes('Position',[0.05 0.1 0.4 0.8]);
plot(X,Y2,'B--O');
title('NDMI mean value over time')
colormap(A1,'Gray')
set(gca,'FontSize',14)
axis auto tight
 
A2 = axes('Position',[0.375 0.1 0.4 0.8]);
imagesc(NDMI_list_crop{k},[-1 1])
title(NDMI_mean(k))
colormap(A2,'parula')
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.625 0.1 0.4 0.8]);
imagesc(NDMI_list{k},[-1 1])
title(B04files(k).date)
colormap(A3,'parula'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
hold on;
temp=['4_NDMI_plot_',num2str(k),'.png']; 
saveas(gca,temp);
end
%}
 
%%%%%%plot con istogramma
 
%{
% histogramma grafico media, crop ndvi, ndvi completo
for k = 1 : length(B04files)
    
figure('Position',[100 100 1650 450])
A1 = axes('Position',[0.05 0.1 0.4 0.8]);
histogram(NDVI_list_crop{k},30,'FaceColor','auto')
title('NDVI mean values')
colormap(A1,'turbo')
set(gca,'FontSize',14)
axis auto tight
colorbar('location','southoutside','Ticks',[],'TickLabels',{''})
 
A2 = axes('Position',[0.375 0.1 0.4 0.8]);
imagesc(NDVI_list_crop{k},[0 1])
title(NDVI_mean(k))
colormap(A2,'turbo')
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.625 0.1 0.4 0.8]);
imagesc(NDVI_list{k},[0 1])
title(B04files(k).date)
colormap(A3,'turbo'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
hold on;
temp=['5_NDVI_hist_',num2str(k),'.png']; 
saveas(gca,temp);
end
 
%}
 
% plot histogramma media, crop ndmi, ndmi completo
%{
for k = 1 : length(B04files)
    
figure('Position',[100 100 1650 450])
A1 = axes('Position',[0.05 0.1 0.4 0.8]);
xlim([0 1])
%histogram(NDMI_list_crop{k},30);
%histogram(NDMI_list_crop{k}, xlim=c(-4, 4), xaxt="n")
title('NDMI mean values')
colormap(A1,'parula')
set(gca,'FontSize',14)
axis auto tight
colorbar('location','southoutside','Ticks',[],'TickLabels',{''})
 
 
A2 = axes('Position',[0.375 0.1 0.4 0.8]);
imagesc(NDMI_list_crop{k},[-1 1])
title(NDMI_mean(k))
colormap(A2,'parula')
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.625 0.1 0.4 0.8]);
imagesc(NDMI_list{k},[-1 1])
title(B04files(k).date)
colormap(A3,'parula'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
hold on;
temp=['6_NDMI_hist_',num2str(k),'.png']; 
saveas(gca,temp);
end
%}
 
%}
 
%%%%%
%% fine
fprintf('\n ____FINE____\n')
toc
