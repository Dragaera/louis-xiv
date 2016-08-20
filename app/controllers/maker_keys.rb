LouisXiv::App.controllers :maker_keys do

  get :index do
    @maker_keys = MakerKey.all
    render 'index'
  end

  get :show, map: '/maker_keys/:id' do
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
