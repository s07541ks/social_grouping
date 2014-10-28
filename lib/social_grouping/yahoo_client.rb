require 'nokogiri'
require 'moji'

class YahooClient
  require 'rexml/document'

  @ma_api
  @key_api
  
  def initialize
    @ma_api = 'http://jlp.yahooapis.jp/MAService/V1/parse?appid=' + ENV['YH_API_ID'] + '&results=uniq&filter=9&sentence='  
    @key_api = 'http://jlp.yahooapis.jp/KeyphraseService/V1/extract?appid=' + ENV['YH_API_ID'] + '&sentence='  
  end
  
  def get_noun(sentence, nouns)
    result = Net::HTTP.get(URI.parse(URI.escape(@ma_api + sentence)))
    doc = REXML::Document.new(result)
    doc.elements.each('ResultSet/uniq_result/word_list/word') do |elem|
      noun = elem.elements[2].text.upcase
      if noun.bytesize > 2 && noun.size > 1
        if nouns.key?(noun)
          nouns[noun] += 1
        else
          nouns[noun] = 1
        end
      end
    end
    return nouns
  end
  
  def get_key(sentence, nouns)
    result = Net::HTTP.get(URI.parse(URI.escape(@key_api + sentence)))
    doc = REXML::Document.new(result)
    doc.elements.each('ResultSet/Result') do |elem|
      noun = elem.elements[1].text.upcase
      value = elem.elements[2].text.to_i
      if noun.split(//).size > 1
        if nouns.key?(noun)
          nouns[noun] = nouns[noun] * value
        else
          nouns[noun] = value
        end
      end
    end
    return nouns
  end
  
end
