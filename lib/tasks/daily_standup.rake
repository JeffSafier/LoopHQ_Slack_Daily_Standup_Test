task daily_standup: :environment do
    Slack.new.send_to_create_bot_button
end
