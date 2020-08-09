class PlaylistsController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:create, :search]
    before_action :set_playlist, only: [ :destroy]
    before_action :set_playlist_show, only: [:show]
    def new
        @playlist = Playlist.new
    end

    def create
        @playlist = current_user.playlists.create(name: params[:name])
        respond_to do |format|
            if @playlist.save
              format.html { redirect_to show_playlist_path, notice: 'Playlist was successfully created.' }
            else
              format.html { render playlist }
            end
        end
    end

    def show
        @content_text = " Your Playlists"
    end

    def destroy
        @playlist.destroy
        respond_to do |format|
            format.html { redirect_to show_playlist_path, notice: 'Playlist was successfully destroyed.' }
        end
    end

    def search
        search_playlist = Playlist.where(name: params[:name].upcase)
        @playlists = search_playlist
        if search_playlist
            @content_text = "Playlist searched for"
            render "show"
        else
            @content_text = "Playlist not found"
            redirect_to show_playlist_path
        end
    end
    private
    # Use callbacks to share common setup or constraints between actions.
    def set_playlist_show
      @playlists = Playlist.where(user_id: current_user)
    end
    def set_playlist
        @playlist = Playlist.find(params[:id])
    end
    
end
