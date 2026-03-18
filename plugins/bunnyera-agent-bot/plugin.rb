# name: bunnyera-agent-bot
# about: BunnyEra AI Bot (momo) powered by AgentCore + Model Pool
# version: 1.0
# authors: BunnyEra Org
# url: https://github.com/bunnyera-org/bunnyera-community

enabled_site_setting :bunnyera_agentbot_enabled

after_initialize do
  module ::BunnyEraAgentBot
    PLUGIN_NAME = "bunnyera-agent-bot"
  end

  require_relative "services/agentcore_client"
  require_relative "controllers/bot_controller"

  DiscourseEvent.on(:post_created) do |post|
    BunnyEraAgentBot::BotController.process_post(post)
  end
end
