class SampleJob < ApplicationJob
  queue_as :default

  # sidekiqのログメッセージ
  def perform(*args)
    Sidekiq::Logging.logger.info "サンプルジョブを実行しました。"
  end
end
