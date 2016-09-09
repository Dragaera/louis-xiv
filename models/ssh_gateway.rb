class SSHGateway < Sequel::Model
  plugin :validation_helpers

  def before_validation
    self.name = host if name.nil? || name.empty?
  end

  def validate
    validates_presence [:host, :ssh_user]
  end

  def ssh_gateway
    ssh_host, ssh_port = host.split(':')
    opts = {
      port:                    ssh_port || 22,
      non_interactive:         true,  # Don't offer interactive password prompt
      use_agent:               false, # Prevent using SSH agent of server
      config:                  false, # Prevent using OpenSSH config of server
      global_known_hosts_file: [],    # Don't load global known-hosts files
      user_known_hosts_file:   [],    # Don't load/touch user known-hosts files
    }
    opts.merge! case ssh_user.authentication_method
                when :private_key
                  { key_data: [ssh_user.private_key] }
                when :passphrase
                  { password: ssh_user.password }
                end

    Net::SSH::Gateway.new(ssh_host, ssh_user.user, opts)
  end

  many_to_one :ssh_user,           delay_pks: true, class: :SSHUser
  one_to_many :solar_log_stations, delay_pks: true
end
