function [outIm] = makeMask(bg, im, tol)
%bg - background image
%im - input image
%tol - tolerance
[h,w] = size(bg);
outIm = false(h, w);
for ch = 1:h
    for cw = 1:w
        imPix = im(ch,cw);
        bgPix = bg(ch,cw);
        if ((bgPix == imPix) || (bgPix > imPix && bgPix <= imPix + tol) || (bgPix < imPix && bgPix >= imPix - tol))
            outIm(ch, cw) = 0;
        else
            outIm(ch, cw) = 1;
        end
    end
end
end