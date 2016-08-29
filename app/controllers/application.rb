LouisXiv::App.controllers :application do

  get :home, map: '/' do
    render 'home'
  end

  not_found do
    @msg = env['sinatra.error'].message

    render 'not_found'
  end

end
