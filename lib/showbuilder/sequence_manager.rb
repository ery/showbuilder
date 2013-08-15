module Showbuilder
  class SequenceManager
    class << self

      attr_accessor :current_sequence

      def initialize_sequence(params)
        self.current_sequence = get_sequence_start_point(params)
      end

      def get_sequence
        sequence = self.current_sequence
        self.current_sequence += 1
        return sequence
      end

      # per_page: 10
      #   page: 1, start_point:  1
      #   page: 2, start_point: 10
      #   page: 3, start_point: 20
      # per_page: 20
      #   page: 1, start_point:  1
      #   page: 2, start_point: 21
      #   page: 3, start_point: 31
      # per_page: 30
      #   page: 1, start_point:  1
      #   page: 2, start_point: 31
      #   page: 3, start_point: 61
      def get_sequence_start_point(params)
        param_page     = params[:page] || 1
        param_per_page = params[:per_page] || 10

        current_page     = param_page.to_i
        current_per_page = param_per_page.to_i

        offset = (current_page - 1) * current_per_page

        start_point = offset + 1
        return start_point
      end

    end
  end
end