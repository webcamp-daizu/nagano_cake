class Public::SearchesController < ApplicationController
  def genre_search
    @value = params["search"]["value"]
    @how = params["search"]["how"]
    @datas = search_for(@how, @value)
  end

  def item_search
    @items = Item.search(params[:keyword]).page(params[:page]).per(8)
    @keyword = params[:keyword]
  end

  private

  def match(value)
    @genre = Genre.find_by(name: value)
    Item.where(genre_id: @genre)
  end

  def search_for(how, value)
    case how
    when 'match'
      match(value)
    end
  end
end
