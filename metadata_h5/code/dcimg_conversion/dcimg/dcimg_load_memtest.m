% fn = char(basepath + basefilename + channels(1) + extention);
%%
filepath = 'Q:\GEVI_Wave\Raw\Anesthesia\m354\20191002\meas07\afterKX-6min--BL5-fps100-cG.dcimg';
nframes = 2000;
framesize = [512,512];
%%
frames1 = [];
userview = memory; 
memused1 = userview.MemUsedMATLAB;

for i = 1:10
    frames1 = zeros([framesize, nframes], 'uint16');
    for frame_index = [1:nframes]        
        frames1(:,:,frame_index) = dcimgmatlab(frame_index-1, filepath);
        clear mex;
%         if(mod(frame_index,200) == 0) disp(frame_index); end
    end
    clear mex;
    userview = memory;
    memused1 = [memused1, userview.MemUsedMATLAB];
    disp(i);
end

plot((memused1 - memused1(1))/1024/1024/1024, '-o');
xlabel('repetition'); ylabel('MemUsedMATLAB, GB'); 

%%
frames2 = [];
userview = memory; 
memused2 = userview.MemUsedMATLAB;

hdcimg = dcimgmex('open', filepath);
for i = 1:10
    frames2 = zeros([framesize, nframes], 'uint16');
    for frame_index = [1:nframes]
        frames2(:,:,frame_index) = dcimgmex('readframe', hdcimg, frame_index-1);
    %     if(mod(frame,200) == 0) disp(frame); end
    end
    userview = memory;
    memused2 = [memused2, userview.MemUsedMATLAB];
    disp(i);
end
dcimgmex('close', hdcimg);

hold on;
plot((memused2 - memused2(1))/1024/1024/1024, '-o');
xlabel('repetition'); ylabel('MemUsedMATLAB, GB')
hold off;
legend("dcimgmatlab", "dcimgmex")
