class IndustriesController < ApplicationController
  include SwaggerDocs::Industries
  before_action -> { doorkeeper_authorize! :read_only, :read_write }, only: [:index, :show]
  before_action only: [:create, :update, :destroy] do
    doorkeeper_authorize! :read_write, :write_only
  end
  before_action :set_industry, only: [:show, :update, :destroy]
  before_action :validate_industry_presence, only: [:show, :update, :destroy]

  after_action only: [:index] { set_pagination_header(Industry.all) }

  # GET /industries
  def index
    @industries = params[:page] == 'all' ? Industry.kept : Industry.kept.page(params[:page]).per(params[:per_page])

    render json: @industries
  end

  # GET /industries/1
  def show
    render json: @industry
  end

  # POST /industries
  def create
    @industry = Industry.new(industry_params)

    if @industry.save
      render json: @industry, status: :created, location: @industry
    else
      render json: @industry.errors.messages, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /industries/1
  def update
    if @industry.update(industry_params)
      render json: @industry
    else
      render json: @industry.errors.messages, status: :unprocessable_entity
    end
  end

  # DELETE /industries/1
  def destroy
    @industry.discard
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_industry
    @industry = Industry.find_by_hashid(params[:id])
  end

  def validate_industry_presence
    render_error(404, "#{I18n.t('industry.key_id')}": [I18n.t('general_error.not_found')]) if @industry.nil? || !@industry.presence?
  end

  # Only allow a trusted parameter "white list" through.
  def industry_params
    params.require(:industry).permit(:name, :description)
  end
end
