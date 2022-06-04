function Y = BasicMusNoteEKS1(nInput)

% 不建议用，基本不能控制包络形状

	global fs;
	persistent Lastfs;
	if isempty(fs)     fs = 44100; end
	
	LEN = ceil(fs / 8) * 32;

	persistent MusNote4SecKSDb;   % 要判断全局变量fs是否被修改了
	if isempty(Lastfs) || (Lastfs ~= fs) Lastfs = fs;
		MusNote4SecKSDb = cell(1,88); % A0 ~ D8，88个音符，n的范围：-38~49
		ymul = genADSR(0.05, 0.9, 0.0001, 0.05, LEN);
		
		for ii = 1:88
			n = ii - 39;
			fq = 261.63 * 2^(n/12);

			T = double( uint64(fs / fq) );
			TimesOfT = ceil(LEN / T);
			
			BUFADD = 4;
			wnoise = randn(1, T + BUFADD);
			wnoise = wnoise / max(abs(wnoise));
			x = wnoise;

			%% Pick-Direction Lowpass Filter
			p = 0.9;
			x = filter(1 - p, [1, -p], x);
			
			%% Pick-Position Comb Filter 
			% beta = 0.2;
			% ppdel = floor(beta * T);
			% tmpbuf = zeros(1, T + BUFADD);
			% tmpbuf((ppdel+1):(T + BUFADD)) = x(1 : (T + BUFADD - ppdel));
			% x = x - tmpbuf;

			%% LOOP
			x = x / max(abs(x));
			buf = zeros(1, TimesOfT * T);
			buf(1:T) = x(1+BUFADD:T+BUFADD);
			x0 = x(1:BUFADD);
			
			%% Two-Zero String Damping Filter
			% rescale : yd / max(abs(yd)), so now `rho' is useless
			% t60 = 4;
			% rho = 0.01 ^ (1 / t60 / fq);

			B = 0.8; 
			h0 = (1 + B) / 2; h1 = (1 - B) / 4;
			[b1, a1] = deal([h1, h0, h1], 1);
			% [b1, a1] = deal([1/2, 1/2], 1);
			[~,  z1] = filter(b1, a1, x0);

			yd = buf(1:T);
			% 不需要: yd = yd / max(abs(yd))
			for kk = 2:TimesOfT
				[yd, z1] = filter(b1, a1, yd, z1);
				
				ydiv = max(abs(yd));
				yd = yd / ydiv;
				z1 = z1 / ydiv;

				buf( ((kk - 1)*T+1):(kk*T) ) = yd;
			end

			y = buf(1:LEN) .* ymul;
			% y = lowpass(y, fq, fs, 'Steepness', 0.5);
			% y = y / max(abs(y));
			MusNote4SecKSDb{ii} = y;
		end
	end
	
	if isinf(nInput)
		Y = zeros(1, LEN);
	else
		inputLen = length(nInput);
		Y = mean(reshape(cell2mat(arrayfun(@(x) MusNote4SecKSDb{x+39}, nInput, 'UniformOutput', false)), LEN, inputLen), 2)';
	end
end

