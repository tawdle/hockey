class SearchResultsController < ApplicationController
  skip_authorization_check

  def index
    @results = PgSearch.multisearch(params[:q]).map(&:searchable).reject {|i| i.respond_to?(:deleted_at) && i.deleted_at }
    @query_text = params[:q]
  end
end
