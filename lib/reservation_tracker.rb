require 'date'
require 'pry'
require_relative 'reservation'
require_relative 'dates'

class ReservationTracker
  attr_reader :rooms, :all_reservations, :cost


  def initialize
    @all_reservations = []
  end


  def new_reservation(date_range)
    date_range = Dates::date_range_format(date_range)

    raise ArgumentError, "Invalid dates. Begin date must be at least one day prior to end date." if date_range[:begin_date] > date_range[:end_date]

    room_num = Room::find_available_room(occupied_rooms(date_range))
    if  room_num == nil
      raise ArgumentError, "No available rooms"
    end

    rate = Room::RATE

    reservation = Reservation.new(date_range, room_num, rate)
    @all_reservations << reservation
    return reservation
  end


  def reservation_list_by_date(date)
    date = Dates::date_format(date)

    reservation_list_by_date = @all_reservations.find_all { |reservation|
      date >= reservation.begin_date && date < reservation.end_date }
    return reservation_list_by_date
  end


  def occupied_rooms(date_range)
    occupied_rooms = []
    date_range = Dates::date_range_format(date_range)
    (date_range[:begin_date]..date_range[:end_date]).each do |date|
      reservation_list_by_date(date).each do |reservation|
        occupied_rooms << reservation.room_num if !occupied_rooms.include?(reservation.room_num)
      end
    end
    return occupied_rooms
  end
end