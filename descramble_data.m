function descrambled = descramble_data(scramble_key, scrambled_data)
    % DESCRAMBLE_DATA Descrambles 100Base-T1 Ethernet stream using LFSR
    % Inputs:
    %   scramble_key    - 33-bit initial key as vector
    %   scrambled_data  - Binary vector of scrambled bits (0 or 1)
    %
    % Output:
    %   descrambled.data        - Descrambled bitstream
    %   descrambled.start_locs  - Detected frame start indices

    real_data = zeros(1, length(scrambled_data));
    start_loc = [];

    find_offset = 0;
    frame_in_progress = false;
    frame_end_margin = 2048; % Estimated frame size in bits

    for i = 1:length(scrambled_data)
        % XOR descrambling
        real_data(i) = bitxor(scrambled_data(i), scramble_key(1));

        % Update scrambler key using LFSR
        scramble_key = lfsr_key(scramble_key);

        % Only search when not inside a frame
        if ~frame_in_progress && i >= 33
            % Check the last 33 bits for a preamble
            preamble_candidate = real_data(i-32:i);
            if is_preamble(preamble_candidate)
                % Found frame start
                frame_start = i - 32;
                start_loc = [start_loc, frame_start];
                frame_in_progress = true;
                find_offset = i; % Resume searching after this frame
            end
        end

        % End of frame region — allow search again
        if frame_in_progress && i >= find_offset + frame_end_margin
            frame_in_progress = false;
        end
    end

    descrambled.data = real_data;
    descrambled.start_locs = start_loc;
end
