//
//  Extension+Color.swift
//  GitHubObserver
//
//  Created by ukseung.dev on 9/27/24.
//

import Foundation
import SwiftUI

extension Color {
    /// 헥스 문자열을 받아 Color를 반환합니다.
    /// - Parameter hex: 헥스 색상 코드 (예: "#RRGGBB" 또는 "RRGGBB")
    init?(hex: String) {
        var rgb: UInt64 = 0
        
        // 헥스 문자열이 '#'로 시작하면 제거
        let hexString = hex.hasPrefix("#") ? String(hex.dropFirst()) : hex
        
        // 헥스 문자열을 UInt64로 변환
        guard Scanner(string: hexString).scanHexInt64(&rgb) else { return nil }
        
        // 색상 값 추출
        let r = Double((rgb >> 16) & 0xFF) / 255.0
        let g = Double((rgb >> 8) & 0xFF) / 255.0
        let b = Double(rgb & 0xFF) / 255.0
        
        self.init(red: r, green: g, blue: b)
    }
}

func hexColor(for language: String) -> String {
    switch language {
    case "Mercury":
        return "#abcdef"
    case "TypeScript":
        return "#31859c"
    case "PureBasic":
        return "#5a6986"
    case "Objective-C++":
        return "#4886FC"
    case "Self":
        return "#0579aa"
    case "edn":
        return "#db5855"
    case "NewLisp":
        return "#eedd66"
    case "Rebol":
        return "#358a5b"
    case "Frege":
        return "#00cafe"
    case "Dart":
        return "#98BAD6"
    case "AspectJ":
        return "#1957b0"
    case "Shell":
        return "#89e051"
    case "Web Ontology Language":
        return "#3994bc"
    case "xBase":
        return "#3a4040"
    case "Eiffel":
        return "#946d57"
    case "Nix":
        return "#7070ff"
    case "SuperCollider":
        return "#46390b"
    case "MTML":
        return "#0095d9"
    case "Racket":
        return "#ae17ff"
    case "Elixir":
        return "#6e4a7e"
    case "SAS":
        return "#1E90FF"
    case "Agda":
        return "#467C91"
    case "D":
        return "#fcd46d"
    case "Opal":
        return "#f7ede0"
    case "Standard ML":
        return "#dc566d"
    case "Objective-C":
        return "#438eff"
    case "ColdFusion CFC":
        return "#ed2cd6"
    case "Oz":
        return "#fcaf3e"
    case "Mirah":
        return "#c7a938"
    case "Objective-J":
        return "#ff0c5a"
    case "Gosu":
        return "#82937f"
    case "Ruby":
        return "#701516"
    case "Component Pascal":
        return "#b0ce4e"
    case "Arc":
        return "#ca2afe"
    case "SystemVerilog":
        return "#343761"
    case "APL":
        return "#8a0707"
    case "Go":
        return "#375eab"
    case "Visual Basic":
        return "#945db7"
    case "PHP":
        return "#4F5D95"
    case "Cirru":
        return "#aaaaff"
    case "SQF":
        return "#FFCB1F"
    case "Glyph":
        return "#e4cc98"
    case "Java":
        return "#b07219"
    case "Scala":
        return "#7dd3b0"
    case "ColdFusion":
        return "#ed2cd6"
    case "Perl":
        return "#0298c3"
    case "Elm":
        return "#60B5CC"
    case "Lua":
        return "#fa1fa1"
    case "Verilog":
        return "#848bf3"
    case "Factor":
        return "#636746"
    case "Haxe":
        return "#f7941e"
    case "Pure Data":
        return "#91de79"
    case "Forth":
        return "#341708"
    case "Red":
        return "#ee0000"
    case "Hy":
        return "#7891b1"
    case "Volt":
        return "#0098db"
    case "LSL":
        return "#3d9970"
    case "CoffeeScript":
        return "#244776"
    case "HTML":
        return "#e44b23"
    case "UnrealScript":
        return "#a54c4d"
    case "Swift":
        return "#ffac45"
    case "C":
        return "#555"
    case "AutoHotkey":
        return "#6594b9"
    case "Isabelle":
        return "#fdcd00"
    case "Boo":
        return "#d4bec1"
    case "AutoIt":
        return "#36699B"
    case "Clojure":
        return "#db5855"
    case "Rust":
        return "#dea584"
    case "Prolog":
        return "#74283c"
    case "SourcePawn":
        return "#f69e1d"
    case "ANTLR":
        return "#9DC3FF"
    case "Harbour":
        return "#0e60e3"
    case "Tcl":
        return "#e4cc98"
    case "BlitzMax":
        return "#cd6400"
    case "PigLatin":
        return "#fcd7de"
    case "Lasso":
        return "#2584c3"
    case "ECL":
        return "#8a1267"
    case "VHDL":
        return "#543978"
    case "Arduino":
        return "#bd79d1"
    case "Propeller Spin":
        return "#2b446d"
    case "IDL":
        return "#e3592c"
    case "ATS":
        return "#1ac620"
    case "Ada":
        return "#02f88c"
    case "Nu":
        return "#c9df40"
    case "LFE":
        return "#004200"
    case "RAML":
        return "#77d9fb"
    case "Oxygene":
        return "#5a63a3"
    case "ASP":
        return "#6a40fd"
    case "Assembly":
        return "#6E4C13"
    case "Gnuplot":
        return "#f0a9f0"
    case "Turing":
        return "#45f715"
    case "Vala":
        return "#ee7d06"
    case "Processing":
        return "#2779ab"
    case "FLUX":
        return "#33CCFF"
    case "NetLogo":
        return "#ff2b2b"
    case "C Sharp":
        return "#178600"
    case "CSS":
        return "#563d7c"
    case "LiveScript":
        return "#499886"
    case "QML":
        return "#44a51c"
    case "Pike":
        return "#066ab2"
    case "LOLCODE":
        return "#cc9900"
    case "ooc":
        return "#b0b77e"
    case "Mask":
        return "#f97732"
    case "EmberScript":
        return "#f64e3e"
    case "TeX":
        return "#3D6117"
    case "Nemerle":
        return "#0d3c6e"
    case "KRL":
        return "#f5c800"
    case "Unified Parallel C":
        return "#755223"
    case "Golo":
        return "#f6a51f"
    case "Perl6":
        return "#0298c3"
    case "Fancy":
        return "#7b9db4"
    case "OCaml":
        return "#3be133"
    case "wisp":
        return "#7582D1"
    case "Pascal":
        return "#b0ce4e"
    case "F#":
        return "#b845fc"
    case "Puppet":
        return "#cc5555"
    case "ActionScript":
        return "#e3491a"
    case "Ragel in Ruby Host":
        return "#ff9c2e"
    case "Fantom":
        return "#dbded5"
    case "Zephir":
        return "#118f9e"
    case "Smalltalk":
        return "#596706"
    case "DM":
        return "#075ff1"
    case "Ioke":
        return "#078193"
    case "PogoScript":
        return "#d80074"
    case "Emacs Lisp":
        return "#c065db"
    case "JavaScript":
        return "#f1e05a"
    case "VimL":
        return "#199c4b"
    case "Matlab":
        return "#bb92ac"
    case "Slash":
        return "#007eff"
    case "R":
        return "#198ce7"
    case "Erlang":
        return "#0faf8d"
    case "Pan":
        return "#cc0000"
    case "LookML":
        return "#652B81"
    case "Eagle":
        return "#3994bc"
    case "Scheme":
        return "#1e4aec"
    case "PAWN":
        return "#dbb284"
    case "Python":
        return "#3581ba"
    case "Max":
        return "#ce279c"
    case "Common Lisp":
        return "#3fb68b"
    case "Latte":
        return "#A8FF97"
    case "XQuery":
        return "#2700e2"
    case "Omgrofl":
        return "#cabbff"
    case "Nimrod":
        return "#37775b"
    case "Nit":
        return "#0d8921"
    case "Chapel":
        return "#8dc63f"
    case "Groovy":
        return "#e69f56"
    case "Dylan":
        return "#3ebc27"
    case "E":
        return "#ccce35"
    case "Parrot":
        return "#f3ca0a"
    case "Grammatical Framework":
        return "#ff0000"
    case "Game Maker Language":
        return "#8ad353"
    case "VCL":
        return "#0298c3"
    case "Papyrus":
        return "#6600cc"
    case "FORTRAN":
        return "#4d41b1"
    case "Clean":
        return "#3a81ad"
    case "Alloy":
        return "#cc5c24"
    case "AGS Script":
        return "#B9D9FF"
    case "Slim":
        return "#ff8877"
    case "PureScript":
        return "#bcdc53"
    case "Julia":
        return "#a270ba"
    case "Haskell":
        return "#29b544"
    case "Io":
        return "#a9188d"
    case "Rouge":
        return "#cc0088"
    case "cpp":
        return "#f34b7d"
    case "Shen":
        return "#120F14"
    case "Dogescript":
        return "#cca760"
    case "nesC":
        return "#ffce3b"
    default:
        return "#ededed" // Other
    }
}
