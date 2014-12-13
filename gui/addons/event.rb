class Event
	GUI_COLOR_ON = [1.0,1.0,0.0,1.0]
	GUI_COLOR_OFF = [1.0,1.0,0.0,0.1]

	def gui_render!
		gui_render_background
		gui_render_on_off_state
		gui_render_label
	end

private

	def gui_render_on_off_state
		with_translation(0.5 - 0.08, 0.0) {
			with_scale(0.1, 0.35) {
				with_color(now? ? GUI_COLOR_ON : GUI_COLOR_OFF) {
					unit_square
				}
			}
		}
	end

	def gui_render_label
		with_translation(-0.08, 0.0) {
			with_scale(0.8, 1.0) {
				super
			}
		}
	end
end
