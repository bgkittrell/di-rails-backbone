module FormControl
  def control(object_name, method, label, options = {}, &block)
    object = instance_variable_get("@#{object_name}")
    output =  %{ <div class="control-group#{ " error" if object.errors.has_key? method }"> } +
      label(object_name, :url, label, :class => 'control-label') +
      %{ <div class="controls"> } +
      (block_given? ?  capture(&block) : text_field(object_name, method, options)) +
      (object.errors.has_key?(method) ? %{ <span class="help-inline"> #{object.errors[method].first()} </span> } : "" ) +
      %{ </div> } +
      %{ </div> }
    return output.html_safe
  end
end

module FormControlBuilder
  def control(method, label, options = {}, &block)
    @template.control(@object_name, method, label, objectify_options(options), &block).html_safe
  end
end

ActionView::Helpers::FormHelper.send(:include, FormControl)
ActionView::Base.send(:include, FormControl)
ActionView::Helpers::FormBuilder.send(:include, FormControlBuilder)

