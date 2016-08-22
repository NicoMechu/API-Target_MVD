ActiveAdmin.register Target do
  permit_params :lat, :lng, :radius, :topic_id

  index do
    selectable_column
    id_column
    column :lat
    column :lng
    column :radius
    column :topic
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
