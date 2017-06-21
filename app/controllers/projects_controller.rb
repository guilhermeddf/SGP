class ProjectsController < ApplicationController
  before_action :set_project, only: [:show, :edit, :update, :destroy, :select, :scrumboard]
  before_action :set_client, only: [:create, :destroy, :scrumboard]

  def select
    session[:project] = @project.id
    redirect_to @project
  end

  def deselect
    session[:project] = nil
    redirect_to projects_path
  end

  def scrumboard
    teste1 = @project.linkgit.split('/',4)
    teste2 = teste1[3].split('.')[0]
  end

  def index
    if current_user.admin?
      @projects = Project.all
    else
      redirect_to user_project_path
    end
  end

  def user_project
    @projects = current_user.projects
    render :index
  end

  def show
  end

  def new
    @project = Project.new
  end

  def edit
  end

  def create
    #falso gerador de links do git
    link_git = 'https://github.com/'+current_user.usernamegit+'/'+project_params["name"]+'.git'
    @project = Project.new(project_params.merge(linkgit: link_git))

    respond_to do |format|
      if @project.save
          #funcao que cria repositorio no git
        @client.create_repository(@project.name, options = {"description": params[:description],
                        "homepage": params[:site],
                        "private": params[:opcao_privado],
                        "has_issues": params[:opc_issues],
                        "has_projects": params[:opc_project],
                        "has_wiki": params[:opc_wiki]})
        format.html { redirect_to @project }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @project.update(project_params)
        format.html { redirect_to @project }
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    #funcao que deleta repositorio do git
    @client.delete_repository(current_user.usernamegit+'/'+@project.name)
    @project.destroy
    session[:project] = nil
    respond_to do |format|
      format.html { redirect_to projects_url }
    end
  end

  private
    def set_client
      @client = Octokit::Client.new(:login => current_user.usernamegit, :password => current_user.passwordgit)
    end

    def set_project
      @project = Project.find(params[:id])
    end

    def project_params
      params.require(:project).permit(:name, :size, :start_date, :end_date, :local_id, :linkgit)
    end
end
