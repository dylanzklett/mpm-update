class Task < ActiveRecord::Base
  attr_accessor :support_update

  belongs_to :manufacturer
  belongs_to :project

  has_many :task_items, dependent: :destroy

  has_many :support_items, dependent: :destroy
  accepts_nested_attributes_for :support_items, :allow_destroy => true,
                                                :reject_if => lambda { |si|
                                                  si[:name].blank? ||
                                                  si[:unit].blank? ||
                                                  si[:quantity].blank?
                                                }

  has_many :drape_task_items, class_name: 'TaskItem', dependent: :destroy
  accepts_nested_attributes_for :drape_task_items, :allow_destroy => true

  has_many :trough_task_items, class_name: 'TaskItem', dependent: :destroy
  accepts_nested_attributes_for :trough_task_items, :allow_destroy => true

  STATUSES = %w( open in\ process closed expired finished )

  delegate :title, :email, to: :manufacturer, prefix: true, :allow_nil => true
  delegate :versioned_name, to: :project, prefix: true, :allow_nil => true

  after_create :populate_task_items
  after_save :populate_support_items, unless: :support_update

  def populate_task_items
  end

  def populate_support_items
  end

  def mailer
    TaskMailer
  end

  def worksheet_name
    'Task email'
  end
end
