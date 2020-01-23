Workarea.append_partials(
  'admin.people_menu',
  'workarea/admin/organizations/menu',
  'workarea/admin/organization_accounts/menu'
)

Workarea.append_partials(
  'admin.people_dashboard_navigation',
  'workarea/admin/organizations/dashboard_link',
  'workarea/admin/organization_accounts/dashboard_link'
)

Workarea.append_partials(
  'admin.user_cards',
  'workarea/admin/users/memberships_card'
)

Workarea.append_partials(
  'admin.catalog_menu',
  'workarea/admin/pricing_price_lists/menu'
)

Workarea.append_partials(
  'admin.catalog_dashboard_navigation',
  'workarea/admin/pricing_price_lists/dashboard_link'
)

Workarea.append_partials(
  'admin.price_table_columns',
  'workarea/admin/prices/price_list_table_header'
)

Workarea.append_partials(
  'admin.price_table_values',
  'workarea/admin/prices/price_list_table_row'
)

Workarea.append_partials(
  'admin.price_table_fields',
  'workarea/admin/prices/price_list_field'
)

Workarea.append_partials(
  'admin.order_aux_navigation',
  'workarea/admin/orders/account_aux_navigation'
)

Workarea.append_partials(
  'storefront.utility_nav',
  'workarea/storefront/accounts/link_placeholder'
)

Workarea.append_partials(
  'storefront.current_user',
  'workarea/storefront/users/current_membership'
)

Workarea.append_partials(
  'storefront.checkout_addresses_top',
  'workarea/storefront/checkouts/account_addresses'
)

Workarea.append_partials(
  'storefront.checkout_payment_top',
  'workarea/storefront/checkouts/account_payments'
)

Workarea.append_partials(
  'storefront.payment_method',
  'workarea/storefront/checkouts/terms'
)

Workarea.append_partials(
  'storefront.product_pricing',
  'workarea/storefront/products/price_list_pricing'
)

Workarea.append_partials(
  'storefront.order_summary_header',
  'workarea/storefront/orders/reorder'
)

Workarea.append_partials(
  'storefront.order_summary_actions',
  'workarea/storefront/users/orders/summary_reorder'
)

Workarea.append_javascripts(
  'storefront.modules',
  'workarea/storefront/b2b/modules/account_link_placeholders',
  'workarea/storefront/b2b/modules/account_addresses',
  'workarea/storefront/b2b/modules/account_payments'
)

Workarea.append_javascripts(
  'storefront.templates',
  'workarea/storefront/b2b/templates/account_link'
)
