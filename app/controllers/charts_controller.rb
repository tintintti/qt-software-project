class ChartsController < ApplicationController
  before_action :ensure_that_logged_in, except: [:index]

  def index

  end

  def forumCharts
    @post_counts = UserHandler.user_postcounts
    @email_counts = UserHandler.count_emails
    @users_by_email = UserHandler.users_by_email_provider
  end

  def gitCharts
    # 2015 jälkeiset authorien commitit
    @authorCommitsFrom2015 = GitHandler.author_commits
    # @commits = Commit.all

  end

  def gerritCharts
    download = params[:download]

    if download.nil?
      @owners = Rails.cache.read "owners_data"
    else
      owners_data = OwnerHandler.changes_by_owner
      @owners = owners_data
      Rails.cache.write "owners_data", owners_data
    end
  end


end
