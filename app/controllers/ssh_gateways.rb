LouisXiv::App.controllers :ssh_gateways do
  get :index do
    @ssh_gateways = SSHGateway.order(:name)
    render 'index'
  end

  get :new do
    @ssh_gateway = session['ssh_gateway'] || SSHGateway.new(active: true)
    session.delete 'ssh_gateway'

    render 'new'
  end

  post :new do
    obj_params = params.fetch('ssh_gateway')
    if obj_params.key? 'active'
      obj_params['active'] = to_bool(obj_params['active'])
    end
    ssh_user = get_or_404(SSHUser, obj_params.delete('ssh_user'))
    ssh_gateway = SSHGateway.new(obj_params)
    ssh_gateway.ssh_user = ssh_user

    if ssh_gateway.valid?
      ssh_gateway.save
      redirect(url(:ssh_gateways, :index),
               success: "Created SSH gateway #{ ssh_gateway.name }")
    else
      # TODO: Marshal
      session['ssh_gateway'] = ssh_gateway
      redirect(url(:ssh_gateways, :new),
               form_error: pp_form_errors(ssh_gateway.errors))
    end
  end

  get :show, map: '/ssh_gateways/:id' do
    @ssh_gateway = get_or_404(SSHGateway, params.fetch('id').to_i)
    render 'show'
  end

  get :edit, map: '/ssh_gateways/:id/edit' do
    @ssh_gateway = session['ssh_gateway'] ||
                   get_or_404(SSHGateway, params.fetch('id').to_i)
    session.delete 'ssh_gateway'

    render 'edit'
  end

  post :edit, map: '/ssh_gateways/:id/edit' do
    ssh_gateway = get_or_404(SSHGateway, params.fetch('id').to_i)

    obj_params = params.fetch('ssh_gateway')
    if obj_params.key? 'active'
      obj_params['active'] = to_bool(obj_params['active'])
    end
    ssh_user = get_or_404(SSHUser, obj_params.delete('ssh_user'))
    ssh_gateway.set(obj_params)
    ssh_gateway.ssh_user = ssh_user

    if ssh_gateway.valid?
      ssh_gateway.save
      redirect(url(:ssh_gateways, :show, id: ssh_gateway.id),
               success: "Modified #{ ssh_gateway.name }")
    else
      # TODO: Marshal
      session['ssh_gateway'] = ssh_gateway
      redirect(url(:ssh_gateways, :edit, id: ssh_gateway.id),
               form_error: pp_form_errors(ssh_gateway.errors))
    end
  end

  post :delete, map: '/ssh_gateways/:id/delete' do
    ssh_gateway = get_or_404(SSHGateway, params.fetch('id').to_i)

    ssh_gateway.destroy
    redirect(url(:ssh_gateways, :index))
  end
end
