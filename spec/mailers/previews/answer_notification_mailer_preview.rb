# Preview all emails at http://localhost:3000/rails/mailers/answer_notification_mailer
class AnswerNotificationMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/answer_notification_mailer/notify
  def notify
    AnswerNotificationMailerMailer.notify
  end

end
