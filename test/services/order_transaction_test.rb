require 'test_helper'

class OrderTransactionTest < MiniTest::Test
	include FactoryGirl::Syntax::Methods

	def test_creates_a_transaction
		order = Order.new
		order. order_items << OrderItem.new(product: build(:product),quantity: 1)
		nonce = Braintree::Test::Nonce::Transactable
		trans = OrderTransaction.new order,nonce
		
		trans.execute
		assert transaction.ok?, "Excepted the transaction to be successful"
	end
end