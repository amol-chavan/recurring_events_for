require 'postgres'

begin
  $db_conn = PGconn.open(
    'localhost',
    5432,
    '',
    '',
    'recurring_events_test',
    'dan',
    ''
  )
  
  $db_conn.exec File.open(File.dirname(__FILE__) + '/../events.sql').read
  $db_conn.exec File.open(File.dirname(__FILE__) + '/../interval_for.sql').read
  $db_conn.exec File.open(File.dirname(__FILE__) + '/../intervals_between.sql').read
  $db_conn.exec File.open(File.dirname(__FILE__) + '/../generate_recurrences.sql').read
  $db_conn.exec File.open(File.dirname(__FILE__) + '/../recurring_events_for.sql').read
rescue PGError
  puts "Failed to connect to and initialize database"
  raise
end

def executing(statement)
  $db_conn.exec "BEGIN"
  results = []
  $db_conn.exec(statement).each do |result|
    results.push(result)
  end.clear
  $db_conn.exec "ROLLBACK"
  results
end
