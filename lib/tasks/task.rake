 task :move_tasks_from_future_list_to_index_list => :environment do

  client = WunderlistClient.new

  list_inbox = client.get_list('inbox')
  list_future = client.get_list('Future')

  list_future.tasks.
    select { |t| t.reminder.date.present? && DateTime.parse(t.reminder.date) < DateTime.now }.
    each { |t| t.list_id = list_inbox.id; t.save }

end
