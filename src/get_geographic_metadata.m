function [districtKeys, stateNames, stateCodes] = get_geographic_metadata(Tclean)
% GET_GEOGRAPHIC_METADATA Generates unique geographic keys and state names
%
% Syntax:
%   [districtKeys, stateNames, stateCodes] = get_geographic_metadata(Tclean)
%
% Description:
%   Resolves geographic ambiguity in the Census 2011 dataset. Multiple
%   districts share identical names across different states (e.g., Hamirpur
%   in Himachal Pradesh and Uttar Pradesh; Aurangabad in Bihar and Maharashtra;
%   Bilaspur in HP and Chhattisgarh; Pratapgarh in Rajasthan and UP; Bijapur
%   in Chhattisgarh and Karnataka). This function creates unique keys:
%   "DistrictName [StateName]" to prevent accidental cross-state collisions.

    numRows = height(Tclean);
    districtNames = string(Tclean.Name);
    
    % Official 35 States & Union Territories in Census 2011 (Codes 01 to 35)
    stateMap = containers.Map('KeyType', 'int32', 'ValueType', 'char');
    stateMap(1)  = 'Jammu & Kashmir';
    stateMap(2)  = 'Himachal Pradesh';
    stateMap(3)  = 'Punjab';
    stateMap(4)  = 'Chandigarh';
    stateMap(5)  = 'Uttarakhand';
    stateMap(6)  = 'Haryana';
    stateMap(7)  = 'NCT of Delhi';
    stateMap(8)  = 'Rajasthan';
    stateMap(9)  = 'Uttar Pradesh';
    stateMap(10) = 'Bihar';
    stateMap(11) = 'Sikkim';
    stateMap(12) = 'Arunachal Pradesh';
    stateMap(13) = 'Nagaland';
    stateMap(14) = 'Manipur';
    stateMap(15) = 'Mizoram';
    stateMap(16) = 'Tripura';
    stateMap(17) = 'Meghalaya';
    stateMap(18) = 'Assam';
    stateMap(19) = 'West Bengal';
    stateMap(20) = 'Jharkhand';
    stateMap(21) = 'Odisha';
    stateMap(22) = 'Chhattisgarh';
    stateMap(23) = 'Madhya Pradesh';
    stateMap(24) = 'Gujarat';
    stateMap(25) = 'Daman & Diu';
    stateMap(26) = 'Dadra & Nagar Haveli';
    stateMap(27) = 'Maharashtra';
    stateMap(28) = 'Andhra Pradesh';
    stateMap(29) = 'Karnataka';
    stateMap(30) = 'Goa';
    stateMap(31) = 'Lakshadweep';
    stateMap(32) = 'Kerala';
    stateMap(33) = 'Tamil Nadu';
    stateMap(34) = 'Puducherry';
    stateMap(35) = 'Andaman & Nicobar Islands';

    stateCodes = zeros(numRows, 1);
    stateNames = strings(numRows, 1);
    districtKeys = strings(numRows, 1);

    hasStateCol = ismember("State", string(Tclean.Properties.VariableNames));
    
    for i = 1:numRows
        sCode = 0;
        if hasStateCol
            val = Tclean.State(i);
            if isnumeric(val)
                sCode = int32(val);
            elseif isstring(val) || ischar(val) || iscell(val)
                sCode = int32(str2double(string(val)));
            end
        end

        % Fallback if State column is absent or zero: deduce from known 2011 district sequence
        if sCode == 0 || ~isKey(stateMap, sCode)
            sCode = deduceStateCodeFromIndex(i);
        end

        stateCodes(i) = sCode;
        if isKey(stateMap, sCode)
            sName = string(stateMap(sCode));
        else
            sName = "State " + string(sCode);
        end
        stateNames(i) = sName;
        districtKeys(i) = districtNames(i) + " [" + sName + "]";
    end

end

function sCode = deduceStateCodeFromIndex(idx)
    % Cumulative district counts per state in Census 2011 (Total = 640)
    % 1:22 J&K (22), 23:34 HP (12), 35:54 PB (20), 55 CH (1), 56:68 UK (13),
    % 69:89 HR (21), 90:98 DL (9), 99:131 RJ (33), 132:202 UP (71), 203:240 BR (38),
    % 241:244 SK (4), 245:260 AR (16), 261:271 NL (11), 272:280 MN (9), 281:288 MZ (8),
    % 289:292 TR (4), 293:299 ML (7), 300:326 AS (27), 327:345 WB (19), 346:369 JH (24),
    % 370:399 OD (30), 400:417 CG (18), 418:467 MP (50), 468:493 GJ (26), 494:495 DD (2),
    % 496 DN (1), 497:531 MH (35), 532:554 AP (23), 555:584 KA (30), 585:586 GA (2),
    % 587 LD (1), 588:601 KL (14), 602:633 TN (32), 634:637 PY (4), 638:640 AN (3)
    counts = [22, 12, 20, 1, 13, 21, 9, 33, 71, 38, ...
               4, 16, 11, 9,  8,  4, 7, 27, 19, 24, ...
              30, 18, 50, 26,  2,  1, 35, 23, 30,  2, ...
               1, 14, 32,  4,  3];
    cumCounts = cumsum(counts);
    sCode = find(idx <= cumCounts, 1, 'first');
    if isempty(sCode)
        sCode = 35;
    end
end
