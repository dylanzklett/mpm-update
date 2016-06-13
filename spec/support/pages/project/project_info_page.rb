require_relative '../general_page'

class ProjectInfoPage < GeneralPage

  set_url '/projects{/pid}'

  element :project_version, 'h1 > a'

  #status buttons
  element :make_quoted_btn, 'input[value="Make quoted"]'
  element :make_propose_btn, 'input[value="Make propose"]'
  element :make_ordered_btn, 'input[value="Make ordered"]'
  element :make_active_btn, 'input[value="Make active"]'
  element :make_close_btn, 'input[value="Make close"]'
  element :create_drapery_task_btn, :xpath, "//a[contains(text(),'Create Drapery Task')]"
  element :create_trough_task_btn, :xpath, "//a[contains(text(),'Create Trough Task')]"

  element :state, 'div.state'

  #curtain buttons
  element :curtain_new_btn, :xpath, "//a[contains(text(),'Add curtain')]"
  element :curtain_edit_btn, :xpath, "(//a[contains(text(),'Edit')])[2]"
  element :curtain_delete_btn, :xpath, "(//a[contains(text(),'Delete')])[2]"

  def nav_btn_visible?
    all_visible? :back_btn, :edit_btn, :delete_btn
  end
end
