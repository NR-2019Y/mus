function Y = BasicMusNoteADSR(nInput)
	global fs;
	if isempty(fs)     fs = 44100; end
	persistent Lastfs;
	
	LEN = ceil(fs / 8) * 32;
	
	persistent MusNote4SecDb;   % 要判断全局变量fs是否被修改了
	if isempty(Lastfs) || (Lastfs ~= fs) Lastfs = fs;

		% https://github.com/Nuullll/music-synthesizer
		% [A, D, S, R] = deal(0.9, 0.05, 0.0001, 0.05); % 管乐
		[A, D, S, R] = deal(0.05, 0.9, 0.0001, 0.05); % 钢琴
		% [A, D, S, R] = deal(0.05, 0.05, 0.0001, 0.9);  % 电话按键音
		% [A, D, S, R] = deal(0.05, 0.05, 0.05, 0.05);   % 拨弦音
		% [A, D, S, R] = deal(0.05, 0.25, 0.15, 0.15);  % 木琴
		% [A, D, S, R] = deal(0.0001, 0.0001, 0.8, 0.99); % 吉他
		% A, D, R 表示时间占比，S 表示振幅

		tA = floor(LEN * A);
		tD = floor(LEN * D);
		tR = floor(LEN * R);
		tS = LEN - tA - tD - tR;

		AIndex = 1:tA;
		yA = (1 - 10 .^ (1 - AIndex)) / (1 - 10 ^ (1 - tA));
		tmpDIndex = (0 : (tD - 1)) / (tD - 1);
		yD = S + (1-S) * (exp(1 - tmpDIndex) - 1) / (exp(1) - 1);
		yS = S * ones(1, tS);
		tmpRIndex = (0:(tR-1)) / (tR-1);
		RBaseN = 10 ^ S;
		yR = S * (RBaseN .^ (1 - tmpRIndex) - 1) / (RBaseN - 1);
		ymul = [yA, yD, yS, yR];


		VEC = 1:LEN;
		t = (VEC - 1) / fs;         % [0, 4)
		MusNote4SecDb = cell(1,88); % 88个音符，n的范围：-38~49。n=0表示C4
		for ii = 1:88
			n = ii - 39;
			fq = 261.63 * 2^(n/12);

			% https://github.com/Nuullll/music-synthesizer
			% https://zhuanlan.zhihu.com/p/378287088

			k = [1,0.20,0.15,0.15,0.10,0.10,0.01,0.05,0.01,0.01,0.003,0.003,0.002,0.002]; % 钢琴
			% k = [1 0.35 0.23 0.12 0.04 0.08 0.08 0.08 0.12]; % 吉他
			% k = [0.55 0.95 0.65 0.3 0.1]; % 吉他

			y = k * cos(2 * pi * fq * (1:length(k)) .'* t);
			y = y / max(y);

			y = y .* ymul;

			MusNote4SecDb{ii} = y;
		end
	end
	if isinf(nInput)
		Y = zeros(1, LEN);
	else
		inputLen = length(nInput);
		Y = sum(reshape(cell2mat(arrayfun(@(x) MusNote4SecDb{x+39}, nInput, 'UniformOutput', false)), LEN, inputLen), 2)';
	end
end

