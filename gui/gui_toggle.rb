#
# GuiToggle is a widget for editing booleans
#
class GuiToggle < GuiValue
	callback :clicked
	easy_accessor :image

	COLOR_ON = [0.7,1,0.7,1]
	COLOR_OFF = [1.0,0.7,0.7,0.3]

	#
	# Helpers
	#
	def on?
		get_value
	end

	#
	# Pointer
	#
	def click(pointer)
		set_value(!get_value)
		clicked_notify(pointer)
	end

	#
	# Rendering
	#
	def gui_render
		with_gui_object_properties {
			with_scale(0.6, 0.4) {
				with_color(get_value ? COLOR_ON : COLOR_OFF) {
					image.using {
						unit_square
					}
				}
			}
		}
	end
end

