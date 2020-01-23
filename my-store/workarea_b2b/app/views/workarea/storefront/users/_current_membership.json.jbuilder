if current_membership.present?
  json.membership current_membership.account_name
  json.membership_role current_membership.role
  json.require_account_address current_account.require_account_address?
  json.require_account_payment current_account.require_account_payment?
end
