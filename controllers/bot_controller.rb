module BunnyEraAgentBot
  class BotController
    def self.process_post(post)
      return if post.user.admin? || post.user.moderator?
      return unless SiteSetting.bunnyera_agentbot_enabled

      content = post.raw
      reply = AgentCoreClient.query(content)

      PostCreator.create!(
        Discourse.system_user,
        topic_id: post.topic_id,
        raw: "**momo（BunnyEra AI）**：\n\n#{reply}"
      )
    end
  end
end
