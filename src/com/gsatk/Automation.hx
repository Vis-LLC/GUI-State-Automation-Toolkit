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
 * Automation is the main class of the GSATK. It is responsible for
 * managing the states and components of the application. It also
 * provides the main loop of the application.
 **/
@:nativeGen
@:expose
class Automation extends Referenceable<State> {
    private var _components : Array<Component>;
    private var _states : Array<State>;
    private var _currentState : State;
    private static var _className : String;
    private var _delay : Int = 1000;
    private var _document : Dynamic;

    /**
     * Creates a new Automation object.
     **/
    public function new() {
        super();
        var components : Array<Component> = new Array<Component>();
        var states : Array<State> = new Array<State>();

        for (field in Reflect.fields(this)) {
            var value : Dynamic = Reflect.field(this, field);
            if (Std.isOfType(value, Component)) {
                var c : Component = cast value;
                components.push(c);
                c.assignReference(field);
            } else if (Std.isOfType(value, State)) {
                var s : State = cast value;
                states.push(s);
                s.assignReference(field);
            }
        }

        _components = components;
        _states = states;
    }

    /**
     * Updates the state of the Automation to reflect the UI state.
     * Generally called internally by go().
     **/
    public function updateState() : Void {
        for (component in _components) {
            component.reset(_document);
        }
        for (state in _states) {
            if (state.check()) {
                _currentState = state;
                return;
            }
        }
    }

    /**
     * Starts the main loop of the Automation.  This will update the state of the application using updateState() and call nextStep() until it returns false.
     **/
    public function go() : Void {
        var result : Bool = true;
        #if sys
            do {
        #end
            updateState();
            result = nextStep(_currentState);
        #if sys 
                if (result) {
                    Sys.sleep(_delay / 1000);
                }
            } while (result);
        #else
            js.Browser.window.setTimeout(go, _delay);
        #end
    }

    /**
     * Takes the next step in the automation.  This is called by go() and should be overridden by subclasses.
     *
     * @param state The current state of the UI.
     **/
    public function nextStep(state : State) : Bool { return false; }

    /**
     * Find a registered automation by name.
     **/
    public static function findByReference(ref : String) : Automation {
        return cast Referenceable.findByReference(_className, ref);
    }

    /**
     * Used by Referenceable to set the class name.
     **/
    private override function gotClassName(className : String) : Void {
        _className = className;
    }    
}
