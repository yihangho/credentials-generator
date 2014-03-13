require "SecureRandom"
require "set"

# Store the YAML output that can be copy/pasted to contest.yaml
yaml_output_file = File.new("output.yaml", "w")
# A plain text summary of all usernames/passwords so that I can easily send them over to their respective owner
summary_file = File.new("summary.txt", "w")

# The set of all usernames, used to ensure that all usernames are unique
usernames = Set.new

while true
  input = gets

  break unless input

  email = input.chomp.downcase
  # The default username is actually the front part (the part before @) of email address.
  # Also, remove any special characrers (like +, _, ., etc).
  username = email[/^(.*)@.*$/, 1].gsub(/(\W|_)/, '')
  # Password is a 6 character random string
  password = SecureRandom.base64[0, 6]

  # Ensure that all usernames are unique by appending 1, 2, ... to the end of the username until an unused username is found
  counter = ""
  until usernames.add?(username + counter.to_s)
    if counter == ""
      counter = 1
    else
      counter += 1
    end
  end

  username += counter.to_s

  yaml_output_file.puts "- username: #{username}"
  yaml_output_file.puts "  password: #{password}"
  yaml_output_file.puts "  ip: null"

  summary_file.puts email
  summary_file.puts username
  summary_file.puts password
  summary_file.puts
end

yaml_output_file.close
summary_file.close