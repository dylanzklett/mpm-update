require_relative '../general_page'

class ProjectEmailPage < GeneralPage

  set_url '/projects{/pid}/email/new'

  element :curtains_table, '.curtains'
end
