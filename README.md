# String-scrambling-challenge

An answer to a coding challenge from MacBidoulle.com programmers forum

You will be given a scrambled word phrase. You must unscramble the letters to reveal the original phrase. Each phrase has been scrambled by the following process:
1) Find every 2nd letter of the alphabet in the phrase (B, D, F, etc.) and reverse their order within the phrase.
2) Find every 3rd letter of the alphabet in the phrase (C, F, I, etc.) and shift their positions one to the right, with the last letter wrapped around to the first position.
3) Find every 4th letter of the alphabet in the phrase (D, H, L, etc.) and shift their positions one to the left, with the first letter wrapped around to the last position. 
4) Count the number of letters in each word, and reverse that list of numbers, re-applying the revised word lengths to the letter sequence.
ex : MOSTLY HARMLESS -> MOSLRY HALMTESS -> MLSOLY HARMTESS -> MLSOHY TARMLESS -> MLSOHYTA RMLESS

