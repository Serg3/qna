class AnswerNotificationMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.answer_notification_mailer.notify.subject
  #
  def notify(user, answer)
    @answer = answer

    mail to: user.email
  end
end
