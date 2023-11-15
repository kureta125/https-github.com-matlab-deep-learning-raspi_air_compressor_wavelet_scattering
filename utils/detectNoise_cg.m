function a = detectNoise_cg(xin) 
%# codegen

%% データ読み込み
%n=4
%uniqueLabels(n)
%idx = find(adsTest.Labels==uniqueLabels(n),1);
%[x,fs] = audioread(adsTest.Files{idx});
%fname = "preprocess_Reading63.wav";

%afr = dsp.AudioFileReader(adsTest.Files{idx},'SamplesPerFrame',50000);
%afr = dsp.AudioFileReader(fname,'SamplesPerFrame',50000);
%xin = afr();
    
%t = (0:size(x,1)-1)/fs;

%% Waveret Time Scattering (preprocess)
%indata = read(adsTest);
indata = xin;
e = 17;   % was 7
N = 2^e;

persistent sn
if isempty(sn)

%batchsize = 64;

sn = waveletScattering('SignalLength',N,'SamplingFrequency',44100,...  % was 16*10^3
    'InvarianceScale',0.5);
end

batchout = zeros(N,1,'single');
batchout(:,1) = cast(indata(1:N),'single');

% Obtain scattering features
S = sn.featureMatrix(batchout,'transform','log');
%gather(batchout);
%S = gather(S);

% Subsample the features
sc = S(:,1:6:end,:);

% Modefy scattering features
% size = 329x3 single
%scm = zeros(329,3,'single');
scm = sc(2:330,:,:);

%% Classification(Projected LSTM network)
% Predect
a = myLSTM(scm);

% dlIn = dlarray(scm, 'CTB');
% 
% persistent dlnet;
% if isempty(dlnet)
%     dlnet = coder.loadDeepLearningNetwork('myNetwork.mat');
% end
% 
% dlA = predict(dlnet, dlIn);
% 
% a = extractdata(dlA);

end