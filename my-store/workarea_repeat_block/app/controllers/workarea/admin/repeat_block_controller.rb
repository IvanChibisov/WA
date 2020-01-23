module Workarea
  module Admin
    class RepeatBlockController < Admin::ApplicationController

      def delete
        current_block = Workarea::Content::Block.find(params[:button])
        current_block.type.repeat_with_delete
      end

      def add
        current_block = Workarea::Content::Block.find(params[:button])
        current_block.type.repeat
      end

    end
  end
end
