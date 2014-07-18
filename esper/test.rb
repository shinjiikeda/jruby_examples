#!/usr/bin/env jruby

require 'java'

java_import 'com.espertech.esper.client.Configuration'
java_import 'com.espertech.esper.client.EPServiceProvider'
java_import 'com.espertech.esper.client.EPServiceProviderManager'
java_import 'com.espertech.esper.client.EPStatement'
java_import 'com.espertech.esper.client.UpdateListener'
java_import 'com.espertech.esper.client.EventBean'
java_import 'java.util.HashMap'


class TestListener
  include UpdateListener

  def initialize()
    puts "Initialized EsperListener"
  end
  
  java_signature 'void update(EventBean[], EventBean[])'
  def update(newEvents, oldEvents)
    newEvents.each do |event|
      puts "New event: #{event.getUnderlying.toString}"
    end
  end
end

config = com.espertech.esper.client.Configuration.new

map = java.util.HashMap.new
map.put("key", java.lang.String.java_class)
map.put("val", java.lang.Long.java_class)
config.addEventType("SampleEvent", map)

serv = EPServiceProviderManager.getDefaultProvider(config)
st = serv.getEPAdministrator().createEPL("select * from SampleEvent(val >= 5)");

listener = TestListener.new
st.addListener(listener)


event = java.util.HashMap.new
event.put("key", "test1")
event.put("val", 100)
serv.getEPRuntime.sendEvent(event, "SampleEvent")

event.put("val", 10)
serv.getEPRuntime.sendEvent(event, "SampleEvent")
