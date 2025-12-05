class SlackController < ApplicationController
  def interactions
    payload = JSON.parse(params["payload"])
    action = payload.dig("actions")&.first&.dig("action_id")
    if action == "open dialog"
      ret_cd = Slack.new.send_to_open_standup_modal(payload["trigger_id"])
    elsif payload["type"] == "view_submission"
      ret_cd = Slack.new.process_data(user_info: payload["user"], standup_data: payload.dig("view","state","values"))
    end

    head ret_cd ? :ok : :unprocessable_entity
  end

end
