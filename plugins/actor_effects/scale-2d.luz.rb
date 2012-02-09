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

class ActorEffectScale2D < ActorEffect
	title				'Scale 2D'
	description 'Scales actor in its X and Y dimensions.'

	setting 'amount_x', :float, :default => 1.0..2.0
	setting 'amount_y', :float, :default => 1.0..2.0

	setting 'pivot_offset_x', :float, :default => 0.0..0.5
	setting 'pivot_offset_y', :float, :default => 0.0..0.5

	def render
		with_translation(pivot_offset_x * (1.0 - amount_x), pivot_offset_y * (1.0 - amount_y)) {
			with_scale(amount_x, amount_y) {
				yield
			}
		}
	end
end
