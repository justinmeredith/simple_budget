# Simple_Budget.rb

# This program calculates what someone/s make per month, per year,
# and what they can afford to pay monthly for a living space

# All function names end with "_func" to distinguish them from variables.
# "member" refers to a single individual involved in the budget. Each member
# is stored as a nested hash inside of the array "members"
# "members" refers to the group of individuals as a whole. They are stored
# in an array called "members".
# "user" in the context of code is a variable used to reference a nested member,
# i.e. "user = 1" would be referencing the second member of the budget.
# "user" in the context of comments and meta is referring to the person
# actually running the program.
# Comments that look like "# - - - - - - TEXT - - - - - - - #" are used to
# separate the different groupings of code blocks within the
# program. They are called 'chapters' and are merely for the sake of easing the
# process of reading the code.
# Comments that look like '# ~ ~ ~ ~ TEXT ~ ~ ~ ~ #' are used to further break
# up the chapters for easier reading. These are called 'subchapters'.


# This clears the terminal screen.
Gem.win_platform? ? (system "cls") : (system "clear")

# Makes the savings goal feature and various functions accesible
require "./functions"
require "./savings_goal"

# This variable is to be used later in the program for functions/code that will
# only run if there is a savings goal set.
is_there_a_savings_goal = false



# - - - - - - - - - - - - - - - RUNNING THE PROGRAM - - - - - - - - - - - - - - - #

print "How many people is this budget for? "
number_of_people = $stdin.gets.chomp.to_i

# This runs the function "member_register_loop_func" for the amount of people the
# user specifies above and stores the output in the variable "members"
members = member_register_loop_func(number_of_people)

# This combines the users' monthly incomes and stores it in the variable
# "combined_monthly"
combined_monthly = combined_monthly_func(number_of_people, members)

# This combines the users' annual incomes and stores them in the variable
# "combined_annually"
combined_annually = combined_annually_func(number_of_people, members)

# This calculates the different categories of the budget for the members as a whole
budget_categories = budget_categories_func(combined_monthly)

# This calculates each individual member's monthly leftovers
individual_leftovers_func(members)

# This calculates the group's leftovers as a whole and stores them in a variable to be
# used in the output message
group_leftovers = leftovers_func(members)

print "\n\nWould you like to set a savings goal (yes/no)? "
# If the user answers yes, savings goal function runs and returns the
# savings_goal_message from the savings goal message function.
user_answer = $stdin.gets.chomp
if user_answer == "yes" || user_answer == "y"
  savings_goal_message = savings_goal_func(members, number_of_people)
  is_there_a_savings_goal = true
end



# - - - - - - - - - - - - - - - - - PRINTED MESSAGE - - - - - - - - - - - - - - - #

individual_incomes = individual_incomes_message_func(members)

budget_message = <<~BUDGETMESSAGE

Combined, this household makes $#{sprintf('%.2f', combined_monthly)} per month, and $#{sprintf('%.2f', combined_annually)} per year.


~ BUDGET ~
Here is a break down of your monthly budget:
  * You can afford a living expense of $#{sprintf('%.2f', budget_categories[:living])}.
  * You can afford $#{sprintf('%.2f', budget_categories[:bills])} in bills.
  * You can afford $#{sprintf('%.2f', budget_categories[:gas])} in gas.
  * You can afford $#{sprintf('%.2f', budget_categories[:groceries])} in groceries and food.

This leaves roughly $#{sprintf('%.2f', group_leftovers)} left over for spending and saving.
Keep in mind that these estimates are based on averages,
and provide room for flexibility.
Also remember to try and stay under budget so that
you have more left over each month.
BUDGETMESSAGE



# - - - - - - - - - - - - - - - - - - FILE WRITING - - - - - - - - - - - - - - - #

# This line allows the user to name their output budget file
print "\n\nWhat would you like to name your budget? "
output_file_name = $stdin.gets.chomp

# This ensures the file is a text file
output_file_name_extended = "#{output_file_name}.txt"

# This creates the file with the name provided by the user and opens it in write
# mode.
output_budget_text_file = open(output_file_name_extended, 'w')

# This writes to the text file named by the user
write_to_output_file_func(output_file_name, number_of_people, individual_incomes, output_budget_text_file, budget_message, savings_goal_message, is_there_a_savings_goal)

# This closes the file
output_budget_text_file.close

puts "\n\n\nYour budget can be found in the same folder as this program: \n\n#{Dir.pwd}\n\n\n\n"

puts "Thank you for using Simple Budget!\n\n"

# This pauses the program before clearing the screen after the user presses
# 'Return'
$stdin.gets.chomp
Gem.win_platform? ? (system "cls") : (system "clear")
