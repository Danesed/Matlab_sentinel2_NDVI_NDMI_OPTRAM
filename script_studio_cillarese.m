tic

%% cropping tif files for geographical info
fprintf('Now importing tif %s\n');
 
[Acrop0,Rcrop0]= readgeoraster('shape_tif_crop0.tif'); %full size product
[Acrop1,Rcrop1]= readgeoraster('shape_tif_crop1.tif'); %brindisi area product
[Acrop2,Rcrop2]= readgeoraster('shape_tif_crop2.tif'); %cillarese crops area product

% matrice lon e lat
info0 = geotiffinfo('shape_tif_crop0.tif');
height0 = info0.Height; %height of the image in pixels
width0 = info0.Width; %width of the image in pixels
[cols0,rows0] = meshgrid(1:width0,1:height0);
[x0,y0] = pix2map(info0.RefMatrix, rows0, cols0);
[lat0,lon0] = projinv(info0, x0,y0);

info0 = geotiffinfo('shape_tif_crop0.tif');
height0 = info0.Height; 
width0 = info0.Width;
[cols0,rows0] = meshgrid(1:width0,1:height0);
[x0,y0] = pix2map(info0.RefMatrix, rows0, cols0);
[lat0,lon0] = projinv(info0, x0,y0);

info1 = geotiffinfo('shape_tif_crop1.tif');
height1 = info1.Height;
width1 = info1.Width;
[cols1,rows1] = meshgrid(1:width1,1:height1);
[x1,y1] = pix2map(info1.RefMatrix, rows1, cols1);
[lat1,lon1] = projinv(info1, x1,y1);

info2 = geotiffinfo('shape_tif_crop2.tif');
height2 = info2.Height;
width2 = info2.Width;
[cols2,rows2] = meshgrid(1:width2,1:height2);
[x2,y2] = pix2map(info2.RefMatrix, rows2, cols2);
[lat2,lon2] = projinv(info2, x2,y2);

% pixel coordinates of cropped images
lat_crop = lat0(8980:10980,4000:6000);
lon_crop = lon0(8980:10980,4000:6000);
lon_crop2 = lon_crop(600:1100,100:600);
lat_crop2 = lat_crop(600:1100,100:600);

