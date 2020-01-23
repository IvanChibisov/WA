module Workarea
  module Search
    class Admin
      class OrganizationAccount < Search::Admin
        def type
          'organization_account'
        end

        def search_text
          "account #{organization} #{model.name}"
        end

        def jump_to_text
          "#{organization} - #{model.name}"
        end

        def jump_to_position
          13
        end

        def facets
          super.merge(
            organization: organization,
            price_list: model.price_list_id
          )
        end

        def organization
          @organization ||= model.organization&.name
        end
      end
    end
  end
end
