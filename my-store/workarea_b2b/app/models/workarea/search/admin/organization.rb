module Workarea
  module Search
    class Admin
      class Organization < Search::Admin
        def search_text
          model.name
        end
      end
    end
  end
end