%% Lettura files
% B04 FILES
B04Pattern = fullfile('/jp2000PATH/B04/*.jp2');
B04files = dir(B04Pattern);
for k = 1 : length(B04files)
    baseFileName = B04files(k).name;
    fullFileName = fullfile(B04files(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    B04list{k} = imread(fullFileName);
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
 
B08Pattern = fullfile('/jp2000PATH/B08/*.jp2');
B08files = dir(B08Pattern);
for k = 1 : length(B08files)
    baseFileName = B08files(k).name;
    fullFileName = fullfile(B08files(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    B08list{k} = imread(fullFileName);
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
 
B11Pattern = fullfile('/jp2000PATH/B11/*.jp2');
B11files = dir(B11Pattern);
for k = 1 : length(B11files)
    baseFileName = B11files(k).name;
    fullFileName = fullfile(B11files(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    B11list{k} = imread(fullFileName);
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

%B12 FILES
 
B12Pattern = fullfile('/jp2000PATH/B12/*.jp2');
B12files = dir(B12Pattern);
for k = 1 : length(B12files)
    baseFileName = B12files(k).name;
    fullFileName = fullfile(B12files(k).folder, baseFileName);
    fprintf(1, 'Now reading %s\n', baseFileName);
    B12list{k} = imread(fullFileName);
end
fprintf('\n')
 
for k = 1 : length(B12files)
    fprintf('Now clipping and converting %s\n',B12files(k).name);
    B12list{k} = B12list{k}(8980:10980,4000:6000);
    B12list{k} = single(B12list{k});
end
fprintf('\n')
 
 
%% CALCULATING NDVI
 
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
 
%% SEA FILTER USING B08

for k = 1 : length(B08files)
    fprintf('Now masking out water \n');
    Sea_Mask_list{k} = (B08list{k}>1400);
    NDVI_list{k} = (NDVI_list{k}.*Sea_Mask_list{k});
    NDMI_list{k} = (NDMI_list{k}.*Sea_Mask_list{k});
    B12list{k} = (B12list{k}.*Sea_Mask_list{k});
end
fprintf('\n')
 
%% FIGURE 1: montage(NDVI_list);
 
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
 
 
%% FIGURE 2: montage(NDMI_list);
 
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
    fprintf('Now clipping NDVI and NDMI on Cillarese area \n');
    NDVI_list_crop{k} = NDVI_list{k}(600:1100,100:600);
    NDMI_list_crop{k} = NDMI_list{k}(600:1100,100:600);
end
%% CLIPPING ON CROPS all bands
 
for k = 1 : length(B04files)
    fprintf('Now clipping ALL BANDS on Cillarese area \n');
    B04_list_crop{k} = B04list{k}(600:1100,100:600);
    B08_list_crop{k} = B08list{k}(600:1100,100:600);
    B11_list_crop{k} = B11list{k}(600:1100,100:600);
    B03_list_crop{k} = B03list{k}(600:1100,100:600);
    B02_list_crop{k} = B02list{k}(600:1100,100:600);
    B12_list_crop{k} = B12list{k}(600:1100,100:600);
end

%% MASKING USING EDGE DETECTION

value = [0 0.2];
method = 'canny';
direction = 'both';

for k = 1 : length(B04files)
    fprintf('Now edge ALL BANDS on sample crops \n');
    B04_list_crop_edge{k} = edge(B04_list_crop{k},method,value,direction);
    B03_list_crop_edge{k} = edge(B03_list_crop{k},method,value,direction);
    B02_list_crop_edge{k} = edge(B02_list_crop{k},method,value,direction);
    B08_list_crop_edge{k} = edge(B08_list_crop{k},method,value,direction);
    B11_list_crop_edge{k} = edge(B11_list_crop{k},method,value,direction);
end

for k = 1 : length(B04files)
    fprintf('Now summing ALL edges on sample crops \n');
    edge_lists{k} = (B04_list_crop_edge{k} + B08_list_crop_edge{k} + B03_list_crop_edge{k} + B02_list_crop_edge{k} + B11_list_crop_edge{k} );
end

edge_MASK = edge_lists{1}>0;

for k = 1 : length(B04files)
    fprintf('Now summing ALL edges on ONE sample crops \n');
    edge_MASK = edge_MASK + edge_lists{k};
end

% creating the mask
SE = strel('square',2);
edge_dilate = imdilate(edge_MASK,SE);
edge_mask_logic = edge_dilate<12;
imagesc(edge_mask_logic)
cropmask = edge_mask_logic;
%% mean of centroids, NDVI edge

for k = 1 : length(B04files)
    figure
s = regionprops(cropmask(:,:,1),NDVI_list_crop{k},{'Centroid','PixelValues','BoundingBox','Area'});
props_list{k}=s;
numObj{k} = numel(s);
imagesc(NDVI_list_crop{k})
colormap('gray')
 
title('Mean value of NDVI on sample crops')
hold on
for j = 1:numObj{k}
    props_list{k}(j).mean = mean(double(props_list{k}(j).PixelValues));
    if props_list{k}(j).Area>50
    text(props_list{k}(j).Centroid(1),props_list{k}(j).Centroid(2), ...
        sprintf('%2.5f', props_list{k}(j).mean), ...
        'EdgeColor','b','Color','r');
    end
end
hold off
end

% show mean for each crop
for k = 1 : length(B04files)
figure
bar(1:numObj{k},[props_list{k}.mean])
xlabel('Region Label Number')
ylabel('Mean value of NDVI on sample crops')
end

%% mean centroids, NDMI edge

for k = 1 : length(B04files)
    figure
s2 = regionprops(cropmask,NDMI_list_crop{k},{'Centroid','PixelValues','BoundingBox','Area'});
props_list_2{k}=s2;
numObj_2{k} = numel(s2);
imagesc(NDMI_list_crop{k})
colormap('gray')
 
title('Mean value of NDMI on sample crops')
hold on
for j = 1:numObj_2{k}
    props_list_2{k}(j).mean = mean(double(props_list_2{k}(j).PixelValues));
 if props_list_2{k}(j).Area>100
    text(props_list_2{k}(j).Centroid(1),props_list_2{k}(j).Centroid(2), ...
        sprintf('%2.5f', props_list_2{k}(j).mean), ...
       'EdgeColor','b','Color','r');
 end
end
hold off
end

% show mean for each crop
for k = 1 : length(B04files)
figure
bar(1:numObj_2{k},[props_list_2{k}.mean])
xlabel('Region Label Number')
ylabel('Mean value of NDMI on sample crops')
end

%% FIGURE 3: BARGRPH, grafico media, crop ndvi, ndvi 

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
    if props_list{k}(j).Area>100
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

%% Calculating weighted mean value of NDVI and NDMI on crops

fprintf('\nNow calculating weighted mean value of NDVI and NDMI on crops \n');

area_sum =0;
area_sum2 =0;
    for j = 1:numObj{1}
       area_sum = area_sum + props_list{1}(j).Area;
       area_sum2 = area_sum2 + props_list_2{1}(j).Area;
    end
    
for k = 1 : length(B04files)
    for j = 1:numObj{k}
        props_list{k}(j).w_mean = ((props_list{k}(j).mean) * (props_list{k}(j).Area)) / area_sum;
        props_list_2{k}(j).w_mean = ((props_list_2{k}(j).mean) * (props_list_2{k}(j).Area)) / area_sum2;
    end
end

% WEIGHTED MEAN
for k = 1 : length(B04files)
    NDVI_mean{k}=0;
    NDMI_mean{k}=0;
    for j = 1:numObj{k}
        NDVI_mean{k} =  NDVI_mean{k} + props_list{k}(j).w_mean ;
        NDMI_mean{k} =  NDMI_mean{k} + props_list_2{k}(j).w_mean ;
    end
end

% calculating values for round circles in figure montage
for k = 1 : length(B04files)
    NDVI_crops_values{k}=0;
    NDMI_crops_values{k}=0;
    for j = 1:numObj{k}
        NDVI_crops_values{k}(j) = props_list{k}(j).mean ;
        NDMI_crops_values{k}(j) = props_list_2{k}(j).mean ;
    end
end
%% Plotting NDVI and NDMI values and Date

Y = cell2mat(NDVI_mean);
Y2 = cell2mat(NDMI_mean);
X = datetime(Datelist, 'InputFormat', 'yyyyMMdd');

%% FIGURE 5: plot trend of Weighted NDVI throudg days

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

temp=['5b_NDVI_WEIGHTED_plot_overtime','.png']; 
saveas(gca,temp);

%% FIGURE 6: plot trend of Weighted NDMI throudg days

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

temp=['6b_NDMI_WEIGHTED_plot_overtime','.png']; 
saveas(gca,temp);

%% Geotiff reading

% Calculating matrix for lon e lat

info = geotiffinfo('geotiff2_test.tif');
height = info.Height; % Integer indicating the height of the image in pixels
width = info.Width; % Integer indicating the width of the image in pixels
[cols,rows] = meshgrid(1:width,1:height);
[x,y] = pix2map(info.RefMatrix, rows, cols);
[lat,lon] = projinv(info, x,y);

lat_crop = lat(8980:10980,4000:6000);
lon_crop = lon(8980:10980,4000:6000);
lon_crop2 = lon_crop(600:1100,100:600);
lat_crop2 = lat_crop(600:1100,100:600);

%% Calculating and Showing coordinates of crops (NDVI)

for k = 1 : length(B04files)
    figure
s = regionprops(cropmask,NDVI_list_crop{k},{'Centroid','PixelValues','BoundingBox','Area','all'});
props_list{k}=s;
numObj{k} = numel(s);
imagesc(NDVI_list_crop{k})
colormap('gray')
 
title('Mean value of NDVI on sample crops with coordinates')
hold on
for j = 1:numObj{k}
    
    props_list{k}(j).mean = mean(double(props_list{k}(j).PixelValues));
    props_list{k}(j).centroid = round(props_list{k}(j).Centroid);
    props_list{k}(j).lat = lat_crop2(props_list{k}(j).centroid(2),props_list{k}(j).centroid(1));
    props_list{k}(j).lon = lon_crop2(props_list{k}(j).centroid(2),props_list{k}(j).centroid(1));
        if props_list{k}(j).Area>400
         text(props_list{k}(j).Centroid(1),props_list{k}(j).Centroid(2), ...
         sprintf('%0.4f Lat , %0.4f Lon',props_list{k}(j).lat,props_list{k}(j).lon'), 'EdgeColor','b','Color','r');
        end
end
hold off
end

%% Calculating coordinates (NDMI)

for k = 1 : length(B04files)
    figure
s = regionprops(cropmask,NDMI_list_crop{k},{'Centroid','PixelValues','BoundingBox','Area'});
props_list_2{k}=s;
numObj_2{k} = numel(s);

for j = 1:numObj_2{k}
    props_list_2{k}(j).mean = mean(double(props_list_2{k}(j).PixelValues));
    props_list_2{k}(j).centroid = round(props_list_2{k}(j).Centroid);
    props_list_2{k}(j).lat = lat_crop2(props_list_2{k}(j).centroid(2),props_list_2{k}(j).centroid(1));
    props_list_2{k}(j).lon = lon_crop2(props_list_2{k}(j).centroid(2),props_list_2{k}(j).centroid(1));
end
end


%% [EXTRA] Geographical plot on matlab geoplot

figure
geolimits([39.45 42],[15 19])
title 'Fields in Brindisi';
%coordinates of T33TYF
imlat = ([41.5268622910048 41.4919436335118 40.5048858361439 40.5386175014828]);
imlon = ([17.3967035858509 18.7105746486792 18.6555550144011 17.3611090420914]);
geobasemap %satellite
hold on;
geoplot([lat(1,1),lat(1,end),lat(end,end),lat(end,1),lat(1,1)],[lon(1,1),lon(1,end),lon(end,end),lon(end,1),lon(1,1)]);
geoplot([lat_crop(1,1),lat_crop(1,end),lat_crop(end,end),lat_crop(end,1),lat_crop(1,1)],[lon_crop(1,1),lon_crop(1,end),lon_crop(end,end),lon_crop(end,1),lon_crop(1,1)]);
geoplot([lat_crop2(1,1),lat_crop2(1,end),lat_crop2(end,end),lat_crop2(end,1),lat_crop2(1,1)],[lon_crop2(1,1),lon_crop2(1,end),lon_crop2(end,end),lon_crop2(end,1),lon_crop2(1,1)]);
%plot all fields
for j = 1:numObj{k}
geoplot(props_list{k}(j).lat,props_list{k}(j).lon,'Marker', '.', 'Color', 'red');
hold on;
end

%% Shapefile creation
pp = mappoint(); %create empty mappoint
for j = 1:numObj{k}
    if props_list{k}(j).Area >20
pp = append(pp,props_list{k}(j).lon,props_list{k}(j).lat);
    end
end
shapewrite(pp,"Campi_cillarese.shp")

%% Creating geotiff for qgis exploration 
for k = 1 : length(B04files)
fprintf('\n Exporting NDVI tif files');
temp=['geo_ndvi_0',num2str(k),'.tif']; 
geotiffwrite(temp,NDVI_list_crop{k},Rcrop2,'CoordRefSysCode',32633);
end

for k = 1 : length(B04files)
fprintf('\n Exporting NDMI tif files');
temp=['geo_ndmi_0',num2str(k),'.tif']; 
geotiffwrite(temp,NDMI_list_crop{k},Rcrop2,'CoordRefSysCode',32633);
end

%% OPTRAM model

% Calculating STR 
for k = 1 : length(B04files)
    fprintf('\n Calculating STR');
    STR_list_crop{k}= ((((1-B12_list_crop{k}))^2)./(2*B12_list_crop{k}));
end

% matrix to vector, needed for calculation.
for k = 1 : length(B04files)
    fprintf('Converting to vector \n');
    NDVI_vector{k}=NDVI_list_crop{k}(:);
    STR_vector{k}=STR_list_crop{k}(:);
end

plot(NDVI_vector{k},STR_vector{k},'.');

% removing outliers on Y and X axes
for k = 1 : length(B04files)
    fprintf('Now masking outliers for STR and NDVI \n');
    NDVI_v_mask = NDVI_vector{k}>0.01;
    STR_vector_masked{k} = STR_vector{k}.*NDVI_v_mask;
    STR_vector_mask = STR_vector_masked{k}>1;
    NDVI_vector_masked{k} =  NDVI_vector{k}.*STR_vector_mask;
   
    % substitute STR 0 with mean value of STR
    meanstr{k} = mean(STR_vector_masked{k}(STR_vector_masked{k}>0));
    STR_vector_masked{k}(STR_vector_masked{k}==0)=meanstr{k};      
end

plot(NDVI_vector_masked{k},STR_vector_masked{k},'.');
%% FIGURE 7: plot STR-NDVI

for k = 1 : length(B04files)

figure
plot(NDVI_vector_masked{k},STR_vector_masked{k},'.');
xlim([0 1])
xlabel('NDVI')
ylabel('STR')
title('OPTRAM',B04files(k).date)
set(gca,'FontSize',14)
hold off
temp=['7alfa_OPTRAM_',num2str(k),'.png']; 
saveas(gca,temp);
end

%% Calculating wet and dry edges
for k = 1 : length(B04files)
    
% Calculating the max and minimum value of NDVI and the corresponding index
% for each day:
[ndvi_max{k}, index_ndvi_max{k}] = max(NDVI_vector_masked{k}(NDVI_vector_masked{k}>0));
[ndvi_min{k}, index_ndvi_min{k}] = min(NDVI_vector_masked{k}(NDVI_vector_masked{k}>0));

% calculating the STR minimum value at maximum NDVI
% calculating the STR Maximum value at minimum NDVI
str_min_atndvimax{k} = (STR_vector_masked{k}(index_ndvi_max{k}));
str_max_atndvimin{k} = (STR_vector_masked{k}(index_ndvi_min{k}));

% calculating the STR minimum value at minimum NDVI
str_min{k} = min(STR_vector_masked{k}(NDVI_vector_masked{k}>0.1));
% calculating the STR maximum value at minimum NDVI
% I selected the 15th value to accomodate the best fitting coordinates
tempor{k} = maxk(STR_vector_masked{k}(STR_vector_masked{k}<1.6*10^6),15);
str_max{k}=tempor{k}(15);

% X and Y coordinates for DRY EDGE
coo_dry_1{k} = [ndvi_min{k} ndvi_max{k}];
coo_dry_2{k} = [str_min{k} str_min_atndvimax{k}];

% X and Y coordinates for WET EDGE
coo_wet_1{k} = [ndvi_min{k} ndvi_max{k}];
coo_wet_2{k} = [str_max_atndvimin{k} str_max{k}];

%FIGURE

figure
plot(NDVI_vector_masked{k},STR_vector_masked{k},'.');
hold on;
plot(coo_dry_1{k},coo_dry_2{k},'lineWidth',3);
hold on;
plot(coo_wet_1{k},coo_wet_2{k},'lineWidth',3);
    
end
%% wetness

%calculate points to linear function (slope intercept form)
for k = 1 : length(B04files)
coo_dry{k} = [[1; 1]  coo_dry_1{k}(:)]\coo_dry_2{k}(:);                       
slope_dry{k} = coo_dry{k}(2);
intercept_coo_dry{k} = coo_dry{k}(1);
end

for k = 1 : length(B04files)
coo_wet{k} = [[1; 1]  coo_wet_1{k}(:)]\coo_wet_2{k}(:);                        
slope_wet{k} = coo_wet{k}(2);
intercept_coo_wet{k} = coo_wet{k}(1);
end

%find str/ndvi knowing value etc

for k = 1 : length(B04files) % cicla nelle immagini per ogni giorno
    for j = 1 : length(NDVI_vector_masked{k}) % cicla nella immagine vettore per ogni pixel
        NDVI_vector_masked{k}(j) ;
        STR_vector_masked{k}(j);
        STRw{k}(j) = interp1(coo_wet_1{k},coo_wet_2{k},NDVI_vector_masked{k}(j));
        STRd{k}(j) = interp1(coo_dry_1{k},coo_dry_2{k},NDVI_vector_masked{k}(j));
    end
end

% Calculating Wetness

for k = 1 : length(B04files) % cicla nelle immagini per ogni giorno
    for j = 1 : length(NDVI_vector_masked{k}) % cicla nella immagine vettore per ogni pixel
        wetness_vector{k}(j) = (STRd{k}(j) - STR_vector_masked{k}(j))./ ( STRd{k}(j) - STRw{k}(j));   
        %wetness_vector2{k}(j) = ( str_min{k} + (str_min_atndvimax{k}.*NDVI_vector_masked{k}(j)) - STR_vector_masked{k}(j) ) ./ ( (str_min{k} - str_max_atndvimin{k}) + ((str_min_atndvimax{k} - str_max{k}).*NDVI_vector_masked{k}(j))) ;

    end
end

%normalize [0 1] wetness vector and reshape from vector to 501x501 matrix
for k = 1 : length(B04files)
    norm_wetness_vector{k} = wetness_vector{k} - min(wetness_vector{k}(:));
    norm_wetness_vector{k} = norm_wetness_vector{k} ./ max(norm_wetness_vector{k}(:));
    wetness_list{k}= reshape (norm_wetness_vector{k},501,501);
end

%% FIGURE 7: STR-NDVI with heatmap and DRY-WET edges

for k = 1 : length(B04files)
%figure
plot(NDVI_vector_masked{k},STR_vector_masked{k},'k.');
ylim([0 2*10^6])
xlim([0 1])
xlabel('NDVI')
ylabel('STR')
title('OPTRAM',B04files(k).date)
set(gca,'FontSize',14)

hold on;
ptsx = linspace(0, 1, 50);
ptsy = linspace(0, 2*10^6, 50);
N = histcounts2(STR_vector_masked{k},NDVI_vector_masked{k}, ptsy, ptsx);
p=imagesc(ptsx, ptsy, N);
set(gca, 'XLim', ptsx([1 end]), 'YLim', ptsy([1 end]), 'YDir', 'normal');
alpha(p,0.5);
colorbar;
colormap jet
hold on;
plot(coo_dry_1{k},coo_dry_2{k},'lineWidth',3);
hold on;
plot(coo_wet_1{k},coo_wet_2{k},'lineWidth',3,'Color','g');
hold off;
temp=['7_OPTRAM_',num2str(k),'.png']; 
saveas(gca,temp);
end

%% FIGURE 8: wetness images for each day

for k = 1 : length(B04files)
%figure
imagesc(wetness_list{k})
title('Wetness',B04files(k).date)
set(gca,'FontSize',14)
colorbar;
colormap parula
temp=['8_wetness_',num2str(k),'.png']; 
saveas(gca,temp);
end
%% comparison with NDMI NDVI

for k = 1 : length(B04files)
NDMI_list_crop_vector{k} = NDMI_list_crop{k} - min(NDMI_list_crop{k}(:));
NDMI_list_crop_vector{k} = NDMI_list_crop_vector{k} ./ max(NDMI_list_crop_vector{k}(:));
NDVI_list_crop_vector{k} = NDVI_list_crop{k} - min(NDVI_list_crop{k}(:));
NDVI_list_crop_vector{k} = NDVI_list_crop_vector{k} ./ max(NDVI_list_crop_vector{k}(:));

end

for k = 1 : length(B04files)
MEDIA_WET(k)= mean(mean(wetness_list{k}(wetness_list{k}>0)));
MEDIA_NDMI(k)=mean(mean(NDMI_list_crop_vector{k}(NDMI_list_crop_vector{k}>0)));
MEDIA_NDVI(k)=mean(mean(NDVI_list_crop_vector{k}(NDVI_list_crop_vector{k}>0)));

end


%% FIGURE 9: comparison trend of NDVI NDMI and OPTRAM

figure('Position',[100 100 1250 450])

A1 = axes('Position',[0.1 0.1 0.8 0.8]); 

plot(X,MEDIA_WET,'lineWidth',3)
hold on;

plot(X,MEDIA_NDVI,'lineWidth',3)
hold on;

plot(X,MEDIA_NDMI,'lineWidth',3)
legend('OPTRAM','NDVI','NDMI')
title('OPTRAM NDVI NDMI comparison')
set(gca,'FontSize',14)
axis auto tight
hold on;

temp=['9_OPTRAM_NDMI_NDVI_comparison','.png']; 
saveas(gca,temp);


%% FIGURE 10: Study ndmi and wetness
 for k = 1 : length(B04files)
     figure
plot(wetness_list{k},NDMI_list_crop{k},'k.')
hold on;

ylim([-1 1])
xlim([0 1])
xlabel('Wetness')
ylabel('NDMI')
title('NDMI Wetness density',B04files(k).date)
set(gca,'FontSize',14)
hold on;
ptsx = linspace(0, 1, 500);
ptsy = linspace(-1,1, 500);
N = histcounts2(NDMI_list_crop{k},wetness_list{k}, ptsy, ptsx);
p=imagesc(ptsx, ptsy, N);
set(gca, 'XLim', ptsx([1 end]), 'YLim', ptsy([1 end]), 'YDir', 'normal');
alpha(p,0.5);
colorbar
colormap jet
ylabel('Pixel Density')
hold off;
temp=['10_NDMIxWet_',num2str(k),'.png']; 
saveas(gca,temp);
end

%% FIGURE 11: Study ndmi ndvi and wetness

% convert to vector
for k = 1 : length(B04files)
    fprintf('Converting to vector \n');
    wetness_list_vector{k}=wetness_list{k}(:);
end

for k = 1 : length(B04files)
    figure
 scatter(wetness_list_vector{k},NDMI_vector{k},1,NDVI_vector{k})
 colormap(turbo)
 cb = colorbar();
hold on;

ylim([-1 1])
xlim([0 1])
xlabel('Wetness')
ylabel('NDMI')
title('NDMI Wetness comparison with NDVI level',B04files(k).date)
set(gca,'FontSize',14)

hold on;

hold off;
temp=['11_NDMIxWetxNDVI_',num2str(k),'.png']; 
saveas(gca,temp);
end

%% CROP SELECTION
labeled_crop = (label2rgb (bwlabel(cropmask,8), 'hsv', 'k', 'shuffle'));
imagesc(labeled_crop)
numberOfBlobs = size(props_list{1}, 1);
blobMeasurements = props_list{1};
originalImage = NDVI_list_crop{k};

imshow(NDVI_list_crop{k});

hold on;
boundaries = bwboundaries(cropmask);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;



prompt = {'Enter min NDVI:','Enter max NDVI:','Enter min area of crop:','Enter day:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'0','1','200','1'};
answer = inputdlg(prompt,dlgtitle,dims,definput);


ndvi_min=str2double(answer{1});
ndvi_max=str2double(answer{2});



    
for k = str2double(answer{4})
    figure
    NDVI_user= (NDVI_list_crop{k}>ndvi_min).* NDVI_list_crop{k};
    NDVI_user= (NDVI_list_crop{k}<ndvi_max).* NDVI_user;
imagesc(NDVI_user)
colormap('summer')

hold on
for j = 1:numObj{k}

        if props_list{k}(j).PixelValues>ndvi_min
        if props_list{k}(j).Area>str2double(answer{3})
         text(props_list{k}(j).Centroid(1),props_list{k}(j).Centroid(2), ...
         sprintf('%0.4f Lat , %0.4f Lon , %0.4f ndvi',props_list{k}(j).lat,props_list{k}(j).lon,props_list{k}(j).mean'), 'EdgeColor','b','Color','r');

            end
        end
end
hold off
end


%% EXTRA SELEZIONE CAMPI

%calculate full regionprops
for k = 1 : length(B04files)
s = regionprops(cropmask,NDVI_list_crop{k},'all');
props_list{k}=s;
s2 = regionprops(cropmask,NDMI_list_crop{k},'all');
props_list_2{k}=s2;
end



for k = 1 : length(B04files)
for j = 1:numObj{k}
    
    props_list{k}(j).mean = mean(double(props_list{k}(j).PixelValues));
    props_list{k}(j).centroid = round(props_list{k}(j).Centroid);
    props_list{k}(j).lat = lat_crop2(props_list{k}(j).centroid(2),props_list{k}(j).centroid(1));
    props_list{k}(j).lon = lon_crop2(props_list{k}(j).centroid(2),props_list{k}(j).centroid(1));
end
hold off
end

for k = 1 : length(B04files)
for j = 1:numObj_2{k}
    props_list_2{k}(j).mean = mean(double(props_list_2{k}(j).PixelValues));
    props_list_2{k}(j).centroid = round(props_list_2{k}(j).Centroid);
    props_list_2{k}(j).lat = lat_crop2(props_list_2{k}(j).centroid(2),props_list_2{k}(j).centroid(1));
    props_list_2{k}(j).lon = lon_crop2(props_list_2{k}(j).centroid(2),props_list_2{k}(j).centroid(1));
end
end



labeledImage = bwlabel(cropmask, 8);
coloredLabels = label2rgb (labeledImage, 'hsv', 'k', 'shuffle');
imagesc(coloredLabels)
numberOfBlobs = size(props_list{k}, 1);

% GREEN BORDERS
imshow(NDVI_list_crop{1});
hold on;
boundaries = bwboundaries(cropmask);
numberOfBoundaries = size(boundaries, 1);
for k = 1 : numberOfBoundaries
	thisBoundary = boundaries{k};
	plot(thisBoundary(:,2), thisBoundary(:,1), 'g', 'LineWidth', 2);
end
hold off;


prompt = {'Enter min NDVI:','Enter max NDVI:','Enter min NDMI:','Enter max NDMI:','Enter min area of crop:','Enter day:'};
dlgtitle = 'Input';
dims = [1 35];
definput = {'0','1','-1','1','200','1'};
answer = inputdlg(prompt,dlgtitle,dims,definput);


ndvi_min=str2double(answer{1});
ndvi_max=str2double(answer{2});
ndmi_min=str2double(answer{3});
ndmi_max=str2double(answer{4});
area_user=str2double(answer{5});
k=str2double(answer{6});


% TEXT DATA
textFontSize = 14;
labelShiftX = -7;	
blobECD = zeros(1, numberOfBlobs);

%
fprintf(1,'Blob #      Mean NDVI         Mean NDMI      Area    Perimeter      Lat   Lon \n');
for j = 1 : numberOfBlobs

	thisBlobsPixels =  props_list{k}(j).PixelIdxList;
	
    blobMean =props_list{k}(j).mean;
    blobMean_2 =props_list_2{k}(j).mean;
    blobArea = props_list{k}(j).Area;
	blobPerimeter = props_list{k}(j).Perimeter;
    blobLat = props_list{k}(j).lat;
    blobLon = props_list{k}(j).lon;
    fprintf(1,'#%2d %17.4f %17.4f %11.1f %8.1f  %8.4f %8.4f\n', j, blobMean,blobMean_2, blobArea, blobPerimeter, blobLat,blobLon);
	text(blobCentroid(1) + labelShiftX, blobCentroid(2), num2str(j), 'FontSize', textFontSize, 'FontWeight', 'Bold');
end
allBlobCentroids = [blobMeasurements.Centroid];
centroidsX = allBlobCentroids(1:2:end-1);
centroidsY = allBlobCentroids(2:2:end);


%
allBlobIntensities = [props_list{k}.MeanIntensity];
allBlobAreas = [props_list{k}.Area];
allBlobLat = [props_list{k}.lat];
allBlobLon = [props_list{k}.lon];

allowableNDVIIndexes = (allBlobIntensities > ndvi_min) & (allBlobIntensities < ndvi_max);
allowableNDMIIndexes = (allBlobIntensities > ndmi_min) & (allBlobIntensities < ndmi_max);

allowableAreaIndexes = allBlobAreas > area_user;

keeperIndexesNDVI = find(allowableNDVIIndexes & allowableAreaIndexes);
keeperIndexesNDMI = find(allowableNDMIIndexes & allowableAreaIndexes);


keeperBlobsImageNDVI = ismember(labeledImage, keeperIndexesNDVI);
labeledDimeImageNDVI = bwlabel(keeperBlobsImageNDVI, 8); 
NDVI_user = labeledDimeImageNDVI.*NDVI_list_crop{k};

keeperBlobsImageNDMI = ismember(labeledImage, keeperIndexesNDMI);
labeledDimeImageNDMI = bwlabel(keeperBlobsImageNDMI, 8); 
NDMI_user = labeledDimeImageNDMI.*NDMI_list_crop{k};

figure
imagesc(NDVI_user);
hold on;
axis image;
for j = keeperIndexesNDVI
         text(props_list{k}(j).Centroid(1),props_list{k}(j).Centroid(2), ...
         sprintf('%0.4f Lat , %0.4f Lon , %0.4f ndvi',props_list{k}(j).lat,props_list{k}(j).lon,props_list{k}(j).mean'), 'EdgeColor','b','Color','r');
end
title('NDVI crops',B04files(k).date)
set(gca,'FontSize',14)
hold off;
temp=['001_NDVI_user_',ndvi_min,ndvi_max,num2str(k),'.png']; 
saveas(gca,temp);




figure
imagesc(NDMI_user);
hold on;
axis image;
for j = keeperIndexesNDVI
         text(props_list{k}(j).Centroid(1),props_list{k}(j).Centroid(2), ...
         sprintf('%0.4f Lat , %0.4f Lon , %0.4f ndmi',props_list{k}(j).lat,props_list{k}(j).lon,props_list_2{k}(j).mean'), 'EdgeColor','b','Color','r');
end
title('NDMI crops',B04files(k).date)
set(gca,'FontSize',14)
hold off;
temp=['002_NDMI_user_',ndmi_min,ndmi_max,num2str(k),'.png']; 
saveas(gca,temp);


%%
fprintf('\n ____END____\n')
toc
