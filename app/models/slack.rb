# frozen_string_literal: true

class Slack

  def send_to_create_bot_button
    rc = HTTParty.post(Rails.application.credentials.slack.webhook_url,
                  headers: { "Content-Type" => "application/json" },
                  body: bot_button_body
    )

  end

  def send_to_open_standup_modal(trigger_id)
    rc = HTTParty.post(Rails.application.credentials.slack.modal_open,
                       headers: {
                         "Content-Type" => "application/json",
                         "Authorization" => "Bearer #{Rails.application.credentials.slack.bot_token}"
                       },
                       body: modal_body(trigger_id)
    )
    rc == "ok"
  end

  def process_data(user_info:, standup_data:)
    User.transaction do
      user = User.find_or_create_by!(slack_user_id: user_info["id"]) do |us|
        us.name = user_info["username"]
        us.team_id = user_info["team_id"]
        us.slack_user_id = user_info["id"]
      end
      standup_info = StandupInformation.find_or_create_by!(standup_date: Date.current.strftime("%Y-%m-%d"), user_id: user.id) do |info|
        info.standup_date = Date.current.strftime("%Y-%m-%d")
        info.user_id = user.id
        info.yesterdays_work = standup_data.dig("yesterday_block", "yesterday", "value")
        info.todays_work = standup_data.dig("today_block", "today", "value")
        info.blockers =standup_data.dig("blockers_block", "blockers", "value")
      end
    end
    true
  rescue Mysql2::Error => e
    false
  end

  private

  def bot_button_body
    {
      text: "Daily Standup!",
      blocks:
        [
          { type: "section", text: { type: "mrkdwn", text: "Standup!" } },
          { type: "actions", elements:
            [
              {
                type: "button", text: { type: "plain_text", text: "Complete Standup Info!" },
                value: "open_modal", action_id: "open dialog",
              }
            ]
          }
        ]
    }.to_json
  end

  def modal_body(trigger_id)
    {
      trigger_id: trigger_id,
      view: {
        type: "modal",
        callback_id: "standup",
        title: {type: "plain_text", text: "Standup Information!"},
        submit: {type: "plain_text", text: "Submit"},
        blocks: [
          {
            type: "input",
            block_id: "yesterday_block",
            optional: false,
            label: {
              type: "plain_text",
              text: "What did you do yesterday?"
            },
            element: {
              type: "plain_text_input",
              multiline: true,
              action_id: "yesterday"
            }
          },
          {
            type: "input",
            optional: false,
            block_id: "today_block",
            label: {
              type: "plain_text",
              text: "What will you do today?"
            },
            element: {
              type: "plain_text_input",
              multiline: true,
              action_id: "today"
            }
          },
          {
            type: "input",
            optional: true,
            block_id: "blockers_block",
            label: {
              type: "plain_text",
              text: "Any Blockers?"
            },
            element: {
              type: "plain_text_input",
              multiline: true,
              action_id: "blockers"
            }
          }
        ]
      }
    }.to_json
  end
end
