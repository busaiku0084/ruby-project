class JankenGame
  CHOICES = ["グー", "チョキ", "パー"]

  def self.play(player_choice)
    computer_choice = CHOICES.sample

    result =
      if player_choice == computer_choice
        "あいこ！"
      elsif win?(player_choice, computer_choice)
        "あなたの勝ち！"
      else
        "あなたの負け！"
      end

    {
      player: player_choice,
      computer: computer_choice,
      result: result
    }
  end

  def self.win?(player, computer)
    (player == "グー" && computer == "チョキ") ||
    (player == "チョキ" && computer == "パー") ||
    (player == "パー" && computer == "グー")
  end
end
