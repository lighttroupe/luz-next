class GuiButton < GuiObject
	callback :clicked
	callback :holding
	easy_accessor :background_image, :hotkey

	def click(pointer)
		clicked_notify(pointer)
	end

	def click_hold(pointer)
		holding_notify(pointer)
	end

	BUTTON_COLOR = [1.0,1.0,1.0,1.0]
	BUTTON_HOVER_COLOR = [1.0,0.5,0.5]
	BUTTON_CLICK_COLOR = [0.5,1.0,0.5]

	def gui_tick!
		super
		clicked_notify(nil) if hotkey && $engine.button_pressed_this_frame?(hotkey)
	end

	def gui_color
		(pointer_clicking?) ? BUTTON_CLICK_COLOR : ((pointer_hovering?) ? BUTTON_HOVER_COLOR : nil)
	end

	def gui_render!
		return if hidden?
		with_positioning {
			with_color(gui_color) {
				if background_image
					background_image.using {
						unit_square
					}
				else
					unit_square
				end
			}
		}
	end
end