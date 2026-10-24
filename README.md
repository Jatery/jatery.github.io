# Jatery’s website

使用 [Minimal Mistakes](https://mmistakes.github.io/minimal-mistakes/docs/quick-start-guide/) 4.28.1 的原生版型。沒有自訂 CSS，也沒有複製主題的 layout、導覽或腳本。

## 改內容

- **首頁**：`_pages/home.md`，直接改 Markdown 正文。
- **近況**：`_now/` 裡每個主題一個 `.md`。`title` 是標題，`order` 決定順序。
- **Now 頁首與更新日期**：`_pages/now.md`。底下的 Liquid 迴圈會依序收進各主題，不必改它。
- **導覽連結**：`_data/navigation.yml`。
- **作者資料、聯絡方式與主題設定**：`_config.yml`。

新增近況時，在 `_now/` 新建檔案：

```markdown
---
title: "主題名稱"
order: 80
---

最近做了什麼，直接寫在這裡。
```

`order` 越小越前面。刪除主題檔案，就不再顯示那則近況。圖片、清單與連結都可以用 Markdown。

## 圖片

先壓縮圖片，再放進 `assets/images/`。摺紙照片使用約 82 KB 的 AVIF，原始 JPG 留存但不會發布。

```markdown
![照片說明](/assets/images/origami-tessellation-2026-09-832.avif){: width="416" height="555"}
```

圖片後面的尺寸是 Jekyll 內建 Markdown 引擎 Kramdown 的寫法，用來預留版面空間，不需要 HTML 或另外維護圖片資料表。換圖時按比例更新尺寸。

## 本機預覽

```sh
bundle exec jekyll serve
```

開啟終端機提示的本機網址。只檢查建置則執行 `bundle exec jekyll build`。

`_site/` 是生成的網頁，不要直接改。`.local-notes/` 是未加入 Git 的本機筆記與舊版備份，不會發布。

## 主題維護

要改設定，先查[主題文件](https://mmistakes.github.io/minimal-mistakes/docs/configuration/)。目前只保留頁籤圖示的 `head/custom.html`，以及舊文章正在使用的 `youtube.html`，沒有覆寫整份主題模板。

CSS 使用 Jekyll 的壓縮設定。更新圖片或主題後，檢查手機版和 Lighthouse；原生主題的載入資源與上一版不同，舊分數不能當作目前結果。

`_posts/` 目前仍排除於建置。既有文章與未完成草稿都保留，這次沒有開放發布。
