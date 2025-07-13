ActiveAdmin.register Membership do
  permit_params :user_id, :organization_id, :role

  index do
    selectable_column
    id_column
    column :user
    column :organization
    column :role
    column :created_at
    actions
  end

  filter :user
  filter :organization
  filter :role

  form do |f|
    f.inputs do
      f.input :user
      f.input :organization
      f.input :role, as: :select, collection: Membership.roles.keys
    end
    f.actions
  end
end
