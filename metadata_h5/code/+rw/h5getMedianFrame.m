function median_frame = h5getMedianFrame(h5filename, varargin)
   
    options = defaultOptions();
    if(~isempty(varargin))
        options = getOptions(options, varargin);
    end

    movie_size = rw.h5getDatasetSize(h5filename, options.dataset);
    
    movie_total = zeros([movie_size(3), 1]);
    median_frames = [];
   
    for i_c = 1:options.nframes_read:movie_size(3)
%         disp(i_c);
        nframes_read = min(options.nframes_read, movie_size(3)-i_c+1);
        movie_current = h5read(h5filename, options.dataset, [1, 1, i_c], [Inf, Inf, nframes_read]);
        median_frames(:,:,size(movie_total,3)+1) = median(movie_current, 3, 'omitnan');
    end

    %technically median of medians, good estimate in practice
    median_frame = median(median_frames, 3, 'omitnan'); 
end


function options = defaultOptions()
    
    options.dataset = '/mov';
    options.nframes_read = Inf;
end