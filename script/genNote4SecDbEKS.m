function db = genNote4SecDbEKS(p, beta, b1, r)
	fs = 44100;
	LEN = ceil(fs / 8) * 32;

	db.c4idx = 40;
	db.v     = cell(1, 90); % 90个音符( A0 ~ D8 )，n的范围：-39~50。n = 0表示C4

	for ii = 1:90
		n = ii - db.c4idx;
		fq = 261.63 * 2^(n/12);

		T = double( uint64(fs / fq) );
		TimesOfT = ceil(LEN / T);
		
		% BUFADD = length(b1) - 1;
		BUFADD = 0;
		wnoise = randn(1, T + BUFADD);
		wnoise = wnoise / max(abs(wnoise));
		x = wnoise;

		%% Pick-Direction Lowpass Filter
		x = filter(1 - p, [1, -p], x);
		
		%% Pick-Position Comb Filter 
		if ~isinf(beta)
			ppdel = ceil(beta * T);
			tmpbuf = zeros(1, T + BUFADD);
			tmpbuf( ppdel+1 : T+BUFADD ) = x( 1 : T+BUFADD-ppdel );
			x = x - tmpbuf;
		end

		%% LOOP
		x = x / max(abs(x));
		buf = zeros(1, TimesOfT * T);
		buf(1:T) = x( 1+BUFADD : T+BUFADD );
		x0 = x(1:BUFADD);

		%% Two-Zero String Damping Filter
		t60 = 4;
		rho = r ^ (1 / t60 / fq);

		a1 = 1;
		[~, z1] = filter(rho * b1, a1, x0);

		yd = buf(1:T);
		for kk = 2:TimesOfT
			[yd, z1] = filter(rho * b1, a1, yd, z1);
			buf( ((kk - 1)*T+1):(kk*T) ) = yd;
		end

		y = buf(1:LEN);
		db.v{ii} = y;
	end
end

