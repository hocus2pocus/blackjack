module Scoring
  def card_cost(hand)
    scores = []
    aces = 0

    hand.each do |card|
      if card.rank == 'A'
        scores << 1
        aces += 1
      elsif ['J', 'Q', 'K'].include?(card.rank)
        scores << 10
      else
        scores << card.rank.to_i
      end
    end

    if aces > 0
      aces_score(aces, scores)
    else
      scores.sum
    end
  end

  def aces_score(aces, scores)
    aces.times do
      scores << 10 if scores.sum + 10 <= 21
    end

    scores.sum
  end
end
