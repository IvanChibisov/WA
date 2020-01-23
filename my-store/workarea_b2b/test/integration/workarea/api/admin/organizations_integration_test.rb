require 'test_helper'

module Workarea
  if Plugin.installed?('Workarea::Api::Admin')
    module Api
      module Admin
        class OrganizationsIntegrationTest < IntegrationTest
          include Workarea::Admin::IntegrationTest

          setup :set_sample_attributes

          def set_sample_attributes
            @sample_attributes = create_organization.as_json.except('_id')
          end

          def test_lists_organizations
            organizations = [create_organization, create_organization]
            get admin_api.organizations_path
            result = JSON.parse(response.body)['organizations']

            assert_equal(3, result.length)
            assert_equal(organizations.second, Organization.new(result.first))
            assert_equal(organizations.first, Organization.new(result.second))
          end

          def test_creates_organizations
            assert_difference 'Organization.count', 1 do
              post admin_api.organizations_path,
                   params: { organization: @sample_attributes }
            end
          end

          def test_shows_organizations
            organization = create_organization
            get admin_api.organization_path(organization.id)
            result = JSON.parse(response.body)['organization']
            assert_equal(organization, Organization.new(result))
          end

          def test_updates_organizations
            organization = create_organization
            patch admin_api.organization_path(organization.id),
                  params: { organization: { name: 'foo' } }

            organization.reload
            assert_equal('foo', organization.name)
          end

          def test_bulk_upserts_organizations
            data = [@sample_attributes] * 10

            assert_difference 'Organization.count', 10 do
              patch admin_api.bulk_organizations_path,
                    params: { organizations: data }
            end
          end

          def test_destroys_organizations
            organization = create_organization

            assert_difference 'Organization.count', -1 do
              delete admin_api.organization_path(organization.id)
            end
          end
        end
      end
    end
  end
end
