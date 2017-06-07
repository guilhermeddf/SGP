class GithubController < ApplicationController
  before_action :set_project
  before_action :set_client

    def index
      @repository = @client.repository(current_user.usernamegit+'/'+@project.name)
      @branch = @client.branches(current_user.usernamegit+'/'+@project.name)
    end

    def branch
      @getbranch = @client.branch(current_user.usernamegit+'/'+@project.name, params[:bran])
      @listcommits = @client.commits(current_user.usernamegit+'/'+@project.name, params[:bran])
    end

    private
      def set_client
        @client = Octokit::Client.new(:login => current_user.usernamegit, :password => current_user.passwordgit)
      end

      def set_project
        @project = Project.find(current_project_id)
      end
end
