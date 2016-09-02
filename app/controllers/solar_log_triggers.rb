LouisXiv::App.controllers :solar_log_triggers do

  get :index do
    @solar_log_triggers = SolarLogTrigger.order(:name)
    render 'index'
  end

  get :new do
    @solar_log_trigger = session['solar_log_trigger'] || 
      SolarLogTrigger.new(active: true)
    session.delete 'solar_log_trigger'

    render 'new'
  end

  post :new do
    obj_params = params.fetch('solar_log_trigger')
    solar_log_trigger = SolarLogTrigger.new(
      name: obj_params.fetch('name'),
      condition: obj_params.fetch('condition'),
      active: to_bool(obj_params.fetch('active'))
    )

    maker_action_ids = to_int(obj_params.fetch('maker_actions', []), 
                              strict: false)
    solar_log_station_ids = to_int(obj_params.fetch('solar_log_stations', []), 
                                   strict: false)

    errors = []

    begin
      Sequel::Model::db.transaction do
        solar_log_trigger.maker_action_pks = maker_action_ids
        solar_log_trigger.solar_log_station_pks = solar_log_station_ids

        if solar_log_trigger.valid?
          solar_log_trigger.save
          redirect(url(:solar_log_triggers, :index), 
                   success: "Created SolarLog trigger #{ solar_log_trigger.name }")
        end

        # Trigger invalid (e.g. missing fields)
        errors += pp_form_errors(solar_log_trigger.errors)
      end
    rescue Sequel::DatabaseError
      # @Todo: Logging
      # Saving trigger failed (e.g. referential integrity of fk to maker actions)
      errors += ['Could not create SolarLog trigger']
    end

    # @Todo: Marshal
    session['solar_log_trigger'] = solar_log_trigger
    redirect(url(:solar_log_triggers, :new), form_error: errors)
  end

  get :show, map: '/solar_log_triggers/:id' do
    @solar_log_trigger = get_or_404(SolarLogTrigger, params.fetch('id').to_i)
    render 'show'
  end

  get :edit, map: '/solar_log_triggers/:id/edit' do
    @solar_log_trigger = session['solar_log_trigger'] || 
      get_or_404(SolarLogTrigger, params.fetch('id').to_i)
    session.delete 'solar_log_trigger'

    render 'edit'
  end

  post :edit, map: '/solar_log_triggers/:id/edit' do
    solar_log_trigger = get_or_404(SolarLogTrigger, params.fetch('id').to_i)

    obj_params = params.fetch('solar_log_trigger')
    solar_log_trigger.set(
      name: obj_params.fetch('name'),
      condition: obj_params.fetch('condition'),
      active: to_bool(obj_params.fetch('active', false))
    )

    maker_action_ids = to_int(obj_params.fetch('maker_actions', []), 
                              strict: false)
    solar_log_station_ids = to_int(obj_params.fetch('solar_log_stations', []), 
                                   strict: false)

    errors = []

    begin
      Sequel::Model::db.transaction do
        solar_log_trigger.maker_action_pks = maker_action_ids
        solar_log_trigger.solar_log_station_pks = solar_log_station_ids

        if solar_log_trigger.valid?
          solar_log_trigger.save
          redirect(url(:solar_log_triggers, :show, id: solar_log_trigger.id), 
                       success: "Modified '#{ solar_log_trigger.name }'")
        end

        # Trigger invalid (missing fields)
        errors += pp_form_errors(solar_log_trigger.errors)
      end
    rescue Sequel::DatabaseError
      # @Todo: Logging
      # Saving trigger failed (e.g. ref integrity maker action fk)
      errors += ["Could not modify '#{ solar_log_trigger.name }'"]
    end

    # @Todo: Marshal
    session['solar_log_trigger'] = solar_log_trigger
    redirect(url(:solar_log_triggers, :edit, id: solar_log_trigger.id), 
             form_error: errors)
  end

  post :delete, map: '/solar_log_triggers/:id/delete' do
    solar_log_trigger = get_or_404(SolarLogTrigger, params.fetch('id').to_i)

    solar_log_trigger.destroy
    redirect(url(:solar_log_triggers, :index))
  end

  post :check, map: '/solar_log_triggers/:id/check' do
    trigger = get_or_404(SolarLogTrigger, params.fetch('id').to_i)

    if trigger.async_check
      opts = { success: "Scheduled check of trigger '#{ trigger.name }'" }
    else
      opts = { error: "Failed to schedule check of trigger '#{ trigger.name }'" }
    end

    redirect(url(:solar_log_triggers, :show, id: trigger.id), opts)
  end

end
