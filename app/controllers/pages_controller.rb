class PagesController < ApplicationController

  def home

  end
  def contents_search
    if params[:query].present?
      @contents = Content.search_by_title_description_creator(params[:query])
    else
      @contents = Content.all
    end
  end
  def recommendation

  end
end
