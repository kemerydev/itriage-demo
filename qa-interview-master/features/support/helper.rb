def wait_until(timeout=::PageObject.default_element_wait, message=nil, &block)
  wait = Object::Selenium::WebDriver::Wait.new({:timeout => timeout, :message => message})
  wait.until &block
end