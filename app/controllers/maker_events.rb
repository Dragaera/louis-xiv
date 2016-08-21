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
  end

  post :edit, map: '/maker_events/:id/edit' do
  end

  post :delete, map: '/maker_events/:id/delete' do
  end
end
