# frozen_string_literal: true

module ERBLint
  class RunnerConfig
    def initialize(config = nil)
      @config = (config || {}).dup.deep_stringify_keys
    end

    def to_hash
      @config.dup
    end

    def for_linter(klass)
      klass_name = if klass.is_a?(String)
        klass.to_s
      elsif klass.is_a?(Class) && klass <= ERBLint::Linter
        klass.simple_name
      else
        raise ArgumentError, 'expected String or linter class'
      end
      LinterConfig.new(linters_config[klass_name] || {})
    end

    def merge(other_config)
      self.class.new(@config.deep_merge(other_config.to_hash))
    end

    def merge!(other_config)
      @config.deep_merge!(other_config.to_hash)
      self
    end

    class << self
      def default
        new(
          linters: {
            FinalNewline: {
              enabled: true,
            },
          },
        )
      end
    end

    private

    def linters_config
      @config['linters'] || {}
    end
  end
end