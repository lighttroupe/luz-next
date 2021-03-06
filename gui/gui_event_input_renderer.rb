class	GuiEventInputRenderer < GuiChildUserObjectRenderer
	BACKGROUND_COLOR_ON = [1.0,1.0,0.0,0.2]
	BACKGROUND_COLOR_ON_HOVERING = [1.0,1.0,0.0,0.4]

	def gui_render
		gui_render_background
		gui_render_label
		gui_render_summary
		gui_render_enable_checkbox
	end

	def background_color
		if @object.now?
			if pointer_hovering? || selected?
				BACKGROUND_COLOR_ON_HOVERING
			else
				BACKGROUND_COLOR_ON
			end
		else
			super
		end
	end
end
