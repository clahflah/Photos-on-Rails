class CollectionsController < ApplicationController
  def new
    @collection = Collection.new
    @bookmark = Bookmark.new
    authorize @collection
  end

  def create
    @collection = Collection.new(collection_params)
    authorize @collection
    if @collection.save!
      params[:collection][:photo_ids].delete("")
      params[:collection][:photo_ids].each do |photo|
        @bookmark = Bookmark.new(photo_id: photo.to_i, collection: @collection)
        @bookmark.save!
      end
      flash[:notice] = "Album saved."
      redirect_to collection_path(@collection)
    else
      render :new
    end
  end

  private

  def collection_params
    params.require(:collection).permit(:name, :description)
  end
end
