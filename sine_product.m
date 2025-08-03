clc; clear;close all;
fs = 8192000;
N = 16384;
f1 = 25000;
f2 = 65000;
t = (0:N-1)/fs; % 时间向量
%hs1 = 0.1*sin(2*pi*f1*t);
hs1 = 0.1*sawtooth(2*pi*f1*t+ pi/2,0.5);
hs2 = 0.1*sin(2*pi*f2*t);

hs = hs1 + hs2; % 叠加并平均

figure;
subplot(2,1,1);
plot((1:5000), hs(1:5000)); 
title('时域信号');
xlabel('时间 (s)');
ylabel('幅度');

Hs = fft(hs, N);
subplot(2,1,2);
plot((0:N/2-1), abs(Hs(1:N/2)));
title('信号频谱');
xlabel('频率 (Hz)');
ylabel('幅度');

bw = 10;        % 量化位宽 10 bits
rr = real(hs);
rr = rr / max(abs(rr)); % 归一化到
rr = rr ./5;
rr_10 = round(rr * (2^(bw-1) - 1)); % 量化为10位有符号整数

%%
fid = fopen('nue13.txt', 'w'); 
% 转换为10位二进制补码
for i = 1:N
    % 处理负数（二进制补码）
    if rr_10(i) < 0
        % 计算补码：取绝对值 -> 按位取反 -> 加1
        val = bitand(1023 - abs(rr_10(i)) + 1, 1023);
    else
        val = rr_10(i);
    end
    % 生成10位二进制字符串
    bin_str = dec2bin(val, 10);
    fprintf(fid, '%s\n', bin_str);
end
fclose(fid);