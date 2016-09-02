LouisXiv::App.controllers :maker_events do

  get :index do
    @maker_events = MakerEvent.order(:name)
    render 'index'
  end

  get :new do
    @maker_event = session['maker_event'] || MakerEvent.new(active: true)
    session.delete 'maker_event'

    render 'new'
  end

  post :new do
    maker_event = MakerEvent.new(params.fetch('maker_event'))

    if maker_event.valid?
      maker_event.save
      redirect(url(:maker_events, :index), 
               success: "Created Maker event #{ maker_event.name }")
    else
      # @Todo: Marshal
      session['maker_event'] = maker_event
      redirect(url(:maker_events, :new), 
               form_error: pp_form_errors(maker_event.errors))
    end
  end

  get :show, map: '/maker_events/:id' do
    @maker_event = get_or_404(MakerEvent, params.fetch('id').to_i)
    render 'show'
  end

  get :edit, map: '/maker_events/:id/edit' do
    @maker_event = session['maker_event'] || 
      get_or_404(MakerEvent, params.fetch('id').to_i)
    session.delete 'maker_event'

    render 'edit'
  end

  post :edit, map: '/maker_events/:id/edit' do
    maker_event = get_or_404(MakerEvent, params.fetch('id').to_i)

    maker_event_params = params.fetch('maker_event')
    if maker_event_params.key? 'active'
      maker_event_params['active'] = to_bool(maker_event_params['active'])
    end
    maker_event.set(maker_event_params)

    if maker_event.valid?
      maker_event.save
      redirect(url(:maker_events, :show, id: maker_event.id), 
                   success: "Modified #{ maker_event.name }")
    else
      # @Todo: Marshal
      session['maker_event'] = maker_event
      redirect(url(:maker_events, :edit, id: maker_event.id), 
                   form_error: pp_form_errors(maker_event.errors))
    end
  end

  post :delete, map: '/maker_events/:id/delete' do
    maker_event = get_or_404(MakerEvent, params.fetch('id').to_i)

    maker_event.destroy
    redirect(url(:maker_events, :index))
  end
end
