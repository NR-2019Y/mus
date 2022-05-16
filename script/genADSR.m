function ymul = genADSR(A, D, S, R, LEN)
	% https://github.com/Nuullll/music-synthesizer
	% [A, D, S, R] = deal(0.9, 0.05, 0.0001, 0.05); % ����
	% [A, D, S, R] = deal(0.05, 0.9, 0.0001, 0.05); % ����
	% [A, D, S, R] = deal(0.05, 0.05, 0.0001, 0.9);  % �绰������
	% [A, D, S, R] = deal(0.05, 0.05, 0.05, 0.05);   % ������
	% [A, D, S, R] = deal(0.05, 0.25, 0.15, 0.15);  % ľ��
	% [A, D, S, R] = deal(0.0001, 0.0001, 0.8, 0.99); % ����
	% A, D, R ��ʾʱ��ռ�ȣ�S ��ʾ���
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
end

