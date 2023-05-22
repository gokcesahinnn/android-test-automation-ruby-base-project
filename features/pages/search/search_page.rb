class SearchPage

  def initialize
    @lbl_search_result_title = {xpath: "//android.view.View[@text ='%s']"}
  end

  def verify_search_result
    PageHelper.find(PageHelper.locator_string_format(@lbl_search_result_title,$searched_word))
    self
  end
end