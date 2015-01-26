require 'data_policy/version'
require 'data_policy/policy'

module DataPolicy

  def self.included(base)
    base.extend DataPolicy::ClassMethods
  end

  module ClassMethods

    def data_policy(policy=nil, &block)
      if block_given?
        @data_policy = Proc.new do
          policy = load_policy(policy)
          policy.reload if policy.kind_of?(ActiveRecord::Base)
          policy.instance_eval &block
          policy
        end
      else
        @data_policy
      end
    end

    def load_policy(object)
      if object.is_a?(Proc)
        if object.lambda?
          callable_object = object.call
          return callable_object
        end
      else
        object
      end
    end

  end

  def apply_policy
    klass = self.class
    klass.data_policy.call.policies.each do |policy|
      @return = policy.call(self)
      break if @return
    end
    return @return
  end

end
