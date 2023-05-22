class HomePage

  def initialize
    @txt_search_bar = { id: 'search_box_text' }
  end

  def search(url)
    PageHelper.fill_text_field(@txt_search_bar, url)
    PageHelper.click_enter_on_screen_keyboard
  end

end
