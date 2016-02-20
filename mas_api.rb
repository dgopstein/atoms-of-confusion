require 'open-uri'

# Microsoft Academic Search API
class MasJsonApi
  BASE_URL = 'http://academic.research.microsoft.com/json.svc/search'

  def initialize(key)
    @key = key
  end

  def url
    BASE_URL + "?AppId=#@key&ResultObjects=publication&PublicationContent=title,author"
  end

  def query(type, q)
    query_url = "#{url}&#{type}=#{q}"
    open(query_url).read
  end

  def full_text_query(q)
    query('FullTextQuery', q)
  end
end

if __FILE__ == $PROGRAM_NAME
  key = open('MAS_API_KEY.txt').each_line.first.strip
  mja = MasJsonApi.new(key)
  p mja.full_text_query('data mining')
end
