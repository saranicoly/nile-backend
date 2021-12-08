class DashboardController < ApplicationController
    def last_measure
        require "google/cloud/firestore"

        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"
        measured_data = firestore.col "device_data"

        measured_data = measured_data.get.map do |measure|
            measure.data
        end

        last_measure = measured_data.sort_by { |measure| measure[:datetime] }.last

        render json: last_measure
    end

    # def weekly_measure
    #     require "google/cloud/firestore"

    #     firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"
    #     users = firestore.col "device_data"

    #     @weekly_measure = users.order(:timestamp, :desc).limit(1).get.map do |doc|
    #         doc.data
    #     end
    # end
end