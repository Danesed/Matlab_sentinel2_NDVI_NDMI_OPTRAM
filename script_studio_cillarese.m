tic

cropmask = imread('/Users/danilod/Documents/MATLAB/TVA/Cillarese immagini/test/crops_mask_ps.png');
cropmask = cropmask > 1;
cropmask = imcomplement(cropmask);
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
 
%% CLIPPING ON CROPS
 
for k = 1 : length(B04files)
    fprintf('Now clipping NDVI and NDMI on sample crops \n');
    NDVI_list_crop{k} = NDVI_list{k}(1200:1550,450:750);
    NDMI_list_crop{k} = NDMI_list{k}(1200:1550,450:750);
end
 

%% media centroidi NDVI PNG

for k = 1 : length(B04files)
 %   figure
s = regionprops(cropmask(:,:,1),NDVI_list_crop{k},{'Centroid','PixelValues','BoundingBox','Area'});
props_list{k}=s;
numObj{k} = numel(s);
imagesc(NDVI_list_crop{k})
colormap('gray')
 
title('Mean value of NDVI on sample crops')
hold on
for j = 1:numObj{k}
    
    props_list{k}(j).mean = mean(double(props_list{k}(j).PixelValues));
   
  %  text(props_list{k}(j).Centroid(1),props_list{k}(j).Centroid(2), ...
  %      sprintf('%2.5f', props_list{k}(j).mean), ...
  %      'EdgeColor','b','Color','r');
    
end
hold off
end
 
%{
%%%mostra media per ogni campo
for k = 1 : length(B04files)
figure
bar(1:numObj{k},[props_list{k}.mean])
xlabel('Region Label Number')
ylabel('Man value of NDVI on sample crops')
end
%}
%%% fine media con centroidi con ndvi

%% media centroidi NDMI PNG

for k = 1 : length(B04files)
%    figure
s2 = regionprops(cropmask,NDMI_list_crop{k},{'Centroid','PixelValues','BoundingBox','Area'});
props_list_2{k}=s2;
numObj_2{k} = numel(s2);
imagesc(NDMI_list_crop{k})
colormap('gray')
 
title('Mean value of NDMI on sample crops')
hold on
for j = 1:numObj_2{k}
    
    props_list_2{k}(j).mean = mean(double(props_list_2{k}(j).PixelValues));

%    text(props_list_2{k}(j).Centroid(1),props_list_2{k}(j).Centroid(2), ...
 %       sprintf('%2.5f', props_list_2{k}(j).mean), ...
  %      'EdgeColor','b','Color','r');


end
hold off
end

%% BARGRPH grafico media, crop ndvi, ndvi completo PNG


for k = 1 : length(B04files)

figure('Position',[100 100 1650 450])

A1 = axes('Position',[0.05 0.1 0.4 0.8]);
bar(1:numObj{k},[props_list{k}.mean])
ylim([0 1 ])
xlabel('Crops Label Number')
ylabel('NDVI mean values')
title('NDVI mean values in sample crops')
set(gca,'FontSize',14)


