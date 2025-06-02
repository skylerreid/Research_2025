function key = lfsr_key(key)
    % Calculate next register to XOR stream with to get plaintext
    temp = bitxor(key(1), key(3));
    key = flip(key);

    key(11) = key(10);  
    key(10) = key(9);
    key(9) = key(8);
    key(8) = key(7);
    key(7) = key(6);
    key(6) = key(5);
    key(5) = key(4);
    key(4) = key(3);
    key(3) = key(2);
    key(2) = key(1);
    key(1) = temp;     
    %less elegant than using circshift but more reliable
    key = flip(key);
end