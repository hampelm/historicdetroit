RailsAdmin.config do |config|
  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :user
    redirect_to main_app.new_user_session_path unless current_user
    redirect_to main_app.root_path unless current_user.try(:admin)
  end
  config.current_user_method(&:current_user)

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.included_models = [
    'ActsAsTaggableOn::Tag', # Because this isn't in models/, we have to list all
    'Architect',
    'Building',
    'Gallery',
    'Page',
    'Photo',
    'Post',
    'User'
  ]

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
      field :name
      field :slug
      field :also_known_as
      field :byline
      field :description, :simple_mde
      field :photo
      field :address
      field :status
      field :style
      field :year_opened
      field :year_closed
      field :year_demolished
      field :architects
      field :created_at
      field :updated_at
    end

    edit do
      field :name
      field :slug
      field :also_known_as
      field :byline
      field :description, :simple_mde
      field :photo
      field :address
      field :status
      field :style
      field :year_opened
      field :year_closed
      field :year_demolished
      field :architects

      field :created_at
      field :updated_at
    end
  end

  config.model Gallery do
    list do
      sort_by :updated_at
      field :title
      field :updated_at
    end

    edit do
      include_all_fields
      exclude_fields :base_tags
    end
  end

end
