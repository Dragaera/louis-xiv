LouisXiv::App.controllers :ssh_users do
  get :index do
   @ssh_users = SSHUser.order(:user)
   render 'index'
  end

  get :new do
    @ssh_user = session['ssh_user'] || SSHUser.new(active: true)
    session.delete 'ssh_user'

    render 'new'
  end

  post :new do
    obj_params = params.fetch('ssh_user')
    if obj_params.key? 'active'
      obj_params['active'] = to_bool(obj_params['active'])
    end
    ssh_user = SSHUser.new(obj_params)

    if ssh_user.valid?
      ssh_user.save
      redirect(url(:ssh_users, :index), 
               success: "Created SSH user #{ ssh_user.name }")
    else
      # TODO: Marshal
      session['ssh_user'] = ssh_user
      redirect(url(:ssh_users, :new),
               form_error: pp_form_errors(ssh_user.errors))
    end
  end

  get :show, map: '/ssh_users/:id' do
    @ssh_user = get_or_404(SSHUser, params.fetch('id').to_i)
    render 'show'
  end

  get :edit, map: '/ssh_users/:id/edit' do
    @ssh_user = session['ssh_user'] ||
                get_or_404(SSHUser, params.fetch('id').to_i)
    session.delete 'ssh_user'

    render 'edit'
  end

  post :edit, map: '/ssh_users/:id/edit' do
    ssh_user = get_or_404(SSHUser, params.fetch('id').to_i)

    obj_params = params.fetch('ssh_user')
    if obj_params.key? 'active'
      obj_params['active'] = to_bool(obj_params['active'])
    end
    ssh_user.set(obj_params)

    if ssh_user.valid?
      ssh_user.save
      redirect(url(:ssh_users, :show, id: ssh_user.id),
               success: "Modified #{ ssh_user.name }")
    else
      # TODO: Marshal
      session['ssh_user'] = ssh_user
      redirect(url(:ssh_users, :edit, id: ssh_user.id),
               form_error: pp_form_errors(ssh_user.errors))
    end
  end

  post :delete, map: '/ssh_users/:id/delete' do
    ssh_user = get_or_404(SSHUser, params.fetch('id').to_i)

    if ssh_user.ssh_gateways.count > 0
      gws = ssh_user.ssh_gateways
      error_msg = "SSH user is used for #{ gws.count } gateways! (#{ gws.map(&:name).join(', ') })"
      redirect(url(:ssh_users, :show, id: ssh_user.id),
               error: error_msg)
    end

    ssh_user.destroy
    redirect(url(:ssh_users, :index))
  end
end
