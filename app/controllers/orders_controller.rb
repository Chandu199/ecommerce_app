class OrdersController < ApplicationController
	before_action :initialize_cart

	def index
		@orders = Order.order(created_at: :desc).all
	end

	def create
		@order_form = OrderForm.new(
			user: User.new(order_params[:user]), 
			cart: @cart
		)
		if @order_form.save
			notify_user
			if charge_user
			redirect_to root_path,notice: "Thank you for placing the order"
			else
				flash[:warning] = "Sorry the Transaction failed Please try again, Also check you inbox for order and password details"
				redirect_to new_payment_order_path(@order_form.order)
			end
		else
			render "carts/checkout"
		end
	end

	def update
		@order = Order.find(params[:id])
		@prev_state = @order.state
		if @order.update(state_order_params)
			notify_user_about_state
			flash[:notice] = "Order Updated"
			redirect_to orders_path
		end

	end

	def new_payment
		@order = Order.find(params[:id])
		@client_token = Braintree::ClientToken.generate
	end

	def pay
		@order = Order.find(params[:id])
		transaction = OrderTransaction.new @order,params[:payment_method_nonce]
		transaction.execute
		if transaction.ok?
			redirect_to root_path, notice: "Thank you for the order"
		else
			 render "orders/new_payment"
		end
	end

	def notify_user_about_state
		OrderMailer.state_changed(@order,@prev_state).deliver
	end


	private
	def order_params
		params.require(:order_form).permit(
			user: [:name,:phone,:address,:city,:country,:postal_code,:email]
		)
	end

	def notify_user
		@order_form.user.send_reset_password_instructions
		OrderMailer.order_confirmation(@order_form.order).deliver
	end

	def charge_user
		transaction = OrderTransaction.new @order,params[:payment_method_nonce]
		transaction.execute
		transaction.ok?
	end

	def state_order_params
		params.require(:order).permit(:state)
	end
end