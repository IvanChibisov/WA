module Workarea
  if Plugin.installed?('Workarea::Api::Admin')
    module Api
      module Admin
        class AccountsController < Admin::ApplicationController
          before_action :find_account, except: [:index, :create, :bulk]

          swagger_path '/accounts' do
            operation :get do
              key :summary, 'All Organization Accounts'
              key :description, 'Returns all accounts from the system'
              key :operationId, 'listAccounts'
              key :produces, ['application/json']

              parameter do
                key :name, :page
                key :in, :query
                key :description, 'Current page'
                key :required, false
                key :type, :integer
                key :default, 1
              end
              parameter do
                key :name, :sort_by
                key :in, :query
                key :description, 'Field on which to sort (see responses for possible values)'
                key :required, false
                key :type, :string
                key :default, 'created_at'
              end
              parameter do
                key :name, :sort_direction
                key :in, :query
                key :description, 'Direction for sort by'
                key :type, :string
                key :enum, %w(asc desc)
                key :default, 'desc'
              end

              response 200 do
                key :description, 'Organization Accounts'
                schema do
                  key :type, :object
                  property :accounts do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Organization::Account'
                    end
                  end
                end
              end
            end

            operation :post do
              key :summary, 'Create Organization Account'
              key :description, 'Creates a new account'
              key :operationId, 'addAccount'
              key :produces, ['application/json']

              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Account to add'
                key :required, true
                schema do
                  key :type, :object
                  property :account do
                    key :'$ref', 'Workarea::Organization::Account'
                  end
                end
              end

              response 201 do
                key :description, 'Account created'
                schema do
                  key :type, :object
                  property :account do
                    key :'$ref', 'Workarea::Organization::Account'
                  end
                end
              end

              response 422 do
                key :description, 'Validation failure'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :document do
                    key :'$ref', 'Workarea::Organization::Account'
                  end
                end
              end
            end
          end

          def index
            @accounts = Organization::Account
                        .all
                        .order_by(sort_field => sort_direction)
                        .page(params[:page])

            respond_with accounts: @accounts
          end

          def create
            @account = Organization::Account.create!(params[:account])
            respond_with(
              { account: @account },
              {
                status: :created,
                location: account_path(@account.id)
              }
            )
          end

          swagger_path '/accounts/{id}' do
            operation :get do
              key :summary, 'Find Organization Account by ID'
              key :description, 'Returns a single account'
              key :operationId, 'showAccount'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of account to fetch'
                key :required, true
                key :type, :string
              end

              response 200 do
                key :description, 'Account details'
                schema do
                  key :type, :object
                  property :account do
                    key :'$ref', 'Workarea::Organization::Account'
                  end
                end
              end

              response 404 do
                key :description, 'Account not found'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :params do
                    key :type, :object
                    key :additionalProperties, true
                  end
                end
              end
            end

            operation :patch do
              key :summary, 'Update an Organization Account'
              key :description, 'Updates attributes on a account'
              key :operationId, 'updateAccount'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of account to update'
                key :required, true
                key :type, :string
              end

              parameter do
                key :name, :body
                key :in, :body
                key :required, true
                schema do
                  key :type, :object
                  property :account do
                    key :description, 'New attributes'
                    key :'$ref', 'Workarea::Organization::Account'
                  end
                end
              end

              response 204 do
                key :description, 'Account updated successfully'
              end

              response 422 do
                key :description, 'Validation failure'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :document do
                    key :'$ref', 'Workarea::Organization::Account'
                  end
                end
              end

              response 404 do
                key :description, 'Account not found'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :params do
                    key :type, :object
                    key :additionalProperties, true
                  end
                end
              end
            end

            operation :delete do
              key :summary, 'Remove an Organization Account'
              key :description, 'Remove a account'
              key :operationId, 'removeAccount'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of account to remove'
                key :required, true
                key :type, :string
              end

              response 204 do
                key :description, 'Account removed successfully'
              end

              response 404 do
                key :description, 'Account not found'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :params do
                    key :type, :object
                    key :additionalProperties, true
                  end
                end
              end
            end
          end

          def show
            respond_with account: @account
          end

          def update
            @account.update_attributes!(params[:account])
            respond_with account: @account
          end

          swagger_path '/accounts/bulk' do
            operation :patch do
              key :summary, 'Bulk Upsert Accounts'
              key :description, 'Creates new accounts or updates existing ones in bulk.'
              key :operationId, 'upsertAccounts'
              key :produces, ['application/json']

              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Array of accounts to upsert'
                key :required, true
                schema do
                  key :type, :object
                  property :accounts do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Organization::Account'
                    end
                  end
                end
              end

              response 204 do
                key :description, 'Upsert received'
              end
            end
          end

          def bulk
            @bulk = Api::Admin::BulkUpsert.create!(
              klass: Organization::Account,
              data: params[:accounts].map(&:to_h)
            )

            head :no_content
          end

          def destroy
            @account.destroy
            head :no_content
          end

          private

          def find_account
            @account = Organization::Account.find(params[:id])
          end
        end
      end
    end
  end
end
