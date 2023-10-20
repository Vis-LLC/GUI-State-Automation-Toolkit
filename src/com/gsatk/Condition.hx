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
 * A condition is a function that returns a boolean value.  It is used to determine if a state transition hase occurred.
 **/
@:nativeGen
@:expose
class Condition {
    private var _f : Void -> Bool;

    /**
     * Creates a new condition with the given function.
     **/
    public function new(f : Void -> Bool) {
        _f = f;
    }

    /**
     * Returns the result of the condition function.
     **/
    public function check() : Bool {
        return _f();
    }

    public function And(c : Condition) : Condition {
        return new ConditionAnd(this, c);
    }

    public function Or(c : Condition) : Condition {
        return new ConditionOr(this, c);
    }

    public function Xor(c : Condition) : Condition {
        return new ConditionXor(this, c);
    }

    public function Not() : Condition {
        return new ConditionNot(this);
    }
}

@:nativeGen
class ConditionAnd extends Condition {
    public function new(c1 : Condition, c2 : Condition) {
        super(function() {
            return c1.check() && c2.check();
        });
    }
}

@:nativeGen
class ConditionOr extends Condition {
    public function new(c1 : Condition, c2 : Condition) {
        super(function() {
            return c1.check() || c2.check();
        });
    }
}

@:nativeGen
class ConditionXor extends Condition {
    public function new(c1 : Condition, c2 : Condition) {
        super(function() {
            return c1.check() != c2.check();
        });
    }
}

@:nativeGen
class ConditionNot extends Condition {
    public function new(c : Condition) {
        super(function() {
            return !c.check();
        });
    }
}