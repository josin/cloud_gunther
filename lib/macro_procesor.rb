class MacroProcesor
  
  MACRO_REGEXP = /\{{2}([^}]*)\}{2}/
  
  class << self
    def process_macros(text, context)
      raise "Task instance required as context for macro processing." unless context.is_a?(Task)
      # Rails.logger.debug { "Macro processing: '#{text}', '#{context}'" }
    
      text.gsub!(MACRO_REGEXP) do |m|
        all, macro = $&, $1.downcase
        
        macro_method = "#{macro}_macro"
        begin
          self.send(macro_method, context)
        rescue
        end
      end

      text
    end
    
    private
    
    def binary_macro(context)
      context.algorithm_binary.attachment.data_file_name if context.respond_to? :algorithm_binary
    end
    
    def inputs_macro(context)
      context.inputs if context.respond_to? :inputs
    end
    
    def instances_count_macro(context)
      context.task_params[:instances_count]
    end
    
    def instance_id_macro(context)
      context.instance_id
    end
    
    def cloud_user_macro(context)
      "euca"
    end
    
    def unix_uid_macro(context)
      context.user.unix_uid
    end

    def unix_username_macro(context)
      context.user.unix_username
    end
    
    def logger
      Rails.logger
    end
    

  end # of self.class
end # of class

