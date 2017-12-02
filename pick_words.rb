#!/usr/bin/env ruby
require 'natto'

# 品詞ID
NOUNS_POSID = (36..67).to_a
VERBS_POSID = (31..33).to_a

text = STDIN.read.gsub(',', ' ')
words = []
natto = Natto::MeCab.new
natto.parse(text) do |n|
  if !n.is_eos? && (NOUNS_POSID + VERBS_POSID).include?(n.posid)
    words << n.surface.to_s
  end
end
print words.join(' ')
