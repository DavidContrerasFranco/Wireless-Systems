function [HNew, Samples] = delimitarBW(H, BW, Tau)
    Ts = 1/BW;
    smpls = max(Tau)/Ts;

    HNew = ones(smpls, length(H));
    for k = 1:smpls
        HNew(k,:) = sum(H((k - 1)*Ts < Tau & Tau < k*Ts));
    end
    Samples = 1:smpls;
end