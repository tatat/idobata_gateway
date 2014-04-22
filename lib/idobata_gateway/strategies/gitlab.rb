require 'idobata_gateway/strategies/base'

module IdobataGateway
  module Strategies
    class GitLab < Base
      def build
        case payload.object_kind
        when 'issue'
          build_issue
        when 'merge_request'
          build_merge_request
        else
          build_push
        end
      end

      def build_push
        ref    = payload.ref.gsub(%r{\Arefs/heads/}, '')
        locals = {ref: ref}

        if payload.before =~ /000000/
          render 'gitlab.push.new.html.haml', locals
        elsif payload.after =~ /000000/
          render 'gitlab.push.delete.html.haml', locals
        else
          render 'gitlab.push.html.haml', locals
        end
      end

      def build_issue
        render 'gitlab.issue.html.haml', {attributes: payload.object_attributes}
      end

      def build_merge_request
        render 'gitlab.merge_request.html.haml', {attributes: payload.object_attributes}
      end
    end

    register :gitlab, as: 'GitLab'
  end
end