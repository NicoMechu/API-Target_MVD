ActiveAdmin.register Message do
  permit_params :text, :user_id, :match_conversation_id

  index do
    selectable_column
    id_column
    column :text
    column :user
    column :match_conversation
    actions
  end

  filter :user_id
  filter :match_conversation_id

  form do |f|
    f.inputs 'Message' do
      f.input :text
    end
    f.actions
  end
end
