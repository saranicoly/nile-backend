class ApplicationController < ActionController::Base
    protect_from_forgery unless: -> { request.format.json? }

    def firebase_connection
        require "google/cloud/firestore"

        return Google::Cloud::Firestore.new project_id: "nile-2ae8a"
    end
end
