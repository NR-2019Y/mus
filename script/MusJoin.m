function y = MusJoin(datmus, vct, varargin)
	global fs;

	paras = inputParser;
	addParameter(paras, 't32', 1/8);
	parse(paras, varargin{:});
	t32 = paras.Results.t32; % 需要保证 t32 <= 1/8
	
	t32Len = ceil(fs * t32); % 向量长度，肯定是整数
	LEN = ceil(fs / 8) * 32; % 4s音频对应的向量长度
	
	DecayFunc = @(x,c) (c.^(1-x)-1)./(c-1);
	DecayVec  = DecayFunc( (0:(LEN-1))/(LEN-1), 10000);
	% DecayVec = ones(1, LEN);
	% DecayVec = zeros(1, LEN);

	vctEnd   = cumsum(vct);
	vctBegin = [0, vctEnd(1:end-1)];

	idxEnd   = floor( vctEnd   * t32Len );
	idxBegin = floor( vctBegin * t32Len );
	
	y = zeros(1, idxEnd(end) + LEN);
	
	Len = length(datmus);
	for i = 1:Len
		if any(datmus{i} ~= 0)
			idxFullBegin = idxBegin(i) + 1;
			idxFullEnd   = idxBegin(i) + LEN;

			idxF = idxFullBegin:idxEnd(i);
			y(idxF) = y(idxF) + datmus{i}(idxF - idxF(1) + 1);
			if (idxFullEnd > idxEnd(i))
				idx = 1:(idxFullEnd - idxEnd(i));
				idxL = idx + idxEnd(i);
				y(idxL) = y(idxL) + datmus{i}(idx + idxF(end) - idxF(1) + 1).* DecayVec(idx);
			end
		end
	end
end

