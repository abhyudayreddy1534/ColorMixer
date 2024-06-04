//
//  ContentView.swift
//  ColorMixer
//
//  Created by Sravanthi Chinthireddy on 04/06/24.
//

import SwiftUI

struct ContentView: View {
    @State var cssColor: String = ""
    @State var redValue: Double = 0.0
    @State var greenValue: Double = 0.0
    @State var blueValue: Double = 0.0
    
    let acceptedInputString = "0123456789ABCDEFabcdef"
    
    func rgbToHexColor(r: Int, g: Int, b: Int) -> String {
        return String(format: "#%02X%02X%02X", r, g, b)
    }
    
    func hexToRGBColor(hex: String) {
        let hexFormatted = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        
        guard hexFormatted.count == 6, let hexValue = UInt64(hexFormatted, radix: 16) else {
            //return nil
            fatalError("unable to decode HEX")
        }
        
        
        redValue = Double(Int((hexValue & 0xFF0000) >> 16)) / 255
        greenValue = Double(Int((hexValue & 0xFF00) >> 8)) / 255.0
        blueValue = Double(Int(hexValue & 0x0000FF)) / 255
    }
    
    func decimalToInt(dec: Double) -> Int {
        return Int((dec * 255).rounded())
    }
    
    func validateCSSColorInput() {
        let acceptedInput = cssColor.uppercased().filter {acceptedInputString.contains($0)}
        if acceptedInput.count == 6 {
            if acceptedInput.count > 6 {
                cssColor = String(acceptedInput.prefix(6))
            }
            else {
                cssColor = acceptedInput
            }
            hexToRGBColor(hex: cssColor)
        }
    }
    
    var body: some View {
        VStack() {
            ZStack {
                Rectangle()
                    .fill(Color(red: redValue, green: greenValue, blue: blueValue))
                .frame(height: 300)
                Text(
                    rgbToHexColor(
                        r: decimalToInt(dec: redValue),
                        g: decimalToInt(dec: greenValue),
                        b: decimalToInt(dec: blueValue)
                    )
                )
                .font(.title2)
                .fontWeight(.medium)
                .foregroundStyle(
                    (
                        redValue>0.5 && greenValue > 0.5 && blueValue > 0.5
                    ) ? .black : .white
                )
                .shadow(
                    color: .black,
                    radius: /*@START_MENU_TOKEN@*/10/*@END_MENU_TOKEN@*/,
                    x: 5,
                    y: 5
                )
            }
            TextField(
                "CSS Code",
                text: Binding(
                    get: { self.cssColor },
                    set: { newValue in
                        self.cssColor = newValue.filter {acceptedInputString.contains($0)}
                        validateCSSColorInput()
                    }
                )
            )
                .border(cssColor.count == 6 ? .green : .red)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .padding(.horizontal, 50)
                .frame(alignment: .center)
                .autocorrectionDisabled()
                .textInputAutocapitalization(.never)
                .onSubmit {
                    validateCSSColorInput()
                }
            
            VStack {
                Text("Red: \(redValue)")
                Slider(value: $redValue, in: 0...1, step: 0.05)
            }
            .padding()
            VStack {
                Text("Green: \(greenValue)")
                Slider(value: $greenValue, in: 0...1, step: 0.05)
            }
            .padding()
            VStack {
                Text("Blue: \(blueValue)")
                Slider(value: $blueValue, in: 0...1, step: 0.05)
            }
            .padding()
            
        }
        .padding()
    }
    
}

#Preview {
    ContentView()
}
