%% this file is the filter decoder code - part 2
% this project done by 
% -> Aseel Deek        - 1190587
% -> Lojain Abdalraqaz - 1190707
% -> Mariam Taweel     - 1192099
%% reading  chars.txt file   
Fs = 8000;
fileID=fopen('chars.txt','r');
formatSpec='%s %d %d %d %d';     % file formate 
C = textscan(fileID,formatSpec); % first colum is for characters, second is for c/s .. 
r  = 320;
%%  reading the input wav file   
prompt='Enter a Wav File : ';
file = input(prompt);
[x,Fs] = audioread(file); 
%plot(x,'k'); 
n=round(length(x)/r); % find numbers of samples (characters) in the wave 
disp(n); 
string = '';          % to print the retrieved string 
%%  from this line the FTT Decoder algorithm statrs
for j = 0 : n-1
sig =  x(1+(r*j):(r*(j+1)));
 Y = fft(sig,190);
 Yout = abs(Y(1:160)); 
 [pks,locs] = findpeaks(Yout); 
 % Finding the First 4 peaks values for the signal  
 locs(1) = (locs(1)*6600)/160;
 locs(2) = (locs(2)*6600)/160;
 locs(3) = (locs(3)*6600)/160;
 locs(4) = (locs(4)*6600)/160;
 
 out(1)=(ceil(locs(1)/100)*100)-100; % upper/lower
 out(2)=(ceil(locs(2)/100)*100)-100; % lowest signal
 out(3)=(ceil(locs(3)/100)*100)-100; % middle signal 
 out(4)=(ceil(locs(4)/100)*100)-100; % hight signal
 
% case like 'G/g' letter 
if ( double(out(3)) == 1600)
     temp = out(3);
     out(3) = out(4); 
     out(4) = temp;
end 
% case like 'S/s' letter 
if ( double(out(3)) == 1000)
     temp = out(3);
     out(3) = out(2); 
     out(2) = temp;
end
% 1900 for letter K
if ( double(out(4)) == 2300 || double(out(4)) == 1900 ) 
    out(4) = 2400 ; 
end
% for l/L  case 
if ( double(out(4)) == 1400 || double(out(4)) >= 3000 ) % letters OoucCxX
    out(4) = 4000; 
end
% case like 'E/e' 'Z/z' letters
if ( double(out(3)) == 1100 || double(out(3)) == 1900 )
    out(3) = out(3)+100 ; 
end

  for k = 1:length(C{1})
     % case when the signal represents "space" character 
    if ( double(out(2)) == 1000 && double(out(3)) == 2000 && double(out(4)) == 4000 ) % handdel the "space" case 
      string  = string + " ";
        break;
    end
    if (double(C{2}(k))== double(out(1)) && double(C{3}(k))== double(out(2)) && double(C{4}(k))== double(out(3)) && double(C{5}(k))== double(out(4)))
        string  = strcat(string,C{1}(k));
        break; 
    end
  end
end  
%% displaying the encoded string 
disp('the retrieval string: ');
disp(string); 
