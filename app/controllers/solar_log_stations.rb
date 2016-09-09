LouisXiv::App.controllers :solar_log_stations do
  get :index do
    @solar_log_stations = SolarLogStation.order(:name)
    render 'index'
  end

  get :new do
    @solar_log_station = session['solar_log_station'] || 
                         SolarLogStation.new(active: true)
    session.delete 'solar_log_station'

    render 'new'
  end

  post :new do
    obj_params = params.fetch('solar_log_station')
    if obj_params.key? 'active'
      obj_params['active'] = to_bool(obj_params['active'])
    end
    ssh_gateway_id = obj_params.delete('ssh_gateway')
    ssh_gateway = if ssh_gateway_id && !ssh_gateway_id.empty?
                    get_or_404(SSHGateway, ssh_gateway_id)
                  else
                    nil
                  end
    solar_log_station = SolarLogStation.new(obj_params)
    solar_log_station.ssh_gateway = ssh_gateway

    if solar_log_station.valid?
      solar_log_station.save
      redirect(url(:solar_log_stations, :index), 
               success: "Created SolarLog station '#{ solar_log_station.name }'")
    else
      # TODO: Marshal
      session['solar_log_station'] = solar_log_station
      redirect(url(:solar_log_stations, :new), 
               form_error: pp_form_errors(solar_log_station.errors))
    end
  end

  get :show, map: '/solar_log_stations/:id' do
    @solar_log_station = get_or_404(SolarLogStation, params.fetch('id').to_i)
    render 'show'
  end

  get :edit, map: '/solar_log_stations/:id/edit' do
    @solar_log_station = session['solar_log_station'] || 
                         get_or_404(SolarLogStation, params.fetch('id').to_i)
    session.delete 'solar_log_station'

    render 'edit'
  end

  post :edit, map: '/solar_log_stations/:id/edit' do
    solar_log_station = get_or_404(SolarLogStation, params.fetch('id').to_i)

    obj_params = params.fetch('solar_log_station')
    if obj_params.key? 'active'
      obj_params['active'] = to_bool(obj_params['active'])
    end
    ssh_gateway_id = obj_params.delete('ssh_gateway')
    ssh_gateway = if ssh_gateway_id && !ssh_gateway_id.empty?
                    get_or_404(SSHGateway, ssh_gateway_id)
                  else
                    nil
                  end
    solar_log_station.set(obj_params)
    solar_log_station.ssh_gateway = ssh_gateway

    if solar_log_station.valid?
      solar_log_station.save
      redirect(url(:solar_log_stations, :show, id: solar_log_station.id))
    else
      # TODO: Marshal
      session['solar_log_station'] = solar_log_station
      redirect(url(:solar_log_stations, :edit, id: solar_log_station.id), 
               form_error: pp_form_errors(solar_log_station.errors))
    end
  end

  post :delete, map: '/solar_log_stations/:id/delete' do
    solar_log_station = get_or_404(SolarLogStation, params.fetch('id').to_i)

    solar_log_station.destroy
    redirect(url(:solar_log_stations, :index))
  end

  post :update_data, map: '/solar_log_stations/:id/update_data' do
    solar_log_station = get_or_404(SolarLogStation, params.fetch('id').to_i)

    if solar_log_station.async_update_data
      redirect(url(:solar_log_stations, :show, id: solar_log_station.id), 
               success: "Scheduled update for #{ solar_log_station.name }")
    else
      redirect(url(:solar_log_stations, :show, id: solar_log_station.id), 
               error: "Failed to schedule update for #{ solar_log_station.name }")
    end
  end
end
