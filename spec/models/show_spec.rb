require 'rails_helper'

RSpec.describe Show, type: :model do
  let!(:movie) { create(:movie) }
  let!(:theatre) { create(:theatre) }
  subject { build(:show, movie: movie, theatre: theatre) }

  describe 'associations' do
    it { should have_many(:line_items).dependent(:restrict_with_error) }
    it { should belong_to(:movie).without_validating_presence }
    it { should belong_to(:theatre).without_validating_presence }
  end

  describe 'validations' do
    it { should validate_presence_of(:start_time) }
    it { should validate_presence_of(:price) }
    it "should not allow editing past shows" do
      show = create(:show, start_time: Time.current - 1.day)
      show.update(start_time: Time.current)
      expect(show.errors[:base]).to include('Cannot edit past show')
    end
  end

  describe "callbacks" do
    it { should callback(:calculate_end_time).before(:validation) }
    it { should callback(:set_seats_available).before(:create) }
  end

  describe 'Delegations' do
    it { should delegate_method(:name).to(:theatre).with_prefix }
    it { should delegate_method(:title).to(:movie).with_prefix }
  end

  describe 'Enums' do
    it { should define_enum_for(:status).with_values(active: 0, cancelled: 1) }
  end

  describe "scopes" do
    let!(:show1) { create(:show, start_time: 30.minutes.from_now, end_time: Time.current + 2.hours) }
    let!(:show2) { create(:show, start_time: Time.current + 3.hours, end_time: Time.current + 4.hours) }

    it "should return shows with low occupancy" do
      expect(Show.low_occupancy(0.2)).to eq([show1, show2])
    end

    it "should return shows in the next hour" do
      expect(Show.next_hour).to eq([show1])
    end
  end
end
