Workarea.configure do |config|
  config.copy_order_ignored_fields += [
    :account_id,
    :reviewed_at,
    :reviewed_by_id,
    :review_notes
  ]

  # Whether or not to allow users that are not members of an account to
  # login and browse the site.
  config.enforce_membership = false

  # Options for roles a membership can apply to a user.
  config.membership_roles = %w(administrator approver shopper)

  # Options for terms an account can have, determines which tenders are allowed
  # as primary payment for orders under that account.
  config.payment_terms = {
    'Credit card or terms' => %i(credit_card terms),
    'Credit card only' => %i(credit_card),
    'Terms only' => %i(terms)
  }

  # The number of transactions to show on the storefront when an account
  # an approver or higher views transaction history.
  config.account_transaction_count = 50

  config.order_status_calculators.insert_after(
    'Workarea::Order::Status::Canceled',
    'Workarea::Order::Status::PendingReview'
  )

  config.tender_types << :terms

  config.pricing_calculators.swap(
    "Workarea::Pricing::Calculators::ItemCalculator",
    "Workarea::Pricing::Calculators::PriceListItemCalculator"
  )
end
