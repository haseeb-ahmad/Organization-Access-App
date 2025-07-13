ActiveAdmin.register Organization do
  permit_params :name, :description

  index do
    selectable_column
    id_column
    column :name
    column :description
    column("Members Count") { |org| org.users.count }
    column("Spaces Count") { |org| org.spaces.count }
    column :created_at
    actions
  end

  filter :name
  filter :created_at

  show do
    attributes_table do
      row :id
      row :name
      row :description
      row :created_at
      row :updated_at
    end

    panel "Spaces" do
      table_for organization.spaces do
        column :id
        column :name
        column :description
      end
    end

    panel "Users (via Memberships)" do
      table_for organization.users do
        column :id
        column :email
        column :created_at
      end
    end
  end

  form do |f|
    f.inputs "Organization Details" do
      f.input :name
      f.input :description
    end
    f.actions
  end
end
