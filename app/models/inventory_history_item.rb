class InventoryHistoryItem < ActiveRecord::Base
  belongs_to :inventory_item
  belongs_to :support_item, class_name: 'SupportItem'

  scope :additions, -> { where(event: 'addition') }
  scope :deletions, -> do
    joins('LEFT OUTER JOIN support_items ON support_items.id = inventory_history_items.support_item_id').
    joins('LEFT OUTER JOIN tasks ON tasks.id = support_items.task_id').
    joins('LEFT OUTER JOIN projects ON projects.id = tasks.project_id').
    where("( projects.state IN ('in_process', 'closed') OR projects.state IS NULL )").
    where(event: 'deletion')
  end

  scope :balances, -> do
    joins('LEFT OUTER JOIN support_items ON support_items.id = inventory_history_items.support_item_id').
    joins('LEFT OUTER JOIN tasks ON tasks.id = support_items.task_id').
    joins('LEFT OUTER JOIN projects ON projects.id = tasks.project_id').
    where("( projects.state IN ('in_process', 'closed') OR projects.state IS NULL )").
    where(event: ['deletion', 'addition'])
  end

  validates :amount, numericality: { greater_than: 0 }
  validates :event,  presence: true,
                     inclusion: { in: %w(addition deletion) }

  def addition?
    self.event == 'addition'
  end
end
