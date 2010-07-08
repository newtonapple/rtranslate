# encoding: utf-8

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
  require 'active_support'
  if ActiveSupport.respond_to?(:load_all!)
    require 'active_support/core_ext/string/multibyte'
  end
end

if RUBY_VERSION < '1.9'
  $KCODE = 'u'
end

def Translate.t(text, from, to, options={})
  Translate::RTranslate.translate(text, from, to, options)
rescue
  "Error: " + $!
end

def Translate.d(text)
  Translate::Detection.detect(text)
rescue
  "Error: " + $!
end
