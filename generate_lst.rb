#!/usr/bin/env ruby
require 'natto'

# 元文章と生成したファイルの設置場所
DOCS_DIR = 'docs'
DEST_DIR = 'generated'

# 品詞ID
NOUNS_POSID = (36..67).to_a
VERBS_POSID = (31..33).to_a

# テキストから名詞と動詞だけ取り出す
def pick_words(text)
  words = []
  natto = Natto::MeCab.new
  natto.parse(text) do |n|
    if !n.is_eos? && (NOUNS_POSID + VERBS_POSID).include?(n.posid)
      words << n.surface.to_s
    end
  end
  words
end

# ディレクトリに分けたファイルリスト
files = {}
Dir.entries(DOCS_DIR).each do |category|
  path = File.join(DOCS_DIR, category)
  if File.directory?(path) && !%w(. ..).include?(category)
    files[category] = []
    Dir.entries(path).each do |name|
      filename = File.join(path, name)
      if File.file?(filename) && !/^\./.match(name)
        files[category] << filename
      end
    end
  end
end

# カテゴリ毎に.lstファイルを作って単語を並べる
files.each do |category, filenames|
  puts "Parse: #{category}"
  f = open(File.join(DEST_DIR, "#{category}.lst"), 'w')
  filenames.each do |filename|
    words = pick_words(IO.read(filename).gsub(',', ' '))
    f.puts "__label__#{category}, #{words.join(' ')}"
  end
end
