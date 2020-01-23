module Workarea
  module Admin
    class OrganizationsController < ApplicationController
      required_permissions :people

      before_action :find_organization, except: :index

      def index
        search = Search::AdminOrganizations.new(
          params.merge(autocomplete: request.xhr?)
        )

        @search = Admin::SearchViewModel.new(search, view_model_options)
      end

      def show
        redirect_to edit_organization_path(@organization)
      end

      def new; end

      def create
        if @organization.save
          flash['success'] = t('workarea.admin.organizations.flash_messages.created')
          redirect_to organizations_path
        else
          flash['error'] = t('workarea.admin.organizations.flash_messages.error')
          render :new
        end
      end

      def edit; end

      def update
        if @organization.update(params[:organization])
          flash['success'] = t('workarea.admin.organizations.flash_messages.updated')
          redirect_to organizations_path
        else
          flash['error'] = t('workarea.admin.organizations.flash_messages.error')
          render :edit
        end
      end

      def destroy
        @organization.destroy

        flash['success'] = t('workarea.admin.organizations.flash_messages.destroyed')
        redirect_to organizations_path
      end

      private

      def find_organization
        model =
          if params[:id].present?
            Organization.find(params[:id])
          else
            Organization.new(params[:organization])
          end

        @organization = Admin::OrganizationViewModel.wrap(
          model,
          view_model_options
        )
      end
    end
  end
end
