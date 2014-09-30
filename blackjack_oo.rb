# blackjack_oo.rb
# This is the an object oriented version of blackjack
#
# Game Logic:
# Start game by dealing 2 cards to the player and 2 cards to the dealer.
# The player goes first and chooses to hit or stay.
# If the player chooses hit, another card is dealt.
#   If the player's cards total 21, she wins. If the player's cards total > 21, she loses. 
#   The player can choose hit again and again until she wins, loses or stays.
# When the player chooses stay, it becomes the dealer's turn.
# The dealer must choose hit until her card total is >= 17
# If the dealer reaches exactly 21 with a hit, she wins.
# If the dealer goes over 21 with a hit, she loses.
# If the dealer stays, then the player total and the dealer total are compared and the highest total wins.

class Deck
  attr_accessor :full_ordered_deck

  SUITS = ["Hearts", "Diamonds", "Clubs", "Spades"]
  CARDS = ["2", "3", "4", "5", "6", "7", "8", "9", "10", "Jack", "Queen", "King", "Ace"]

  def initialize
    self.full_ordered_deck = SUITS.product(CARDS)
  end  

end   

class Participant
  attr_accessor :name, :hand, :total, :winner

  def initialize(n)
    self.name = n
    self.hand = []
    self.total = 0
    self.winner = false
  end
end

class BlackJack
  attr_accessor :deck, :player, :dealer

  def initialize(name)
    self.deck = Deck.new.full_ordered_deck.shuffle!
    self.player = Participant.new(name)
    self.dealer = Participant.new("Dealer")
  end

  def deal_cards
    2.times do
      player.hand << deck.pop
      dealer.hand << deck.pop
    end
  end    

  def display_hand(p)
    puts "#{p.name}'s cards: "
    p.hand.each { |card| puts "-> #{card[1]} of #{card[0]}" } 
    puts "-> Total: #{p.total}"
    puts ""
  end

  def calculate_total(hand)
    total = 0
    face_cards = ["Jack", "Queen", "King"]
    hand.each do |card|
      if face_cards.include?(card[1]) 
        total += 10
      elsif card[1] == "Ace" # Use value of 11 for now. Change to 1 later if total > 21
        total += 11
      else
        total += card[1].to_i
      end        
    end

    # Use value of 1 instead of 11 for Aces if the total > 21
    hand.select{ |card| card[1] == "Ace"}.count.times do
      total -= 10 if total > 21
    end    
    total       
  end  

  def player_takes_turn
    if player.total == 21
      puts "Congratulations! You have hit blackjack!"
      player.winner = true
    end

    while (player.total < 21) && !player.winner
      puts "What would you like to do #{player.name}? Enter 'H' for hit and 'S' for stay."
      hit_or_stay = gets.chomp.downcase
      if !['h', 's'].include?(hit_or_stay)
        puts "You did not enter a valid response. Enter 'H' for hit and 'S' for stay. "
        next
      end  
      if hit_or_stay == "s"
        puts "You have decided to stay."
        puts " "
        break
      end
  
      hit(player)
        
      if player.total == 21
        puts "Congratulations #{player.name}! You have hit blackjack!"
        player.winner = true
        break
      elsif player.total > 21
        puts "Sorry #{player.name}...you have busted!"
        dealer.winner = true
        break
      end  
    end 
  end  

  def dealer_takes_turn
    puts "It is now my turn."
    puts " "

    if (dealer.total > player.total) && (dealer.total > 17)
      puts "I have won! My total is higher than your total"
    else
      while ((dealer.total < 21) && (dealer.total < player.total)) || dealer.total < 17
        hit(dealer)
      end

      if dealer.total == 21
        puts "I have hit blackjack! Dealer has won!"
      elsif dealer.total > 21
        puts "I have busted! You have won!" 
      elsif dealer.total == player.total
         puts "We have tied. Our totals are equal."   
      elsif dealer.total < player.total
        puts puts "Congratulations #{player.name}! You have won! Your total is higher than mine."
      else  
        puts "I have won! My total is higher than your total."
      end  
    end  
  end  

  def hit(p)
    p.hand << deck.pop
    system 'clear'
    puts "I just dealt #{p.name} a #{p.hand.last[1]} of #{p.hand.last[0]}"
    puts " "
    p.total = calculate_total(p.hand)
    display_hand(player)
    display_hand(dealer)
  end  

  def play_again?
    puts "Would you like to play again #{player.name}? (Y or N)"
    if gets.chomp.downcase == "y"
      name = player.name
      BlackJack.new(name).run
    else
      puts "Goodbye #{player.name}!"  
    end
  end  

  def run
    system 'clear'
    puts "Hello #{player.name}! I will start by dealing 2 cards to each of us."
    puts " "
    deal_cards
    player.total = calculate_total(player.hand)
    dealer.total = calculate_total(dealer.hand)
    display_hand(player)
    display_hand(dealer)
    player_takes_turn
    dealer_takes_turn if !player.winner && !dealer.winner
    play_again?
  end  

end

system 'clear'
puts "Welcome to Blackjack! What is your name?"
name = gets.chomp
BlackJack.new(name).run


