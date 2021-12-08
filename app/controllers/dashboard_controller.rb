class DashboardController < ApplicationController
    def last_measure
        render json: data.last
    end

    def weekly_measure
        weekly_measure = []
        data.reverse.each_with_index { | measure, index | index < 5 ? weekly_measure << measure : break }

        render json: weekly_measure
    end

    private

    def data
        firestore = firebase_connection
        measured_data = firestore.col "device_data"

        return measured_data.get.map { |measure| measure.data }.sort_by { |measure| measure[:datetime] }
    end
end