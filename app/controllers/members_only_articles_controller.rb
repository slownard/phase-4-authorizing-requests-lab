class MembersOnlyArticlesController < ApplicationController
  rescue_from ActiveRecord::RecordNotFound, with: :record_not_found
  #added this 
  before_action :authorize


  def index
    articles = Article.where(is_member_only: true).includes(:user).order(created_at: :desc)
    render json: articles, each_serializer: ArticleListSerializer
  end

  def show
    article = Article.find(params[:id])
    #if article 
    render json: article
    # else 
    # render json: { error: "Not authorized" }, status: :unauthorized
    # end

  end

  private

  def authorize
    return render json: { error: "Not authorized" }, status: :unauthorized unless session.include? :user_id
  end

  def record_not_found
    render json: { error: "Article not found" }, status: :not_found
  end

end
