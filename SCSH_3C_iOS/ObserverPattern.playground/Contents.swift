import Foundation

protocol Subject {
    // 紀錄狀態
    var userInput: String? { get set }
    
    // 綁定裝置
    func attach(observer: Observer)
    
    // 解除綁定裝置
    func detach(observer: Observer)
    
    // 通知
    func notify()
}

protocol Observer {
    // 更新
    func update()
}

// 聲控系統
class VoiceRecognition: Subject {
    var userInput: String? {
        didSet {
            notify()
        }
    }
    
    // 記錄所有裝置
    var devices = [Observer]()
    
    func attach(observer: Observer) {
        devices.append(observer)
    }
    
    func detach(observer: Observer) {}
    
    func notify() {
        for device in devices {
            device.update()
        }
    }
}

// 燈
class Light: Observer {
    func update() {
        print("燈被打開了！ 💡")
    }
}

// 門
class Door: Observer {
    func update() {
        print("門被打開了 90度！ 🚪")
    }
}

//class 窗簾:

// 聲控系統
let voiceRecognition = VoiceRecognition()
// 燈
let light = Light()
// 門
let door = Door()

// 在聲控系統上註冊燈的裝置
voiceRecognition.attach(observer: light)

// 在聲控系統上註冊門的裝置
voiceRecognition.attach(observer: door)

// 通知燈打開！
voiceRecognition.userInput = "打開燈！"
