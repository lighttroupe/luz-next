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

require 'project_effect', 'project_effect_treeview', 'parent_user_object_editor_window_with_dialogs', 'add_project_effect_window'

class ProjectEffectEditorWindow < ParentUserObjectEditorWindowWithDialogs
	pipe :set_parent_objects, :parent_treeview, :method => :set_objects
	alias :add_project_effect_class :add_parent_class

	def initialize
		super('user_object_editor_window',
			ProjectEffect, ProjectEffectTreeView, UserObjectSettingsEditor, AddProjectEffectWindow,
			nil, nil, nil, nil)

		@child_container.hide
	end

	def on_parent_list_changed
		$engine.project.effects = @parent_treeview.objects
	end
end

