# frozen_string_literal: true

require 'rbconfig'
require 'yaml'
require 'json'
require 'openai'

module Llm
  class Error < StandardError; end
  class CLI

    def os_info
      host_os = RbConfig::CONFIG['host_os']
      
      case host_os
      when /linux/
        os_name = "Linux"
      when /darwin/
        os_name = "Mac"
      when /mswin|msys|mingw|cygwin|bccwin|wince|emc/
        os_name = "Windows"
      else
        os_name = "Unknown"
      end

      version = RbConfig::CONFIG['host_os']

      { os_name: os_name, version: version }
    end

    def run(argv=nil)
      os = os_info
      prompt = "You are a systems engineer working on #{os[:os_name]} (version #{os[:version]}). Your job is to write a shell commands. Please return your best guess as a single command that can be directly executed. If you must, you may include a short note, but please use comments so the results are directly executable. Please write a command that will:\n"

      config = { 
        "model" => "gpt-4o",
        "temperature" => 0.7, 
        "prompt" => prompt,
        "openai_api_key" => ENV["OPENAI_API_KEY"],
        "openai_organization_id" => ENV["OPENAI_ORGANIZATION_ID"]
      }
      config_filename = find_file(".llm-cli-config.yml")
      config_file = YAML.load_file(".llm-cli-config.yml") if config_filename
      config.merge!(config_file) if config_file

      if config["openai_api_key"].nil?
        puts "Please set OPENAI_API_KEY environment variable"
        exit 1
      end

      prompt = config["prompt"] + (argv || []).join(" ")

      client = OpenAI::Client.new(access_token: config["openai_api_key"], organization_id: config["openai_organization_id"])
      response = client.chat(
        parameters: {
          model: config["model"],
          temperature: config["temperature"],
          messages: [{ role: "user", content: prompt }]
        }
      )
      puts response.dig("choices", 0, "message", "content")
    end

    # Find the closest .llm-cli-config.yml file in the current directory, any parent directory or the users home directory
    def find_file(filename)
      paths = []
      path_pieces = Dir.pwd.split(File::SEPARATOR)
      while path_pieces.any?
        path = path_pieces.join(File::SEPARATOR)
        path_pieces.pop
        paths << [path, filename].join(File::SEPARATOR)
      end
      paths << [ENV["HOME"], filename].join(File::SEPARATOR) if ENV["HOME"]
      result = paths.detect { |path| File.exist?(path) }
      result
    end
  end
end