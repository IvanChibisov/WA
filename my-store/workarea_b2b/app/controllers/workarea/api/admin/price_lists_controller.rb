module Workarea
  if Plugin.installed?('Workarea::Api::Admin')
    module Api
      module Admin
        class PriceListsController < Admin::ApplicationController
          before_action :find_price_list, except: [:index, :create, :bulk]

          swagger_path '/price_lists' do
            operation :get do
              key :summary, 'All Price Lists'
              key :description, 'Returns all price lists from the system'
              key :operationId, 'listPriceLists'
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
                key :description, 'Price Lists'
                schema do
                  key :type, :object
                  property :price_lists do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Pricing::PriceList'
                    end
                  end
                end
              end
            end

            operation :post do
              key :summary, 'Create Price List'
              key :description, 'Creates a new price list'
              key :operationId, 'addPriceList'
              key :produces, ['application/json']

              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Price list to add'
                key :required, true
                schema do
                  key :type, :object
                  property :price_list do
                    key :'$ref', 'Workarea::Pricing::PriceList'
                  end
                end
              end

              response 201 do
                key :description, 'Price list created'
                schema do
                  key :type, :object
                  property :price_list do
                    key :'$ref', 'Workarea::Pricing::PriceList'
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
                    key :'$ref', 'Workarea::Pricing::PriceList'
                  end
                end
              end
            end
          end

          def index
            @price_lists = Pricing::PriceList
                        .all
                        .order_by(sort_field => sort_direction)
                        .page(params[:page])

            respond_with price_lists: @price_lists
          end

          def create
            @price_list = Pricing::PriceList.create!(params[:price_list])
            respond_with(
              { price_list: @price_list },
              {
                status: :created,
                location: price_list_path(@price_list.id)
              }
            )
          end

          swagger_path '/price_lists/{id}' do
            operation :get do
              key :summary, 'Find Price List by ID'
              key :description, 'Returns a single price list'
              key :operationId, 'showPriceList'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of price list to fetch'
                key :required, true
                key :type, :string
              end

              response 200 do
                key :description, 'Price list details'
                schema do
                  key :type, :object
                  property :price_list do
                    key :'$ref', 'Workarea::Pricing::PriceList'
                  end
                end
              end

              response 404 do
                key :description, 'Price list not found'
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
              key :summary, 'Update an Price List'
              key :description, 'Updates attributes on a price list'
              key :operationId, 'updatePriceList'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of price list to update'
                key :required, true
                key :type, :string
              end

              parameter do
                key :name, :body
                key :in, :body
                key :required, true
                schema do
                  key :type, :object
                  property :price_list do
                    key :description, 'New attributes'
                    key :'$ref', 'Workarea::Pricing::PriceList'
                  end
                end
              end

              response 204 do
                key :description, 'Price list updated successfully'
              end

              response 422 do
                key :description, 'Validation failure'
                schema do
                  key :type, :object
                  property :problem do
                    key :type, :string
                  end
                  property :document do
                    key :'$ref', 'Workarea::Pricing::PriceList'
                  end
                end
              end

              response 404 do
                key :description, 'Price list not found'
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
              key :summary, 'Remove an Price list'
              key :description, 'Remove a price list'
              key :operationId, 'removePriceList'

              parameter do
                key :name, :id
                key :in, :path
                key :description, 'ID of price list to remove'
                key :required, true
                key :type, :string
              end

              response 204 do
                key :description, 'Price list removed successfully'
              end

              response 404 do
                key :description, 'Price list not found'
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
            respond_with price_list: @price_list
          end

          def update
            @price_list.update_attributes!(params[:price_list])
            respond_with price_list: @price_list
          end

          swagger_path '/price_lists/bulk' do
            operation :patch do
              key :summary, 'Bulk Upsert Price Lists'
              key :description, 'Creates new price lists or updates existing ones in bulk.'
              key :operationId, 'upsertPriceLists'
              key :produces, ['application/json']

              parameter do
                key :name, :body
                key :in, :body
                key :description, 'Array of price lists to upsert'
                key :required, true
                schema do
                  key :type, :object
                  property :price_lists do
                    key :type, :array
                    items do
                      key :'$ref', 'Workarea::Pricing::PriceList'
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
              klass: Pricing::PriceList,
              data: params[:price_lists].map(&:to_h)
            )

            head :no_content
          end

          def destroy
            @price_list.destroy
            head :no_content
          end

          private

          def find_price_list
            @price_list = Pricing::PriceList.find(params[:id])
          end
        end
      end
    end
  end
end
