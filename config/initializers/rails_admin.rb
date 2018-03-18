RailsAdmin.config do |config|
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
  end
  config.current_user_method(&:current_user)

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model 'Building' do
    list do
      configure :description_formatted do
        hide
      end
    end

    create do
      configure :description_formatted do
        hide
      end
    end

    edit do
      field :name
      field :also_known_as
      field :byline
      field :description, :simple_mde
      field :address
      field :status
      field :style
      field :year_opened
      field :year_closed
      field :year_demolished
      field :created_at
      field :updated_at
      field :architect_id
    end
  end
end
