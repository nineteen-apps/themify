// -*-swift-*-
// The MIT License (MIT)
//
// Copyright (c) 2017 - Nineteen
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all
// copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
// SOFTWARE.
//
// Created: 2017-04-25 by Ronaldo Faria Lima
// This file purpose: Main library entry point/interface

import Foundation

/// Themify main interface. This library is implemented as a façade and singleton. But, you can create you own instance 
/// and spread it through your code as a simple plain swift class.
public final class Themify {
    /// Singleton instance of themify.
    fileprivate static var instance: Themify!
    
    /// Set of loaded themes
    fileprivate var themes = Set<Theme>()
    
    /// Shared instance of Themify. You can use it as a singleton. This is only a convenience.
    public var shared: Themify {
        if Themify.instance == nil {
            Themify.instance = Themify()
        }
        return Themify.instance
    }
    
    /// Default initializer. So far, does nothing.
    public init() {}
    
    public func loadThemes(from fileURL: URL) throws {
        guard let themeArray = NSArray(contentsOf: fileURL) as? Array<Any> else {
           throw ThemifyError.cantLoadThemeFile(themeFileURL: fileURL)
        }
        do {
            themes = try Parser().parse(rawThemes: themeArray)
        } catch {
            // TODO: Error handling
        }
    }
    
    public func applyTheme(themeName: String) throws {
        if let theme = (themes.filter { $0.name == themeName }).first {
            theme.apply()
        } else {
            throw ThemifyError.themeNotFound(themeName: themeName)
        }
    }
}
