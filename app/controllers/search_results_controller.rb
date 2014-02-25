class SearchResultsController < ApplicationController
  skip_authorization_check

  def index
    @results = PgSearch.multisearch(params[:q]).map(&:searchable)
    @query_text = params[:q]
  end
end
