require 'rails_helper'

RSpec.describe Task, :type => :model do
  it 'mailer' do
    task = create :task
    expect(task.mailer).to eql(TaskMailer)
  end

  it 'worksheet template' do
    task = create :task
    expect(task.worksheet_name).to eql('Task email')
  end
end
