module Api
  class CompaniesController < ApplicationController
    before_action :set_company, only: [:show, :update, :destroy]
    before_action :authenticate_user, except: [:index, :show]
    def create
      @company = Company.new(company_params)
      authorize @company
      if @company.save
        render json: CompanyBlueprint
          .render(@company, root: root.present? ? root.singularize : nil),
               status: :created
      else
        render json: { errors: @company.errors }, status: :bad_request
      end
    end

    def index
      @companies = Company.all
      render json: CompanyBlueprint.render(@companies, root: root)
    end

    def show
      render json: CompanyBlueprint.render(@company, root: root.present? ? root.singularize : nil)
    end

    def update
      authorize @company
      if @company.update(company_params)
        render json: CompanyBlueprint.render(@company, root: root.present? ? root.singularize : nil)
      else
        render json: { errors: @company.errors }, status: :bad_request
      end
    end

    def destroy
      authorize @company
      @company.destroy
      head :no_content
    end

    private

    def set_company
      @company = Company.find(params[:id])
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Company not found' }, status: :not_found
    end

    def company_params
      params.require(:company).permit(:name)
    end

    def root
      if request.headers['HTTP_X_API_SERIALIZER_ROOT'] == '1' ||
         request.headers['HTTP_X_API_SERIALIZER_ROOT'].blank?
        'companies'
      end
    end

    def authenticate_user
      auth_token = request.headers['HTTP_AUTHORIZATION']
      @authenticated_user = User.find_by(token: auth_token)
      return unless auth_token.nil? || @authenticated_user.nil?

      render json: {
               "errors": {
                 "token": ['is invalid']
               }
             },
             status: :unauthorized
    end

    def current_user
      @authenticated_user
    end
  end
end
