require 'rails_helper'

RSpec.describe Text::Renderer do
  let!(:report)      { create(:report, variables: variables, name: report_name) }
  let(:report_name) { 'ReportName' }
  let(:intention)      { :real }
  let(:renderer) { described_class.new(text_component: text_component, diary_entry: DiaryEntry.new(intention: intention)) }
  subject { renderer }

  describe '#render' do
    let(:part) { :main_part }
    subject { super().render(part) }

    context 'given one text_component' do
      let(:text_component)  { create(:text_component, report: report, main_part: main_part) }
      let(:main_part)       { "some content" }
      let(:variables)       { [] }

      it { is_expected.to eq("some content")}

      describe 'report markup' do
        describe 'report name' do
          let(:report_name) { 'Foobar' }
          let(:main_part) { "Say something about { report}." }
          it { is_expected.to eq("Say something about Foobar.")}
        end

        describe 'report variables' do
          let(:variables) { [ create(:variable, key: 'cool_thing', value: 'sth. cool') ] }
          let(:main_part) { "Say something about { cool_thing }." }
          it { is_expected.to eq("Say something about sth. cool.")}

          context 'many variables' do
            let(:main_part) { "Write about { v1 } and { v2 }." }
            let(:variables) { [ create(:variable, key: 'v1', value: 'this'),
                                create(:variable, key: 'v2', value: 'that'),] }
            it { is_expected.to eq("Write about this and that.")}
          end
        end
      end

      context 'given a trigger for the text component' do
        let(:trigger) { create(:trigger, text_components: [text_component]) }

        context 'given an event' do
          let!(:event)      { create(:event, id: 42, name: "DEATH", triggers: [trigger], happened_at: nil) }

          context 'has happened' do
            before { event.happened_at = DateTime.parse('2018-02-02'); event.save! }
            it { is_expected.to eq("some content")}

            describe 'markup for the day of the event' do
              let(:main_part)      { 'Day of your death: { date(42) }' }
              it 'renders the day of the event' do
                is_expected.to eq('Day of your death: 2.2.2018')
              end
            end
          end
        end

        context 'given a condition' do
          let(:condition)      { create(:condition, sensor: sensor, trigger: trigger, from: 0, to: 10) }
          let(:sensor)         { create(:sensor, name: 'SensorXY', sensor_type: sensor_type) }
          let(:sensor_type)    { create(:sensor_type, property: 'Temperature', unit: '°C') }
          before { condition }

          context 'given sensor data' do
            let(:reading)        { create(:sensor_reading, sensor: sensor, calibrated_value: 5) }
            before { report; reading }

            it { is_expected.to eq("some content")}

            context 'with markup for sensor' do
              let(:sensor)         { create(:sensor, id: 42, name: 'SensorXY', sensor_type: sensor_type) }
              let(:main_part)      { 'Sensor value: { value(42) }' }
              it('renders sensor value') { is_expected.to eq('Sensor value: 5.0°C')}
              context 'but with sensor data of different intention' do
                before { reading; create(:sensor_reading, sensor: sensor, intention: :fake, calibrated_value: 0) }

                context 'render :fake report' do
                  let(:intention) { :fake }
                  it { is_expected.to eq('Sensor value: 0.0°C')}
                end

                context 'render :real report' do
                  let(:intention) { :real }
                  it { is_expected.to eq('Sensor value: 5.0°C')}
                end
              end
            end

            context 'markup references an unknown sensor' do
              let(:text_component)  { create(:text_component, :active, report: report, main_part: main_part) }
              let(:main_part)       { "Sensor value: { valueOf(4711) }" }
              it { expect(text_component.sensors.pluck(:id)).not_to include(4711)}
              it { expect(text_component).to be_active }
              describe 'markup' do
                it('will be ignored') { is_expected.to eq('Sensor value: { valueOf(4711) }')}
              end
            end
          end
        end
      end
    end
  end
end
