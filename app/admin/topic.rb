ActiveAdmin.register Topic do
  permit_params :label

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
    end
    f.actions
  end
end
