LouisXiv::App.controllers :solar_log_triggers do

  get :index do
    @solar_log_triggers = SolarLogTrigger.order(:name)
    render 'index'
  end

  get :new do
    @solar_log_trigger = session['solar_log_trigger'] || SolarLogTrigger.new(active: true)
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

    maker_action_ids = to_int(obj_params.fetch('maker_actions', []), strict: false)

    errors = []

    begin
      Sequel::Model::db.transaction do
        solar_log_trigger.maker_action_pks = maker_action_ids

        if solar_log_trigger.valid?
          solar_log_trigger.save
          redirect(url(:solar_log_triggers, :index), success: "Created SolarLog trigger #{ solar_log_trigger.name }")
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

  end

  get :edit, map: '/solar_log_triggers/:id/edit' do

  end

  post :edit, map: '/solar_log_triggers/:id/edit' do

  end

  post :delete, map: '/solar_log_triggers/:id/delete' do

  end

end
