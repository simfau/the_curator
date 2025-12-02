class PagesController < ApplicationController
  skip_before_action :authenticate_user!

  def home

  end
  def contents_search

  end
  def recommendation

  end
end
