LouisXiv::App.controllers :maker_actions do

  get :index do
  end

  get :new do
    @maker_action = session['maker_session'] || MakerAction.new(active: true)
    session.delete 'maker_action'

    render 'new'
  end

  post :new do
    obj_params = params.fetch('maker_action')
    maker_action = MakerAction.new(
      name: obj_params.fetch('name'),
      active: to_bool(obj_params.fetch('active'))
    )

    maker_key_ids   = to_int(obj_params.fetch('maker_keys', []), strict: false)
    maker_event_ids = to_int(obj_params.fetch('maker_events', []), strict: false)

    if maker_action.valid?
      begin
        Sequel::Model::db.transaction do
          maker_action.maker_key_pks   = maker_key_ids
          maker_action.maker_event_pks = maker_event_ids
          maker_action.save

          redirect(url(:maker_actions, :index), success: "Created Maker action #{ maker_action.name }")
        end
      rescue Sequel::DatabaseError, e
        # @Todo: Logging
        errors = ['Could not create maker action']
      end
    else
      errors = pp_form_errors(maker_action.errors)
    end
    
    # @Todo: Marshal
    session['maker_action'] = maker_action
    redirect(url(:maker_actions, :new), form_error: errors)
  end

  get :show, map: '/maker_actions/:id' do
  end

  get :edit, map: '/maker_actions/:id/edit' do
  end

  post :edit, map: '/maker_actions/:id/edit' do
  end

  post :delete, map: '/maker_actions/:id/delete' do
  end

end
