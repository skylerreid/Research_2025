function rkey = get_new_key(seed, pos)
    key_value = seed(pos:(pos+10)); % take the current scrambled bits
    rkey = double(~key_value); % Invert the bits
end