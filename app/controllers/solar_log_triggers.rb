LouisXiv::App.controllers :solar_log_triggers do

  get :index do
    @solar_log_triggers = SolarLogTrigger.order(:name)
    render 'index'
  end

  get :new do

  end

  post :new do

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
