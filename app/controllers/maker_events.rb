LouisXiv::App.controllers :maker_events do

  get :index do
    @maker_events = MakerEvent.all
    render 'index'
  end

  get :new do
  end

  post :new do
  end

  get :show, map: '/maker_events/:id' do
  end

  get :edit, map: '/maker_events/:id/edit' do
  end

  post :edit, map: '/maker_events/:id/edit' do
  end

  post :delete, map: '/maker_events/:id/delete' do
  end
end
