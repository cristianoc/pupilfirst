class ApplicationMutatorV2
  include ActiveModel::Model

  attr_reader :context

  def initialize(attributes, context)
    @context = context
    assign_attributes(attributes)
    raise UnauthorizedMutationException unless authorized?
  end

  def respond_to_missing?(name, *args)
    context.key?(name.to_sym) || super
  end

  def method_missing(name, *args)
    name_symbol = name.to_sym
    super unless context.key?(name_symbol)

    context[name_symbol]
  end

  def error_codes
    errors.messages.values.flatten
  end

  def notify(kind, title, body)
    context[:notifications].push(kind: kind, title: title, body: body)
  end

  def notify_errors
    notify(:error, 'Something went wrong!', error_codes.join(", "))
  end

  def pundit_class
    raise 'You need to set pundit_class in your mutators and resolvers.'
  end

  def pundit_method
    (self.class.name.underscore.split('_') - ['mutator']).join('_') + '?'
  end

  def pundit_record
    nil
  end

  def authorized?
    pundit_class.new(context, pundit_record).send(pundit_method)
  end
end
