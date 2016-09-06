ActiveAdmin.register PushToken do
  permit_params :user_id, :push_token, :match_conversation_id

  index do
    selectable_column
    id_column
    column :user
    column :push_token
    actions
  end

  filter :user_id

  form do |f|
    f.inputs 'PushToken' do
      f.input :push_token
    end
    f.actions
  end
end
