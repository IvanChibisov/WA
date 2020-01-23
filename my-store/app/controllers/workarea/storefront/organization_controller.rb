class Workarea::Storefront::OrganizationController < Workarea::Storefront::ApplicationController
  helper Workarea::Storefront::OrganizationsHelper
  def index

  end

  def create
    new_organization = Workarea::Organization.new
    new_organization.name = params[:organization][:name]
    new_organization.save!
    new_account = Workarea::Organization::Account.new
    new_account.organization_id = new_organization.id
    new_account.name = params[:account][:name]
    new_account.payment_terms = params[:account][:payment_terms]
    new_account.tax_code = params[:account][:tax_code]
    new_account.credit_limit = params[:account][:credit_limit]
    new_account.save!
  end

  def join_org

  end

  def join
    current_user = Workarea::User.all.find_by(email: params[:joined][:email])
    account = Workarea::Organization::Account.all.find_by(name: params[:account][:name])
    join_request = Workarea::Organization::JoinRequest.new(
      email: params[:joined][:email],
      user_id: current_user.id,
      account_id: account.id )
    join_request.save!
  end

  def join_account
    @account_params  = []
    org_name = params[:organization][:name]
    @organization_name = org_name
    Workarea::Organization::Account.all.each do |account|
       @account_params  << account.name if account.organization.name == org_name
     end
  end
end
