
folder = 'images/plates/negative_2';

if ~isdir('images/plates/negative_2')
  errorMessage = sprintf('Error: The following folder does not exist:\n%s', folder);
  uiwait(warndlg(errorMessage));
  return;
end

filePattern = fullfile(folder, '*.jpg');
files = dir(filePattern);

X_negative = [];
itr = 0;

for k = 1:numel(files)
    itr = itr + 1
    baseFileName = files(k).name;
    if(~strcmp(baseFileName, '.') && ~strcmp(baseFileName, '..'))
        Xtemp = [];
        fullFileName = fullfile(folder, baseFileName);
        I = imread(fullFileName);
        I = rgb2gray(I);
        
        for i=1:(floor((size(I, 1)-45)/5))
            for j=1:(floor((size(I, 2)-150)/5))
                
                itr = itr + 1

                X = I(i*5:i*5+45, j*5:j*5+150);
                X = imresize(X, [40 40]);
                X = reshape(X,1,[]);
                
                Xtemp = [Xtemp; X];
                
                if rem(itr, 1000) == 0
                    X_negative = [X_negative; Xtemp];
                    Xtemp = [];
                end
            end
        end
        
        X_negative = [X_negative; Xtemp];
    end
end

X_negative_1 = X_negative(1:250000, :);
X_negative_2 = X_negative(250001:end, :);

y_negative_1 = 2.* ones(size(X_negative_1,1), 1);
y_negative_2 = 2.* ones(size(X_negative_2,1), 1);

save('plates_negative_features_labels_parti.mat', 'X_negative_1', 'y_negative_1');
save('plates_negative_features_labels_part2.mat', 'X_negative_2', 'y_negative_2');
