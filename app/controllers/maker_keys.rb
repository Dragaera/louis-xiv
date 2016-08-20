LouisXiv::App.controllers :maker_keys do

  get :index do
    @maker_keys = MakerKey.all
    render 'index'
  end

  get :show, map: '/maker_keys/:id' do
    @maker_key = get_or_404(:maker_key, params.fetch('id').to_i)
    render 'show'
  end

  get :new do
  end

  post :new do
  end

  get :edit, map: '/maker_keys/:id/edit' do
  end

  post :edit, map: '/maker_keys/:id/edit' do
  end

  delete :delete, map: '/maker_keys/:id' do
  end
end
