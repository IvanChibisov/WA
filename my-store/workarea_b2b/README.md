Workarea B2B
================================================================================

Workarea Commerce platform plugin to allow retailers to operate a B2B storefront.

Overview
--------------------------------------------------------------------------------
* Organizations, Accounts, and Memberships for customers.
* Account configuration - payment terms, price lists, credit limits, and order restrictions
* Membership roles - Administrator, Approver, and Shopper
* Admin management of account credit limits and balances.
* Storefront organization account pages for customers to view and manage their accounts
* Account customer checkout with configurable address and payment options
* Configurable order approvals
* Custom price lists
* Reorder items from order history

Features
--------------------------------------------------------------------------------

* __Organizations & Accounts__

  Admin users can create and manage organizations for users. Organizations serve as an umbrella to a group of accounts and memberships to those accounts by customers.

  Account management allows an admin to create accounts and define the rules for the account, manage memberships, and control credit limits and balances. Account options include payment terms, price lists, credit limits, and order requirements.

  Accounts have their own set of addresses and credit cards. These can be added by account administrators from the storefront account management pages. Order options allow administrators to require their shoppers use account addresses and/or payments for orders when placing an order for that account and require approval before an order is processed.

* __Memberships__

  Memberships tie customers to accounts (and thusly organizations). Each user can have memberships to any number of accounts, with configurable roles for each membership. The default roles are `Administrator`, `Approver`, and `Shopper`, configurable via `Workarea.config.membership_roles`. Account administrators can manage memberships (including creating new customers for their account), manage membership roles, manage account addresses and credit cards, and customize the order requirements for the account. Account approvers can review and approve/decline orders associated to the account that require approval before being processed. Account shoppers can place orders for accounts and view the account page.

  When logged in, a customer is tied to a default account. If a customer has multiple memberships, they can switch accounts on the account management page to view details, orders, pricing, and checkout for any of their accounts.

  Retailers can operate a storefront strictly for organization customers (requiring an account membership to login) or can allow a mix through the `Workarea.config.enforce_membership` configuration. Default is `false`.

* __Account Orders__

  Customers with account memberships can place orders that are tied to their organization account. Accounts requiring the use of account addresses will only be able to use the addresses associated to the account for shipping and billing addresses. Account's requiring account payment will only be allowed to use the account's credit cards or complete orders using the account's line of credit (if the account's payment terms allow for use of credit). If account addresses or payments are not required by the order options, an account customer still has access to those options, but is not required to use them to place an order.

* __Price Lists__

  An admin can create and manage custom price lists. Price list pricing can be defined for each sku price along side normal tiered prices. A price list can then be assigned to an account to allow account members to view and purchase merchandise at price list prices.

* __Payment Terms__

  Payment terms allow admin to manage the forms of payment accepted for account orders. Payment term codes are configurable via `Workarea.config.payment_terms`. By default `001` allows accounts to use either a credit card or terms to purchase merchandise. `Terms` refers to use of credit up to the amount defined as a credit limit for that account. `002` allows only credit cards. `003` allows only the use of terms. An account with no payment terms can use any form of payment accepted for customers without an account (only prevents the use of terms).

* __Credit Limits__

  If an account is allowed to place orders based on terms, they are bound to an account's credit limit. Upon placing an order under terms, their account balance increases until reaching the credit limit. An account cannot use terms if their available credit does not cover the order's total price.

  An admin can adjust credit limits or reimburse some or all of the balance. A ledger of account transactions including purchases, refunds, and reimbursements are viewable by both admin users and account approvers or administrators.

* __Reordering__

  When viewing order history in either the user or organization account pages users can click "Reorder" to copy an order to their current cart to allow for quick reordering of frequently purchased items.

Getting Started
--------------------------------------------------------------------------------

This gem contains a rails engine that must be mounted onto a host Rails application.

To access Workarea gems and source code, you must be an employee of WebLinc or a licensed retailer or partner.

Workarea gems are hosted privately at https://gems.weblinc.com/.
You must have individual or team credentials to install gems from this server. Add your gems server credentials to Bundler:

    bundle config gems.weblinc.com my_username:my_password

Or set the appropriate environment variable in a shell startup file:

    export BUNDLE_GEMS__WEBLINC__COM='my_username:my_password'

Then add the gem to your application's Gemfile specifying the source:

    # ...
    gem 'workarea-b2b', source: 'https://gems.weblinc.com'
    # ...

Or use a source block:

    # ...
    source 'https://gems.weblinc.com' do
      gem 'workarea-b2b'
    end
    # ...

Update your application's bundle.

    cd path/to/application
    bundle

Workarea Platform Documentation
--------------------------------------------------------------------------------

See [http://developer.workarea.com](http://developer.workarea.com) for Workarea platform documentation.

Copyright & Licensing
--------------------------------------------------------------------------------

Copyright WebLinc 2018. All rights reserved.

For licensing, contact sales@workarea.com.
