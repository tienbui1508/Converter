//
//  ContentView.swift
//  UnitConversions
//
//  Created by Tien Bui on 15/5/2023.
//

import SwiftUI

struct ContentView: View {
    @State private var inputUnit: Dimension = UnitLength.meters
    @State private var outputUnit: Dimension = UnitLength.inches
    @State private var input: Double = 0
    @FocusState private var inputIsFocused: Bool
    
    let conversions = ["Distance", "Mass", "Temperature", "Time"]
    
    let unitTypes = [
        [UnitLength.meters, UnitLength.kilometers, UnitLength.inches, UnitLength.miles, UnitLength.feet],
        [UnitMass.grams, UnitMass.kilograms, UnitMass.ounces, UnitMass.pounds],
        [UnitTemperature.celsius, UnitTemperature.fahrenheit, UnitTemperature.kelvin],
        [UnitDuration.seconds, UnitDuration.minutes, UnitDuration.hours]
    ]
    
    @State var selectedUnit = 0
    let formatter: MeasurementFormatter

    init() {
        formatter = MeasurementFormatter()
        formatter.unitOptions = .providedUnit
        formatter.unitStyle = .long
    }
    
    var result: String {
        let inputValue = Measurement(value: input, unit: inputUnit)
        let outputValue = inputValue.converted(to: outputUnit)
        return formatter.string(from: outputValue)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    TextField("Amount", value: $input, format: .number)
                        .keyboardType(.decimalPad)
                        .focused($inputIsFocused)
                } header: {
                    Text("Amount to convert")
                }

                Picker("Convert type", selection: $selectedUnit) {
                    ForEach(0..<conversions.count) {
                        Text(conversions[$0])
                    }
                }

                Picker("Convert from", selection: $inputUnit) {
                    ForEach(unitTypes[selectedUnit], id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }

                Picker("Convert to", selection: $outputUnit) {
                    ForEach(unitTypes[selectedUnit], id: \.self) {
                        Text(formatter.string(from: $0).capitalized)
                    }
                }
                
                Section {
                    Text(result)
                } header: {
                    Text("Result")
                }
            }
            .navigationTitle("Converter")
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Done") {
                        inputIsFocused = false
                    }
                }
            }
            .onChange(of: selectedUnit) { newValue in
                let units = unitTypes[newValue]
                inputUnit = units[0]
                outputUnit = units[1]
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
