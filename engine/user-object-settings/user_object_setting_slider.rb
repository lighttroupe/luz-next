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

require 'user_object_setting'	#, 'variable_combobox'

class UserObjectSettingSlider < UserObjectSetting
	def to_yaml_properties
		['@slider', '@is_inverted', '@input_min', '@input_max', '@dead_center_size', '@output_min', '@output_max', '@output_curve'] + super
	end

	def after_load
		@output_curve ||= $engine.project.curves.first
		set_default_instance_variables(:input_min => 0.0, :input_max => 1.0, :output_min => 0.0, :output_max => 1.0, :dead_center_size => 0.0)
		super
	end

	LABEL_NORMAL = 'Record '
	LABEL_RECORDING = 'Recording - move desired slider...'
	INPUT_TAB_TITLE = 'Input'
	OUTPUT_TAB_TITLE = 'Output'

	NON_NOTIFY_SLIDER_NAME_REGEXES = [/^Mouse /, /^Wiimote /, /^Tablet /, /^Spectrum Analyzer /]

	def immediate_value
		@last_value = @current_value

		# Get raw value, as reported by physical input (MIDI slider, mouse x/y, joystick axis, etc.)
		v = $engine.slider_value(@slider)

		# Invert for:
		# - devices axis that just feel upside down (that's why it's done first)
		v = 1.0 - v if @is_inverted

		# Re-scale input for:
		# - devices that never reach 0.0 or 1.0
		# - using only part of the input range eg 0.5 to 1.0

		if @input_min >= @input_max		# some sanity for kooky settings and avoids possible divide by 0.0 below when ==
			v = @input_min
		else
			v = v.clamp(@input_min, @input_max)

			# rescale it to 0.0..1.0
			v = (v - @input_min) / (@input_max - @input_min)

			# no--- NOTE: v can be outside 0.0..1.0 here if eg. min>max are kooky
		end

		# Dead-center for:
		# - axis that are hard to leave exactly at 0.5 but shouldn't be (eg. MIDI crossfader, gamepad analog stick X/Y)
		if @dead_center_size > 0.0
			half_center_width = (@dead_center_size / 2.0)
			ramp_width = (0.5 - half_center_width)

			if v < ramp_width
				# Left of three parts
				v = (v / ramp_width) * 0.5
			elsif (v > (0.5 + half_center_width))
				# Right of three parts
				v = 0.5 + (((v - 0.5 - half_center_width) / ramp_width) * 0.5)
			else
				v = 0.5
			end
		end

		v = @output_curve.value(v) if @output_curve

		# Scale to output range
		v = v.scale(@output_min, @output_max)

		@current_value = v
		return v
	end

	def summary
		summary_format(@slider)
	end
end
