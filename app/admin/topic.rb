ActiveAdmin.register Topic do
  permit_params :label, :icon

  index do
    selectable_column
    id_column
    column :label
    actions
  end

  filter :label

  form do |f|
    f.inputs 'Topic' do
      f.input :label
      f.input :icon_cache, :as => :hidden
      f.input :icon
    end
    f.actions
  end

  show do
    attributes_table do
      row :label
      row :icon do |topic|
        topic.icon.present? ? image_tag(topic.icon.url) : content_tag(:span, "no icon yet")
      end
    end
  end
end
