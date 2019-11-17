function imshowHSV (imHSV)

imRGB = hsv2rgb (imHSV);
imshow(imRGB);

return;