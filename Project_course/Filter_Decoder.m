%% this file is the filter decoder code - part 2
% this project done by 
% -> Aseel Deek        - 1190587
% -> Lojain Abdalraqaz - 1190707
% -> Mariam Taweel     - 1192099
%% reading  char.txt file   
Fs = 8000;
fileID=fopen('chars.txt','r');
formatSpec='%s %d %d %d %d'; % file formate 
C = textscan(fileID,formatSpec); % first colum is for characters, second is for c/s .. 
r  = 320;
%% reading the input wav file  
prompt='Enter a Wav File : ';
file = input(prompt);
[x,Fs] = audioread(file);
%plot(x);
n=round(length(x)/r); % find numbers of samples (characters) in the wave 
disp(n); % display the number of samples in the wave file 
feq = []; % to save the frequencies for a each char 
string = ''; % to print the retrieved string 
freq_peaks = [100,200,400,600,1000,800,1200,2000,1600,2400,3974]; % % the 11 frequencies 
z = length(freq_peaks); % freq_peaks array length  
%% from this line the Filter Decoder algorithm statrs 
for b = 0 : n-1 % for samples 
    sample_x= x(1+(r*b):(r*(b+1)));
    for j = 1: z % sampling 
     fc  = freq_peaks(j);  
     low = fc - 25;
     high = fc + 25;
     [b a]=butter(4,[low high]/4000,'bandpass'); 
     y=filter(b,a,sample_x);
     pRMS =rms(y)^2; 
      if ( pRMS > 0.0061) % if the power is more than 0.0061, then save that peak 
       feq = [feq,freq_peaks(j)];
      end   
    end
  % disp(Filter_string); % display the freqyencies    
  
   for k = 1:length(C{1})
       % handdel the "space" case 
       if ( feq(2) == 1000 && feq(3) == 2000 && feq(4) == 4000 ) 
          string  = string + " ";
          break;
       end
       % handdel the 4000 HZ
       if (feq(4)==3974)
          feq(4)=4000;
       end   
       % print the character 
       if (double(C{2}(k))== feq(1) && double(C{3}(k))==feq(2) && double(C{4}(k))== feq(3) && double(C{5}(k))== feq(4))
           string  = strcat(string,C{1}(k));
           break; 
       end
   end
   % this is to make it empty so the next character has it own frequencies 
  feq = []; 
end
%% displaying the encoded string 
disp('the retrieval string: ');
disp(string); % display the retrieved string 
