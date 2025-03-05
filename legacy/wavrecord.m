function x = wavrecord( Nx, fs, Lb, chan)
% wavrecord (OLD) via audiorecorder (NEW)

recorder = audiorecorder(fs,Lb,chan);  % create the recorder
recordblocking( recorder, Nx/fs );    % record Nx/fs seconds of data
x = getaudiodata( recorder );         % get the samples   
