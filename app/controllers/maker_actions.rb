LouisXiv::App.controllers :maker_actions do
  get :index do
    @maker_actions = MakerAction.order(:name)
    render 'index'
  end

  get :new do
    @maker_action = session['maker_action'] || MakerAction.new(active: true)
    session.delete 'maker_action'

    render 'new'
  end

  post :new do
    # @Todo: refactor

    obj_params = params.fetch('maker_action')
    maker_action = MakerAction.new(
      name: obj_params.fetch('name'),
      active: to_bool(obj_params.fetch('active'))
    )

    maker_key_ids   = to_int(obj_params.fetch('maker_keys', []), strict: false)
    maker_event_ids = to_int(obj_params.fetch('maker_events', []), strict: false)

    errors = []

    begin
      Sequel::Model.db.transaction do
        maker_action.maker_key_pks   = maker_key_ids
        maker_action.maker_event_pks = maker_event_ids

        if maker_action.valid?
          maker_action.save
          redirect(url(:maker_actions, :index), 
                   success: "Created Maker action #{ maker_action.name }")
        end

        # Action not valid due to missing name etc
        errors += pp_form_errors(maker_action.errors)
      end
    rescue Sequel::DatabaseError
      # @Todo: Logging
      # Saving action failed because of non-existant key or event
      errors += ['Could not create maker action']
    end

    # @Todo: Marshal
    session['maker_action'] = maker_action
    redirect(url(:maker_actions, :new), form_error: errors)
  end

  get :show, map: '/maker_actions/:id' do
    @maker_action = get_or_404(MakerAction, params.fetch('id').to_i)
    render 'show'
  end

  get :edit, map: '/maker_actions/:id/edit' do
    @maker_action = session['maker_action'] || 
                    get_or_404(MakerAction, params.fetch('id').to_i)
    session.delete 'maker_action'

    render 'edit'
  end

  post :edit, map: '/maker_actions/:id/edit' do
    maker_action = get_or_404(MakerAction, params.fetch('id').to_i)

    obj_params = params.fetch('maker_action')
    maker_action.set(
      name: obj_params.fetch('name'), 
      active: to_bool(obj_params.fetch('active', false))
    )

    maker_key_ids   = to_int(obj_params.fetch('maker_keys', []), strict: false)
    maker_event_ids = to_int(obj_params.fetch('maker_events', []), strict: false)

    errors = []

    begin
      Sequel::Model.db.transaction do
        maker_action.maker_key_pks   = maker_key_ids
        maker_action.maker_event_pks = maker_event_ids

        if maker_action.valid?
          maker_action.save
          redirect(url(:maker_actions, :show, id: maker_action.id), 
                   success: "Modified '#{ maker_action.name }'")
        end

        # Action not valid due to missing name etc
        errors += pp_form_errors(maker_action.errors)
      end
    rescue Sequel::DatabaseError
      # @Todo: Logging
      # Saving action failed because of non-existant key or event
      errors += ["Could not modify #{ maker_action.name }"]
    end

    # @Todo: Marshal
    session['maker_action'] = maker_action
    redirect(url(:maker_actions, :edit, id: maker_action.id), 
             form_error: errors)
  end

  post :delete, map: '/maker_actions/:id/delete' do
    maker_action = get_or_404(MakerAction, params.fetch('id').to_i)

    maker_action.destroy
    redirect(url(:maker_actions, :index))
  end

  post :execute, map: '/maker_actions/:id/execute' do
    action = get_or_404(MakerAction, params.fetch('id').to_i)

    if action.async_execute
      opts = { success: "Scheduled execution of action '#{ action.name }'" }
    else
      opts = { error: "Failed to schedule execution of action '#{ action.name }'" }
    end

    redirect(url(:maker_actions, :show, id: action.id), opts)
  end
end
