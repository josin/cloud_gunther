# FIXME: to avoid 'warning: regexp match /.../n against to UTF-8 string'
module Rack
  module Utils
    def escape(s)
      EscapeUtils.escape_url(s)
    end
  end
end