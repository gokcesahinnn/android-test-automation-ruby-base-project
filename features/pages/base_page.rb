class BasePage
  def initialize
    @btn_dismiss_sign_in = { id: "signin_fre_dismiss_button" }
    @btn_agree_terms = {id: "terms_accept"}
    @drp_account_picker = {id: "signin_account_picker"}
    @btn_negative = {id: "negative_button"}
  end

  def agree_terms
    PageHelper.click_element(@btn_agree_terms)
    self
  end

  def refuse_account_sync
    PageHelper.click_element(@btn_negative) if PageHelper.is_element(@drp_account_picker)
    self
  end
end
