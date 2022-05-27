function y = MusNoteParse(s)
	y = cellfun(@s2n, strsplit(s, '/'));
end

function y = s2n(s)
	if s == '0'
		y = Inf;
	else
		n2mn_table = [0, 2, 4, 5, 7, 9, 11];
		ss = strip(s, '=');
		y  = n2mn_table( str2num(ss(end)) );
		if startsWith(s, '=')
			y = y - 12 * count(s, '=');
		elseif endsWith(s, '=')
			y = y + 12 * count(s, '=');
		end
		if contains(s, 'b')
			y = y - 1;
		elseif contains(s, '#')
			y = y + 1;
		end
	end
end

