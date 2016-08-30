module Tasks
  class Test
    @queue = :tasks

    def self.perform(arg)
      puts "Test task firing!"
      puts arg
      puts "Test task fin"
    end
  end
end
