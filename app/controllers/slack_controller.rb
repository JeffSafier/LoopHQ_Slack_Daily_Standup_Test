class SlackController < ApplicationController
  def interactions
    slack = Slack.new
    payload = JSON.parse(params["payload"])
    action = payload["actions"].first["action_id"]
    trigger_id = payload["trigger_id"]
    slack.send_to_open_standup_modal(trigger_id) if action == "open dialog"
    head :ok
  end

end
