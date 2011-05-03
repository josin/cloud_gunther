class MacroProcesor
  
  MACRO_REGEXP = /\{{2}([^}]*)\}{2}/
  
  def self.process_macros(text, context)
    text.gsub!(MACRO_REGEXP) do |m|
      all, macro = $&, $1
      case macro
        when "BINARY"
          context.algorithm_binary.attachment.data_file_name if context.respond_to? :algorithm_binary
        when "INPUTS"
          context.inputs if context.respond_to? :inputs
      end
    end
  end

end # of class

