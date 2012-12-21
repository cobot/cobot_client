module CobotClient
  module XdmHelper
    def self.included(base)
      if base.ancestors.include?(ActionController::Base)
        base.class_eval do
          before_filter :capture_xdm_params
          helper_method :xdm_params
        end
      end
    end

    def xdm_params
      session.inject({}) do |hash, element|
        if element.first.match(/xdm\_/)
          hash[element.first] = element.last
        end
        hash
      end
    end

    def capture_xdm_params
      params.each do |key, value|
        if key.match(/xdm\_/)
          session[key] = value
        end
      end
    end
  end
end
