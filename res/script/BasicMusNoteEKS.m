function Y = BasicMusNoteEKS(nInput)
	global fs;
	persistent Lastfs;
	if isempty(fs)     fs = 44100; end
	
	LEN = ceil(fs / 8) * 32;

	persistent MusNote4SecKSDb;   % 要判断全局变量fs是否被修改了
	if isempty(Lastfs) || (Lastfs ~= fs) Lastfs = fs;
		MusNote4SecKSDb = cell(1,88); % A0 ~ D8，88个音符，n的范围：-38~49
		for ii = 1:88
			n = ii - 39;
			fq = 261.63 * 2^(n/12);

			T = double( uint64(fs / fq) );
			TimesOfT = ceil(LEN / T);
			
			wnoise = randn(1, T + 2);
			wnoise = wnoise / max(abs(wnoise));
			x = wnoise;
			
			%% Pick-Direction Lowpass Filter
			p = 0.99;
			x = filter(1 - p, [1, -p], x);
			
			%% Pick-Position Comb Filter 
			beta = 0.2;
			ppdel = floor(beta * T + 0.5);
			tmpbuf = zeros(1, T+2);
			tmpbuf((ppdel+1):(T+2)) = x(1 : (T+2 - ppdel));
			x = x - tmpbuf;
			
			%% LOOP
			BUFNADD = 2;
			buf = zeros(1, TimesOfT * T + BUFNADD);
			buf(1:(T+BUFNADD)) = x;
			
			
			for kk = 2:TimesOfT
				yd = buf( ((kk - 2)*T + 1) : ((kk - 1)*T + BUFNADD) );
				
				%% Two-Zero String Damping Filter
				t60 = 4;
				rho = 0.01 ^ (1 / t60 / fq);
				% rho = 1;

				B = 0.1;
				h0 = (1 + B) / 2;
				h1 = (1 - B) / 4;
				yd = filter(rho * [h1, h0, h1], 1, yd);
				% yd = filter([1/2, 1/2], 1, yd); %% KS

				buf( (((kk - 1)*T+1):(kk*T)) + BUFNADD ) = yd( (1:T) + BUFNADD );
			end

			% t = (1:LEN) / fs;
			% MusNote4SecKSDb{ii} = buf((1:LEN) + BUFNADD) .* (t.^(1/15));
			% MusNote4SecKSDb{ii} = buf((1:LEN) + BUFNADD) / max(buf((1:LEN) + BUFNADD)) .* (t.^(1/10)) .* exp(-t);
			MusNote4SecKSDb{ii} = buf((1:LEN) + BUFNADD);
		end
	end
	
	if isinf(nInput)
		Y = zeros(1, LEN);
	else
		inputLen = length(nInput);
		Y = sum(reshape(cell2mat(arrayfun(@(x) MusNote4SecKSDb{x+39}, nInput, 'UniformOutput', false)), LEN, inputLen), 2)';
	end
end

