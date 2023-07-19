require 'mysql2'

client = Mysql2::Client.new(
  host: 'localhost',
  username: 'root',
  password: '',
  database: 'sam_tests'
)

def get_data_from_table(client)
  select_query = <<~SQL
    SELECT * FROM people_sam;
  SQL
  data_from_table = client.query(select_query).to_a # returns array of hashes - [{"id"=>1,"first_name"=>"Ted", ...}, {"id"=>2,"first_name"=>"Harry", ...}, ...]
  data_from_table.each do |row|
    update_query = <<~SQL
      UPDATE people_sam 
      SET email = "#{row['firstname'].downcase}" -- edits column firstname by iterating through each row one at a time and running an update command with .downcase on each name 
      WHERE id = #{row['id']}; -- specifies that it is only updating the one row, not the whole table
    SQL
    client.query(update_query)
  end
end

# get_data_from_table(client)

def look_at_data(client)
  res = client.query("SELECT * FROM people_sam WHERE firstname like 'A%'").to_a
  puts res, res.class
end

look_at_data(client)

client.close
