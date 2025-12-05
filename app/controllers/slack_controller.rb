class SlackController < ApplicationController
  def interactions
    slack = Slack.new
    payload = JSON.parse(params["payload"])
    action = payload.dig("actions")&.first&.dig("action_id")
    if action && action == "open dialog"
      trigger_id = payload["trigger_id"]
      Rails.logger.info("ABOUT TO CALL SEND TO OPEN")
      slack.send_to_open_standup_modal(trigger_id)
    elsif payload["type"] == "view_submission"
      slack.process_data(user_info: payload["user"], standup_data: payload["state"])
    end

    head :ok
  end

end
