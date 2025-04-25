---
title: iOS Workshop
date: 2025-04-25
draft: false
description: 參加 iOS 工作坊第二週的心得
tags:
  - iOS
  - Swift
---
# iOS 工作坊

簡單打一點上了兩週工作坊的心得，邊上邊打🙂。（還是其實是上課筆記？）
## 筆記

蘋果簽章：登入才給你簽，簽了才能上架，為了 App 不相衝，有用 reverse domain name

點 `.xcodeproj` 就能直接開 or `.xcworkspace` for 某些專案 ex. [try-swift-tokyo](https://github.com/tryswift/try-swift-tokyo?tab=readme-ov-file#getting-started)

好好的使用 preview 這件事，可以讓你快速呈現畫面

Predictive Code Completion Model (LLM) 蘋果本機跑的，但有點跟不上時代？

用 opt + click 去查看定義

```swift
struct VirtualKeyboard: View { // View 是一個 protocol，一個顯式方式？
	VStack (spacing 16) { // 排版用
		HStack () {
			speaker // 有點像函式的功能？
			keyborad
			speaker
		}
		.background(.red) // 修飾上面的元件 (HStack)
	}
}

@ViewBuilder
private var speaker: some View { // 定義 speaker 元件的地方
	Color.speakers
		.frame(width: 32)
		.padding(.vertical)
}
...

```

把講義最後的清單放進來好了：
### Xcode

- [x] 下載 Xcodes app
- [x] 安裝 Xcode 16.2
- [x] 下載 iOS 18.2 SDK
- [x] 新增一個 iOS 專案，並且跑在模擬器上
- [x] 設定 Xcode 的 Preview 快速鍵為 `Cmd + P`
- [x] 成功在 SwiftUI Preview 看到畫面
- [ ] 嘗試修改 Swift 檔案（多按幾行 Enter），然後按 `Cmd + Opt + I` 讓它自動排版
- [ ] 搞懂 Project、Target、Scheme、Run Destination 的區別（如果課堂中來不及消化，建議問 ChatGPT 問到飽。[對話範例](https://chatgpt.com/share/67bf3008-d3ec-800b-ac87-746fb80ce656)）
- [ ] 學會如何找到編譯階段的錯誤訊息
- [ ] 學會寫 `print`
- [ ] 學會切換中斷點

### 練習

- [ ] 找到一個想「做」的題目
- [x] 新增一個 macOS 專案
- [ ] 透過 SwiftUI 做出一部分的畫面
### 心得

說實話挺入門的，但作為一個開始學習怎麼寫 iOS App 的途徑來說應該算是不錯？跟自己在做的社課介紹滿像的。感覺有空可以再打一篇 DMCC 或 NTURO 的心得。

RAM 不太夠。至少要 16 GB 以上，感覺手邊這臺 Mac 還是買太早了？

說到 iOS 其實對版本滿敏感的，（甚至不建議用 App Store 來裝？），想到之前也滑到人說 Apple 的資安漏洞…可能得觀望一下吧，作為目前還是一個 Mac 重度使用者。

說起來…第一次碰到這種多層的 App 架構好像是暑假學的 React Native App，但那個半途而廢就是另一件事了。

噢，感覺這些模擬也是挺興師動眾的，版本就今年 + 去年 = 8 成多的使用者

蘋果內建的是很多，但感覺跟 font awesome 相比還是差了點 :)

噢，講師的語氣感覺也跟社課在上課滿像的，感覺很有趣？
對耶，整堂課感覺就在講一堆工具，他們也是工具控？但我們的工具控的方向感覺不太一樣，他們也覺比較像「[假宅男](https://wiwi.blog/docs/tech/fake-vs-real-tech-nerd)」？無貶義，不要打我。噢我應該也是四格派的，但可能 OS 寫一寫就會習慣兩格？沒什麼特別的堅持。

後面試著寫了一下，說實話體驗滿糟的。我想說既然只是個排版的練習就拿了可能 Github 主畫面的排版來練習，但先是 CPU 跑到 100% 不說，再來是元件使用困難，就算有建議也根本不知道該用哪一個。再來是 SF Symbol 的封閉性，就說根本比不了 Font Awesome 了，看來是完全不支援這些商標的。但反觀組員都至少寫出了個像樣的東西，有人甚至已經把那個日記主畫面寫出來了，可能回去再多試一下吧。
