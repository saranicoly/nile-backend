class UsersController < ApplicationController
    def create
        require "google/cloud/firestore"
        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"
        doc_ref = firestore.doc "users/"

        doc_ref.set(JSON.parse(request.raw_post))
    end

    def index
        # return an array with all the users
        require "google/cloud/firestore"

        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"
        users = firestore.col "users"

        all_users = users.get.map do |user|
            user.data
        end

        render json: all_users
    end

    def show
        # return a single user
        require "google/cloud/firestore"

        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"
        users = firestore.col "users"

        user = users.get(params[:id]).data

        render json: user
    end
end
