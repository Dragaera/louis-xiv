LouisXiv::App.controllers :maker_events do

  get :index do
    @maker_events = MakerEvent.all
    render 'index'
  end

  get :new do
    @maker_event = session['maker_event'] || MakerEvent.new
    session.delete 'maker_event'

    render 'new'
  end

  post :new do
    opts = params.fetch('maker_event')
    maker_event = MakerEvent.new(
      name:   opts.fetch('name'),
      event:  opts.fetch('event'),
      active: to_bool(opts.fetch('active'))
    )

    if maker_event.valid?
      maker_event.save
      redirect(url(:maker_events, :index), success: "Created Maker event #{ maker_event.name }")
    else
      # @Todo: Marshal
      session['maker_event'] = maker_event
      redirect(url(:maker_events, :new), form_error: pp_form_errors(maker_event.errors))
    end
  end

  get :show, map: '/maker_events/:id' do
  end

  get :edit, map: '/maker_events/:id/edit' do
    @maker_event = session['maker_event'] || get_or_404(MakerEvent, params.fetch('id').to_i)
    session.delete 'maker_event'

    render 'edit'
  end

  post :edit, map: '/maker_events/:id/edit' do
    maker_event = get_or_404(MakerEvent, params.fetch('id').to_i)
    maker_event_params = params.fetch('maker_event')

    maker_event.name   = maker_event_params['name'] if maker_event_params.key? 'name'
    maker_event.event  = maker_event_params['event'] if maker_event_params.key? 'event'
    maker_event.active = to_bool(maker_event_params['active']) if maker_event_params.key? 'active'

    if maker_event.valid?
      maker_event.save
      redirect(url(:maker_events, :show, id: maker_event.id), success: "Modified #{ maker_event.name }")
    else
      # @Todo: Marshal
      session['maker_event'] = maker_event
      redirect(url(:maker_events, :edit, id: maker_event.id), form_error: pp_form_errors(maker_event.errors))
    end
  end

  post :delete, map: '/maker_events/:id/delete' do
  end
end
