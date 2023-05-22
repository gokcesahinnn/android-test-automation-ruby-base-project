module PageHelper

  def self.locator_string_format(locator, message)
    temp = Hash.new
    locator.each do |key, value|
      temp[key] = value % message
    end
    temp
  end

  def self.find(locator, wait: BaseConfig.wait_time)
    wait_true(timeout: wait, message: "NoSuchElementError: #{locator}") do
      find_element(locator)
    end
  end

  def self.click_element(locator, wait: BaseConfig.wait_time)
    find(locator, wait: wait).click
  end

  def self.fill_text_field(locator, text, wait: BaseConfig.wait_time)
    mobile_element = find(locator, wait: wait)
    mobile_element.clear
    mobile_element.send_keys(text)
    hide_keyboard
  end

  # @abstract Sends input with keycodes. Range -> [A-Za-Z0-9]. Does not include Turkish chars.
  # @param input (string|integer): Input to be sent by keycodes.
  def self.send_keys_with_keycodes(input)
    key_codes = (("a".."z").to_a.zip((29..54).to_a).to_h).merge(("0".."9").to_a.zip((7..16).to_a).to_h)
    input = input.to_s
    (0...input.length).each { |a|
      if input[a] == input[a].upcase
        press_keycode(115)
        press_keycode(key_codes[input[a].downcase])
        press_keycode(115)
      else
        press_keycode(key_codes[input[a]])
      end
    }
    hide_keyboard
  end

  def self.tab_and_send_keys(locator, key, wait: BaseConfig.wait_time)
    mobile_element = find(locator, wait: wait)
    driver.execute_script('mobile: longClickGesture', { element: mobile_element, x: mobile_element.location.x, y: mobile_element.location.y })
    mobile_element.send_keys(key)
    hide_keyboard if is_keyboard_shown
  end

  def self.wait_until_visible(locator, wait: BaseConfig.wait_time)
    wait_true(timeout: wait) do
      find_element(locator).attribute('visible').eql?('true')
    end
  end

  def self.wait_until_displayed(locator, wait: BaseConfig.wait_time)
    wait_true(timeout: wait) do
      find_element(locator).attribute('displayed').eql?('true')
    end
  end

  def self.back_until_element(locator, back_count = 5)
    count = back_count
    visible = false
    while count.positive?
      begin
        visible = find(locator, wait: 5).attribute('displayed').eql?('true') ? true : raise
        count = 0
      rescue StandardError
        back
        count -= 1
      end
    end
    raise "Element not found locator: #{locator} " if count.zero? && visible == false
  end

  def self.single_tap(x_coordinate, y_coordinate)
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: x_coordinate, y: y_coordinate)
    driver.perform_actions [f1]
  end

  def self.get_element_location(locator, wait: BaseConfig.wait_time)
    find(locator, wait: wait).location
  end

  def self.get_element_size(locator, wait: BaseConfig.wait_time)
    find(locator, wait: wait).size
  end

  def self.accept_alert(btn_label)
    driver.execute_script('mobile: alert', { 'action': 'accept', 'buttonLabel': btn_label })
  end

  def self.check_toggle_button(locator, wait: BaseConfig.wait_time)
    element = find(locator, wait: wait)
    wait.until { element.displayed? }
    element.click if element.attribute('checked') == 'false'
    wait.until { element.attribute('checked') == 'true' }
  end

  def self.uncheck_toggle_button(locator, wait: BaseConfig.wait_time)
    element = find(locator, wait: wait)
    wait.until { element.displayed? }
    element.click if element.attribute('checked') == 'true'
    wait.until { element.attribute('checked') == 'false' }
  end

  # Checks if an element is enabled or not.
  # @param locator (string): Locator of the element.
  # * wait (integer): Waiting time for the locator to find element.
  # @return Boolean.
  def self.is_element_enabled(locator, wait: BaseConfig.wait_time)
    @is_element = true
    begin
      wait_true(timeout: wait, message: "NoSuchElementError: #{locator}") do
        find_element(locator).enabled?
      end
    rescue StandardError
      @is_element = false
    end
    @is_element
  end

  def swipe_until(type, locator, swipe_count = 5)
    count = swipe_count
    visible = false
    while count.positive?
      begin
        visible = find(locator, wait: 2).attribute('displayed').eql?('true') ? true : raise
        count = 0
      rescue StandardError
        case type
        when "down"
          swipe_down
        when "up"
          swipe_up
        when "right"
          swipe_right
        when "left"
          swipe_right
        end
        count -= 1
      end
    end
    raise "Element not found locator: #{locator} " if count.zero? && visible == false
  end

  def self.swipe_down_until_element(locator, swipe_count = 5)
    swipe_until("down", locator, swipe_count)
  end

  def self.swipe_up_until_element(locator, swipe_count = 5)
    swipe_until("up", locator, swipe_count)
  end

  def self.swipe_right_until_element(locator, swipe_count = 5)
    swipe_until("right", locator, swipe_count)
  end

  def self.swipe_left_until_element(locator, swipe_count = 5)
    swipe_until("left", locator, swipe_count)
  end

  def self.swipe_to_between_locators(locator_start, locator_end)
    el_start = find(locator_start)
    el_end = find(locator_end)
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: el_start.location.x, y: el_start.location.y)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: el_end.location.x, y: el_end.location.y)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  def self.swipe_right
    window_width = window_size.width
    window_height = window_size.height
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: (window_width * 0.8).to_int, y: (window_height * 0.15).to_int)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: (window_width * 0.15).to_int, y: (window_height * 0.15).to_int)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  def self.swipe_left
    window_width = window_size.width
    window_height = window_size.height
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: (window_width * 0.5).to_int, y: (window_height * 0.15).to_int)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: (window_width * 0.9).to_int, y: (window_height * 0.15).to_int)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  # @abstract Swipes until element is found.
  # @!attribute type can be "down" or "up". Default is "down".
  def self.swipe_until_element(locator, type, scroll_count = 5)
    count = scroll_count
    visible = false
    while count.positive?
      begin
        visible = find(locator, wait: 2).attribute('displayed').eql?('true') ? true : raise
        count = 0
      rescue StandardError
        swipe_down if type == "down"
        swipe_up if type == "up"
        count -= 1
      end
    end
    raise "Element not found locator: #{locator} " if count.zero? && visible == false
  end

  # @abstract Swipes down given amount of argument times.
  def self.swipe_down_multiple_times(scroll_times)
    count = scroll_times
    while count.positive?
      swipe_down
      count -= 1
    end
  end

  def self.swipe_down
    window_width = window_size.width
    window_height = window_size.height
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: (window_width * 0.05).to_int, y: (window_height * 0.7).to_int)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: (window_width * 0.05).to_int, y: (window_height * 0.3).to_int)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  def self.swipe_up
    window_width = window_size.width
    window_height = window_size.height
    f1 = ::Selenium::WebDriver::Interactions.pointer(:touch, name: 'finger1')
    f1.create_pointer_move(duration: 0, x: (window_width * 0.05).to_int, y: (window_height * 0.3).to_int)
    f1.create_pointer_down(0)
    f1.create_pause(0.5)
    f1.create_pointer_move(duration: 1, x: (window_width * 0.05).to_int, y: (window_height * 0.7).to_int)
    f1.create_pointer_up(0)
    driver.perform_actions [f1]
  end

  # @abstract Verifies if an element does not exist on the page.
  def self.verify_no_element(locator, wait: BaseConfig.short_wait_time)
    begin
      is_element(locator, wait: wait).should == false
    rescue StandardError
      raise "There should not be such an element but it was found => #{locator}"
    end
  end

  # @abstract Verifies if an element is enabled.
  def self.verify_element_enabled(locator, wait: BaseConfig.wait_time)
    is_element_enabled(locator, wait: wait).should == true
  end

  # @abstract Verifies if an element is not enabled.
  def self.verify_element_not_enabled(locator, wait: 0)
    begin
      is_element_enabled(locator, wait: wait).should == false
    rescue StandardError
      raise "There should not be such an element enabled but it was found => #{locator}"
    end
  end

  # @abstract Verifies if an element exists.
  def self.verify_element_exists(locator, wait: BaseConfig.wait_time)
    is_element(locator, wait: wait).should == true
  end

  def self.verify_element_is_selected(locator, wait: BaseConfig.wait_time)
    wait_true(timeout: wait, message: "NoSuchElementError: #{locator}") do
      find_element(locator).selected?
    end
  end

  # @abstract Waits until an element disappears on the page. If not, throws error.
  def self.wait_until_no_element(locator, wait: BaseConfig.wait_time)
    @is_element = true
    while wait > 0
      begin
        find_element(locator)
        sleep 1
        wait -= 1
      rescue StandardError
        @is_element = false
        break
      end
    end
    raise "The element for this locator was supposed to disappear but it didn't => #{locator}" if @is_element
  end

  # @abstract Waits until an element appear on the page. If not, throws error.
  def self.wait_until_element(locator, wait: BaseConfig.wait_time)
    @is_element = false
    while wait > 0
      begin
        find_element(locator)
        @is_element = true
        break
      rescue StandardError
        sleep 1
        wait -= 1
      end
    end
    raise "No element was found for this locator => #{locator}" unless @is_element
  end

  # @abstract Finds the amount of an element existed on the page.
  # @return Integer
  def self.element_size(locator)
    find_elements(locator).size
  end

  # @abstract Checks if an element exists or not on the page.
  # @return Boolean.
  def self.is_element(locator, wait: BaseConfig.wait_time)
    @is_element = true
    begin
      wait_true(timeout: wait, message: "NoSuchElementError: #{locator}") do
        element_size(locator) > 0
      end
    rescue StandardError
      @is_element = false
    end
    @is_element
  end

  def self.click_enter_on_screen_keyboard
    press_keycode(66)
  end

  def self.driver_back
    driver.back
  end

  def self.get_current_package
    driver.current_package
  end

  def self.is_element_clickable(locator)
      clickable = find_element(locator).attribute('clickable').eql?('true') ? true : false
      clickable
  end
end
