Workarea B2b 1.0.3 (2019-07-23)
--------------------------------------------------------------------------------

*   Prevent orders from being reviewed that are not tied to current account

    Matt Duffy

*   Update setup for Storefront::Accounts::OrderIntegrationTest

    The test setup was not setting Current.membership, resulting in
    orders created within the tests via factories not associated with
    the account being tested. This change ensures the account is
    configured as expected and any orders created will be tied to the
    account created during setup.

    B2B-41
    Matt Duffy



Workarea B2b 1.0.2 (2019-05-28)
--------------------------------------------------------------------------------

*   Fix namespacing of order and credit card integration tests

    B2B-40
    Matt Duffy



Workarea B2b 1.0.1 (2019-03-19)
--------------------------------------------------------------------------------

*   Add Admin API endpoints for b2b resources

    B2B-21
    Matt Duffy

*   Only show review form and reviewed by if reviewed by a user

    B2B-39
    Matt Duffy



Workarea B2b 1.0.0 (2019-03-13)
--------------------------------------------------------------------------------

*   Add display and searchability of purchase order number to admin

    B2B-38
    Matt Duffy

*   Set order account id in before action instead on checkout#start_as

    B2B-24
    Matt Duffy

*   Add purchase order number field to terms tender

    B2B-29
    Matt Duffy

*   Do not show review details if not reviewed by a user

    B2B-35
    Matt Duffy

*   Clear b2b session values on logout

    B2B-37
    Matt Duffy

*   Add available credit to terms payment option on payment step

    B2B-34
    Matt Duffy

*   Auto-select first valid payment tender on payment step

    B2B-33
    Matt Duffy

*   Add field to create new organiztion when creating an account

    B2B-25
    Matt Duffy

*   Automatically approve orders made by account approvers or admins

    B2B-28
    Matt Duffy

*   Allow adding/editing memberships from both accounts and users

    B2B-22
    Matt Duffy

*   Update accounts index to count orders rather than loading orders to count

    Matt Duffy

*   Move queries to correct path

    Matt Duffy

*   Add dashboard links

    Matt Duffy

*   On terms authorization, set transaction to purchase for proper refunding

    B2B-10
    Matt Duffy

*   Add b2b order fields to copy_order_ignored_fields

    B2B-24
    Matt Duffy

*   Do not allow requiring account addresses and payments if there are none

    B2B-20
    Matt Duffy

*   Make organizations and accounts releasable

    B2B-16
    Matt Duffy

*   Show price list name on prices table

    B2B-13
    Matt Duffy

*   Prevent price lists with blank ids

    B2B-15
    Matt Duffy

*   Expand price list pages in admin

    * Add show pages for price lists with pricing and account pages
    * Add price list facets for account and pricing sku indexes

    B2B-11
    Matt Duffy

*   Rework terms payment operations, add refund logic

    B2B-10
    Matt Duffy

*   Add reorder button to order summary and detail pages

    B2B-9
    Matt Duffy

*   Minor tweaks to support integration with quotes

    Matt Duffy

*   Add usefule README

    Matt Duffy

*   Manage and track account credit balance

    B2B-5
    Matt Duffy

*   Adjust storefront pricing based on account price lists

    B2B-3
    Matt Duffy

*   fix typo

    Matt Duffy

*   Add checkout behavior for organization account users

    B2B-4
    Matt Duffy

*   Add storefront account management

    B2B-2
    Matt Duffy

*   Move Account and Membership to Organization namespace

    B2B-1
    Matt Duffy

*   Setup basic organization account functionality

    * Allow admins to create/manage organizations, accounts, and memberships
    * Add price list management to admin and allow prices to have a price list id
    * Add config to allow preventing users from logging in without a membership
    * Allow storefront users to switch between their account memberships

    B2B-1
    Matt Duffy



