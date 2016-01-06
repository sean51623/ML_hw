function logP = logP_crp(c,alogPha)

table_identifier = unique(c);
K_plus = length(table_identifier);
N = length(c);
m_k = zeros(K_plus,1);

for(k = 1:K_plus)
    m_k(k) = length(find(c==table_identifier(k)));
end

foo = gammaln(m_k-1);
foo(find(foo==Inf))=0;

logP = K_plus*log(alogPha) + sum(foo) + gammaln(alogPha) - gammaln(N+alogPha);
