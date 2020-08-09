class Playlist < ActiveRecord::Base
    belongs_to :user
    validate :upper_case_song_name, on: :create
    has_many :playlist_song, dependent: :destroy
    has_many :songs, through: :playlist_song

    def upper_case_song_name
        self.name = name.upcase
    end
end
