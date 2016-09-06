ActiveAdmin.register User do
  # See permitted parameters documentation:
  # https://github.com/activeadmin/activeadmin/blob/master/docs/2-resource-customization.md#setting-up-strong-parameters
  #
  permit_params :email, :name, :image, :gender

  form do
    inputs 'Details' do
      input :email
      input :name
      input :gender
    end
    actions
  end

  index do
    selectable_column
    id_column
    column :email
    column :name
    column :gender
    column :facebook_id
    column :sign_in_count
    column :created_at
    actions
  end

  filter :id
  filter :email
  filter :name
  filter :gender
  filter :facebook_id
  filter :sign_in_count
  filter :created_at

  show do
    attributes_table do
      row :id
      row :email
      row :gender
      row :name
      row :sign_in_count
      row :created_at
      row :updated_at
      row :facebook_id
      row :image do |user|
        user.image.present? ? image_tag(user.image.url) : content_tag(:span, "no image yet")
      end
    end
    active_admin_comments
  end
end
