module TaskHelpers
  def have_related_tasks_with_types(*task_types)
    within 'table.related-tasks' do
      task_types.each do |type|
        expect(page).to have_content type
      end
    end
  end

  def create_drapery_task_for_project project, curtain_data
    click_link 'Create Drapery Task'
    expect(page).to have_content 'Create new Drapery task for project'
    click_button 'Create Drape task'

    have_buttons_within '.possible_actions', 'Prepare Email', 'Labels', 'SewLabels'
    have_buttons_within '.actions', 'Back', 'Edit', 'Manage task items', 'Manage inventory items', 'Delete'

    click_link_or_button 'Prepare Email'
    sleep 1
    have_buttons_within '.actions', 'Send Email', 'Cancel'

    within_frame 0 do
      expect(page).to have_content curtain_data[:width].to_f

      task = project.drape_tasks.last
      have_price_with_currency task.full_price

      within 'table.worksheet_summary' do
        task.task_items.each do |task_item|
          expect(page).to have_content task_item.width_per_curt * 2
        end
      end

      within 'table.worksheet_inventory_summary' do
        expect(page).to have_content 'fabric Red'
        expect(page).to have_content 'Weight'
        expect(page).to have_content 'shirring'
        expect(page).to have_content '1/4" tape'
        expect(page).to have_content 'box'
      end
    end

    send_task_email
    have_related_tasks_with_types 'Drapery'
  end

  def create_through_task_for_project project, curtain_data
    click_link 'Create Trough Task'

    expect(page).to have_content 'Create new Trough task for project'
    click_button 'Create Trough task'

    have_buttons_within '.possible_actions', 'Prepare Email', 'Labels'
    have_buttons_within '.actions', 'Back', 'Edit', 'Manage task items', 'Manage inventory items', 'Delete'

    click_link_or_button 'Prepare Email'
    sleep 1
    have_buttons_within '.actions', 'Send Email', 'Cancel'

    within_frame 0 do
      expect(page).to have_content curtain_data[:width].to_f

      task = project.trough_tasks.last

      have_price_with_currency task.full_price
      within 'table.worksheet_summary' do
        task.task_items.each do |task_item|
          expect(page).to have_content(task_item.trough_size)
        end
      end

      first_trough_size = task.task_items.first.trough_size

      within 'table.worksheet_inventory_summary' do
        expect(page).to have_content(first_trough_size[1..-1])
        expect(page).to have_content(first_trough_size.first)
      end
    end

    send_task_email
    have_related_tasks_with_types 'Trough'
  end

  def send_task_email
    click_link_or_button 'Send Email'
    expect(page).to have_content 'Email has been sent'
    click_link_or_button 'Back'
  end
end
