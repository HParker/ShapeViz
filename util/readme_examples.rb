f = File.read("README.md")

capturing = false
snippet = +"require 'ShapeViz'\n\n"
snippet_num = 1


f.lines.each do |line|
  if line == "```ruby\n"
    capturing = true
    next
  end

  if capturing
    if line == "```\n"
      File.write("snippets/#{snippet_num}.rb", snippet)
      snippet = +"require 'ShapeViz'\n\n"
      snippet_num += 1
      capturing = false
      next
    end
    snippet << line
  end
end
