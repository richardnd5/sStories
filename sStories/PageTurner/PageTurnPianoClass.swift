import Foundation
import AudioKit

//enum PageTurnPianoNote : String, CaseIterable {
//    case Gb2 = "PageTurnNoteGb2"
//    case Ab2 = "PageTurnNoteAb2"
//    case Bb2 = "PageTurnNoteBb2"
//    case C3 = "PageTurnNoteC3"
//    case Db3 = "PageTurnNoteDb3"
//    case Eb3 = "PageTurnNoteEb3"
//    case F3 = "PageTurnNoteF3"
//    case Gb3 = "PageTurnNoteGb3"
//    case Ab3 = "PageTurnNoteAb3"
//    case Bb3 = "PageTurnNoteBb3"
//    case C4 = "PageTurnNoteC4"
//    case Db4 = "PageTurnNoteDb4"
//    case Eb4 = "PageTurnNoteEb4"
//    case F4 = "PageTurnNoteF4"
//    case Gb4 = "PageTurnNoteGb4"
//    case Ab4 = "PageTurnNoteAb4"
//    case Bb4 = "PageTurnNoteBb4"
//    case C5 = "PageTurnNoteC5"
//    case Db5 = "PageTurnNoteDb5"
//}



//class PageTurnPianoClass {
//
//    private var audioFile : AKAudioFile?
//    var sampler = AKMIDISampler()
//    var name : PageTurnPianoNote!
//    var noteNumber : Int!
//
//    var noteArray = [42,44,46,48,49,51,53,54,56,58,60,61,63,65,66,68,70,72,73]
//
//    init(type: PageTurnPianoNote) {
//
//        audioFile = loadAudioFile(.Db3)
//        setupSampler()
//    }
//
//    private func loadAudioFile(_ name: PageTurnPianoNote)-> AKAudioFile{
//        let path = Bundle.main.url(forResource: name.rawValue, withExtension: "mp3")
//        var file : AKAudioFile!
//        do {
//            try  file = AKAudioFile(forReading: path!)
//        } catch {
//            print("didn't load the audio file. Why? \(error)")
//        }
//        return file
//    }
//
//    func getMidiNoteNumber(name: PageTurnPianoNote) -> Int {
//
//        var num : Int!
//        switch name {
//        case .Gb2:
//            num = 42
//        case .Ab2:
//            num = 44
//        default:
//            num = 60
//        }
//
//        return num
//    }
//
//    private func setupSampler(){
//        do { try sampler.loadAudioFile(audioFile!) } catch { print("Couldn't load the audio file. Here's why:     \(error)") }
//        sampler.enableMIDI()
//        Sound.sharedInstance.pianoMixer.connect(input: sampler)
//    }
//
//    func playNote(){
//        do { try sampler.play(noteNumber: 60, velocity: 50, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
//    }
//
//    func stopNote(){
//        do { try sampler.stop(noteNumber: 60, channel: 1) } catch { print("couldn't play the note. Why? Here:  \(error)") }
//    }
//}

