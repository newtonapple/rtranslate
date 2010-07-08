# The program is a simple, unofficial, ruby client API
# for using Google Translate.
#
# Author::    Dingding Ye  (mailto:yedingding@gmail.com)
# Copyright:: Copyright (c) 2007 Dingding Ye
# License::   Distributes under MIT License

module Translate
  class UnsupportedLanguagePair < StandardError
  end

  class RTranslate
    # Google AJAX Language REST Service URL
    GOOGLE_TRANSLATE_URL = "http://ajax.googleapis.com/ajax/services/language/translate"
    GOOGLE_TRANSLATE_URI = URI.parse(GOOGLE_TRANSLATE_URL)

    # Default version of Google AJAX Language API
    DEFAULT_VERSION = "1.0"

    attr_accessor :version, :key
    attr_reader :default_from, :default_to

    class << self
      def translate(text, from, to, options={})
        RTranslate.new.translate(text, options.merge(:from => from, :to => to))
      end
      alias_method :t, :translate

      def translate_strings(text_array, from, to, options={})
        RTranslate.new.translate_strings(text_array, options.merge(:from => from, :to => to))
      end

      def translate_string_to_languages(text, options={})
        RTranslate.new.translate_string_to_languages(text, options)
      end

      def batch_translate(translate_options)
        RTranslate.new.batch_translate(translate_options)
      end
    end

    def initialize(version = DEFAULT_VERSION, key = nil, default_from = nil, default_to = nil, proxy_url=nil)
      @version = version
      @key = key
      @default_from = default_from
      @default_to = default_to
      
      if proxy_url
        proxy_uri = URI.parse(proxy_url) 
        @default_proxy = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
      end
      
      if @default_from && !(Google::Lanauage.supported?(@default_from))
        raise StandardError, "Unsupported source language '#{@default_from}'"
      end

      if @default_to && !(Google::Lanauage.supported?(@default_to))
        raise StandardError, "Unsupported destination language '#{@default_to}'"
      end
    end

    # translate the string from a source language to a target language.
    #
    # Configuration options:
    # * <tt>:from</tt> - The source language
    # * <tt>:to</tt> - The target language
    # * <tt>:format</tt> - "html", "text" , or nil (same as "html")
    # * <tt>:chunk_size</tt> - Number of characters per request, max 5000.
    # * <tt>:proxy</tt> - Relay traffic through an HTTP proxy, e.g. Tor: "http://127.0.0.1:8118"
    def translate(text, options={})
      from = options[:from] || @default_from
      to = options[:to] || @default_to

      # Google limits request to 5000 chars: http://code.google.com/apis/ajaxlanguage/terms.html
      chunk_size = options[:chunk_size].to_i
      chunk_size = 5000 if (chunk_size <= 0 || chunk_size > 5000)

      if (from.nil? || Google::Language.supported?(from)) && Google::Language.supported?(to)
        from = from ? Google::Language.abbrev(from) : nil
        to = Google::Language.abbrev(to)
        langpair = "#{from}|#{to}"
        text.mb_chars.scan(/.{1,#{chunk_size}}/m).inject("") do |result, st|
          data = {'q' => st, 'langpair' => langpair, 'v' => @version}
          data['key'] = @key if @key
          data['format'] = options[:format] if options[:format]
          result += do_translate(data, options[:proxy])
        end
      else
        raise UnsupportedLanguagePair, "Translation from '#{from}' to '#{to}' isn't supported yet!"
      end
    end

    # translate several strings, all from the same source language to the same target language.
    #
    # Configuration options
    # * <tt>:from</tt> - The source language
    # * <tt>:to</tt> - The target language
    def translate_strings(text_array, options={})
      text_array.collect do |text|
        self.translate(text, options)
      end
    end

    # Translate one string into several languages.
    #
    # Configuration options
    # * <tt>:from</tt> - The source language
    # * <tt>:to</tt> - The target language list
    # Example:
    #
    # translate_string_to_languages("China", {:from => "en", :to => ["zh-CN", "zh-TW"]})
    def translate_string_to_languages(text, option)
      option[:to].collect do |to|
        self.translate(text, { :from => option[:from], :to => to })
      end
    end

    # Translate several strings, each into a different language.
    #
    # Examples:
    #
    # batch_translate([["China", {:from => "en", :to => "zh-CN"}], ["Chinese", {:from => "en", :to => "zh-CN"}]])
    def batch_translate(translate_options)
      translate_options.collect do |text, option|
        self.translate(text, option)
      end
    end

    private

    def do_translate(data, proxy) #:nodoc:
      jsondoc = http(proxy).post_form(GOOGLE_TRANSLATE_URI, data).response.body

      response = JSON.parse(jsondoc)
      if response["responseStatus"] == 200
        response["responseData"]["translatedText"]
      else
        raise StandardError, response["responseDetails"]
      end
    rescue Exception => e
      raise StandardError, e.message
    end

    def http(proxy)
      proxy ||= @default_proxy

      if proxy.is_a?(String)
        proxy_uri = URI.parse(proxy)
        proxy = Net::HTTP::Proxy(proxy_uri.host, proxy_uri.port, proxy_uri.user, proxy_uri.password)
      end

      proxy || Net::HTTP
    end

  end  
end
