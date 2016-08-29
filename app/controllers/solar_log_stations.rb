LouisXiv::App.controllers :solar_log_stations do

  get :index do
    @solar_log_stations = SolarLogStation.order(:name)
    render 'index'
  end

  get :new do
    @solar_log_station = session['solar_log_station'] || SolarLogStation.new(active: true)
    session.delete 'solar_log_station'

    render 'new'
  end

  post :new do
    obj_params = params.fetch('solar_log_station')
    solar_log_station = SolarLogStation.new(
      name: obj_params.fetch('name'),
      http_url: obj_params.fetch('http_url'),
      active: to_bool(obj_params.fetch('active'))
    )

    solar_log_trigger_ids = to_int(obj_params.fetch('solar_log_triggers', []), strict: false)

    errors = []

    begin
      Sequel::Model::db.transaction do
        solar_log_station.solar_log_trigger_pks = solar_log_trigger_ids

        if solar_log_station.valid?
          solar_log_station.save
          redirect(url(:solar_log_stations, :index), success: "Created SolarLog station '#{ solar_log_station.name }'")
        end

        # Station invalid (e.g. missing fields)
        errors += pp_form_errors(solar_log_station.errors)
      end
    rescue Sequel::DatabaseError
      # @Todo: Logging
      # Saving station failed (e.g. referential integrity of fk to solarlog trigger)
      errors += ['Could not create SolarLog station']
    end

    # @Todo: Marshal
    session['solar_log_station'] = solar_log_station
    redirect(url(:solar_log_stations, :new), form_error: errors)
  end

  get :show, map: '/solar_log_stations/:id' do
  end

  get :edit, map: '/solar_log_stations/:id/edit' do
  end

  post :edit, map: '/solar_log_stations/:id/edit' do
  end

  post :delete, map: '/solar_log_stations/:id/delete' do
  end

end
