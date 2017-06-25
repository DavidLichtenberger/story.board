require 'rails_helper'

RSpec.describe Report, type: :model do
  let(:report) { create(:report) }

  describe '#current' do
    specify { expect(Report.current).to be_present }
  end

  describe '#destroy' do
    let(:variables) { {a: 1, b: 2, c: 3}.collect {|k,v| create(:variable, key: k, value: v)} }
    let (:report) { create(:report, variables: variables) }
    it 'destroys dependent variables' do
      report
      expect { report.destroy }.to change { Variable.count }.from(3).to(0)
    end
  end
  describe '#archive!' do
    subject { report.archive! }
    it 'stores a new diary entry' do
     expect{ subject } .to change{ DiaryEntry.count }.from(0).to(1)
    end

    it 'adds a new diary entry to the report' do
     expect{ subject; report.reload }.to change{ report.diary_entries.size }.from(0).to(1)
    end

    context 'for :fake data' do
      subject { report.archive!(intention: :fake) }
      it 'stores the intention along with the diary entry' do
        subject
        expect(report.diary_entries.first.intention).to eq 'fake'
      end
    end

    context 'when maximum limit is reached' do
      before { DiaryEntry::LIMIT.times { report.archive! } }
      it 'number of diary entries stay the same' do
        expect{ subject }.not_to change{ report.diary_entries.size }
      end

      it 'can exceed for another intention' do
        expect{ report.archive!(intention: :fake) }.to change{ report.diary_entries.size }
      end
    end
  end

  describe '#compose' do
    subject { report.compose }
    it 'returns a diary entry' do
      is_expected.to be_kind_of DiaryEntry
    end
  end

  describe '#active_sensor_story_components' do
    subject { report.active_sensor_story_components }
    let(:sensor)          { create :sensor }
    it { is_expected.to be_empty }

    context 'given report has one text_component' do
      let(:report) do
        report = super()
        report.text_components << text_component
        report.save
        report
      end

      let(:text_component) { create(:text_component) }
      context 'given a trigger connected to a sensor via a certain condition' do
        let(:trigger) { create :trigger, text_components: [text_component], report: report }
        before do
          create(:condition, sensor: sensor, trigger: trigger, from: 1, to: 3)
        end

        context 'for sensor readings with a certain intent' do
          before do
            create(:sensor_reading, sensor: sensor, intention: :fake, calibrated_value: 2)
            create(:sensor_reading, sensor: sensor, intention: :real, calibrated_value: 0)
          end

          describe '#active_sensor_story_components :real' do
            subject { report.active_sensor_story_components intention: :real }
            it { is_expected.not_to include text_component }
          end

          describe '#active_sensor_story_components :fake' do
            subject { report.active_sensor_story_components intention: :fake }
            it { is_expected.to include text_component }
          end
        end
      end
    end

    context 'if two text components meet each other at a boundary' do
      let(:lower_component) do
        text_component = create(:text_component, report: report)
        trigger = create(:trigger, report: report, text_components: [text_component])
        create(:condition, trigger: trigger, sensor: sensor, from: 0, to: 10)
        text_component
      end

      let(:upper_component) do
        text_component = create(:text_component, report: report)
        trigger = create(:trigger, report: report, text_components: [text_component])
        create(:condition, trigger: trigger, sensor: sensor, from: 10, to: 20)
        text_component
      end

      context 'sensor reading value hits upper boundary and lower boundary at the same time' do
        before do
          upper_component
          lower_component
          create(:sensor_reading, sensor: sensor, calibrated_value: 10)
        end

        describe'then the report contains only one active text component' do
          it 'ie. the upper component' do
            expect(subject).to contain_exactly(upper_component)
          end

          it 'and not the lower component' do
            expect(subject).not_to contain_exactly(lower_component)
          end
        end
      end
    end
  end
end
