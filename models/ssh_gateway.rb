class SSHGateway < Sequel::Model
  plugin :validation_helpers

  def before_validation
    self.name = host if name.nil? || name.empty?
  end

  def validate
    validates_presence [:host, :ssh_user]
  end

  many_to_one :ssh_user,           delay_pks: true, class: :SSHUser
  one_to_many :solar_log_stations, delay_pks: true
end
