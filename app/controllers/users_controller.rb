class UsersController < ApplicationController
    def create
        require "google/cloud/firestore"
        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"

        params = JSON.parse request.body.read
        doc_ref = firestore.doc "users/#{params['id']}"
        doc_ref.set(params)

        render json: params
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
        user_by_id = user_by_id(users)

        user_by_id.nil? ? render(json: {error: "User not found"}, status: 404) : render(json: user_by_id)
    end

    def update
        require "google/cloud/firestore"
        firestore = Google::Cloud::Firestore.new project_id: "nile-2ae8a"

        users = firestore.col "users"
        user_by_id = user_by_id(users)
        user_by_id.nil? ? render(json: {error: "User not found"}, status: 404) : create
    end

    private

    def user_by_id(users)
        users.get do |user|
            return user.data if user.document_id == params[:id]
        end
        # return null if no user is found
        return nil
    end
end
