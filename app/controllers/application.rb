LouisXiv::App.controllers :application do

  not_found do
    @msg = env['sinatra.error'].message

    render 'not_found'
  end

end
