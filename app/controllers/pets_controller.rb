class PetsController < ApplicationController
  before_action :set_pet, only: %i[show update destroy]
  before_action :set_user
  before_action :authenticate_user!

  # GET /pets
  def index
    @pets = Pet.where(user: @user)
    # render json: PetSerializer.new(@pets).serializable_hash
    render json: @pets, includes: %i[desc created_at], methods: %i[image_url]
  end

  # GET /pets/1
  def show
    render json: @pet
  end

  # POST /pets
  def create
    if params[:pet][:image].present?
      @pet = @user.pets.new(pet_params)
      @pet.image.attach(params[:pet][:image])
    else
      @pet = @user.pets.new(pet_params.except(:image))
      default_image_path = Rails.root.join('app', 'assets', 'pet_images', 'cat1.jpg')
      @pet.image.attach(io: File.open(default_image_path), filename: 'cat1.jpg', content_type: 'image/jpeg')
    end
  
    if @pet.save
      render json: @pet, status: :created, location: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /pets/1
  def update
    if @pet.update(pet_params)
      render json: @pet
    else
      render json: @pet.errors, status: :unprocessable_entity
    end
  end

  # DELETE /pets/1
  def destroy
    @pet.destroy
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_pet
    @pet = Pet.find(params[:id])
  end

  def set_user
    @user = current_user
  end

  # Only allow a list of trusted parameters through.
  def pet_params
    params.require(:pet).permit(:name, :pet_type, :date_of_birth, :size, :breed, :gender, :hair_length, :allergies, :extra_information,
                                :user_id, :image)
  end
end
