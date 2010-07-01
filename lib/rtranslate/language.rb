module Google
  module Language
    Languages = {
      'af'    => 'AFRIKAANS',
      'sq'    => 'ALBANIAN',
      'am'    => 'AMHARIC',
      'ar'    => 'ARABIC',
      'hy'    => 'ARMENIAN',
      'az'    => 'AZERBAIJANI',
      'eu'    => 'BASQUE',
      'be'    => 'BELARUSIAN',
      'bn'    => 'BENGALI',
      'bh'    => 'BIHARI',
      'br'    => 'BRETON',
      'bg'    => 'BULGARIAN',
      'my'    => 'BURMESE',
      'ca'    => 'CATALAN',
      'chr'   => 'CHEROKEE',
      'zh'    => 'CHINESE',
      'zh-CN' => 'CHINESE_SIMPLIFIED',
      'zh-TW' => 'CHINESE_TRADITIONAL',
      'co'    => 'CORSICAN',
      'hr'    => 'CROATIAN',
      'cs'    => 'CZECH',
      'da'    => 'DANISH',
      'dv'    => 'DHIVEHI',
      'nl'    => 'DUTCH',  
      'en'    => 'ENGLISH',
      'eo'    => 'ESPERANTO',
      'et'    => 'ESTONIAN',
      'fo'    => 'FAROESE',
      'tl'    => 'FILIPINO',
      'fi'    => 'FINNISH',
      'fr'    => 'FRENCH',
      'fy'    => 'FRISIAN',
      'gl'    => 'GALICIAN',
      'ka'    => 'GEORGIAN',
      'de'    => 'GERMAN',
      'el'    => 'GREEK',
      'gu'    => 'GUJARATI',
      'ht'    => 'HAITIAN_CREOLE',
      'iw'    => 'HEBREW',
      'hi'    => 'HINDI',
      'hu'    => 'HUNGARIAN',
      'is'    => 'ICELANDIC',
      'id'    => 'INDONESIAN',
      'iu'    => 'INUKTITUT',
      'ga'    => 'IRISH',
      'it'    => 'ITALIAN',
      'ja'    => 'JAPANESE',
      'jw'    => 'JAVANESE',
      'kn'    => 'KANNADA',
      'kk'    => 'KAZAKH',
      'km'    => 'KHMER',
      'ko'    => 'KOREAN',
      'ku'    => 'KURDISH',
      'ky'    => 'KYRGYZ',
      'lo'    => 'LAO',
      'la'    => 'LATIN',
      'lv'    => 'LATVIAN',
      'lt'    => 'LITHUANIAN',
      'lb'    => 'LUXEMBOURGISH',
      'mk'    => 'MACEDONIAN',
      'ms'    => 'MALAY',
      'ml'    => 'MALAYALAM',
      'mt'    => 'MALTESE',
      'mi'    => 'MAORI',
      'mr'    => 'MARATHI',
      'mn'    => 'MONGOLIAN',
      'ne'    => 'NEPALI',
      'no'    => 'NORWEGIAN',
      'oc'    => 'OCCITAN',
      'or'    => 'ORIYA',
      'ps'    => 'PASHTO',
      'fa'    => 'PERSIAN',
      'pl'    => 'POLISH',
      'pt'    => 'PORTUGUESE',
      'pt-PT' => 'PORTUGUESE_PORTUGAL',
      'pa'    => 'PUNJABI',
      'qu'    => 'QUECHUA',
      'ro'    => 'ROMANIAN',
      'ru'    => 'RUSSIAN',
      'sa'    => 'SANSKRIT',
      'gd'    => 'SCOTS_GAELIC',
      'sr'    => 'SERBIAN',
      'sd'    => 'SINDHI',
      'si'    => 'SINHALESE',
      'sk'    => 'SLOVAK',
      'sl'    => 'SLOVENIAN',
      'es'    => 'SPANISH',
      'su'    => 'SUNDANESE',
      'sw'    => 'SWAHILI',
      'sv'    => 'SWEDISH',
      'syr'   => 'SYRIAC',
      'tg'    => 'TAJIK',
      'ta'    => 'TAMIL',
      'tt'    => 'TATAR',
      'te'    => 'TELUGU',
      'th'    => 'THAI',
      'bo'    => 'TIBETAN',
      'to'    => 'TONGA',
      'tr'    => 'TURKISH',
      'uk'    => 'UKRAINIAN',
      'ur'    => 'URDU',
      'uz'    => 'UZBEK',
      'ug'    => 'UIGHUR',
      'vi'    => 'VIETNAMESE',
      'cy'    => 'WELSH',
      'yi'    => 'YIDDISH',
      'yo'    => 'YORUBA',
      ''      => 'UNKNOWN'
    }
      
    # judge whether the language is supported by google translate
    def supported?(language)
      if Languages.key?(language) || Languages.value?(language.upcase)
        true
      else
        false
      end
    end
    module_function :supported?

    # get the abbrev of the language
    def abbrev(language)
      if supported?(language)
        if Languages.key?(language)
          language
        else
          language.upcase!
          Languages.each do |k,v|
            if v == language
              return k
            end
          end
        end
      else
        nil
      end
    end
    module_function :abbrev
  end
end
