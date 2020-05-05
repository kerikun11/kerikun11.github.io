# KERI's Lab

けりのホームページ [KERI's Lab](https://kerikeri.top/) のソースコード

## 構成

以下の要領でホームページを公開しています．

1. マークダウン形式で記事を書く
2. 静的サイトジェネレータ [Hugo](https://gohugo.io/) でサイトを生成する
3. 生成したサイトを [GitHub Pages](https://pages.github.com/) で公開する
4. 独自ドメインを GitHub Pages に[設定](https://help.github.com/en/github/working-with-github-pages/configuring-a-custom-domain-for-your-github-pages-site)する
5. HTTPS アクセスを[許可](https://help.github.com/en/github/working-with-github-pages/securing-your-github-pages-site-with-https)する

### GitHubのブランチ構成

GitHub Pages で公開するにあたって，次のようなブランチ構成になっています．

- master
  - 生成したホームページの HTML などを含む静的サイトディレクトリ
- hugo
  - ホームページのソースとなる Hugo ソースディレクトリ

### サイトのテーマ

以下のテーマを Git Submodule として配置して使用しています．

- [Mainroad Theme](https://github.com/Vimux/Mainroad)
