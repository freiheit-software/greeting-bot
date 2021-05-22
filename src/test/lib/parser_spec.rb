require 'rspec'
require_relative '../../lib/parser'
require 'ostruct'

RSpec.describe Parser do
  let(:request) do
    OpenStruct.new({
      params: {
        "text" => 'add quote "that was great!" by <@USER|user> on Friday'
      }
    })
  end

  describe "#date" do
    context "when the name of the day of the week is sent" do
      let(:request) do
        OpenStruct.new({
          params: {
            "text" => 'add quote "lala" on Friday'
          }
        })
      end

      it "transforms it into a date" do
        parser = Parser.new(request: request)
        expect(parser.date).to eq(Date.today - Date.today.cwday + 1 + 5)
      end
    end

    context "when a date is sent" do
      let(:request) do
        OpenStruct.new({
          params: {
            "text" => 'add quote "lala" on 23.05.2021'
          }
        })
      end

      it "transforms it into a date" do
        parser = Parser.new(request: request)
        expect(parser.date).to eq Date.parse("23.05.2021")
      end
    end

    context "when no date is present" do
      let(:request) do
        OpenStruct.new({
                         params: {
                           "text" => 'add quote "lala"'
                         }
                       })
      end

      it "transforms it into a date" do
        parser = Parser.new(request: request)
        expect(parser.date).to eq Date.today
      end
    end
  end
end