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
        @target = Target.new(user:current_user,
          lat: target_params[:lat], 
          lng: target_params[:lng], 
          radius: target_params[:radius], 
          topic: Topic.find(target_params[:topic]))

        if @target.save 
          @near = get_near(@target)
          render :newTarget
        elsif @target.errors[:limit].any?
          render json: { errors: ['You have exceeded the amount of Targets, please remove one before create a new one.'] }, status: :bad_request 
        else
          render json: { errors: ['Could not creat Target'] }, status: :bad_request
        end
      end

      def target_params
        target_params = params.require(:target).permit(:lat, :lng, :radius, :topic, :id)
      end

      def destroy
        @target = current_user.targets.find_by_id(params[:id])

        if @target.nil?
          render json: { errors: ['There is no target with this ID'] }, status: :bad_request and return 
        end
        if @target.destroy
          render :destroy
        else
          render json: { errors: ['Could not delet Target'] }, status: :bad_request
        end
      end 

      def update
        @target = current_user.targets.find_by_id(params[:id])
        if @target.nil?
          render json: { errors: ['There is no target with this ID'] }, status: :bad_request and return 
        end
        @target.lat = target_params[:lat] if target_params.has_key?(:lat)
        @target.lng = target_params[:lng] if target_params.has_key?(:lng)
        @target.radius = target_params[:radius] if target_params.has_key?(:radius)
        @target.topic_id = target_params[:topic] if target_params.has_key?(:topic)

        if @target.save 
          @near = get_near(@target)
          render :newTarget
        else
          render json: { errors: ['Could not ipdate Target'] }, status: :bad_request
        end
      end

      def get_near(target)
        # Query to find targets present in a square circumscribed around a circle whis radius is equal to the addition
        # of the raidius of both targets.
        box_query     = "earth_box(ll_to_earth(#{target.lat},#{target.lng}),"\
                        "(#{target.radius} + radius)) @> ll_to_earth(lat, lng)"
        # Query to find alltargets present in a radius equal to the addition of the raidius of both targets.
        # This query is more ineficient thant the otherone, the box query allows targets which doesn't corresponds. 
        #So, the box query creates a primary filter and the radius query refines it.
        radius_query  = "earth_distance(ll_to_earth(#{target.lat},#{target.lng}),"\
                        " ll_to_earth(lat, lng)) <= (#{target.radius} + radius)"
        Target.shared_topic(target).where(box_query).where(radius_query)
      end
    end
  end
end
