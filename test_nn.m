
folder = 'DOCS/Data-Images/Plates';
filePattern = fullfile(folder, '*.jpg');
files = dir(filePattern);

load('final_weights.mat');

I = imread('DOCS/Data-Images/Plates/5.jpg');
X = rgb2gray( imresize(I, [40 40]) );
X = reshape(X,1,[]);

pred = predict(Theta1, Theta2, Theta3, X)

%{
true = 0;
for k = 1:numel(files)
    baseFileName = files(k).name;
    if(~strcmp(baseFileName, '.') && ~strcmp(baseFileName, '..'))
        fullFileName = fullfile(folder, baseFileName);
        I = imread(fullFileName);
        X = rgb2gray( imresize(I, [40 40]) );
        X = reshape(X,1,[]);

        pred = predict(Theta1, Theta2, Theta3, X)
        if(pred == 1)
            true = true + 1;
        end
    end
end

true
%}