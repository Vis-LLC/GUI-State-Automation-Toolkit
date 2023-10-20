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
class Component extends Referenceable<Component> implements ComponentActions implements ComponentConditions {
    private var _search : String;
    private var _searchType : Int;
    private var _i : Int;
    private var _parent : Component;
    private var _cache : Dynamic;
    private var _document : Dynamic;
    private static var _className : String;

    /**
     * Creates a new component with the given search string and search type.
     * @param search The search string to use to find the component.
     * @param searchType The search type to use to find the component.
     * @param i The index of the component to find.
     * @param parent The parent component of this component.
     **/
    private function new(search : String, searchType : Int, i : Int, parent : Component) {
        super();
        _search = search;
        _searchType = searchType;
        _i = i;
        _parent = parent;
    }

    /**
     * Finds the component on the screen and then returns it, so it can be wrapped by this object.
     * @return The component on the screen.
    **/
    private function findI() : Dynamic {
        try {
            switch (_searchType) {
                case 0:
                    #if python
                        python.Syntax.code("from selenium.webdriver.common.by import By");
                        return python.Syntax.code("{0}.find_element(By.XPATH, {1})", _document, _search);
                    #elseif JS_BROWSER
                        return js.Syntax.code("{0}.evaluate({1}, {0}, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue", _document, _search);
                    #end
                case 1:
                    // TODO
                case 2:
                    // TODO
                case 3:
                    #if python
                        python.Syntax.code("from selenium.webdriver.common.by import By");
                        return python.Syntax.code("{0}.find_element(By.CSS_SELECTOR, {1})", _document, "*[class^='" + _search + "']");
                    #elseif JS_BROWSER
                        return js.Syntax.code("{0}.evaluate({1}, {0}, null, XPathResult.FIRST_ORDERED_NODE_TYPE, null).singleNodeValue", _document, ("//*[contains(@class, '" + _search + "')]"));
                    #end
                case 4:
            }
            return null;
        } catch (e : Dynamic) {
            return null;
        }
    }

    /**
     * Finds the component on the screen and then returns it, so it can be wrapped by this object.
     * @return The component on the screen.
     */
    private function find() : Dynamic {
        switch (_searchType) {
            case -1:
                var ref = findByReference(_search);
                if (ref == null) {
                    return null;
                } else {
                    return ref.find();
                }
            default:
                var arr : Array<Dynamic> = findI();

                try {
                    if (arr == null || arr.length <= 0 || arr.length < _i) {
                        return null;
                    } else {
                        return arr[_i];
                    }
                } catch (ex : Any) {
                    return arr;
                }
        }
    }

    /**
     * Returns the parent component of this component.
     **/
    public function getParent() : Component {
        return _parent;
    }

    /**
     * Returns the children components of this component.
     **/
    public function getChildren() : Array<Component> {
        // TODO
        return null;
    }

    /**
     * Determines if the component exists on the screen.
     **/
    private function existI() : Bool {
        _cache = find();
        return _cache != null;
    }

    /**
     * Determines if the component is visible on the screen.
    **/
    private function visibleI() : Bool {
        if (existI()) {
            #if python
                return cast python.Syntax.code("{0}.is_displayed()", _cache);
            #elseif JS_BROWSER
                return cast js.Syntax.code("window.getComputedStyle({0}).display === 'none'", _cache);
            #end
        } else {
            return false;
        }
    }

    /**
     * Determines if the component is visible on the screen.
     **/
    public function visible() : Condition {
        return new Condition(visibleI);
    }

    /**
     * Determines if the component is enabled on the screen.
     **/
    private function enabledI() : Bool {
        if (existI()) {
            #if python
                return cast python.Syntax.code("{0}.is_enabled()", _cache);
            #elseif JS_BROWSER
                return cast js.Syntax.code("{0}.disabled", _cache);
            #end
        } else {
            return false;
        }
        return false;
    }

    /**
     * Determines if the component is enabled on the screen.
     **/
    public function enabled() : Condition {
        return new Condition(enabledI);
    }

    /**
     * Determines if the component is both visible and enabled on the screen.
     **/
    private function usableI() : Bool {
        return visibleI() && enabledI();
    }

    /**
     * Determines if the component is both visible and enabled on the screen.
     **/    
    public function usable() : Condition {
        return new Condition(usableI);
    }

    /**
     * Retrieves the value of the component.
     **/
    public function value() : Dynamic {
        // TODO
        return null;
    }

    /**
     * Retrieves a component by XPath.
     **/
    public static function byXPath(xpath : String, ?i : Int = 0, ?parent : Component = null) : Component {
        return new Component(xpath, 0, i, parent);
    }

    /**
     * Retrieves a component by ID.
     **/    
    public static function byId(id : String, ?i : Int = 0, ?parent : Component = null) : Component {
        return new Component(id, 1, i, parent);
    }

    /**
     * Retrieves a component by Name.
     **/        
    public static function byName(name : String, ?i : Int = 0, ?parent : Component = null) : Component {
        return new Component(name, 2, i, parent);
    }

    /**
     * Retrieves a component by Class.
     **/        
    public static function byClass(name : String, ?i : Int = 0, ?parent : Component = null) : Component {
        return new Component(name, 3, i, parent);
    }

    /**
     * Retrieves a component by Tag.
     **/        
    public static function byTag(tag : String, ?i : Int = 0, ?parent : Component = null) : Component {
        return new Component(tag, 4, i, parent);
    }

    /**
     * Retrieves a component by internal reference name.
     **/        
    public static function byReference(ref : String) : Component {
        return new Component(ref, -1, 0, null);
    }

    /**
     * Retrieves a component by internal reference name.
     **/
    private static function findByReference(ref : String) : Component {
        return cast Referenceable.findByReference(_className, ref);
    }

    /**
     * Used by Referenceable to set the class name.
     **/    
    private override function gotClassName(className : String) : Void {
        _className = className;
    }

    /**
     * Reset the Component, so that it can be used to check the current state of the UI.
     **/
    public function reset(document : Dynamic) : Void {
        _document = document;
        _cache = null;
    }

    /**
     * Clicks the component.
     **/
    public function click() : Void {
        if (_cache != null) {
            _cache.click();
        }
    }

    /**
     * Sends keys to the component.
     **/
    public function sendKeys(keys : String) : Void {
        if (_cache != null) {
            _cache.send_keys(keys);
        }
    }

    public function actions() : ComponentActions {
        return this;
    }

    public function conditions() : ComponentConditions {
        return this;
    }    
}
