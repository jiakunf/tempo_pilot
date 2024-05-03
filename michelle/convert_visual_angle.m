function [pixel_per_degree, visual_angle] = convert_visual_angle(distance, width, npixel)
    % distance and width in centimeter
    % npixel: number of pixels in monitor width
    % return number of pixels per degree of visual angle, and total visual angle in monitor width

        visual_angle = 2 * atan(width / (2 * distance));
        pixel_per_degree = npixel / visual_angle;
end

