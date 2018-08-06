module Scoring
  def card_cost(hand)
    scores = []

    hand.each do |card|
      if card.rank.to_i != 0
        scores << card.rank.to_i
      elsif ['J', 'Q', 'K'].include?(card.rank)
        scores << 10
      elsif card.rank == 'A'
        scores << 'A'
      end
    end

    if scores.include?('A')
      aces_score(scores)
    else
      scores.sum
    end
  end

  def aces_score(scores)
    aces = scores.count('A')
    scores.delete('A')

    aces.times do
      if scores.sum <= 10
        scores << 11
      else
        scores << 1
      end
    end

    scores.sum
  end
end
