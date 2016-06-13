require_relative 'curtain_new_page'

class CurtainEditPage < CurtainNewPage

  set_url '/projects{/pid}/curtains{/cid}/edit'
end
