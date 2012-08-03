class EventableSpec
  include Vienna::Eventable

  attr_reader :events
end