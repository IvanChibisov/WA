require 'test_helper'

module Workarea
  module Admin
    class OrganizationsIntegrationTest < Workarea::IntegrationTest
      include Admin::IntegrationTest

      def test_create
        post admin.organizations_path,
             params: {
               organization: {
                 name: 'Foo Organization'
               }
             }

        assert_redirected_to(admin.organizations_path)
        assert(flash[:success].present?)

        organization = Organization.last
        assert_equal('Foo Organization', organization.name)
      end

      def test_update
        organization = create_organization(name: 'Foo')

        put admin.organization_path(organization),
            params: {
              organization: {
                name: 'Bar',
                active: false
              }
            }

        assert_redirected_to(admin.organizations_path)

        organization.reload
        assert_equal('Bar', organization.name)
        refute(organization.active?)
      end

      def test_show
        organization = create_organization

        get admin.organization_path(organization)
        assert_redirected_to(admin.edit_organization_path(organization))
      end

      def test_destroy
        organization = create_organization

        delete admin.organization_path(organization)

        assert_equal(0, Organization.count)
        assert_redirected_to(admin.organizations_path)
        assert(flash[:success].present?)
      end
    end
  end
end
