module Workarea
  if Plugin.installed?('Workarea::Api::Admin')
    module Api
      module Admin
        class OrganizationsController < Admin::ApplicationController
          before_action :find_organization, except: [:index, :create, :bulk]

          swagger_path '/organizations' do
            operation :get do
              key :summary, 'All Organizations'
              key :description, 'Returns all organizations from the system'
              key :operationId, 'listOrganizations'
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
                key :description, 'Organizations'
                schema do
                  key :type, :object
                  property :organizations do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Organization'
                    end
                  end
                end
              end
            end

            operation :post do
              key :summary, 'Create Organization'
              key :description, 'Creates a new organization'
              key :operationId, 'addOrganization'
              key :produces, ['application/json']

              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Organization to add'
                key :required, true
                schema do
                  key :type, :object
                  property :organization do
                    key :'$ref', 'Workarea::Organization'
                  end
                end
              end

              response 201 do
                key :description, 'Organization created'
                schema do
                  key :type, :object
                  property :organization do
                    key :'$ref', 'Workarea::Organization'
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
                    key :'$ref', 'Workarea::Organization'
                  end
                end
              end
            end
          end

          def index
            @organizations = Organization
                        .all
                        .order_by(sort_field => sort_direction)
                        .page(params[:page])

            respond_with organizations: @organizations
          end

          def create
            @organization = Organization.create!(params[:organization])
            respond_with(
              { organization: @organization },
              {
                status: :created,
                location: organization_path(@organization.id)
              }
            )
          end

          swagger_path '/organizations/{id}' do
            operation :get do
              key :summary, 'Find Organization by ID'
              key :description, 'Returns a single organization'
              key :operationId, 'showOrganization'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of organization to fetch'
                key :required, true
                key :type, :string
              end

              response 200 do
                key :description, 'Organization details'
                schema do
                  key :type, :object
                  property :organization do
                    key :'$ref', 'Workarea::Organization'
                  end
                end
              end

              response 404 do
                key :description, 'Organization not found'
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
              key :summary, 'Update a Organization'
              key :description, 'Updates attributes on a organization'
              key :operationId, 'updateOrganization'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of organization to update'
                key :required, true
                key :type, :string
              end

              parameter do
                key :name, :body
                key :in, :body
                key :required, true
                schema do
                  key :type, :object
                  property :organization do
                    key :description, 'New attributes'
                    key :'$ref', 'Workarea::Organization'
                  end
                end
              end

              response 204 do
                key :description, 'Organization updated successfully'
              end

              response 422 do
                key :description, 'Validation failure'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :document do
                    key :'$ref', 'Workarea::Organization'
                  end
                end
              end

              response 404 do
                key :description, 'Organization not found'
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
              key :summary, 'Remove a Organization'
              key :description, 'Remove a organization'
              key :operationId, 'removeOrganization'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of organization to remove'
                key :required, true
                key :type, :string
              end

              response 204 do
                key :description, 'Organization removed successfully'
              end

              response 404 do
                key :description, 'Organization not found'
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
            respond_with organization: @organization
          end

          def update
            @organization.update_attributes!(params[:organization])
            respond_with organization: @organization
          end

          swagger_path '/organizations/bulk' do
            operation :patch do
              key :summary, 'Bulk Upsert Organizations'
              key :description, 'Creates new organizations or updates existing ones in bulk.'
              key :operationId, 'upsertOrganizations'
              key :produces, ['application/json']

              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Array of organizations to upsert'
                key :required, true
                schema do
                  key :type, :object
                  property :organizations do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Organization'
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
              klass: Organization,
              data: params[:organizations].map(&:to_h)
            )

            head :no_content
          end

          def destroy
            @organization.destroy
            head :no_content
          end

          private

          def find_organization
            @organization = Organization.find(params[:id])
          end
        end
      end
    end
  end
end
