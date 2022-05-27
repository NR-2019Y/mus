function y = NoteJoinFromDb(notes, vct, db, t32, toneadj)
	if nargin < 4, t32 = 1/8;   end
	if nargin < 5, toneadj = 0; end
	
	fs = 44100;
	t32Len = ceil(fs * t32); % 向量长度，肯定是整数
	LEN = ceil(fs / 8) * 32; % 4s音频对应的向量长度
	
	DecayFunc = @(x,c) (c.^(1-x)-1)./(c-1);
	DecayVec  = DecayFunc( (0:(LEN-1))/(LEN-1), 1e20 );
	% DecayVec = ones(1, LEN);
	% DecayVec = zeros(1, LEN);

	vctEnd   = cumsum(vct);
	vctBegin = [0, vctEnd(1:end-1)];

	idxEnd   = int64( vctEnd   * t32Len );
	idxBegin = int64( vctBegin * t32Len );

	y = zeros(1, idxEnd(end) + LEN);
	
	for ii = 1:length(notes)
		note = notes{ii};
		if ~isinf(note)
			inputLen = length(note);
			mus = sum(reshape(cell2mat(arrayfun(@(x) db.v{ x + toneadj + db.c4idx }, note, 'UniformOutput', false)), LEN, inputLen), 2)';
			mus = mus / sqrt(inputLen);
			
			idxFullBegin = idxBegin(ii) + 1;
			idxFullEnd   = idxBegin(ii) + LEN;
			idxF = idxFullBegin:idxEnd(ii);
			y(idxF) = y(idxF) + mus(idxF - idxBegin(ii));
			if (idxFullEnd > idxEnd(ii))
				idxL = (idxEnd(ii) + 1):idxFullEnd;
				idx  = idxL - idxEnd(ii);
				y(idxL) = y(idxL) + mus(idxL - idxBegin(ii)).* DecayVec(idx);
			end
		end
	end
end

