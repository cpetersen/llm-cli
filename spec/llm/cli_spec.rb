# frozen_string_literal: true

RSpec.describe Llm::Cli do
  it "has a version number" do
    expect(Llm::Cli::VERSION).not_to be nil
  end
end
