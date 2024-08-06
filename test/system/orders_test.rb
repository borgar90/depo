require "application_system_test_case"

class OrdersTest < ApplicationSystemTestCase
  test "check dynamic fields" do
    visit store_index_url
    click_on 'Add to Cart', match: :first
    click_on 'Checkout'

    assert has_no_field?('Routing number')
    assert has_no_field?('Account number')
    assert has_no_field?('Credit card number')
    assert has_no_field?('Expiration date')
    assert has_no_field?('PO number')
    assert has_no_field?('Cash amount')
    assert has_no_field?('Coupon code')

    select 'Check', from: 'Pay type'

    assert has_field?('Routing number')
    assert has_field?('Account number')
    assert has_no_field?('Credit card number')
    assert has_no_field?('Expiration date')
    assert has_no_field?('PO number')
    assert has_no_field?('Cash amount')
    assert has_no_field?('Coupon code')

    select 'Credit card', from: 'Pay type'

    assert has_no_field?('Routing number')
    assert has_no_field?('Account number')
    assert has_field?('Credit card number')
    assert has_field?('Expiration date')
    assert has_no_field?('PO number')
    assert has_no_field?('Cash amount')
    assert has_no_field?('Coupon code')

    select 'Purchase order', from: 'Pay type'

    assert has_no_field?('Routing number')
    assert has_no_field?('Account number')
    assert has_no_field?('Credit card number')
    assert has_no_field?('Expiration date')
    assert has_field?('PO number')
    assert has_no_field?('Cash amount')
    assert has_no_field?('Coupon code')

    select 'Cash', from: 'Pay type'

    assert has_no_field?('Routing number')
    assert has_no_field?('Account number')
    assert has_no_field?('Credit card number')
    assert has_no_field?('Expiration date')
    assert has_no_field?('PO number')
    assert has_field?('Cash amount')
    assert has_no_field?('Coupon code')

    select 'Coupon', from: 'Pay type'

    assert has_no_field?('Routing number')
    assert has_no_field?('Account number')
    assert has_no_field?('Credit card number')
    assert has_no_field?('Expiration date')
    assert has_no_field?('PO number')
    assert has_no_field?('Cash amount')
    assert has_field?('Coupon code')

  end

end
