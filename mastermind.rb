class String
    def red; "\e[31m#{self}\e[0m" end
    def green; "\e[32m#{self}\e[0m" end
    def blue; "\e[34m#{self}\e[0m" end
end

class Game

    def initialize
        welcome
        role_select
        instructions(@role_choice)
        hints
        start_game(@role_choice)
    end

    def welcome
        puts "****************************"
        puts ""
        puts "WELCOME TO MASTERMIND GAME!!"
        puts ""
        puts "____________________________"       
    end

    def role_select
        puts ""
        puts "Which role do you want to play?"
        puts "1 => Code Maker OR 2 => Code Breaker"
        puts "Please choose from 1 or 2"
            loop do
            @role_choice = gets.chomp.to_i
            if @role_choice == 1 || @role_choice == 2
                break
            else
                puts "Please enter the correct choice"
            end
        end
    end

    def instructions(user_choice)
        puts ""
        puts "*******INSTRUCTIONS*******"
        puts "__________________________"
        puts ""
        if user_choice == 1 
            puts "1. You will create a 4 digits secret code."
            puts "   The code must be between 1 to 6."
            puts ""
            puts "2. The AI will have 5 guesses to"
            puts "   try and crack your secret code. You win"
            puts "   if your secret code is not cracked"
        else
            puts "1. You have to break the secret code in"
            puts "   order to win the game"
            puts ""
            puts "2. You are given 5 guesses to break the"
            puts "   code. The code ranges between 1 to 6"
            puts "   A number can be repeated more than once!"
            puts ""
            puts "3. Each time you enter your guesses...."
            puts "   The computer will give you some hints"
            puts "   on whether your guess had correct digit,"
            puts "   incorrect digits or correct digits"
            puts "   that are in the incorrect position\n "
        end
    end

    def hints
        puts ""
        puts "**********HINTS**********"
        puts "_________________________"
        puts ""
        puts "1. If you get a digit correct and it is"
        puts "   in the correct position, the digit "
        puts "   will be colored #{"green".green}"
        puts ""
        puts "2. If you get a digit correct but in the"
        puts "   wrong position, the digit will be colored #{"blue".blue}"
        puts ""
        puts "3. If you get the digit incorrect, the "
        puts "   digit will be colored #{"red".red}\n "
        puts ""
        puts "For example:"
        puts "If the secret code is:"
        puts "1523"
        puts "and if your guess was:"
        puts "1562"
        puts "Then you will see the following result:"
        puts "#{"15".green}#{"6".red}#{"2".blue}"
    end

    def start_game(user_choice)
        if user_choice == 2 
            game = CodeBreaker.new
        else
            game = CodeMaker.new
        end
    end

    def display_remaining_turns
        puts "You have #{@turns} remaining"
    end

end

class CodeMaker

    def initialize
        @computer_guess = []
        @updated_computer_guess = []
        @computer_guess_marker = []
        @is_in_code = []
        @not_in_code = []
        @temporary = [[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0],[0,0,0,0,0,0]]
        get_user_code
        get_computer_guess
        check_computer_guess
    end

    def get_user_code
        puts "Please enter a 4 digit code between 1 - 6"
        loop do
            @user_code = gets.chomp.split("").map(&:to_i)
            if user_code_validity?(@user_code) == true
                break
            else
                puts "Please enter a valid code"
            end
        end
        print @user_code
        puts ""
    end

    def get_computer_guess
        for i in 0..3 do
            @computer_guess[i] = rand(1..6)
        end
    end

    def user_code_validity?(user_input)
        user_input.length == 4 && user_input.all?{ |x| x >= 1 && x <= 6}
    end

    def check_computer_guess
        i = 0
        @computer_guess.length.times do
            if @computer_guess[i] == @user_code[i]
                @computer_guess_marker[i] = "green"
                #@updated_computer_guess[i] = @computer_guess[i]
                print @computer_guess[i].to_s.green
            elsif @user_code.include?@computer_guess[i]
                if !@is_in_code.include?@computer_guess[i] 
                    @is_in_code << @computer_guess[i]
                    #puts "#{@is_in_code} are in code"
                end
                @computer_guess_marker[i] = "blue"
                print @computer_guess[i].to_s.blue
            else
                @computer_guess_marker[i] = "red"
                @not_in_code << @computer_guess[i]
                print @computer_guess[i].to_s.red
            end
            i += 1
        end
           puts ""
           #print @computer_guess_marker
           #mark_computer_guess
           optimize_computer_guess
    end

    def optimize_computer_guess
        i = 0
        @computer_guess.length.times do
            if @computer_guess_marker[i] == "red"
                if @is_in_code.any? 
                    @computer_guess[i] = @is_in_code[0]
                    @is_in_code.shift
                else
                    loop do
                        new_digit = randomize_digit
                        @computer_guess[i] = new_digit
                        if !@not_in_code.include?new_digit
                            break
                        end
                    end
                end
    
            elsif @computer_guess_marker[i] == "blue"
                
                loop do
                    j = 0 

                    @temporary[i][j] = @computer_guess[i]
                    new_digit = randomize_digit
                    if new_digit != @computer_guess[i]
                        loop do
                            if @temporary[i][j] == 0
                                if @temporary[i].include?new_digit
                                    puts "temp #{i} #{@temporary[i]} contains #{new_digit}" 
                                    break
                                else
                                    @temporary[i][j] = new_digit
                                    @computer_guess[i] = new_digit
                                    j += 1
                                    break
                                end
                            else
                                j += 1
                            end
                        end
                        puts "temp #{i} #{@temporary[i]}" 
                    end

                    if (@temporary[i].include?new_digit)
                        print "It works"
                        puts ""
                        break
                    end
                end
            end
            i += 1
        end
        correct_guess
    end

    def randomize_digit
        return random_digit = rand(1..6)
    end

    def not_present

    end

    def correct_guess
        if @computer_guess == @user_code
            puts "right guess"
            print @computer_guess
        else
            puts "wrong guess"
            #print @updated_computer_guess
            check_computer_guess
        end
    end

end

class CodeBreaker
    attr_reader :random_code
    def initialize
        @random_code = []
        @guess_input = []
        @check_guess_input = []
        @turns = 4
        random_code_generator
        get_user_input
    end

    def random_code_generator
        for i in 0..3 do
            @random_code[i] = rand(1..6)
        end
    end

    def get_user_input
        puts "Please enter your guess"
        puts ""
        loop do
            @user_input = gets.chomp.split("").map(&:to_i)
            if user_input_validity?(@user_input) == true
                break
            else
                puts "Please enter a valid 4 digit code between 1 and 6"
            end
        end
        puts "You entered #{@user_input.join}"
        give_hints
    end

    def user_input_validity?(user_input)
        user_input.length == 4 && user_input.all?{ |x| x >= 1 && x <= 6}
    end

    def give_hints
        i = 0
        @user_input.length.times do
            if @random_code[i] == @user_input[i]
                print @user_input[i].to_s.green
                @check_guess_input[i] = @user_input[i]
            elsif @random_code.include?@user_input[i]
                print  @user_input[i].to_s.blue
                @check_guess_input[i] = @user_input[i]
            else
                print  @user_input[i].to_s.red
                @check_guess_input[i] = @user_input[i]
            end
            i += 1
        end
           puts ""
           check_winner
    end

    def check_winner
        @turns -= 1
        if @check_guess_input == @random_code
            puts "You Win"
        elsif  @turns <= 0
            puts "You Lose"
        else 
            puts "You have #{@turns} turns remaining, use it wisely"
            get_user_input
        end
    end   

end

new_game = Game.new