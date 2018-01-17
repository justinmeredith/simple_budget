=begin

#Simple_Budget.rb

This program calculates what someone/s make per month and year,
and generates a budget based on this information

=end

# This clears the terminal screen.
Gem.win_platform? ? (system "cls") : (system "clear")


# ~   ~   ~   ~   ~   ~   CLASSES    ~   ~   ~   ~   ~   ~ #
class Member
  attr_reader :name, :monthly_income, :annual_income, :living, :bills, :gas, :groceries, :leftovers, :savings_goal

  def initialize(name, hourly_pay, hours_worked_weekly)
    @name = name
    @hourly_pay = hourly_pay.to_f
    @hours_worked_weekly = hours_worked_weekly.to_f
    monthly_income_func(@hourly_pay, @hours_worked_weekly)
    annual_income_func(@monthly_income)
    budget(@monthly_income)
    @savings_goal = String.new
  end

  def monthly_income_func(hourly_pay, hours_worked_weekly)
    @monthly_income = hourly_pay * hours_worked_weekly * 4
  end

  def annual_income_func(monthly_income)
    @annual_income = monthly_income * 12
  end

  def budget(monthly_income)
    @living = monthly_income * 0.3
    @bills = monthly_income * 0.2
    @gas = monthly_income * 0.2
    @groceries = monthly_income * 0.18
    @leftovers = monthly_income - (@living + @bills + @gas + @groceries)
  end

  def savings_goal_func
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

    if @savings_goal == ""
      @savings_goal = "\n\n#{name}'s Goal"
    end
    @savings_goal += "\nIf you save up $#{savings_per_month} each month for your #{goal_name} goal, you will reach this goal in #{sprintf('%.1f', goal_timeframe)} #{month}."
  end
end

class Budget
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
      @living += value.living
      @bills += value.bills
      @gas += value.gas
      @groceries += value.groceries
      @leftovers += value.leftovers
      @monthly_income += value.monthly_income
      @annual_income += value.annual_income
    end
  end
end


# ~   ~   ~   ~   ~   ~   MEMBERS    ~   ~   ~   ~   ~   ~ #
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

budget = Budget.new(members)


# ~   ~   ~   ~   ~   ~   SAVINGS    ~   ~   ~   ~   ~   ~ #
puts "\n\nWould you like to create a savings goal? (y/n)"
answer = gets.chomp.downcase
while answer.include?("y")
  puts "\nWhich member would you like to create the goal for?"
  members.each do |key, value|
    puts "   * #{key}"
  end
  print "   "
  answer = gets.chomp
  members[answer].savings_goal_func
  puts "Would you like to create another savings goal? (y/n)"
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
  message += "Combined, these members make $#{sprintf('%.2f', budget.monthly_income)} per month and $#{sprintf('%.2f', budget.annual_income)}.\n\n"
end

message += <<~MESSAGE
~ BUDGET ~
Here is a breakdown of your monthly budget:
     * Living/Rent: $#{sprintf('%.2f', budget.living)}
     * Bills/Insurance: $#{sprintf('%.2f', budget.bills)}
     * Gas: $#{sprintf('%.2f', budget.gas)}
     * Groceries/Food: $#{sprintf('%.2f', budget.groceries)}

This leaves roughly $#{sprintf('%.2f', budget.leftovers)} leftover each month for shopping and saving.
MESSAGE

title += ".txt"
file = open(title, 'w')
file.write(message)
members.each do |key, value|
  file.write(value.savings_goal)
end
file.close

puts "\n\n\nYour budget can be found in the same folder as this program: \n\n#{Dir.pwd}\n\n\n\n"


# ~   ~   ~   ~   ~   ~   END    ~   ~   ~   ~   ~   ~ #
# This pauses the program before clearing the screen after the user presses 'Return'
$stdin.gets.chomp
Gem.win_platform? ? (system "cls") : (system "clear")
