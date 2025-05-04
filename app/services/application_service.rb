class ApplicationService
  attr_reader :args, :result

  def self.call(**args)
    new(args).call
  end

  protected
    def initialize(args)
      @args   = args
      @result = nil
    end

    def call
      raise NotImplementedError, "Method should be implemented in concrete class."
    end

  private
    def build_data(attrs)
      attrs.merge(payload: @args)
    end

    def handle_failure(**attrs)
      OpenStruct.new(success?: false, data: build_data(attrs))
    end

    def handle_success(**attrs)
      OpenStruct.new(success?: true, data: build_data(attrs))
    end
end
