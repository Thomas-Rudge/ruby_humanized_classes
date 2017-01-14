
def a(name, &block)
  name = name.to_sym
  @class_name = Object.const_set name, Class.new
  block.call if block_given?
end

def will_be(*args)
  @code = ""
  case args[0]
  when :initialized_with
    args = args[1..-1]
    @code = "class #{@class_name}\n  def initialize("
    args.each { |variable| @code += "#{variable}, " }
    @code = @code[0..-3] + ")\n"

    args.each do |variable|
      @code += "    @#{variable} = #{variable}\n"
    end

    @code += "  end\nend\n\n"
  end
end

def the_instance_variable(variable, type, value=nil)
  add_code = "class #{@class_name}\n"
  add_code += case type
    when :will_be_readable   then "  attr_reader "
    when :will_be_writable   then "  attr_writer "
    when :will_be_accessible then "  attr_accessor "
    when :will_be_set_to     then set_instance_variable_default(variable, value) ; return
    else return
  end

  add_code += ":#{variable}\nend\n\n"
  @code += add_code
end

def set_instance_variable_default(variable, value)
  if @code =~ /ze\(#{variable}, /
    @code.gsub!(/ze\(#{variable}, /, "ze(")
  elsif @code =~ /, #{variable}\)\n/m
    @code.gsub!(/, #{variable}\)\n/m, ")\n")
  elsif @code =~ /#{variable}, /
    @code.gsub!(/#{variable}, /, "")
  elsif @code[(@code=~/\n/m)+1..-1] =~ /\n/m
    @code.gsub!(/#{variable}/, "")
  end

  @code.gsub!(/@#{variable} = #{variable}/, "@#{variable} = #{value}")
  ""
end

def the_instance_variables(*args)
  args[0..-2].each { |variable| the_instance_variable(variable, args[-1]) }
end

def and_thats_it(*args)
  print @code if args.include? "now_show_me"
  eval(@code)
end
