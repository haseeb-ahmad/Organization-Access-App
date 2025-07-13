ActiveAdmin.register User do
  permit_params :email, :password, :password_confirmation, memberships_attributes: [:id, :organization_id, :role, :_destroy]

  index do
    selectable_column
    id_column
    column :email
    column("Organizations") { |u| u.organizations.pluck(:name).join(", ") }
    column("Membership Roles") do |u|
      u.memberships.map { |m| "#{m.organization.name}: #{m.role}" }.join("<br>").html_safe
    end
    column :created_at
    actions
  end

  filter :email
  filter :organizations
  filter :created_at

  show do
    attributes_table do
      row :id
      row :email
      row :created_at
      row :updated_at
    end

    panel "Memberships" do
      table_for user.memberships do
        column :organization
        column :role
        column :created_at
      end
    end
  end

  form do |f|
    f.inputs "User Details" do
      f.input :email
      # f.input :password
      # f.input :password_confirmation
    end

    f.has_many :memberships, allow_destroy: true, new_record: true do |m|
      m.input :organization
      m.input :role, as: :select, collection: Membership.roles.keys
    end

    f.actions
  end
end
