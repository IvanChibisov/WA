module Workarea
  if Plugin.installed?('Workarea::Api::Admin')
    module Api
      module Admin
        class MembershipsController < Admin::ApplicationController
          before_action :find_scope, except: :bulk
          before_action :find_membership, except: [:index, :create, :bulk]

          swagger_path 'users/{id}/memberships' do
            operation :get do
              key :summary, 'All User Memberships'
              key :description, 'Returns all memberships for a user'
              key :operationId, 'listUserMemberships'
              key :produces, ['application/json']

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'User ID'
                key :required, true
                key :type, :string
              end
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
                key :description, 'User Memberships'
                schema do
                  key :type, :object
                  property :memberships do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Organization::Membership'
                    end
                  end
                end
              end
            end

            operation :post do
              key :summary, 'Create User Membership'
              key :description, 'Creates a new membership for a user'
              key :operationId, 'addUserMembership'
              key :produces, ['application/json']

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'User ID'
                key :required, true
                key :type, :string
              end
              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Membership to add'
                key :required, true
                schema do
                  key :type, :object
                  property :membership do
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end

              response 201 do
                key :description, 'Membership created'
                schema do
                  key :type, :object
                  property :membership do
                    key :'$ref', 'Workarea::Organization::Membership'
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
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end
            end
          end

          swagger_path 'account/{id}/memberships' do
            operation :get do
              key :summary, 'All Account Memberships'
              key :description, 'Returns all memberships for an account'
              key :operationId, 'listAccountMemberships'
              key :produces, ['application/json']

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'Account ID'
                key :required, true
                key :type, :string
              end
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
                key :description, 'Account Memberships'
                schema do
                  key :type, :object
                  property :memberships do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Organization::Membership'
                    end
                  end
                end
              end
            end

            operation :post do
              key :summary, 'Create Account Membership'
              key :description, 'Creates a new membership for an account'
              key :operationId, 'addAccountMembership'
              key :produces, ['application/json']

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'Account ID'
                key :required, true
                key :type, :string
              end
              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Membership to add'
                key :required, true
                schema do
                  key :type, :object
                  property :membership do
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end

              response 201 do
                key :description, 'Membership created'
                schema do
                  key :type, :object
                  property :membership do
                    key :'$ref', 'Workarea::Organization::Membership'
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
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end
            end
          end


          def index
            @memberships = @scope
                            .order_by(sort_field => sort_direction)
                            .page(params[:page])

            respond_with memberships: @memberships
          end

          def create
            @membership = @scope.create!(params[:membership])
            respond_with(
              { membership: @membership },
              {
                status: :created,
                location: membership_path(@membership.id)
              }
            )
          end

          swagger_path 'users/{user_id}/memberships/{id}' do
            operation :get do
              key :summary, 'Find User Membership by ID'
              key :description, 'Returns a single membership for a user'
              key :operationId, 'showUserMembership'

              parameter do
                key :name, :user_id
                key :in, :path
                key :description, 'User ID'
                key :required, true
                key :type, :string
              end
              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of membership to fetch'
                key :required, true
                key :type, :string
              end

              response 200 do
                key :description, 'Membership details'
                schema do
                  key :type, :object
                  property :membership do
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end

              response 404 do
                key :description, 'Membership not found'
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
              key :summary, 'Update a User Membership'
              key :description, 'Updates attributes on a membership for a user'
              key :operationId, 'updateUserMembership'

              parameter do
                key :name, :user_id
                key :in, :path
                key :description, 'User ID'
                key :required, true
                key :type, :string
              end
              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of membership to update'
                key :required, true
                key :type, :string
              end

              parameter do
                key :name, :body
                key :in, :body
                key :required, true
                schema do
                  key :type, :object
                  property :membership do
                    key :description, 'New attributes'
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end

              response 204 do
                key :description, 'Membership updated successfully'
              end

              response 422 do
                key :description, 'Validation failure'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :document do
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end

              response 404 do
                key :description, 'Membership not found'
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
              key :summary, 'Remove a User Membership'
              key :description, 'Remove a membership for a user'
              key :operationId, 'removeUserMembership'

              parameter do
                key :name, :user_id
                key :in, :path
                key :description, 'User ID'
                key :required, true
                key :type, :string
              end
              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of membership to remove'
                key :required, true
                key :type, :string
              end

              response 204 do
                key :description, 'Membership removed successfully'
              end

              response 404 do
                key :description, 'Membership not found'
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

          swagger_path 'account/{account_id}/memberships/{id}' do
            operation :get do
              key :summary, 'Find Account Membership by ID'
              key :description, 'Returns a single membership for an account'
              key :operationId, 'showAccountMembership'

              parameter do
                key :name, :account_id
                key :in, :path
                key :description, 'Account ID'
                key :required, true
                key :type, :string
              end
              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of membership to fetch'
                key :required, true
                key :type, :string
              end

              response 200 do
                key :description, 'Membership details'
                schema do
                  key :type, :object
                  property :membership do
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end

              response 404 do
                key :description, 'Membership not found'
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
              key :summary, 'Update a Account Membership'
              key :description, 'Updates attributes on a membership for an account'
              key :operationId, 'updateAccountMembership'

              parameter do
                key :name, :account_id
                key :in, :path
                key :description, 'Account ID'
                key :required, true
                key :type, :string
              end
              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of membership to update'
                key :required, true
                key :type, :string
              end

              parameter do
                key :name, :body
                key :in, :body
                key :required, true
                schema do
                  key :type, :object
                  property :membership do
                    key :description, 'New attributes'
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end

              response 204 do
                key :description, 'Membership updated successfully'
              end

              response 422 do
                key :description, 'Validation failure'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :document do
                    key :'$ref', 'Workarea::Organization::Membership'
                  end
                end
              end

              response 404 do
                key :description, 'Membership not found'
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
              key :summary, 'Remove a Account Membership'
              key :description, 'Remove a membership for an account'
              key :operationId, 'removeAccountMembership'

              parameter do
                key :name, :account_id
                key :in, :path
                key :description, 'Account ID'
                key :required, true
                key :type, :string
              end
              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of membership to remove'
                key :required, true
                key :type, :string
              end

              response 204 do
                key :description, 'Membership removed successfully'
              end

              response 404 do
                key :description, 'Membership not found'
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
            respond_with membership: @membership
          end

          def update
            @membership.update_attributes!(params[:membership])
            respond_with membership: @membership
          end

          swagger_path '/memberships/bulk' do
            operation :patch do
              key :summary, 'Bulk Upsert Memberships'
              key :description, 'Creates new memberships or updates existing ones in bulk.'
              key :operationId, 'upsertMemberships'
              key :produces, ['application/json']

              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Array of memberships to upsert'
                key :required, true
                schema do
                  key :type, :object
                  property :memberships do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Organization::Membership'
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
              klass: Organization::Membership,
              data: params[:memberships].map(&:to_h)
            )

            head :no_content
          end

          def destroy
            @membership.destroy
            head :no_content
          end

          private

          def find_scope
            @scope =
              if params[:user_id].present?
                User.find(params[:user_id]).memberships
              elsif params[:account_id].present?
                Organization::Account.find(params[:account_id]).memberships
              else
                Organization::Membership.all
              end
          end

          def find_membership
            @membership = @scope.find(params[:id])
          end
        end
      end
    end
  end
end
