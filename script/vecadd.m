function v = vecadd(v1, v2)
% 输出列向量
	n1 = length(v1);
	n2 = length(v2);
	v = zeros(max(n1, n2), 1);
	v(1:n1) = v1(:);
	v(1:n2) = v(1:n2) + v2(:);
end
