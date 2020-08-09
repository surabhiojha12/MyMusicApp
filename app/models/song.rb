class Song < ActiveRecord::Base
    belongs_to :user
    has_many :playlist_song, dependent: :destroy
    has_many :users, through: :playlist_song
   
    validates :name, presence: true, length: {minimum: 5}
    validates :description, presence: true 
    validates :year, presence: true, length: {minimum: 4, maximum: 4}
    validates :song_url, presence: true
    validate :upper_case_song_name, on: :create
    

    def upper_case_song_name
        self.name = name.upcase
    end
end
