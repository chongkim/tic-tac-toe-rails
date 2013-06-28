class Email < ActionMailer::Base
  default from: "chongkim@yahoo.com"
  def request_game to_email, from_email, url
    @url = url
    @to_email = to_email
    @from_email = from_email
    mail(to: @to_email, subject: "You have a Tic Tac Toe game request from #{@from_email}")
  end
end
