function Y = BasicMusNoteKS(nInput)
	global fs;
	persistent Lastfs;
	if isempty(fs)     fs = 44100; end
	
	LEN = ceil(fs / 8) * 32;

	persistent MusNote4SecKSDb;   % 要判断全局变量fs是否被修改了
	if isempty(Lastfs) || (Lastfs ~= fs) Lastfs = fs;
		MusNote4SecKSDb = cell(1,88); % 88个音符，n的范围：-38~49。n=0表示C4
		for ii = 1:88
			n = ii - 39;
			fq = 261.63 * 2^(n/12);

			T = double( uint64(fs / fq) );
			TimesOfT = ceil(LEN / T);
			bufLen = TimesOfT * T + 1;
			buf = zeros(1, bufLen);
			
			wnoise = randn(1, T+1);
			wnoise = wnoise / max(abs(wnoise));
			% wnoise = sin ( (-1:T-1)*2 * pi / T );
			% wnoise = rand(1, T+1) * 2 - 1;
			% wnoise = ones(1, T+1);
			buf(1:(T+1)) = wnoise;
			
			% alpha = 1;
			basicIdx = 1:T;
			for kk=2:TimesOfT
				buf(basicIdx +(kk-1)*T + 1) = (buf(basicIdx +(kk-2)*T) + buf(basicIdx +(kk-2)*T+1))*0.5;
				% b = 0.1;
				% buf(basicIdx +(kk-1)*T + 1) = (buf(basicIdx +(kk-2)*T) + sign(b-rand(1)) * buf(basicIdx +(kk-2)*T+1))*0.5;
			end
			MusNote4SecKSDb{ii} = buf(2:(LEN + 1));
		end
	end
	
	if isinf(nInput)
		Y = zeros(1, LEN);
	else
		inputLen = length(nInput);
		Y = sum(reshape(cell2mat(arrayfun(@(x) MusNote4SecKSDb{x+39}, nInput, 'UniformOutput', false)), LEN, inputLen), 2)';
	end
end

