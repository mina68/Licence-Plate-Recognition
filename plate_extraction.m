clear ; close all; clc

%{

filePattern = fullfile('DOCS/Data-Images/Cars/*.*');
files = dir(filePattern);

for k = 1:length(files)
    baseFileName = files(k).name;
    fullFileName = fullfile('DOCS/Data-Images/Cars', baseFileName);
    if(~strcmp(baseFileName, '.') && ~strcmp(baseFileName, '..'))
%}
OriginalI = imread('DOCS/Data-Images/Cars/23.jpg');
figure
imshow(OriginalI);

I = rgb2gray(OriginalI);
figure
imshow(I);

I = edge(I, 'Prewitt', .1);
figure
imshow(I);

se = strel('line',5,90);
I = imopen(I, se);
figure
imshow(I);

I = imdilate(I, se);
figure
imshow(I);

se = strel('line',30,0);
I = imclose(I, se);
figure
imshow(I);

I = bwareaopen(I, 500);
figure
imshow(I);

[labeledImage, numRegions] = bwlabel(I);
props = regionprops(labeledImage, 'BoundingBox');

for i = 1:length(props)

    width = props(i).BoundingBox(3);
    height = props(i).BoundingBox(4);

    if(width/height < 6 && width/height > 1)
        subImage = imcrop(OriginalI, props(i).BoundingBox);
        
        
        I = rgb2gray(subImage);
        I = edge(I, 'Prewitt', .1);
        
        wPixels = sum(sum(I>0));
        wPerc = wPixels / (size(I,1) * size(I,2));
        
        I = bwareaopen(I, 20);
        
        figure
        imshow(I);
        
        [labeledImage, numRegions] = bwlabel(I);
        props2 = regionprops(labeledImage, 'BoundingBox');
        
        for j = 1:length(props2)

            width = props2(j).BoundingBox(3);
            height = props2(j).BoundingBox(4);

            if(width/height > .2 && width/height < 1)
                char = imcrop(subImage, props2(j).BoundingBox);
                
                txt = ocr(char);
                txt.Text

                figure
                imshow(char);
            end
        end
    end
end
        
%{
    end
end
%}
