ActiveAdmin.register Target do
  permit_params :lat, :lng, :radius, :topic_id

  index do
    selectable_column
    id_column
    column :lat
    column :lng
    column :radius
    column :topic
    # column :topic do |target|
    #   link_to(target.topic, admin_topic_path(target.topic))
    # end
    actions
  end

  filter :label
  form do |f|
    f.inputs 'Topic' do
      f.input :label
    end
    f.actions
  end
end
