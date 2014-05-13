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

class ProjectEffectRhythmboxControl < ProjectEffect
	title				"Rhythmbox Control"
	description "Remote control of the Rhythmbox music player."

	setting 'play', :event
	setting 'stop', :event

	setting 'next_track', :event
	setting 'previous_track', :event

	setting 'volume', :float, :range => 0.0..1.0, :default => 1.0..1.0

	def tick
		`dbus-send --dest='org.gnome.Rhythmbox' /org/gnome/Rhythmbox/Player org.gnome.Rhythmbox.Player.playPause boolean:true` if play.now?
		`dbus-send --dest='org.gnome.Rhythmbox' /org/gnome/Rhythmbox/Player org.gnome.Rhythmbox.Player.playPause boolean:false` if stop.now?

		`dbus-send --dest='org.gnome.Rhythmbox' /org/gnome/Rhythmbox/Player org.gnome.Rhythmbox.Player.next` if next_track.now?
		`dbus-send --dest='org.gnome.Rhythmbox' /org/gnome/Rhythmbox/Player org.gnome.Rhythmbox.Player.previous` if previous_track.now?

		if volume != @previous_volume
			`dbus-send --dest='org.gnome.Rhythmbox' /org/gnome/Rhythmbox/Player org.gnome.Rhythmbox.Player.setVolume double:#{volume}`
			@previous_volume = volume
		end
	end
end