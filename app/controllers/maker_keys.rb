LouisXiv::App.controllers :maker_keys do

  get :index do
    @maker_keys = MakerKey.all
    render 'index'
  end

  get :new do
    @maker_key = session['maker_key'] || MakerKey.new
    session.delete 'maker_key'

    render 'new'
  end

  post :new do
    opts = params.fetch('maker_key')
    maker_key = MakerKey.new(
      name:   opts.fetch('name'),
      key:    opts.fetch('key'),
      active: to_bool(opts.fetch('active'))
    )

    if maker_key.valid?
      maker_key.save
      redirect(url(:maker_keys, :index), success: "Created Maker key #{ maker_key.name }")
    else
      # @Todo: Marshal: Avoid full objects in session
      session['maker_key'] = maker_key
      redirect(url(:maker_keys, :new), form_error: pp_form_errors(maker_key.errors))
    end
  end

  get :show, map: '/maker_keys/:id' do
    @maker_key = get_or_404(MakerKey, params.fetch('id').to_i)
    render 'show'
  end

  get :edit, map: '/maker_keys/:id/edit' do
  end

  post :edit, map: '/maker_keys/:id/edit' do
  end

  delete :delete, map: '/maker_keys/:id' do
  end
end
