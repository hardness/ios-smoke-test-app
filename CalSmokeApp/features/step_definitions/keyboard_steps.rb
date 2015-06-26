module CalSmokeApp
  module Keyboard
    # For a comprehensive investigation of setting the capitalization,
    # auto-correct, and spell-check properites of a UITextField see this gist:
    #
    # https://gist.github.com/jmoody/106d56a73beff1ffc291
    #
    # TL;DR
    #
    # You can turn auto-correct on or off _before_ the keyboard is presented.

    CORRECTION =
          {
                default: 0, # UITextAutocorrectionTypeDefault,
                off: 1,     # UITextAutocorrectionTypeNo,
                on: 2       # UITextAutocorrectionTypeYes
          }

    def auto_correct_type
      query('UITextField', :autocorrectionType).first
    end

    def set_auto_correct_type(name)
      if keyboard_visible?
        fail('Cannot change the auto-correct settings if the keyboard is visible')
      end

      type = CORRECTION[name]

      unless type
        raise "Unknown auto correct type: '#{name}'. Valid names: :default, :no, :yes"
      end

      query('UITextField', [{setAutocorrectionType:type}])
    end
  end
end

World(CalSmokeApp::Keyboard)

And(/^I turn (on|off) auto correct$/) do |on_or_off|
  set_auto_correct_type(on_or_off.to_sym)
end

Then(/^I touch the text field$/) do
  touch('UITextField')
  wait_for_keyboard
end

When(/^I type "([^"]*)" and touch done$/) do |typed|
  keyboard_enter_text typed
  tap_keyboard_action_key
end

Then(/^the text should be "([^"]*)"$/) do |expected|
  actual = query('UITextField', :text).first
  expect(actual).to be == expected
end
