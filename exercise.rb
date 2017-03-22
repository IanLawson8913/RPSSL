# input: array of strings
# output: string; made of one letter from each string; idx 0 += 1

# determine number of strings
# create collection to add each letter to
# iterate through array of strings and add idx 0 += 1 to collection

def nth_char(words)
  result = ''
  words.each_with_index { |word, idx| result << word[idx] }
  result
end

p nth_char(['yes','yes','yes'])