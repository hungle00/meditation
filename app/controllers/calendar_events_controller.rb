class CalendarEventsController < ApplicationController
  before_action :fetch_dates, only: [:index, :create]

  def index
    @calendar_events = CalendarEvent.where(occurs_at: @date_range).order(:occurs_at).group_by(&:occurs_at_date)
    @calendar_event = CalendarEvent.new
  end

  def create
    @calendar_event = CalendarEvent.new(calendar_event_params)
    @calendar_event.save!
    redirect_to calendar_events_path
  end

  private

    def calendar_event_params
      params.require(:calendar_event).permit(:occurs_at, :description, :color)
    end

    def fetch_dates
      @start_date = start_date.to_date
      @date_range = (@start_date..@start_date.end_of_month)
      @dates = @date_range.to_a
      @dates.prepend(@dates.first - 1) until @dates.first.sunday?
      @dates.append(@dates.last + 1) until @dates.last.saturday?
    end

    def start_date
      params[:start_date] || Date.current.beginning_of_month
    end
end
