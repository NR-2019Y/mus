function Y = BasicMusNote(nInput)
	global fs;
	persistent Lastfs;
	if isempty(fs)     fs = 44100; end
	
	LEN = ceil(fs / 8) * 32;

	persistent MusNote4SecDb;   % 要判断全局变量fs是否被修改了
	if isempty(Lastfs) || (Lastfs ~= fs) Lastfs = fs;
		MusNote4SecDb = cell(1,88); % A0 ~ D8，88个音符，n的范围：-38~49
		VEC = 1:LEN;
		t = (VEC - 1) / fs;         % [0, 4)
		for ii = 1:88
			n = ii - 39;
			fq = 261.63 * 2^(n/12);

			k = [1,0.20,0.15,0.15,0.10,0.10,0.01,0.05,0.01,0.01,0.003,0.003,0.002,0.002]; % 钢琴
			% k = [1 0.35 0.23 0.12 0.04 0.08 0.08 0.08 0.12]; % 吉他
			% k = [0.55 0.95 0.65 0.3 0.1]; % 吉他
			% k = 1;
			% k = 1;
			
			y = k * cos(2 * pi * fq * (1:length(k)) .'* t);
			y = y / max(y);

			y = y .* (t.^(1/15)) .* exp(-2*t);
			% y = sin(pi * t/4) .* y;

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

