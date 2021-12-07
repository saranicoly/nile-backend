class UserController < ApplicationController
    def create
        require "google/cloud/firestore"
        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"
        doc_ref = firestore.doc "users/"

        doc_ref.set(JSON.parse(request.raw_post))
    end

    def index
        require "google/cloud/firestore"
        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"
        users = firestore.col "users"

        users.get do |user|
            puts "user: #{user.document_id} => #{user.data}"
        end
    end
end
