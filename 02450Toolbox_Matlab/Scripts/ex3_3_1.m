% exercise 3.3.1

% Image to use as query
i = 1;

% Similarity: 'SMC', 'Jaccard', 'ExtendedJaccard', 'Cosine', 'Correlation' 
SimilarityMeasure = 'cos';

%% Load the CBCL face database
cdir = fileparts(mfilename('fullpath')); 
load(fullfile(cdir,'../Data/digits.mat'));

% You can try out the faces CBCL face database, too:
%load(fullfile(cdir,'../Data/wildfaces_grayscale.mat'));

transpose = true; % set to true if plotted images needs to be transposed

[N,M] = size(X);
imageDim = [sqrt(M),sqrt(M)];
%% Search the face database for similar faces

% Index of all other images than i
noti = [1:i-1 i+1:N]; 
% Compute similarity between image i and all others
sim = similarity(X(i,:), X(noti,:), SimilarityMeasure);
% Sort similarities
[val, j] = sort(sim, 'descend');

%% Plot query and result
mfig('Faces: Query'); clf;
subplot(3,5,1:5);

img = reshape(X(i,:),imageDim);
if transpose; img = img'; end;
imagesc(img);

axis image
set(gca, 'XTick', [], 'YTick', []);
ylabel(sprintf('Image #%d', i));
title('Query image','FontWeight','bold');
for k = 1:5
    subplot(3,5,k+5)
    ii = noti(j(k));
    img = reshape(X(ii,:),imageDim);
    if transpose; img = img'; end;
    imagesc(img);
    axis image
    set(gca, 'XTick', [], 'YTick', []);
    xlabel(sprintf('sim=%.2f', val(k)));
    ylabel(sprintf('Image #%d', ii));
    if k==3, title('Most similar images','FontWeight','bold'); end;
end
for k = 1:5
    subplot(3,5,k+10)
    ii = noti(j(end+1-k));
    img = reshape(X(ii,:),imageDim);
    if transpose; img = img'; end;
    imagesc(img);
    axis image
    set(gca, 'XTick', [], 'YTick', []);
    xlabel(sprintf('sim=%.3f', val(end+1-k)));
    ylabel(sprintf('Image #%d', ii));
    if k==3, title('Least similar images','FontWeight','bold'); end;
end
colormap(gray);
