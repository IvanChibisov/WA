module Workarea
  class Admin::RepeatBlockController < Admin::ApplicationController

    def delete_repeat_block
      @content = Content.find(params[:content_id])
      @content = Workarea::Admin::ContentViewModel.new(
        @content,
        view_model_options
      )
      current_block = @content.blocks.find(params[:button])
      current_block.type.fieldsets.pop
      current_block.type.repeat_with_delete
      current_block.type.save!
      current_block.save!
      @content.save!
    end

    def add_repeat_block
      @content = Content.find(params[:content_id])
      @content = Workarea::Admin::ContentViewModel.new(
        @content,
        view_model_options
      )
      current_block = @content.blocks.find(params[:button])
      current_block.type.fieldsets = current_block.type.repeat
      current_block.type.save!
      current_block.save!
      @content.save!
    end
  end
end
