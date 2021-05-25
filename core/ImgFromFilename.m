function [imgStruct] = ImgFromFilename(windowPtr,filename)
% Takes a image file and a window pointer and returns structure containing
% a texture pointer and a rect equal to the size of the texture...
% Should support the same filetypes as imread.
% use DrawImgAt to draw this to the buffer.

%-ADN 05/11/06


    filetype = lower(filename(end-2:end));
    imData = imread(filename, filetype);
    imgStruct.rect = [0 0 size(imData,2) size(imData,1)];
    imgStruct.ptr = Screen('MakeTexture', windowPtr, imData);
     
end