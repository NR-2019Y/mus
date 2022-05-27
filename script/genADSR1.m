function ymul = genADSR1(A, D, S, R)
	fs = 44100;
	LEN = ceil(fs / 8) * 32;

	% https://github.com/Nuullll/music-synthesizer
	% [A, D, S, R] = deal(0.9, 0.05, 0.0001, 0.05); % 管乐
	% [A, D, S, R] = deal(0.05, 0.9, 0.0001, 0.05); % 钢琴
	% [A, D, S, R] = deal(0.05, 0.05, 0.0001, 0.9);  % 电话按键音
	% [A, D, S, R] = deal(0.05, 0.05, 0.05, 0.05);   % 拨弦音
	% [A, D, S, R] = deal(0.05, 0.25, 0.15, 0.15);  % 木琴
	% [A, D, S, R] = deal(0.0001, 0.0001, 0.8, 0.99); % 吉他
	% A, D, R 表示时间占比，S 表示振幅
	tA = floor(LEN * A);
	tD = floor(LEN * D);
	tR = floor(LEN * R);
	tS = LEN - tA - tD - tR;

	tmpAIndex = (0:(tA - 1)) / (tA - 1);
	ABaseN = 10;
	yA = 1 - (ABaseN .^ (1 - tmpAIndex) - 1) / (ABaseN - 1);
	tmpDIndex = (0 : (tD - 1)) / (tD - 1);
	yD = S + (1-S) * (exp(1 - tmpDIndex) - 1) / (exp(1) - 1);
	yS = S * ones(1, tS);
	tmpRIndex = (0:(tR-1)) / (tR-1);
	RBaseN = 10 ^ S;
	yR = S * (RBaseN .^ (1 - tmpRIndex) - 1) / (RBaseN - 1);
	ymul = [yA, yD, yS, yR];
end

