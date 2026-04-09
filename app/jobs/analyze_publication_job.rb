class AnalyzePublicationJob < ApplicationJob
  queue_as :default
  sidekiq_options retry: false

  def perform(publication)
    AnalyzePublication.new.run(publication)
  end
end
