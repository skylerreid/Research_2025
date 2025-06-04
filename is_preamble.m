function is_p = is_preamble(bits33)
    % Check if bits match 100Base-T1 preamble: alternating 101010...101
    expected = repmat([1 0], 1, 16);  % 32 bits
    expected = [expected, 1];         % 33rd bit
    is_p = isequal(bits33, expected);
end
