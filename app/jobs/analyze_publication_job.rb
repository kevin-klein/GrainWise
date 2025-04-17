class AnalyzePublicationJob < ApplicationJob
  queue_as :default

  def perform(publication)
    AnalyzePublication.new.run(publication)
  end
end
