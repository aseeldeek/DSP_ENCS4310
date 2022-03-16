%% this file is the filter decoder code - part 2
% this project done by 
% -> Aseel Deek        - 1190587
% -> Lojain Abdalraqaz - 1190707
% -> Mariam Taweel     - 1192099
%%  reading file chars.txt 
fileID=fopen('chars.txt','r');
count = 0;% to find the count of the line numbers 
while true
   tline = fgetl(fileID);
   if ~ischar(tline); break; end   %end of file
    count = count + 1;
end
fclose(fileID); 
disp(count);  % display the number of line
%% the entered string  for the user 
prompt='Enter a statement : ';
str = input(prompt);
%% this part to display the content of the array 
Fs = 8000;
n = 0:319;
new =0;
fileID=fopen('chars.txt','r');
formatSpec='%s %d %d %d %d'; % file formate 
C = textscan(fileID,formatSpec); % first colum is for characters, second is for c/s ..  
%%  from this line the Encoder algorithm statrs
for i = 1:length(str)
    if (strcmp(str(i),' '))
      sig1 = cos(2*pi*double(C{2}(count))*n/Fs)+cos(2*pi*double(C{3}(count))*n/Fs)+cos(2*pi*double(C{4}(count))*n/Fs)+cos(2*pi*double(C{5}(count))*n/Fs);
      new = [new, sig1];
    else  
       for j =1:length(C{1}) % it could be c{3} ,, all columns have the same leng
           if (strcmp(C{1}(j),str(i)))  % compare each character with the C ( table)
             sig1 = cos(2*pi*double(C{2}(j))*n/Fs)+cos(2*pi*double(C{3}(j))*n/Fs)+cos(2*pi*double(C{4}(j))*n/Fs)+cos(2*pi*double(C{5}(j))*n/Fs);
             new = [new, sig1];
             break; % when find the anser break and go for the other character 
           end
       end            
    end 
end
new_normalized = new/(max(abs(new(:))));
audiowrite('test.wav',new_normalized,Fs)
[x,Fs] = audioread('test.wav'); 
plot(x); % the signal i have create 


 