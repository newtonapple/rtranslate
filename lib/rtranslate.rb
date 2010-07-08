require 'uri'
require 'open-uri'
require 'net/http'

require File.join(File.dirname(__FILE__), 'rtranslate/language')
require File.join(File.dirname(__FILE__), 'rtranslate/rtranslate')
require File.join(File.dirname(__FILE__), 'rtranslate/detection')

begin
  require 'json'
rescue LoadError
  require 'rubygems'
  require 'json'
end

unless defined?(ActiveSupport)
  require 'activesupport'
end

$KCODE = 'u'

include Translate
def Translate.t(text, from, to, options={})
  RTranslate.translate(text, from, to, options)
rescue
  "Error: " + $!
end

def Translate.d(text)
  Detection.detect(text)
rescue
  "Error: " + $!
end
