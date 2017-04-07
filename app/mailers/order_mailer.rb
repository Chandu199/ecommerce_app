class OrderMailer < ActionMailer::Base
	default from: "Example@order.com"
	def order_confirmation order
		@order = order
		mail to:order.user.email, subject: "Your Order (##{order.id})"
	end
	def state_changed order,previous_state
		@order = order
		@prev_state = previous_state
		mail to: order.user.email, subject: "#{@order.id}-Your Order has changed"

	end
end