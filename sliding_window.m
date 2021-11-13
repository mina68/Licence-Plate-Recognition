
I = imread('DOCS/Data-Images/Cars/23.jpg');
I = rgb2gray(I);

load('final_weights.mat');

for i=1:(floor((size(I, 1)-45)/5))
    for j=1:(floor((size(I, 2)-150)/5))
        
        X = I(i*5:i*5+45, j*5:j*5+150);
        X = imresize(X, [40 40]);
        X = reshape(X,1,[]);
        
        pred = predict(Theta1, Theta2, Theta3, X);
        if(pred == 1)
            X = I(i*5:i*5+45, j*5:j*5+150);
            imshow(X);
        end
    end
end