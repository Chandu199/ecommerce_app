class OrderMailer < ActionMailer::Base
	default from: "Example@order.com"
	def order_confirmation order
		@order = order
		mail to:order.user.email, subject: "Your Order (##{order.id})"
	end
end