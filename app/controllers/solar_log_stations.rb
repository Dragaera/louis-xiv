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

    if solar_log_station.valid?
      solar_log_station.save
      redirect(url(:solar_log_stations, :index), success: "Created SolarLog station '#{ solar_log_station.name }'")
    else
      # @Todo: Marshal
      session['solar_log_station'] = solar_log_station
      redirect(url(:solar_log_stations, :new), form_error: pp_form_errors(solar_log_station.errors))
    end
  end

  get :show, map: '/solar_log_stations/:id' do
    @solar_log_station = get_or_404(SolarLogStation, params.fetch('id').to_i)
    render 'show'
  end

  get :edit, map: '/solar_log_stations/:id/edit' do
  end

  post :edit, map: '/solar_log_stations/:id/edit' do
  end

  post :delete, map: '/solar_log_stations/:id/delete' do
  end

end
