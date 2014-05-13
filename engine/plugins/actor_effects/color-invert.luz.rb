 ###############################################################################
 #  Copyright 2006 Ian McIntosh <ian@openanswers.org>
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

class ActorEffectColorInvert < ActorEffect
	title				"Color Invert"
	description "Inverts set color."

	categories :color

	setting 'amount', :float, :range => 0.0..1.0, :default => 1.0..1.0

	def render
		return yield if amount == 0.0

		c = current_color
		@a ||= []
		@a[0] = amount.scale(c.red, 1.0-c.red)
		@a[1] = amount.scale(c.green, 1.0-c.green)
		@a[2] = amount.scale(c.blue, 1.0-c.blue)
		@a[3] = 1.0
		with_color(@a) {
			yield
		}
	end
end