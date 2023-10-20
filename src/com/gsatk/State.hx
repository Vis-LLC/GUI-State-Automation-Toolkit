/*
    Copyright (C) 2023 Vis LLC - All Rights Reserved

    This program is free software : you can redistribute it and/or modify
    it under the terms of the GNU Lesser General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU Lesser General Public License
    along with this program.  If not, see <https ://www.gnu.org/licenses/>.
*/

/*
    GUI State Automation Toolkit (GSATK) - Source code can be found on SourceForge.net
*/

package com.gsatk;

/**
 * A state is a collection of conditions that must all be true for the state to be considered active.
 **/
@:nativeGen
@:expose
class State extends Referenceable<State> {
    private var _condition : Condition;
    private static var _className : String;

    /**
     * Create a new state with the given conditions.
     **/
    public function new(condition : Condition) {
        super();
        _condition = condition;
    }

    /**
     * Check if all conditions are true and the state matches the current state of the UI.
     **/
    public function check() : Bool {
        return _condition.check();
    }

    /**
     * Find a registered state by name.
     **/
    public static function findByReference(ref : String) : State {
        return cast Referenceable.findByReference(_className, ref);
    }

    /**
     * Used by Referenceable to set the class name.
     **/
    private override function gotClassName(className : String) : Void {
        _className = className;
    }
}
