%% ����
[filename, pathname] = uigetfile({'*.jpg;*.png;*.gif'}, 'Select the Maze Imgae');

%% ��l�����F���](�ǂ�1�ɂ��邽��)
original = imread([pathname, filename]);
bw = imbinarize(rgb2gray(original));
bw = imcomplement(bw);
imshow(bw);

%% ���H�̗֊s�𒊏o
colsum = sum(bw);
rowsum = sum(bw, 2);
[wM, we] = max(colsum(1:end/2));
[eM, ee] = max(colsum(end/2:end));
[nM, ne] = max(rowsum(1:end/2));
[sM, se] = max(rowsum(end/2:end));
trim = bw(ne:(se+size(rowsum,1)/2), we:(ee+size(colsum,2)/2));
trim = imresize(trim, [1600 1600]);

%% �m�C�Y�̏����ƕǂ̖c��
trim = imopen(trim, ones(5));   % ���_��������
trim = imdilate(trim, ones(5)); % �����𑾂�����
imshow(trim);

%% ���H�T�C�Y�����o
trimsum = sum(trim);
trimsum = trimsum < sum(trimsum) / length(trimsum);
maze_size = sum(([trimsum 0]-[0 trimsum])>0);
msgbox(sprintf('���H�T�C�Y�� %d �ł�', maze_size)); % ���H�T�C�Y�̕\��

%% �ǂ̒��o
segsize = size(trim)/maze_size;
vwall = trim(round(segsize(1)/2:segsize(1):end), round(1:segsize(2):end-segsize(2)/3));
hwall = trim(round(1:segsize(1):end-segsize(1)/3), round(segsize(2)/2:segsize(2):end));
vwall = [vwall, ones(maze_size, 1)];
hwall = [hwall; ones(1, maze_size)];

%% �ǂ̍���
wall =        1 * vwall(:, 2:end);      % �� 0 bit
wall = wall + 2 * hwall(1:end-1, :);    % �k 1 bit
wall = wall + 4 * vwall(:, 1:end-1);    % �� 2 bit
wall = wall + 8 * hwall(2:end, :);      % �� 3 bit

%% �t�@�C���ɕۑ�
output = reshape(sprintf('%x',wall), maze_size, maze_size);
output = ['"'*ones(maze_size, 1) output '",'.*ones(maze_size,1)];
new_filename = sprintf('%s.txt', filename);
dlmwrite(new_filename, output, 'precision', '%c', 'delimiter', '');
