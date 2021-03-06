# frozen_string_literal: true

RSpec.describe Dry::Configurable, '.included' do
  shared_examples 'configure' do
    it 'extends ClassMethods' do
      expect(configurable_klass.singleton_class.included_modules)
        .to include(Dry::Configurable::ClassMethods)
    end

    it 'includes InstanceMethods' do
      expect(configurable_klass.included_modules)
        .to include(Dry::Configurable::InstanceMethods)
    end

    it 'raises when Dry::Configurable has already been included' do
      expect {
        configurable_klass.include(Dry::Configurable)
      }.to raise_error(Dry::Configurable::AlreadyIncluded)
    end

    it 'ensures `.config` is not defined' do
      expect(configurable_klass).not_to respond_to(:config)
    end

    it 'ensures `.configure` is not defined' do
      expect(configurable_klass).not_to respond_to(:configure)
    end

    it 'ensures `#config` returns instance of Dry::Configurable::Config' do
      expect(configurable_klass.new.config).to be_a(Dry::Configurable::Config)
    end
  end

  let(:configurable_klass) { Class.new.include(Dry::Configurable) }

  it_behaves_like 'configure'

  context 'when #initialize is defined in configurable class' do
    let(:configurable_klass) do
      Class.new do
        include Dry::Configurable
        def initialize; end
      end
    end

    it_behaves_like 'configure'
  end
end
