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
 * A referenceable object is one that can be referenced by a string.  This is useful for
 * referencing objects in a GUI or reusing states.
 **/
@:nativeGen
@:expose
class Referenceable<T> {
    private var _reference : String;
    private static var _referenceMap : Map<String, Map<String, Referenceable<Dynamic>>>;

    private function new() { }

    /**
     * Looks up the reference map for the given class name.  If it doesn't exist, it is created.
     **/
    private static function check(className : String) : Map<String, Referenceable<Dynamic>> {
        if (_referenceMap == null) {
            _referenceMap = new Map<String, Map<String, Referenceable<Dynamic>>>();
        }
        var myReferenceMap : Map<String, Referenceable<Dynamic>> = _referenceMap.get(className);
        if (myReferenceMap == null) {
            myReferenceMap = new Map<String, Referenceable<Dynamic>>();
            _referenceMap.set(className, myReferenceMap);
        }
        return myReferenceMap;
    }

    /**
     * Assigns a reference string to this object.
     **/
    public function assignReference(ref : String) : T {
        var className = Type.getClassName(Type.getClass(this));
        gotClassName(className);
        _reference = ref;
        check(className).set(ref, this);
        return cast this;
    }

    /**
     * Called when the class name is known.
     **/
    private function gotClassName(className : String) : Void { }

    /**
     * Returns the referenceable object with the given reference string and the type.
     **/
    public static function findByReference(className : String, ref : String) : Referenceable<Dynamic> {
        return check(className).get(ref);
    }

    /**
     * Returns the reference string for this object.
     **/
    public function reference() : String {
        return _reference;
    }
}
