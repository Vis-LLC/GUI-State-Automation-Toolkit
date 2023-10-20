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

import com.gsatk.Referenceable;

/**
 * Represents a component on the screen and wraps the lower level concept of a component.
 **/
@:nativeGen
@:expose
interface ComponentConditions {
    /**
     * Determines if the component is visible on the screen.
     **/
    function visible() : Condition;

    /**
     * Determines if the component is enabled on the screen.
     **/
    function enabled() : Condition;

    /**
     * Determines if the component is both visible and enabled on the screen.
     **/    
    function usable() : Condition;
}