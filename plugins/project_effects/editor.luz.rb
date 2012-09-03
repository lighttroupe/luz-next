 ###############################################################################
 #  Copyright 2012 Ian McIntosh <ian@openanswers.org>
 #
 #  This program is free software; you can redistribute it and/or modify
 #  it under the terms of the GNU General Public License as published by
 #  the Free Software Foundation; either version 2 of the License, or
 #  (at your option) any later version.
 #
 #  This program is distributed in the hope that it will be useful,
 #  but WITHOUT ANY WARRANTY; without even the implied warranty of
 #  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 #  GNU Library General Public License for more details.
 #
 #  You should have received a copy of the GNU General Public License
 #  along with this program; if not, write to the Free Software
 #  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 ###############################################################################

require 'easy_accessor'
require 'value_animation'

module GuiHoverBehavior
	def pointers_hovering
		@gui_pointers_hovering ||= Set.new
	end

	def pointer_hovering?
		!pointers_hovering.empty?
	end

	def pointer_clicking?
		pointers_hovering.find { |pointer| pointer.click? }
	end

	def pointer_enter(pointer)
		unless pointers_hovering.include?(pointer)
			pointers_hovering << pointer
			puts "pointer enter"
		end
	end

	def pointer_exit(pointer)
		if pointers_hovering.delete(pointer)
			puts "pointer exit"
		end
	end
end

#
# Gui base class
#
class GuiObject
	include GuiHoverBehavior
	include ValueAnimation
	include Drawing

	easy_accessor :parent, :offset_x, :offset_y, :scale_x, :scale_y
	boolean_accessor :hidden

	def initialize
		@parent = nil
		@offset_x, @offset_y = 0.0, 0.0
		@scale_x, @scale_y = 1.0, 1.0
	end

	def set_scale(scale)
		@scale_x, @scale_y = scale, scale
		self
	end

	# 

	def gui_tick!
		tick_animations!
	end

	def hit_test_render!
		return if hidden?
		with_unique_hit_test_color_for_object(self, 0) {
			with_positioning {
				unit_square
			}
		}
	end

	def gui_render!
		return if hidden?
		with_positioning {
			unit_square
		}
	end

private

	def with_positioning
		with_translation(@offset_x, @offset_y) {
			with_scale(@scale_x, @scale_y) {
				yield
			}
		}
	end
end

class NilClass
	def using
		yield
	end
end

class GuiButton < GuiObject
	callback :clicked
	easy_accessor :background_image

	def click(pointer)
		clicked_notify(pointer)
	end

	BUTTON_COLOR = [0.5,0.5,0.5]
	BUTTON_HOVER_COLOR = [1.0,0.5,0.5]
	BUTTON_CLICK_COLOR = [0.5,1.0,0.5]

	def gui_color
		(pointer_clicking?) ? BUTTON_CLICK_COLOR : ((pointer_hovering?) ? BUTTON_HOVER_COLOR : BUTTON_COLOR)
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

class GuiBox < GuiObject
	def initialize(contents = [])
		@contents = contents
		super()
	end

	def <<(gui_object)
		@contents << gui_object
		gui_object.parent = self
	end

	#
	# Extend GuiObject methods to pass them along to contents
	#
	def gui_render!
		return if hidden?
		with_positioning {
			@contents.each { |gui_object| gui_object.gui_render! }
		}
	end

	def gui_tick!
		return if hidden?
		@contents.each { |gui_object| gui_object.gui_tick! }
		super
	end

	def hit_test_render!
		return if hidden?
		with_positioning {
			@contents.each { |gui_object|
				gui_object.hit_test_render!
			}
		}
	end
end

class GuiList < GuiBox
	easy_accessor :spacing

	def each_with_positioning
		with_positioning {
			@contents.each_with_index { |gui_object, index|
				with_translation(0.0, index * (-1.0 - (@spacing || 0.0))) {
					yield gui_object
				}
			}
		}
	end

	def gui_render!
		return if hidden?
		each_with_positioning { |gui_object| gui_object.gui_render! }
	end

	def hit_test_render!
		return if hidden?
		each_with_positioning { |gui_object| gui_object.hit_test_render! }
	end
end

class UserObject
	empty_method :gui_tick!

	def hit_test_render!
		with_unique_hit_test_color_for_object(self, 0) { unit_square }
	end
end

class Actor
	def gui_render!
		render!
	end

	def hit_test_render!
		with_unique_hit_test_color_for_object(self, 0) { unit_square }
	end

	def click(pointer)
		puts "actor '#{title}' clicked"
	end
end

