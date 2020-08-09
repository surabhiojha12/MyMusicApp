class PlaylistSongController < ApplicationController
    skip_before_action :verify_authenticity_token, only: [:add]
    before_action :set_playlist, only: [:add, :show]
    def add
        @songplaylist = @playlist.playlist_song.create(song_id: params[:song_id])
        redirect_to show_playlist_path
    end

    def show
        @content_text = @playlist.name
        @songs = @playlist.songs
        render 'songs/index'
    end

    private
    def set_playlist
        @playlist = Playlist.find(params[:playlist_id])
    end
end
