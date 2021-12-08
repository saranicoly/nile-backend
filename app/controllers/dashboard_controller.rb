class DashboardController < ApplicationController
    def last_measure
        firestore = firebase_connection
        measured_data = firestore.col "device_data"

        measured_data = measured_data.get.map do |measure|
            measure.data
        end

        last_measure = measured_data.sort_by { |measure| measure[:datetime] }.last

        render json: last_measure
    end

    def weekly_measure
        require "google/cloud/firestore"

        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"
        measured_data = firestore.col "device_data"
        measured_data = measured_data.get.map do |measure|
            measure.data
        end

        weekly_measure = []

        measured_data.sort_by { |measure| measure[:datetime] }.reverse.each_with_index do | measure, index |
            # this number is the number of sends in the week
            index < 5 ? weekly_measure << measure : break
        end

        render json: weekly_measure
    end
end