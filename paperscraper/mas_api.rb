require 'open-uri'
require 'json'
require 'deep_enumerable'

# Microsoft Academic Search API
class MasJsonApi
  BASE_URL = 'http://academic.research.microsoft.com/json.svc/search'

  def initialize(key)
    @key = key
  end

  def parse_json(s)
    JSON::parse(s)
  end

  def url
    BASE_URL + "?AppId=#@key&ResultObjects=publication&PublicationContent=title,author" + "&StartIdx=1&EndIdx=2"
  end

  def query_by_title(title)
    query_url = "#{url}&FullTextQuery=#{title}"
    parse_json(open(query_url).read)
  end

  def dg(h, a)
    h.deep_get(DeepEnumerable.deep_key_from_array(a))
  end

  def title_to_id(title)
    response = query_by_title(title)
    results = dg(response, ['d', 'Publication', 'Result'])
    results.map{|r| r['ID']}
  end

  def get_citations(pub_id)
    query_url = "http://academic.research.microsoft.com/json.svc/search?AppId=Your_AppID&PublicationID=#{pub_id}&ResultObjects=Publication&ReferenceType=Citation&StartIdx=1&EndIdx=10&OrderBy=Year"
    open(query_url.read)
  end
end

if __FILE__ == $PROGRAM_NAME
  key = open('MAS_API_KEY.txt').each_line.first.strip
  mja = MasJsonApi.new(key)
  p mja.title_to_id('The effectiveness of source code obfuscation: An experimental assessment.')
end
