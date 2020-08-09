class SongsController < ApplicationController
  before_action :set_song, only: [:show, :edit, :update, :destroy]
  before_action :require_song_provider_create, only:[:new, :create]
  before_action :require_song_provider_edit, only: [:edit,:update, :destroy]
  skip_before_action :verify_authenticity_token, only: [:search]
  # GET /songs
  # GET /songs.json
  def index
    @songs = Song.all
    @content_text = "Songs For You"
  end

  # GET /songs/1
  # GET /songs/1.json
  def show
  end

  # GET /songs/new
  def new
    @song = Song.new
  end

  # GET /songs/1/edit
  def edit
  end

  # POST /songs
  # POST /songs.json
  def create
  
    @song = current_user.songs.create(song_params)
    @song.user_id = current_user.id
    @song.song_url = YouTubeAddy.extract_video_id(@song.song_url)
    respond_to do |format|
      if @song.save
        format.html { redirect_to new_song_path, notice: 'Song was successfully created.' }
        format.json { render :show, status: :created, location: @song }
      else
        format.html { render :new }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /songs/1
  # PATCH/PUT /songs/1.json
  def update
    respond_to do |format|
      if @song.update(song_params)
        format.html { redirect_to @song, notice: 'Song was successfully updated.' }
        format.json { render :show, status: :ok, location: @song }
      else
        format.html { render :edit }
        format.json { render json: @song.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /songs/1
  # DELETE /songs/1.json
  def destroy
    @song.destroy
    respond_to do |format|
      format.html { redirect_to songs_url, notice: 'Song was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
  #post songs/search
  def search
    
    search_song = Song.where(name: params[:name].upcase)
    @songs = search_song
    puts "===================="
    puts params[:name]
    puts search_song
    puts "===================="
    
    render "index"

  end
   
  #post songs/viewyoursongs
  def addedsongs
    @content_text = "Songs Added By You"
    @songs = Song.where(user_id: current_user.id)
    @edit_access = true
    puts"==============="
    puts @songs
    puts"==============="
    render 'index'
  end





  #=========================================================
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_song
      @song = Song.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def song_params
      params.require(:song).permit(:name, :description, :song_url, :albumn_id, :year)
    end

    def require_song_provider_edit
      
      if logged_in? && current_user.id != @song.user_id
        flash[:notice] = "You cannot edit/delete songs you have not uploaded"
        redirect_to songs_path
      elsif !logged_in?
        redirect_to songs_path
      end 
    end

    def require_song_provider_create
        if logged_in?
          unless current_user.type_of_user 
            flash[:notice] = "You cannot perform such actions"
            redirect_to songs_path
          end
        else
          redirect_to songs_path
        end
    end
end

#since gen was not working this is you tube id extracter
class YouTubeAddy
  URL_FORMATS = {
      regular: /^(https?:\/\/)?(www\.)?youtube.com\/watch\?(.*\&)?v=(?<id>[^&]+)/,
      shortened: /^(https?:\/\/)?(www\.)?youtu.be\/(?<id>[^&]+)/,
      embed: /^(https?:\/\/)?(www\.)?youtube.com\/embed\/(?<id>[^&]+)/,
      embed_as3: /^(https?:\/\/)?(www\.)?youtube.com\/v\/(?<id>[^?]+)/,
      chromeless_as3: /^(https?:\/\/)?(www\.)?youtube.com\/apiplayer\?video_id=(?<id>[^&]+)/
  }

  INVALID_CHARS = /[^a-zA-Z0-9\:\/\?\=\&\$\-\_\.\+\!\*\'\(\)\,]/

  def self.has_invalid_chars?(youtube_url)
    !INVALID_CHARS.match(youtube_url).nil?
  end

  def self.extract_video_id(youtube_url)
    return nil if has_invalid_chars?(youtube_url)

    URL_FORMATS.values.each do |format_regex|
      match = format_regex.match(youtube_url)
      return match[:id] if match
    end
  end

  def self.youtube_embed_url(youtube_url, width = 420, height = 315)
    vid_id = extract_video_id(youtube_url)
    %(<iframe width="#{width}" height="#{height}" src="http://www.youtube.com/embed/#{vid_id}" frameborder="0" allowfullscreen></iframe>)
  end

  def self.youtube_regular_url(youtube_url)
    vid_id = extract_video_id(youtube_url)
    "http://www.youtube.com/watch?v=#{ vid_id }"
  end

  def self.youtube_shortened_url(youtube_url)
    vid_id = extract_video_id(youtube_url)
    "http://youtu.be/#{ vid_id }"
  end
end
