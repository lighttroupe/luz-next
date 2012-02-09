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

class Color
	DEFAULT_COLOR = [1.0,1.0,1.0,1.0]		# NOTE: look at the places that use Color.new before thinking about changing this ;)

	def initialize(color = DEFAULT_COLOR)
		set(color)
	end

	attr_accessor :red, :green, :blue, :alpha
	def alpha
		@alpha || 1.0
	end

	def self.new_from_rgba_bytes(rgba)
		c = Color.new
		c.red, c.green, c.blue, c.alpha = *rgba.collect { |component| component / 255.0 }
		c
	end

	def set(color)
		if color.is_a?(Array)
			@red, @green, @blue, @alpha = color[0], color[1], color[2], (color[3] || 1.0)
		elsif color.is_a?(Color)
			@red, @green, @blue, @alpha = color.red, color.green, color.blue, color.alpha
		end
		self
	end

	def multiply(amt)
		@red = (red * amt).clamp(0.0, 1.0)
		@green = (green * amt).clamp(0.0, 1.0)
		@blue = (blue * amt).clamp(0.0, 1.0)
		@alpha = (alpha * amt).clamp(0.0, 1.0)
		self
	end

	def fade_to(amount, color)
		Color.new([amount.scale(red, color.red), amount.scale(green, color.green), amount.scale(blue, color.blue), amount.scale(alpha, color.alpha)])
	end

	def gdk_color
		return Gdk::Color.new(red * 65535, green * 65535, blue * 65535)
	end

	def gdk_alpha
		alpha * 65535
	end

	def to_a
		[red, green, blue, alpha]
	end
	alias :gl_color :to_a
	alias :cairo_color :to_a

	def gl_color=(rhs)
		@red, @green, @blue, @alpha = *rhs
	end

	def set_gl_color(rhs)
		@red, @green, @blue, @alpha = *rhs
		self
	end

	def gl_color_with_full_alpha
		return [red, green, blue, 1.0]
	end
	alias :cairo_color_with_full_alpha :gl_color_with_full_alpha

	def gl_color_without_alpha
		return [red, green, blue]
	end
	alias :cairo_color_without_alpha :gl_color_without_alpha

	def alpha_multiply(amount)
		return Color.new([red, green, blue, alpha * amount])
	end

	def with_alpha(amount)
		return Color.new([red, green, blue, amount])
	end

	def to_s
		sprintf("#%02x%02x%02x%02x", red * 255, blue * 255, green * 255, alpha * 255)
	end

	def from_s(str)
		if str =~ /\#[0-9a-f]{8}/
			red, green, blue, alpha = $1, $2, $3, $4
		end
		self
	end
end
