require 'pry'
require 'mechanize'
require 'mail'

@agent = Mechanize.new
page = @agent.get 'https://www.getup.org.au'
members = page.search('#member-count').text

options = { :address              => "smtp.gmail.com",
            :port                 => 587,
            :domain               => 'smtp.gmail.com',
            :user_name            => ENV['MORPH_EMAIL_USER'],
            :password             => ENV['MORPH_EMAIL_PASS'],
            :authentication       => 'plain',
            :enable_starttls_auto => true  }



Mail.defaults do
  delivery_method :smtp, options
end

if members.gsub(',','').to_i < 1000000
  email_subject = "We're still at #{members} members"
  email_body = "nothing to see here."
else
  email_subject = "#{members} MEMBERS!!!"
  email_body = '<html><body><img src="http://i.huffpost.com/gen/1688700/images/n-HAPPY-DOG-DAY-OF-HAPPINESS-large570.jpg">
    <div style="font-size: 3em; color:#FF1919; font-family: comic-sans,sans-serif">There are 1,000,001 members!! <a href="https://www.getup.org.au.au">See for yourself.</a></div></body></html>'
end

Mail.deliver do
       to ENV['MORPH_EMAIL_RECIPIENT']
     from "ENV['MORPH_EMAIL_USER']@gmail.com"
  subject email_subject
  html_part do
    content_type 'text/html; charset=UTF-8'
    body email_body
  end
end
