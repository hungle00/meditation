module CalendarEventsHelper
  def color_code(color)
   case color
    when 'green' then 'text-green-500'
    when 'yellow' then 'text-yellow-500'
    when 'red' then 'text-red-500'
    else
      'text-indigo-500'
    end
  end
end
