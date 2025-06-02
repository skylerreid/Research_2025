function descrambled = descramble_data(scramble_key, scrambled_data)
    % Takes data stream and descrambles using scramble_key
    % Returns a struct with real_data and start positions
    % Use descrambled.data and descrambled.start_locs

    % Inputs:
    % scramble_key - Descrambler key to use for the stream.
    % scrambled_data - Data from waveform.

    start_loc = [];
    keysynced = 0;
    find_offset = 0;
    real_data = [];
    for i = 1:length(scrambled_data)
        % Append result of the XOR operation to real_data
        real_data = [real_data, bitxor(scrambled_data(i), scramble_key(1))];

        if real_data(i) ~= 1   
            keysynced = keysynced + 1;  %if not 1, increment key counter
        elseif keysynced > 10
            scramble_key = get_new_key(scrambled_data, i);  %update key if too many zeros
            keysynced = 0;  %reset key counter
        else
            keysynced = 0;  %don't update key counter if ones are found
        end

        if mod(i, 128) == 0 && i > 0    %check if i is multiple of 0x80 and greater than zero
            sval = search_start(real_data, find_offset);    
            %search_start returns index of start frame by checking for idle
            %plus JK. result appended to start locs. Not useful to
            %preallocate since much smaller than real_data
            if sval >= 0
                start_loc = [start_loc, sval + find_offset];
                find_offset = find_offset + sval + 24;
            else
                find_offset = find_offset + 128;
            end
        end

        % check that key is still a double
        scramble_key = double(scramble_key);
        scramble_key = lfsr_key(scramble_key);
    end

    descrambled.data = real_data;   %assign data to struct
    descrambled.start_locs = start_loc;
end