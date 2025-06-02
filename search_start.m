function idx = search_start(bits, offset)
    % Find the start of message delimiter in the bit stream
    % return its index, which gets appended to start_locs
    idx = offset;
    cur_val = 0;
    while idx < length(bits)
        cur_val = bitshift(cur_val, 1);
        cur_val = bitand(cur_val, 0xffffffff);
        cur_val = bitor(cur_val, bits(idx + 1));

        if bitshift(cur_val, -12) == hex2dec('ff88a')
            disp(dec2hex(cur_val)); 
            disp(idx);  %this is a start index
        end

        if cur_val == hex2dec('ff88ad6b')
            disp('found');      %11111111100010001010110101101011 in binary. idle plus start code
            idx = idx - 24 - offset;
            %disp(idx)
            return;
        end
        idx = idx + 1;
    end
    idx = -1;
end