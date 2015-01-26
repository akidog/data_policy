module DataPolicy
  module Policy

    attr_reader :policies

    # TODO: REFACTOR LATER ! METODO CAGADO. Too lazy to fix it now
    def policy(name, &b)
      @policies ||= []
      @policies << Proc.new do |subject_class|
        args = send(name, subject_class)
        if args.kind_of? Array
          if args.reverse!.pop
            subject_class.instance_exec(args.reverse!) &b
            true
          else
            false
          end
        else
          if args
            subject_class.instance_eval &b
            true
          else
            false
          end
        end
      end
    end

  end
end
