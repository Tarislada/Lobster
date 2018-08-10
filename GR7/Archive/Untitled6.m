IROF_mat_new = [IROF_mat1_new;IROF_mat2_new];
coeff = pca(IROF_mat_new);

for i = 1 : 80
    PC{i} = IROF_mat_new * coeff(:,i);
end

figure(2);
clf
scatter3(PC{1}(1:size(IROF_mat1_new,1)),PC{2}(1:size(IROF_mat1_new,1)),PC{3}(1:size(IROF_mat1_new,1)),'r');
hold on;
scatter3(PC{1}(size(IROF_mat1_new,1)+1:end),PC{2}(size(IROF_mat1_new,1)+1:end),PC{3}(size(IROF_mat1_new,1)+1:end),'b');


%% small

IROF_mat_new_small = IROF_mat_new(:,31:50);
coeff = pca(IROF_mat_new_small);

for i = 1 : 20
    PC{i} = IROF_mat_new_small * coeff(:,i);
end

figure(2);
clf
scatter3(PC{1}(1:size(IROF_mat1_new,1)),PC{2}(1:size(IROF_mat1_new,1)),PC{3}(1:size(IROF_mat1_new,1)),'r');
hold on;
scatter3(PC{1}(size(IROF_mat1_new,1)+1:end),PC{2}(size(IROF_mat1_new,1)+1:end),PC{3}(size(IROF_mat1_new,1)+1:end),'b');
