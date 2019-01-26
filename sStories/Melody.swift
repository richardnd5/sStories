class Melody {
    
    let type : MelodyType
    var number = Int()
    var slotPosition = Int()
    var audio : MelodyAudio?
    
    init(type: MelodyType){
        self.type = type
        number = setNumber()
        audio = MelodyAudio(number: number)
    }
    
    private func setNumber() -> Int {
        // depending on the type, choose a random pattern number.
        switch type {
        case .begin:
            return Int.random(in: 0...9)
        case .middle:
            return Int.random(in: 10...19)
        case .tonic:
            return Int.random(in: 20...29)
        case .dominant:
            return Int.random(in: 30...39)
        case .ending:
            return Int.random(in: 40...49)
        case .final:
            return Int.random(in: 50...54)
        }
    }
}
