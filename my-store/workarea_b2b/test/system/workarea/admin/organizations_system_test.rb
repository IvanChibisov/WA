require 'test_helper'

module Workarea
  module Admin
    class OrganizationsSystemTest < Workarea::SystemTest
      include Admin::IntegrationTest

      def test_managing_organizations
        visit admin.organizations_path

        click_link 'add_organization'

        fill_in 'organization[name]', with: 'Foo Organization'
        click_button 'create_organization'

        assert(page.has_content?('Success'))
        assert(page.has_content?('Foo Organization'))
      end
    end
  end
end
