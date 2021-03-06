class DecksController < ApplicationController

  def search
    if params[:deck][:term]
      if params[:deck][:term] == 'default'
        @decks = Deck.default_search
      else
        @decks = Deck.basic_wildcard(params[:deck][:term])
      end
    end
    render json: DeckSerializer.new(@decks).serialized_json
  end

  def show
    @deck = Deck.by_id(params[:id])
    render json: DeckSerializer.new(@deck).serialized_json
  end

  def create
    if params[:cards].length == 0
      render json: {error: {message:"Deck submitted with no cards"}} and return
    end

    if !params[:copy]
      card_errors =  Card.validate_card_names(params[:cards])
      if card_errors.length > 0
        render json: {error: {message:"Some card names are incorrect", keys: card_errors}} and return
      end
    end

    @deck = Deck.new(
      name: params[:name].titleize,
      archtype: params[:archtype],
      format_id: Format.find_by(name: params[:formatName]).id,
      user_id: decode_token["user_id"],
      tournament: params[:tournament],
      creator: params[:creator]
    )

    if @deck.save
      params[:cards].each do |card|
        new_deck_card = DeckCard.new(
          deck_id: @deck.id,
          card_id: card[:card_id] || Card.find_by(name: card[:name]).id,
          card_count: card[:count] == '' ?  1 : card[:count],
          sideboard: card[:sideboard]
        )
        new_deck_card.save
      end
      @deck.save
      @deck = Deck.joins(:format, :user).where(id: @deck.id).select('decks.*, formats.name AS format_name, users.name AS user_name').references(:format, :user)[0]
      render json: DeckSerializer.new(@deck).serialized_json and return
    else
      render json: {message: "Failed to create deck", error: @deck.errors}
    end
  end

  def update
    if decode_token["user_id"]
      original_deck_cards = DeckCard.where(deck_id: params[:id])
      new_deck_cards = params[:cards]
      ids_to_destroy = original_deck_cards.map{|c| c[:id]} - new_deck_cards.map{|c| c[:id]}.compact
      deck_cards_to_delete =
      deck_cards_to_add = new_deck_cards.select{|c| c[:id] == nil}
      if ids_to_destroy.length > 0
        DeckCard.where(id: ids_to_destroy).destroy_all
      end

      if deck_cards_to_add.length > 0
        card_errors =  Card.validate_card_names(deck_cards_to_add)
        if card_errors.length > 0
          render json: {error: {message:"Some card names are incorrect", keys: card_errors}} and return
        end
        deck_cards_to_add.each do |c|
          @deck_card = DeckCard.new(
                  deck_id: params[:id],
                  sideboard: c[:sideboard],
                  card_count: c[:count] == '' ?  1 : c[:count],
                  card_id: Card.find_by(name: c[:name]).id
                )
          @deck_card.save
        end
      end

      @deck = Deck.by_id(params[:id])
      @deck.save
      render json: DeckSerializer.new(@deck).serialized_json
    end
  end

  def destroy
    @deck = Deck.find(params[:id])
    if @deck.destroy
      render json: {message: "#{@deck.name} deleted", user: current_user}
    else
      render json: {message:"Something went wrong"}
    end
  end

end
