class SSHUser < Sequel::Model
  plugin :validation_helpers

  def before_validation
    self.name = user if name.nil? || name.empty?
  end

  def validate
    validates_presence [:user]

    # TODO: Extract into `validates_any_presence` validation.
    both_empty = [password, private_key].map do |i|
      i.nil? || (i.respond_to?(:empty?) && i.empty?) || (i =~ /^\s+$/)
    end.all?
    if both_empty
      errors.add(:password, 'or private key must be defined')
      errors.add(:private_key, 'or password must be defined')
    end
  end

  one_to_many :ssh_gateways, delay_pks: true, class: :SSHGateway

  def password=(v)
    if v.nil? || v.empty?
      super(nil)
    else
      super(v)
    end
  end

  def private_key=(v)
    if v.nil?  || v.empty?
      super(nil)
    else
      super(v)
    end
  end

  def authentication_method
    if private_key && !private_key.empty?
      :private_key
    elsif password && !password.empty?
      :passphrase
    else
      :none
    end
  end
end
