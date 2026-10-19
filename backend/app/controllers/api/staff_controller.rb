module Api
  class StaffController < ApplicationController
    include Authentication

    before_action :require_admin!
    before_action :set_staff, only: [:show, :update, :destroy]

    # GET /api/staff
    def index
      staff_members = User.where(role: "staff").order(:name)

      render json: staff_members.as_json(
        only: [:id, :name, :email, :role, :created_at]
      ), status: :ok
    end

    # GET /api/staff/:id
    def show
      render json: @staff.as_json(
        only: [:id, :name, :email, :role, :created_at]
      ), status: :ok
    end

    # POST /api/staff
    def create
      staff_member = User.new(staff_params)
      staff_member.role = "staff"

      if staff_member.save
        render json: staff_member.as_json(
          only: [:id, :name, :email, :role, :created_at]
        ), status: :created
      else
        render json: {
          errors: staff_member.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    # PATCH /api/staff/:id
    def update
      if @staff.update(staff_params)
        render json: @staff.as_json(
          only: [:id, :name, :email, :role, :created_at]
        ), status: :ok
      else
        render json: {
          errors: @staff.errors.full_messages
        }, status: :unprocessable_entity
      end
    end

    # DELETE /api/staff/:id
    def destroy
      if @staff.destroy
        head :no_content
      else
        render json: { errors: @staff.errors.full_messages },
               status: :unprocessable_entity
      end
    end

    private

    def set_staff
      @staff = User.find_by(id: params[:id], role: "staff")

      return if @staff

      render json: { error: "Staff member not found" },
             status: :not_found
    end

    def staff_params
      params.require(:staff).permit(
        :name,
        :email,
        :password,
        :password_confirmation
      )
    end
  end
end
