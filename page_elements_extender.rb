class AndroidParser
  
  def initialize exclude = []
    $do_not_include = exclude || []
  end
  
  class Appium::Android::AndroidElements
    
    def reset
      @result = []
    end

    def start_element(name, attrs = [], driver = driver)
      return if filter && !name.downcase.include?(filter)

      attributes = {}
      
      attrs.each do |key, value|
        
        #do not include this values
        next if $do_not_include.include? value

        if key.include? "-"
          key = key.gsub("-","_")
        end

        if key == "resource_id"
          key = "id"
        elsif key == "content_desc"
          key = "accessibilty_label"
        end
          
        if ["android:id/button2", "android:id/button1", "android:id/message", "android:id/alertTitle"].include? value
          attributes.merge!({"dialog" => "true"})
        end

        if value.empty?
          value = nil
        end

        if key == "bounds"
          bounds_array = value.scan(/\d*/).reject { |c| c.empty? }.map { |v| v = v.to_i }
          bounds_array_value = bounds_array.each_slice((bounds_array.size/2.0).round).to_a
          attributes["bounds_array"] = bounds_array_value
        end

        attributes[key] = value
      end

      eval_attrs = ["true", "false"]

      @result << attributes.reduce({}) do |memo, (k, v)|
        if eval_attrs.include? v.to_s
          v = eval(v) rescue false
        end
        memo.merge({ k.to_sym => v })
      end
    end
  end

  def page_objects(opts = {})
    class_name = opts.is_a?(Hash) ? opts.fetch(:class, nil) : opts
    results = get_android_inspect class_name
    results.map { |h| results.delete(h) if h.values.uniq == [nil] }
    results
  end

  def print_page_objects
    page_objects.each do |result|
      puts "\n#{result}\n"
      puts ""
    end
  end
end