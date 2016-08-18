module Api
  module V1
    class TargetsController < Api::V1::ApiController
      
      def index
        @Targets = current_user.targets
      end

      def create
        render json: { errors: ['The arguments given are incorrect.'] }, status: :bad_request and return if target_params.nil?
        @target = Target.new(user:current_user,lat: target_params[:lat], lng: target_params[:lng], radius: target_params[:radius], topic: Topic.find(target_params[:topic]))
        if @target.save 
          @near = get_near(@target)
          render :newTarget
        else
          render json: { errors: ['Could not creat Target'] }, status: :bad_request
        end
      end

      def target_params
        target_params = params.require(:target).permit(:lat, :lng, :radius, :topic, :id)
        begin
          target_params[:lat]     = Float(target_params[:lat])    if (target_params.has_key?(:lat)    && (target_params[:lat].is_a? String) )
          target_params[:lng]     = Float(target_params[:lng])    if (target_params.has_key?(:lng)    && (target_params[:lng].is_a? String))
          target_params[:radius]  = Float(target_params[:radius]) if (target_params.has_key?(:radius) && (target_params[:radius].is_a? String))
          target_params[:topic]   = Integer(target_params[:topic])  if (target_params.has_key?(:topic)  && (target_params[:topic].is_a? String)) 
          target_params
        rescue ArgumentError => e
          nil
        end
      end


      def update
        @target = current_user.targets.find_by_id(params[:id])
        render json: { errors: ['There is no target with this ID'] }, status: :bad_request and return if @target.nil?
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
        # Query to find targets present in a square circumscribed around a circle whis radius is equal to the addition of the raidius of both targets.
        box_query     = "earth_box(ll_to_earth(#{target.lat},#{target.lng}), (#{target.radius} + radius)) @> ll_to_earth(lat, lng)"
        # Query to find alltargets present in a radius equal to the addition of the raidius of both targets.
        # This query is more ineficient thant the otherone, the box query allows targets which doesn't corresponds. So, the box query creates a primary filter and the radius query refines it.
        radius_query  = "earth_distance(ll_to_earth(#{target.lat},#{target.lng}), ll_to_earth(lat, lng)) <= (#{target.radius} + radius)"
        Target.shared_topic(target).where(box_query).where(radius_query)
      end
    end
  end
end
