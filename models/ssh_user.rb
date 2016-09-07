class SSHUser < Sequel::Model
  plugin :validation_helpers

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
end
