function db = genNote4SecDbADSR(k, vadsr)
	fs = 44100;
	LEN = ceil(fs / 8) * 32;
	% ymul = genADSR1( vadsr(1), vadsr(2), vadsr(3), vadsr(4) );
	ymul = genADSR( vadsr(1), vadsr(2), vadsr(3), vadsr(4), LEN );

	db.c4idx = 40;
	db.v     = cell(1, 90); % 90个音符( A0 ~ D8 )，n的范围：-39~50。n = 0表示C4

	t = (0:LEN - 1) / fs;         % [0, 4)
	for ii = 1:90
		n = ii - db.c4idx;
		fq = 261.63 * 2^(n/12);
		
		y = k * cos(2 * pi * fq * (1:length(k)) .'* t);
		y = y / max(y);
		y = y .* ymul;

		db.v{ii} = y;
	end 
end

