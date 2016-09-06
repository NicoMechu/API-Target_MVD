ActiveAdmin.register MatchConversation do
  permit_params :user_a, :user_b, :topic

  index do
    selectable_column
    id_column
    column :user_a
    column :user_b
    column :last_logout_a
    column :last_logout_b
    column :channel_id
    column :topic
    actions
  end

  filter :user_a_id
  filter :user_b_id
  filter :topic_id

  form do |f|
    f.inputs 'MatchConversation' do
      f.input :user_a
      f.input :user_b
      f.input :topic
      f.input :last_logout_a
      f.input :last_logout_b
      f.input :channel_id
    end
    f.actions
  end
end
