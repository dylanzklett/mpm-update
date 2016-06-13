class SearchesController < ApplicationController
  def index
  end

  private

  helper_method :term
  def term
    @term ||= params[:term]
  end

  helper_method :projects
  def projects
    @projects ||= Project.search_by(term).page(params[:page])
  end
end
