require "yaml"
require "net/http"
require "json"

module BunnyEraAgentBot
  class AgentCoreClient
    CONFIG_PATH = File.expand_path("../../../config/bunnyera-model-pool.yaml", __FILE__)

    def self.query(text)
      config = YAML.load_file(CONFIG_PATH)
      model_id = config["routing"]["chat_default"].first
      model = config["models"].find { |m| m["id"] == model_id }

      uri = URI(model["endpoint"] || "http://localhost:8000/v1/chat/completions")
      headers = { "Content-Type" => "application/json" }

      if model["key_env"]
        key = ENV[model["key_env"]]
        headers["Authorization"] = "Bearer #{key}" if key
      end

      body = {
        model: model_id,
        messages: [
          { role: "system", content: "You are momo, BunnyEra AI assistant." },
          { role: "user", content: text }
        ]
      }.to_json

      res = Net::HTTP.post(uri, body, headers)
      json = JSON.parse(res.body)
      json["choices"][0]["message"]["content"]
    rescue => e
      "（momo 出错了…）#{e.message}"
    end
  end
end
