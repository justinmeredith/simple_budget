=begin

#Simple_Budget.rb

This program calculates what someone/s make per month and year,
and generates a budget based on this information

=end

# This clears the terminal screen.
Gem.win_platform? ? (system "cls") : (system "clear")


# ~   ~   ~   ~   ~   ~   CLASSES    ~   ~   ~   ~   ~   ~ #
class Member
  attr_reader :name, :monthly_income, :annual_income, :savings_goal, :budget

  def initialize(name, hourly_pay, hours_worked_weekly)
    @name = name
    @monthly_income = hourly_pay.to_f * hours_worked_weekly.to_f * 4
    @annual_income = monthly_income.to_f * 12
    @budget = IndividualBudget.new(@monthly_income)
    #@savings_goal = nil
  end

  def create_goal
    @savings_goal = SavingsGoal.new(name)
  end

  def set_goal
    savings_goal.write_message(savings_goal.message, name, budget.leftovers)
  end
end

class IndividualBudget
  attr_reader :living, :bills, :gas, :groceries, :leftovers

  def initialize(monthly_income)
    @living = monthly_income * 0.3
    @bills = monthly_income * 0.2
    @gas = monthly_income * 0.2
    @groceries = monthly_income * 0.18
    @leftovers = monthly_income - (@living + @bills + @gas + @groceries)
  end
end

class CollectiveBudget
  attr_reader :living, :bills, :gas, :groceries, :leftovers, :monthly_income, :annual_income

  def initialize(members)
    @living = 0
    @bills = 0
    @gas = 0
    @groceries = 0
    @leftovers = 0
    @monthly_income = 0
    @annual_income = 0
    members.each do |key, value|
      @living += value.budget.living
      @bills += value.budget.bills
      @gas += value.budget.gas
      @groceries += value.budget.groceries
      @leftovers += value.budget.leftovers
      @monthly_income += value.monthly_income
      @annual_income += value.annual_income
    end
  end
end

class SavingsGoal
  attr_reader :message

  def initialize(name)
      @message = "\n\n#{name}'s Goals"
  end

  def write_message(message, name, leftovers)
    puts "\n#{name}'s Goal"
    print "   Goal Name (laptop, vacation, etc.): "
    goal_name = gets.chomp
    print "   Goal's Cost: $"
    goal_amount = gets.chomp.to_i
    puts "\n   *You have roughly $#{sprintf('%.2f', leftovers)} leftover each month. \n   It is recommended that you do not try to save more than this each month.*\n"
    print "\n   Amount You Plan to Save Monthly: $"
    savings_per_month = gets.chomp.to_i
    goal_timeframe = goal_amount.to_f / savings_per_month

    if goal_timeframe > 1
      month = "months"
    else
      month = "month"
    end

    @message += "\nIf you save up $#{savings_per_month} each month for your #{goal_name} goal, you will reach this goal in #{sprintf('%.1f', goal_timeframe)} #{month}."
  end
end


# ~   ~   ~   ~   ~   ~   MEMBERS    ~   ~   ~   ~   ~   ~ #
puts "Simple Budget\n\n"
puts "How many people is this budget for?"
people = gets.chomp.to_i
members = Hash.new
message = String.new

(1..people).each do |x|
  puts "\n\nMember ##{x}"
  print "   Name: "
  name = gets.chomp
  print "   Hourly Pay: $"
  hourly_pay = gets.chomp
  print "   Hours Worked Each Week: "
  hours_worked_weekly = gets.chomp

  members[name] = Member.new(name, hourly_pay, hours_worked_weekly)
end

collective_budget = CollectiveBudget.new(members)


# ~   ~   ~   ~   ~   ~   SAVINGS    ~   ~   ~   ~   ~   ~ #
puts "\n\nWould you like to create a savings goal?"
answer = gets.chomp.downcase
while answer.include?("y")
  puts "\nWhich member would you like to create the goal for?"
  members.each do |key, value|
    puts "   * #{key}"
  end
  print "      > "
  answer = gets.chomp
  if members[answer].savings_goal == nil
    members[answer].create_goal
  end
  members[answer].set_goal
  puts "\n\nWould you like to create another savings goal? (y/n)"
  answer = gets.chomp.downcase
end


# ~   ~   ~   ~   ~   ~   WRITING    ~   ~   ~   ~   ~   ~ #
puts "\n\nWhat would you like to call this budget?"
title = gets.chomp

message = " ~ ~ ~ " + title + " ~ ~ ~\n\n\n"
message += "~ INCOME~ \n"

members.each do |key, value|
  message += "#{key} makes $#{sprintf('%.2f', value.monthly_income)} per month, and $#{sprintf('%.2f', value.annual_income)} per year.\n"
end

if members.length > 1
  message += "Combined, these members make $#{sprintf('%.2f', collective_budget.monthly_income)} per month and $#{sprintf('%.2f', collective_budget.annual_income)}.\n\n"
end

message += <<~MESSAGE
~ BUDGET ~
Here is a breakdown of your monthly budget:
     * Living/Rent: $#{sprintf('%.2f', collective_budget.living)}
     * Bills/Insurance: $#{sprintf('%.2f', collective_budget.bills)}
     * Gas: $#{sprintf('%.2f', collective_budget.gas)}
     * Groceries/Food: $#{sprintf('%.2f', collective_budget.groceries)}

This leaves roughly $#{sprintf('%.2f', collective_budget.leftovers)} leftover each month for shopping and saving.
MESSAGE

title += ".txt"
file = open(title, 'w')
file.write(message)
members.each do |key, value|
  file.write(value.savings_goal.message)
end
file.close

puts "\n\n\nYour budget can be found in the same folder as this program: \n\n#{Dir.pwd}\n\n\n\n"


# ~   ~   ~   ~   ~   ~   END    ~   ~   ~   ~   ~   ~ #
# This pauses the program before clearing the screen after the user presses 'Return'
$stdin.gets.chomp
Gem.win_platform? ? (system "cls") : (system "clear")
