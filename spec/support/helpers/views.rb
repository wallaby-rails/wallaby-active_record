def field_name_from(file_name)
  file_name[%r{/_?([^/]+)(\.[^\./]+\.erb|_[^\_/]+)_spec\.rb$}, 1]
end

def type_from(file_name)
  file_name.split('/')[-2]
end

def cell_class_from(file_name)
  file_name[%r{/spec/[^/]+/(.+)_spec\.rb$}, 1].camelize.constantize
end
