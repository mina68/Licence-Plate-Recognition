myFolders = {'images/plates/s01_l01', 'images/plates/s01_l02', 'images/plates/s02_l01', 'images/plates/s02_l02', 'images/plates/s03_l01', 'images/plates/s03_l02', 'images/plates/s04_l01', 'images/plates/s04_l02'};

X_positive = [];

i = 0;

for myFolder = myFolders
    
    Xtemp = [];
    
    if ~isdir(myFolder{1})
      errorMessage = sprintf('Error: The following folder does not exist:\n%s', myFolder{1});
      uiwait(warndlg(errorMessage));
      return;
    end

    sprintf('Working on %s', myFolder{1})

    filePattern = fullfile(myFolder{1}, '*.*');
    files = dir(filePattern);

    for k = 1:length(files)
      baseFileName = files(k).name;
      if(~strcmp(baseFileName, '.') && ~strcmp(baseFileName, '..'))
          
          i = i + 1

          fullFileName = fullfile(myFolder{1}, baseFileName);

          I = imread(fullFileName);
          J = rgb2gray( imresize(I, [40 40]) );
          %imwrite(J, newFullFileName);

          J = reshape(J,1,[]);

          Xtemp = [Xtemp; J];
          
          if rem(i, 1000) == 0
              X_positive = [X_positive; Xtemp];
              Xtemp = [];
          end
      end
    end
    
    X_positive = [X_positive; Xtemp];

    sprintf('Finished working on %s', myFolder{1})
end
y_positive = ones(size(X_positive,1), 1);
save('plates_positive_features_labels.mat', 'X_positive', 'y_positive');

fprintf('done')