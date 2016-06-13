class ProjectVersion < ActiveRecord::Base
  ALPH = ("A".."Z").to_a

  serialize :object, JSON
  serialize :object_changes, JSON

  belongs_to :project

  def index
    self.project.versions.select(:id).order('created_at ASC').index(self)
  end

  def name
    "##{self.project_id}#{self.alph}"
  end

  def name_for_email
    "#{self.project_id}#{self.alph}"
  end

  def alph
    res, number = "", self.index
    (number, letter_num = (number - 1).divmod(26)) && res.prepend(ALPH[letter_num]) until number.zero?
    res
  end

  class << self
    def create_init_version_for(project, event)
      project.versions.create(
        event: event,
        whodunnit: 'System',
        object: prepare(project)
      )
    end

    def create_version_for(project, event)
      project.versions.create(
        event: event,
        whodunnit: AuthorizationData.current_user.try(:id) || 'System',
        object: prepare(project),
        object_changes: project.changes,
      )
    end

    def prepare(project)
      object = project.attributes
      object['curtains'] = project.curtains.map do |curtain|
        curtain.attributes.except('created_at', 'updated_at',  'id')
      end
      object['items'] = project.items.map do |item|
        item.attributes.except('created_at', 'updated_at',  'id')
      end
      object
    end
  end
end
