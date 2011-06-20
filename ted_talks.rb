["rubygems", "mechanize", "FasterCSV", "sinatra", "cgi"].each { |gem| require gem }

feed = "https://spreadsheets.google.com/spreadsheet/pub?key=0AsKzpC8gYBmTcGpHbFlILThBSzhmZkRhNm8yYllsWGc&output=csv"

# Get the feed using Mechanize
agent = Mechanize.new
agent.user_agent_alias = "Mac Safari"
# page = agent.get(feed)

# text = page.body
text = File.read("feed.csv")

# Parse and print
csv = FasterCSV.parse(text)

body = ""

cgi = CGI.new("html4")

csv.each_with_index { |row, index|

  next if index == 0

  begin
    title = row[4]
    speaker = row[3]
    description = row[5]
    
    # Clean things up a little
    title = title[(speaker.length + 1)..-1] if title.include?(speaker)

    body += cgi.div("CLASS" => "talk") { 
      cgi.span("CLASS" => "title") { "#{title}" } + cgi.br +
      cgi.span("CLASS" => "speaker") { "#{speaker}" } +
      cgi.div("CLASS" => "description") { "#{description}" + cgi.br + cgi.br}
    }
    
  rescue

  end
}

output = cgi.html("PRETTY" => "  ") { 
  cgi.title { "Ted Talks" } +
  cgi.body { body } 
}

get '/' do
  output
end