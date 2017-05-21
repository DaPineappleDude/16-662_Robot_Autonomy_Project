clear


changeFileName = 0;
count = 0;
% we had 13 objects. You can change it accordingly.
for class = 1:13
% Each object has 10 different poses. Change it accordingly.
    for i = 1:10
% Robot arm has 15 poses
        for j = 1:15
            imgBin_bin = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/empty_bin/',num2str(j),'/depth_aligned.png');
            switch class
                case 1
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/003_cracker_box_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 2
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/004_sugar_box_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 3
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/006_mustard_bottle_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 4
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/008_pudding_box_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 5
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/009_gelatin_box_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 6
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/011_banana_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 7
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/019_pitcher_base_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 8
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/021_bleach_cleanser_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 9
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/024_bowl_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 10
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/035_power_drill_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 11
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/036_wood_block_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 12
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/037_scissors_',num2str(i),'/',num2str(j),'/depth_aligned.png');
                case 13
                    imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/061_foam_brick_',num2str(i),'/',num2str(j),'/depth_aligned.png');
            end
            %             imgBin_bin = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/empty_bin/11/depth_aligned.png');
            %             imgObj_path = strcat('/Users/mnchen/Documents/RobotAutonomy/project/20170411collection/035_power_drill_5/11/depth_aligned.png');
            if changeFileName == 1
                imgObj_path = strrep(imgObj_path,'depth_aligned','color');
                img = imread(imgObj_path);
                output_path = sprintf('./data/frame_%05d.png',count);
                imwrite(img,output_path);
                count = count + 1;
            else
                imgBin = double(imread(imgBin_bin));
                imgObj = double(imread(imgObj_path));
                % imgObjColor = im2double(imread('colorPitcher1.png'));
                [outIm] = makeMask(imgBin, imgObj, 100);
                % BW1 = im2bw(imgBin,0.65);
                % BW2 = im2bw(imgObj,0.65);
                % outIm = (BW2-BW1);
                %img_test = zeros(size(imgObj));
                %imgFront = abs(imgObj - imgBin);
                %imgFront = abs(imgObj - img_test);
                %imshow(imgFront);
                %imgFront_gray = rgb2gray(imgFront);
                %imshow(imgFront_gray);
                %imgFront_bw = im2bw(imgFront_gray,0.3);
                %imgFront_bw = im2bw(imgFront,0.3);
                %imshow(imgFront_bw);
                % imshow(imgFront_bw);
                if class ~= 12
                    se = strel('disk',2);
                    outIm = imerode(outIm,se);
                    se = strel('disk',2);
                    
                    outIm = imfill(outIm,'holes');
                end
                
                CC = bwconncomp(outIm);
                numPixels = cellfun(@numel,CC.PixelIdxList);
                [biggest,idx] = max(numPixels);
                % imgObjR = imgObjColor(:,:,1);
                % imgObjG = imgObjColor(:,:,2);
                % imgObjB = imgObjColor(:,:,3);
                
                % imgObjR(CC.PixelIdxList{idx}) = 1;
                % imgObjG(CC.PixelIdxList{idx}) = 0;
                % imgObjB(CC.PixelIdxList{idx}) = 0;
                
                outIm = zeros(size(outIm));
                outIm(CC.PixelIdxList{idx}) = class;
                %             outIm = imgaussian(outIm,3);
                %imshow(outIm);
                %outIm = uint8(outIm);
                flatten = reshape(outIm, 1, size(outIm,1)*size(outIm,2));
                table = tabulate(flatten);
                table(1,:) = [];
                table(1, 1)
                %outIm = imresize(outIm,0.4);
                output_path = sprintf('./result2/frame_%05d.png',count);
                imwrite(outIm,output_path,'BitDepth',16);
                count = count + 1;
            end
        end
    end
end
for num = 0:1949
    immm = imread(sprintf('./result2/frame_%05d.png',num));
%     immm = uint8(immm)/255*10;
%     imwrite(immm,sprintf('./result2/frame_%05d.png',num));
    flatten = reshape(immm, 1, size(immm,1)*size(immm,2));
    table = tabulate(flatten);
    table(1,:) = [];
    table(1, 1)
end

% imgObjResult = zeros(size(imgObjColor));
% imgObjResult(:,:,1) = imgObjR;
% imgObjResult(:,:,2) = imgObjG;
% imgObjResult(:,:,3) = imgObjB;
% imshow(imgObjResult);
