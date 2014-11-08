require 'net/http'
require 'rexml/document'
require 'nokogiri'
require 'moji'

class YahooClient

  @ma_api
  @count_api
  
  def initialize
    @ma_api = 'http://jlp.yahooapis.jp/MAService/V1/parse?appid=' + ENV['YH_API_ID'] + '&results=uniq&filter=9&sentence='  
    @count_api = 'http://jlp.yahooapis.jp/MAService/V1/parse?appid=' + ENV['YH_API_ID'] + '&results=uniq&filter=1|2|3|9|10&response=surface&uniq_by_baseform=true&sentence='  
  end
  
  def get_noun(profile, nouns)
    texts = Array.new
    initial = profile['profile'][0,1]
    if profile['lang'] == 'ja' || !initial.ascii_only?
      result = Net::HTTP.get(URI.parse(URI.escape(@ma_api + profile['profile'])))
      doc = REXML::Document.new(result)
      doc.elements.each('ResultSet/uniq_result/word_list/word') do |elem|
        texts.push( elem.elements[2].text.upcase )
      end
    else
      text = profile['profile'].gsub(/(\,|\/)/, '')
      texts = text.split(' ')
    end
    texts.each do |noun|
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
  
  def get_count( texts )
    result = Hash.new
    texts.each do | text |
      response = Net::HTTP.get(URI.parse(URI.escape(@count_api + text)))
      doc = REXML::Document.new(response)
      doc.elements.each('ResultSet/uniq_result/word_list/word') do |elem|
        word = elem.elements[2].text
        unless word.ascii_only?
          if result.key?(word)
            result[word] += 1
          else
            result[word] = 1
          end
        end
      end
    end
    return result
  end

end
