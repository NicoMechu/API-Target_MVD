module Api
  module V1
    class TargetsController < Api::V1::ApiController
      
      def index
        @Targets = current_user.targets
      end

      def create
        if target_params.nil?
          render json: { errors: ['The arguments given are incorrect.'] }, status: :bad_request and return 
        end
        @target = Target.new(target_params)
        @target.user = current_user

        if @target.save 
          @matches = @target.matches
          render :new_target
        elsif @target.errors[:limit].any?
          render json: { errors: ['You have exceeded the amount of Targets, please remove one before create a new one.'] }, status: :bad_request 
        else
          render json: { errors: ['Could not creat Target'] }, status: :bad_request
        end
      end

      def destroy
        @target = current_user.targets.find_by_id(params[:id])

        if @target.nil?
          render json: { errors: ['There is no target with this ID'] }, status: :bad_request and return 
        end
        unless @target.destroy
          render json: { errors: ['Could not delet Target'] }, status: :bad_request
        end
      end 

      def update
        @target = current_user.targets.find_by_id(params[:id])
        if @target.nil?
          render json: { errors: ['There is no target with this ID'] }, status: :bad_request and return 
        end
        @target.update_attributes(target_params)

        if @target.save 
          @matches = @target.matches
          render :new_target
        else
          render json: { errors: ['Could not update Target'] }, status: :bad_request
        end
      end

      def target_params
        target_params = params.require(:target).permit(:lat, :lng, :radius, :topic_id, :id, :title)
      end
    end
  end
end