A2 = axes('Position',[0.390 0.1 0.4 0.8]);
imagesc(NDVI_list_crop{k},[0 1])
title(B04files(k).date)
colormap(A2,'turbo'),colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.650 0.1 0.4 0.8]);
imagesc(NDVI_list_crop{k},[0 1 ])
title(['NDVI mean value in this area: ' num2str( mean([props_list{k}.mean]))])
colormap(A3,'gray'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
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
hold on;
temp=['3_total_NDVI_bar_mask',num2str(k),'.png']; 
saveas(gca,temp);
end

%% BARGRPH grafico media, crop NDMI, NDMI completo TOTAL

for k = 1 : length(B04files)

figure('Position',[100 100 1650 450])

A1 = axes('Position',[0.05 0.1 0.4 0.8]);
bar(1:numObj_2{k},[props_list_2{k}.mean])
ylim([-1 1])
xlabel('Crops Label Number')
ylabel('NDMI mean values')
title('NDMI mean values in sample crops')
set(gca,'FontSize',14)

A2 = axes('Position',[0.390 0.1 0.4 0.8]);
imagesc(NDMI_list_crop{k},[-1 1])
title(B04files(k).date)
colormap(A2,'turbo'),colorbar
set(gca,'FontSize',14)
axis square tight, axis off
 
A3 = axes('Position',[0.650 0.1 0.4 0.8]);
imagesc(NDMI_list_crop{k},[-1 1])
title(['NDMI mean value in this area: ' num2str(mean([props_list_2{k}.mean]))])
colormap(A3,'gray'), colorbar
set(gca,'FontSize',14)
axis square tight, axis off
hold on
for j = 1:numObj_2{k}
    props_list_2{k}(j).mean = mean(double(props_list_2{k}(j).PixelValues));
    if props_list_2{k}(j).Area>20
    text(props_list_2{k}(j).Centroid(1),props_list_2{k}(j).Centroid(2), ...
        sprintf('%2.5f', props_list_2{k}(j).mean), ...
        'EdgeColor','b','Color','r');
    end
end
hold off
hold on;
temp=['4_TOTAL_NDMI_bar_mask_',num2str(k),'.png']; 
saveas(gca,temp);
end

%% calcolo i valori per l' andamento nel tempo

%definisco valori medi nei campi
for k = 1 : length(B04files)
    fprintf('Now calculating mean value of NDVI and NDMI on crops \n');
    NDVI_mean{k} = mean([props_list{k}.mean]);
    NDMI_mean{k} = mean([props_list_2{k}.mean]); 
    NDVI_crops_values{k}=(props_list{k}.PixelValues); %lista dei valori dei pixel per ogni campo per plotting
    NDMI_crops_values{k}=(props_list_2{k}.PixelValues);
end

Y = cell2mat(NDVI_mean);
Y2 = cell2mat(NDMI_mean);
X = datetime(Datelist, 'InputFormat', 'yyyyMMdd');

%% grafico andamento nel tempo NDVI

%grafico andamento media
figure('Position',[100 100 1250 450])

A1 = axes('Position',[0.1 0.1 0.8 0.8]);
for k = 1 : length(B04files)
plot(X(k),NDVI_crops_values{k},'o')
hold on;
end

plot(X,Y,'B--O','LineWidth',5);
title('NDVI mean value over time')
set(gca,'FontSize',14)
axis auto tight
hold on;

temp=['5_NDVI_plot_overtime','.png']; 
saveas(gca,temp);

%% grafico andamento nel tempo NDMI

%grafico andamento media
figure('Position',[100 100 1250 450])

A1 = axes('Position',[0.1 0.1 0.8 0.8]);
for k = 1 : length(B04files)

plot(X(k),NDMI_crops_values{k},'o')
hold on;
end

plot(X,Y2,'B--O','LineWidth',5);
title('NDMI mean value over time')
set(gca,'FontSize',14)
axis auto tight
hold on;

temp=['6_NDMI_plot_overtime','.png']; 
saveas(gca,temp);

%% fine
fprintf('\n ____FINE____\n')
toc
%% extra NDBI

%% calcolo ndBi
 
for k = 1 : length(B04files)
    fprintf('Now calculating NDBI %s\n',B04files(k).name);
    NDBI_list{k} = (B11list{k}-B08list{k})./(B08list{k}+B11list{k});
    NDBI_list_crop{k} = NDBI_list{k}(1200:1550,450:750);
end

fprintf('\n')
%% CLIPPING ON CROPS all bands
 
for k = 1 : length(B04files)
    fprintf('Now clipping ALL BANDS on sample crops \n');
    B04_list_crop{k} = B04list{k}(1200:1550,450:750);
    B08_list_crop{k} = B08list{k}(1200:1550,450:750);
    B11_list_crop{k} = B11list{k}(1200:1550,450:750);
end

%% sum of canny on all bands for each day
 
for k = 1 : length(B04files)
    fprintf('Now edge ALL BANDS on sample crops \n');
    B04_list_crop_edge{k} = edge(B04_list_crop{k},'Canny',0.1);
    B08_list_crop_edge{k} = edge(B08_list_crop{k},'Canny',0.1);
    B11_list_crop_edge{k} = edge(B11_list_crop{k},'Canny',0.1);
end

for k = 1 : length(B04files)
    fprintf('Now summing ALL edge on sample crops \n');
    edge_lists{k} = (B04_list_crop_edge{k} + B08_list_crop_edge{k} + B11_list_crop_edge{k});

end

edge_MASK = edge_lists{1}>500;

for k = 1 : length(B04files)
    fprintf('Now summing ALL edge on ONE sample crops \n');
    edge_MASK = edge_MASK + edge_lists{k};

end