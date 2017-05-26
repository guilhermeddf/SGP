class GithubController < ApplicationController
  before_action :set_client, only: [:create]

  def select
    session[:project] = @project.id
    redirect_to @project
  end

  def deselect
    session[:project] = nil
    redirect_to projects_path
  end

  def create
    @client.create_repository(@project.name, options = {"description": params[:description],
                        "homepage": params[:site],
                        "private": x,
                        "has_issues": params[:opc_issues],
                        "has_projects": params[:opc_project],
                        "has_wiki": params[:opc_wiki]})
  end

  private
    def set_client
      @client = Octokit::Client.new(:login => 'guilhermeddf', :password => 'a07021991')
    end

  end
