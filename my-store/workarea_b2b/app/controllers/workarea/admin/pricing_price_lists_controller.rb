module Workarea
  module Admin
    class PricingPriceListsController < ApplicationController
      required_permissions :catalog

      before_action :find_price_list
      skip_before_action :set_membership_details

      def index
        search = Search::AdminPriceLists.new(
          params.merge(autocomplete: request.xhr?)
        )

        @search = Admin::SearchViewModel.new(search, view_model_options)
      end

      def show; end

      def pricing
        search = Search::AdminPricingSkus.new(
          params.merge(price_lists: @price_list.id)
        )

        @search = SearchViewModel.new(search, view_model_options)
      end

      def accounts
        search = Search::AdminAccounts.new(
          params.merge(price_list: @price_list.id)
        )

        @search = SearchViewModel.new(search, view_model_options)
      end

      def new; end

      def create
        if @price_list.save
          flash[:success] = t('workarea.admin.pricing_price_lists.flash_messages.created')
          redirect_to pricing_price_list_path(@price_list)
        else
          flash[:error] = t('workarea.admin.pricing_price_lists.flash_messages.error')
          render :new
        end
      end

      def destroy
        @price_list.destroy

        flash['success'] = t('workarea.admin.pricing_price_lists.flash_messages.destroyed')
        redirect_to pricing_price_lists_path
      end

      private

      def find_price_list
        model =
          if params[:id].present?
            Pricing::PriceList.find(params[:id])
          else
            Pricing::PriceList.new(price_list_params)
          end

        @price_list = PriceListViewModel.wrap(model, view_model_options)
      end

      def price_list_params
        params.fetch(:price_list, {}).reject { |_, v| v.blank? }
      end
    end
  end
end
