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
    BASE_URL + "?AppId=#@key&StartIdx=1&EndIdx=2"
  end

  def query_by_title(title)
    query_url = "#{url}&ResultObjects=publication&PublicationContent=title&FullTextQuery=#{title}"
    #p query_url
    json = parse_json(open(query_url).read)
    #p json
    json
  end

  def dg(h, a)
    h.deep_get(DeepEnumerable.deep_key_from_array(a))
  end

  def title_to_ids(title)
    response = query_by_title(title)
    results = dg(response, ['d', 'Publication', 'Result'])
    results.map{|r| r['ID']} if results
  end

  def get_citations(pub_id)
    query_url = "#{url}&ResultObjects=Publication&ReferenceType=Citation&PublicationID=#{pub_id}"
    p query_url
    json = parse_json(open(query_url).read)
    json
  end
end

if __FILE__ == $PROGRAM_NAME
  key = open('MAS_API_KEY.txt').each_line.first.strip
  mja = MasJsonApi.new(key)
  p mja.title_to_ids('The effectiveness of source code obfuscation: An experimental assessment.')
  p mja.get_citations(2460494)
end
