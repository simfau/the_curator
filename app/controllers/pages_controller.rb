class PagesController < ApplicationController

  def home

  end
  def contents_search
    if params[:query].present?
      @contents = Content.search_by_title_creator_description(params[:query]).limit(9)
    else
      @contents = Content.all.limit(9)
    end
  end
  def recommendation
    @contents = Content.contents_score(params[:content_ids].flatten)
    @content = @contents.select{ |content| content[:content][:format] == params[:action_type] }.first
  end
end
