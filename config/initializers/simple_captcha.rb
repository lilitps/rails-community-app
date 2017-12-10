# frozen_string_literal: true

SimpleCaptcha.setup do |sc|
  # default: 100x28
  sc.image_size = '120x40'

  # default: 5
  sc.length = 6

  # default: simply_blue
  # possible values:
  # 'embosed_silver',
  # 'simply_red',
  # 'simply_green',
  # 'simply_blue',
  # 'distorted_black',
  # 'all_black',
  # 'charcoal_grey',
  # 'almost_invisible'
  # 'random'
  sc.image_style = 'simply_red'

  # default: low
  # possible values: 'low', 'medium', 'high', 'random'
  sc.distortion = 'medium'

  # default: medium
  # possible values: 'none', 'low', 'medium', 'high'
  sc.implode = 'medium'

  # default: jquery
  # possible values: jquery, :prototype, :plain_javascript
  sc.refresh_format = :jquery

  # you can explicitly state the font used for generating the captcha
  # sc.font = "DejaVu-Sans"

  sc.image_style = 'mycaptha'
  sc.add_image_style('mycaptha', [
                       "-background '#F4F7F8'",
                       "-fill '#86818B'",
                       '-border 1',
                       "-bordercolor '#E0E2E3'"
                     ])
end
