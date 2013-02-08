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

class ActorEffectSprinkle < ActorEffect
	title				"Sprinkle"
	description "Draws actor many times in random positions within a given radius."

	categories :child_producer

	setting 'number', :integer, :range => 1..1000, :default => 1..2
	setting 'radius', :float, :range => 0.0..100.0, :default => 1.0..2.0

	def render
		@seed ||= Time.now.to_i		# TODO: This should be:  setting 'position', :random, :range => -1.0..1.0
		srand(@seed)		# TODO: remove when we have a :random UOS

		yield :child_index => 0, :total_children => number
		for i in 1...number
			with_translation(rand.scale(-1.0, 1.0) * radius, rand.scale(-1.0, 1.0) * radius) {
				yield :child_index => i, :total_children => number
			}
		end

		srand
	end
end
