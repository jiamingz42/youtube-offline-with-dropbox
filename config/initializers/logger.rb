# Formats implementation comes from gem 'colored'
# Ref: https://github.com/defunkt/colored/blob/master/lib/colored.rb
#
# Formats values
#   'black'
#   'red'
#   'green'
#   'yellow'
#   'blue'
#   'magenta'
#   'cyan'
#   'white'
#
#   'clear'
#   'bold'
#   'underline'
#   'reversed'
#
#   'red_on_white'
#   'yellow_on_cyan'
#   .....

class << Rails.logger

  LOG_LEVELS = {
    :debug    => { :formats => ['blue']            },
    :info     => { :formats => ['green']           },
    :warn     => { :formats => ['yellow']          },
    :error    => { :formats => ['red']             },
    :fatal    => { :formats => ['red', 'reversed'] },
    :unknown  => { :formats => []                  },
  }

  # ======= Example
  #   Rails.logger.debug!('Send debug message')
  #   Rails.logger.debug!('Send debug message', :object => current_user)
  #   Rails.logger.error!('Send error message', :object => current_user, :binding => self.binding())

  LOG_LEVELS.each do |log_level, log_settings|
    formats = log_settings[:formats]
    define_method("#{log_level}!") do |log_body, options = {}|

      begin

        object  = options[:obj]
        binding = options[:context]

        log_prefix = get_log_prefix(binding)

        body_formats   = log_settings[:formats]
        prefix_formats = log_settings[:formats] + %w(underline)

        formated_body   = apply_formats(log_body, body_formats)
        formated_prefix = apply_formats(log_prefix, prefix_formats)

        log_message = get_log_message(formated_prefix, formated_body)

        self.send(log_level, log_message)

        if !object.nil? && object.respond_to?(:ai)
          object_repr = object.ai(:indent => 2)
          object_repr.split("\n").each do |line|
            self.send(log_level, line)
          end
        end

      rescue
        # TODO: just in case something goes wrong
      end

    end
  end

  private

  def get_log_prefix(binding)
    if !binding.nil?

      file = File.basename(eval("__FILE__", binding))
      line = eval("__LINE__", binding)

      klass = eval("self", binding)
      klass_name = (klass.class == Class) ? klass.name : klass.class.name

      method_name = eval("__method__", binding)

      return "#{klass_name}##{method_name}:#{line}"
    else
      return ''
    end
  end

  def apply_formats(text, formats)
    formats.each do |format|
      text = text.send(format)
    end
    text
  end

  def get_log_message(log_prefix, log_body)
    if log_prefix.blank?
      log_body
    else
      log_prefix + ' ' + log_body
    end
  end

end
