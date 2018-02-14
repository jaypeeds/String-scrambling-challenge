import Foundation

extension Array {
	func shift(by: Int?) -> [Element] { // Emulates APL vertical shift operator
		if case .some(let amount) = by {
			assert(-count...count ~= amount, "Shift amount out of bounds")
			switch(amount) {
				case 0:
				return self // NOP
				default:
					if amount < 0 {
						// Right
						return Array(self[count + amount ..< count] + self[0 ..< (count + amount)])
					} else {
						// Left
						return Array(self[amount ..< count] + self[0 ..< amount])
					}
			}
		} else {
			return self.reversed() // Mirror
		}
	}

	func select(only: [Bool]) -> [Element] { // Only Elements marked true
		assert(self.count == only.count, "Selection out of bounds")
		var selection = [Element]()
		for (mask, candidate) in Zip2Sequence(_sequence1:only, _sequence2:self) {
			if mask {
				selection.append(candidate)
			}
		}
		return selection
	}

	func select(accept: (Int) -> Bool) -> [Element] { // Only element with accepted index
		var selection = [Element]()
		for n in 0..<count {
			if accept(n) {
				selection.append(self[n])
			}
		}
		return selection
	}

	func selectMaskWhereValue(accept: (Element) -> Bool) -> [Bool] { // Mask of accepted values
		var mask = [Bool]()
		for value in self {
			mask.append(accept(value))
		}
		return mask
	}

	func updateWhereMask(mask:[Bool], values: [Element]) -> [Element] { // Update marked Elements, re-use values as needed
		assert(self.count == mask.count, "Length error")
		var selection = self
		var i = 0
		for n in 0..<count {
			if mask[n] {
				selection[n] = values[i]
				i += 1
				if (i == values.count) {
					i = 0
				}
			}
		}
		return selection
	}
}

func transform<T>(phrase: [T], which: (T) -> Bool, amplitude: Int? ) -> [T] {
	let mask = phrase.selectMaskWhereValue(accept: which)
	if mask.filter({$0}).count > 0 {
		return phrase.updateWhereMask(mask: mask, values: phrase.select(only: mask).shift(by: amplitude))
	} else {
		return phrase
	}
}

let alphabet = Array("ABCDEFGHIJKLMNOPQRSTUVWXYZ".characters)
let every2nd = alphabet.select(accept: {0 == (($0 + 1) % 2)})
let every3rd = alphabet.select(accept: {0 == (($0 + 1) % 3)})
let every4th = alphabet.select(accept: {0 == (($0 + 1) % 4)})

func cipher(clearText: String) -> String {
	let phrase = transform(phrase:
			transform(phrase:
				transform(phrase:Array(clearText.characters), 
						which: {every2nd.contains($0)}, amplitude: nil), 
				which: {every3rd.contains($0)}, amplitude: -1), 
			which: {every4th.contains($0)}, amplitude: 1)
	let maskSpaces = phrase.selectMaskWhereValue(accept: {$0 == " "})
	let maskNotSpaces = phrase.selectMaskWhereValue(accept: {$0 != " "})
	return String(phrase.updateWhereMask(mask: maskSpaces.shift(by: nil), values: [" "]).updateWhereMask(mask: maskNotSpaces.shift(by: nil), values: phrase.select(only: maskNotSpaces)))
}
func decipher(code: String) -> String {
	let ciphered = Array(code.characters)
	let spacesMask = ciphered.selectMaskWhereValue(accept: {$0 == " "})
	let notSpaceMask = ciphered.selectMaskWhereValue(accept: {$0 != " "})
	return String(
		transform(phrase: transform(phrase: transform(phrase:ciphered.updateWhereMask(mask: spacesMask.shift(by: nil), values: [" "]).updateWhereMask(mask: notSpaceMask.shift(by:nil), values: ciphered.select(only: notSpaceMask)), which: {every4th.contains($0)}, amplitude: -1), which: {every3rd.contains($0)}, amplitude: 1), which: {every2nd.contains($0)}, amplitude: nil))
}

print(cipher(clearText:"MOSTLY HARMLESS"))
print(cipher(clearText:"I KNOW KUNG FU"))
print(decipher(code:"ENID OL FNE"))
print(decipher(code:"UK IFWK ONGN U"))
print(decipher(code:"RMSI HT YDAT E OMADNA ID IIAC RVFTO AR"))
print(decipher(code:"BWASRHRT HIGAI TDHE SNR VIY BRTESLOIG YRE ALBG HMTDE INI BEWA LEA ND MRMSYW EDE TVEH ITO GOHES AOTDLE MLM ENA OLSTOUG BATE"))

// Output 
// MLSOHYTA RMLESS
// UK IFWK ONGN U
// END OF LINE
// I KNOW KUNG FU
// IM SORRY DAVE IM AFRAID I CANT DO THAT
// TWAS BRILLIG AND THE SLITHY TOVES DID GYRE AND GIMBLE IN THE WABE ALL MIMSY WERE THE BOROGOVES AND THE MOME RATHS OUTGRABE
