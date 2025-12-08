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
    @content = Content.first

  end
end
