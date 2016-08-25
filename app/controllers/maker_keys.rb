LouisXiv::App.controllers :maker_keys do

  get :index do
    @maker_keys = MakerKey.all
    render 'index'
  end

  get :new do
    @maker_key = session['maker_key'] || MakerKey.new(active: true)
    session.delete 'maker_key'

    render 'new'
  end

  post :new do
    maker_key = MakerKey.new(params.fetch('maker_key'))

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
    @maker_key = session['maker_key'] || get_or_404(MakerKey, params.fetch('id').to_i)
    session.delete 'maker_key'

    render 'edit'
  end

  post :edit, map: '/maker_keys/:id/edit' do
    maker_key = get_or_404(MakerKey, params.fetch('id').to_i)

    maker_key_params = params.fetch('maker_key')
    maker_key_params['active'] = to_bool(maker_key_params['active']) if maker_key_params.key? 'active'
    maker_key.set(maker_key_params)

    if maker_key.valid?
      maker_key.save
      redirect(url(:maker_keys, :show, id: maker_key.id), success: "Modified #{ maker_key.name }")
    else
      # @Todo: Marshal: avoid full objects in session
      session['maker_key'] = maker_key
      redirect(url(:maker_keys, :edit, id: maker_key.id), form_error: pp_form_errors(maker_key.errors))
    end
  end

  post :delete, map: '/maker_keys/:id/delete' do
    maker_key = get_or_404(MakerKey, params.fetch('id').to_i)

    maker_key.destroy
    redirect(url(:maker_keys, :index))
  end
end