class Variable
	GUI_COLOR = [0.0,1.0,0.5,0.7]

	def gui_render!
		with_vertical_clip_plane_right_of(value - 0.5) {
			with_color(GUI_COLOR) {
				unit_square
			}
		}
	end

	def click(pointer)
		puts "variable '#{title}' clicked"
	end
end

class Pointer
	easy_accessor :number, :background_image, :color, :size
	DEFAULT_COLOR = [1,1,1]

	def initialize
		@number = 1
		@size = 0.03
		@color = DEFAULT_COLOR
	end

	def tick!
		if @hover_object && click?
			@hover_object.click(self) if @hover_object.respond_to?(:click)
		end
	end

	def render!
		background_image.using {
			with_color(color) {
				with_translation(x, y) {
					with_scale(size) {
						unit_square
					}
				}
			}
		}
	end

	def is_over(object)
		return if @hover_object == object

		exit_hover_object!

		if object
			# enter new object
			object.pointer_enter(self) if object.respond_to?(:pointer_enter)

			# save
			@hover_object = object
			#puts "hovering over #{@hover_object.title}"
		end
		self
	end

	def exit_hover_object!
		@hover_object.pointer_exit(self) if @hover_object && @hover_object.respond_to?(:pointer_exit)
		@hover_object = nil
	end
end

class PointerMouse < Pointer
	X,Y,BUTTON_01 = 'Mouse 01 / X', 'Mouse 01 / Y', 'Mouse 01 / Button 01'
	def x
		$engine.slider_value(X) - 0.5
	end
	def y
		$engine.slider_value(Y) - 0.5
	end
	def click?
		$engine.button_pressed_this_frame?(BUTTON_01)
	end
end

require 'editor/fonts/bitmap-font'

class ProjectEffectEditor < ProjectEffect
	title				"Editor"
	description ""

	setting 'show_amount', :float, :range => 0.0..1.0
	setting 'output_opacity', :float, :range => 0.0..1.0, :default => 1.0..1.0
	setting 'debug', :event

	def after_load
		super
		@gui = nil
	end

	def create_gui
		@gui = GuiBox.new
		#@gui << (actor_list=GuiList.new($engine.project.actors).set_scale(0.2).set_offset_x(-0.4).set_offset_y(0.4))
		@gui << (variables_list=GuiList.new($engine.project.variables).set_hidden(true).set_scale_x(0.15).set_scale_y(0.04).set_offset_x(-0.6).set_offset_y(0.35).set_spacing(0.4))
		@gui << (button = GuiButton.new.set_scale(0.08).set_offset_x(-0.50 + 0.04).set_offset_y(0.50 - 0.04).set_background_image($engine.load_image('images/buttons/menu.png')))
		@gui << (text = BitmapFont.new.set_string('Luz 2.0 has text support!!').set_scale_x(0.02).set_scale_y(0.04))

		# Main menu
		@gui << (save_button = GuiButton.new.set_scale_x(0.1).set_scale_y(0.1).set_offset_y(0.2).set_background_image($engine.load_image('images/buttons/menu.png')))
		#save_button.hidden!

		@cnt ||= 0
		button.on_clicked {
			if variables_list.hidden?
				variables_list.set_hidden(false).animate(:offset_x, -0.41, duration=0.2) { text.set_string(sprintf("here's your list!")) }
			else
				variables_list.animate(:offset_x, -0.6, duration=0.25) { variables_list.set_hidden(true) ; text.set_string(sprintf("byebye list!")) }
			end
		}
		save_button.on_clicked {
			$engine.project.variables << $engine.project.variables.random.deep_clone
			text.set_string(sprintf("clicked the button %d times", @cnt += 1))
		}

		@pointers = [PointerMouse.new.set_background_image($engine.load_image('images/buttons/menu.png'))]
	end

	def tick
		create_gui unless @gui

		@gui.gui_tick!

		if show_amount > 0.0
			#with_offscreen_buffer { |buffer|
				with_hit_testing {				# render in special colors
					@gui.hit_test_render!
					tick_pointers
					hit_test_pointers
				}
			#}
		end
	end

	def render
		with_multiplied_alpha(output_opacity) {
			yield
		}

		if show_amount > 0.0
			with_enter_and_exit(show_amount, 0.0) {
				@gui.gui_render!
				render_pointers
			}
		end
	end

	def tick_pointers
		@pointers.each { |pointer| pointer.tick! }
	end

	def render_pointers
		@pointers.each { |pointer| pointer.render! }
	end
 
	def hit_test_pointers
		@pointers.each { |pointer|
			object, _unused_user_data = hit_test_object_at_luz_coordinates(pointer.x, pointer.y)
			pointer.is_over(object)
		}
	end
end
