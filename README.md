# 南京理工大学本科毕业设计（论文）LaTeX 模板

这是南京理工大学本科毕业设计（论文）报告模板。它面向以前主要使用 Word 的同学：正文文件只写“内容”和“语义命令”，字号、行距、目录、图表目录、参考文献和封面位置都由 `sty/njustBachelorThesis.cls` 统一控制。

主入口是 `myThesis.tex`；个人信息在 `tex/cover.tex`；正文在 `tex/chap*.tex`；参考文献在 `bib/references.bib`。

## 快速开始

使用 XeLaTeX 编译。根目录的 `.latexmkrc` 已经指定了 XeLaTeX 和 `build/` 输出目录：

```powershell
latexmk myThesis.tex
```

目录、图表目录、交叉引用和参考文献都需要多轮编译，`latexmk` 会自动完成。中间文件会统一放在 `build/` 目录；`build/myThesis.pdf` 是 LaTeX Workshop 用来正反向定位的 PDF，构建成功后会额外复制一份 `myThesis.pdf` 到根目录，方便直接查看或提交。

VS Code 已配置 LaTeX Workshop：

- 保存文件后自动编译：`.vscode/settings.json` 中的 `latex-workshop.latex.autoBuild.run`。
- 不再自动清理中间文件：`latex-workshop.latex.autoClean.run` 设为 `never`，这样下次增量编译会快很多。
- PDF 正反向定位使用 `build/myThesis.pdf` 和 `build/myThesis.synctex.gz`。根目录的 `myThesis.pdf` 只是构建成功后复制出来的成品副本。

如果确实需要完全重新构建，可以手动清理：

```powershell
latexmk -C myThesis.tex
Remove-Item build -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item myThesis.pdf -Force -ErrorAction SilentlyContinue
```

## 从 Word 切换到 LaTeX

Word 里你通常直接选中文字改字体、字号、段前段后。这个模板里不要这样做。正文文件不要写 `\zihao`、`\songti`、`\vspace` 这类格式命令，除非你明确知道自己在覆盖模板。

正确做法是：

- 新段落：空一行。
- 一级/二级/三级/四级标题：用标题命令。
- 图片、表格、公式：用对应环境。
- 文献：写进 `.bib`，正文用 `\cite{}`。
- 格式调整：集中改 `sty/njustBachelorThesis.cls`。

不要用空格手动缩进段首。模板会自动处理首行缩进。

## 全文结构

`myThesis.tex` 负责组织全文：

```tex
\frontmatter
\input{tex/abstract}
\tableofcontents
\njustlistoffiguresandtables

\mainmatter
\input{tex/chap1}
\input{tex/chap2}
\input{tex/conclusion}

\backmatter
\input{tex/thanks}
\nocite{*}
\addbibliography{bib/references}
\input{tex/appendix}
```

含义：

- `\frontmatter`：前置部分，页码为罗马数字，如摘要、目录、图表目录。
- `\mainmatter`：正文部分，页码从阿拉伯数字 1 开始。
- `\backmatter`：后置部分，如致谢、参考文献、附录。
- `\input{tex/chap1}`：把某个章节文件插入到当前位置。

新增章节时，新建 `tex/chap3.tex`，然后在 `\mainmatter` 后加入：

```tex
\input{tex/chap3}
```

## 标题层级

Word 里的“一级标题、二级标题、三级标题、四级标题”对应下面这些命令：

```tex
\njustchapter{绪论}          % 一级标题：1 绪论
\section{课题背景及研究意义} % 二级标题：1.1 课题背景及研究意义
\subsection{储能机理}       % 三级标题：1.1.1 储能机理
\subsubsection{评价指标}    % 四级标题：1.1.1.1 评价指标
```

正文里建议使用 `\njustchapter`，不要直接用 `\chapter`。`\njustchapter` 是模板提供的章命令，它保留了学校格式和页眉处理。

如果章标题很长，页眉可以用短标题：

```tex
\njustchapter[页眉短标题]{正文和目录中显示的完整标题}
```

方括号 `[...]` 是可选参数，花括号 `{...}` 是必填参数。

不要随意使用带星号的标题命令，例如 `\section*{}`。星号标题通常不会编号，也不会自动进目录。

## 封面信息

封面信息集中在 `tex/cover.tex`。

为什么标题要写好几个？

Word 模板的封面、中文题名页、英文题名页和页眉对标题的排版要求不同：封面有下划线和固定两行位置；题名页只需要居中标题；页眉需要一行短标题。因此模板把它们拆开，避免一个标题在所有位置都被迫使用同一种换行。

常用命令：

```tex
\njustcovertitle{封面第一行}{封面第二行}
\njusttitlelines{中文题名页第一行}{中文题名页第二行}
\njustheadertitle{页眉短标题}

\njustenglishtitlelines{English Title Line 1}{English Title Line 2}

\njustauthor{张三}
\njustenglishauthor{Zhang San}
\njuststudentid{1234567445}

\njustsupervisor{爱丽丝}{教授}
\njustenglishsupervisor[Prof.]{Alice}

\njustcollege{学院名称}
\njustmajor{专业名称}
\njustfield{研究方向}
\njustsubmitdate{2026年6月}
```

如果标题只有一行，第二个参数可以留空：

```tex
\njusttitlelines{只有一行的中文题名}{}
```

英文导师头衔写在 `\njustenglishsupervisor` 的方括号里，例如：

```tex
\njustenglishsupervisor[Prof.]{Alice}
\njustenglishsupervisor[Associate Prof.]{Alice}
\njustenglishsupervisor[Dr.]{Alice}
```

如果不写方括号，默认使用 `Prof.`。

## 摘要和关键词

摘要在 `tex/abstract.tex`。

```tex
\begin{njustcnabstract}
这里写中文摘要正文。

\njustkeywords{关键词一，关键词二，关键词三}
\end{njustcnabstract}

\begin{njustenabstract}
Write the English abstract here.

\njustenkeywords{keyword one, keyword two, keyword three}
\end{njustenabstract}
```

摘要正文会自动首行缩进，标题和行距由 `.cls` 控制。

## 图片

图片放在 `img` 目录。建议文件名使用英文、数字和短横线，少用中文路径。

```tex
\begin{figure}[htbp]
  \centering
  \includegraphics[width=0.82\textwidth]{img/sample/arms.jpg}
  \caption{实验平台与机械臂样机示意}
  \label{fig:arms}
\end{figure}

如图~\ref{fig:arms} 所示，……
```

说明：

- `figure`：图片浮动体，LaTeX 会自动安排位置。
- `[htbp]`：建议位置，依次表示 here、top、bottom、page。
- `\caption{}`：图题，会自动生成“图 2.1”。
- `\label{}`：给图片起内部标签，正文用 `\ref{}` 引用。

矢量示意图可以用 TikZ，示例见 `tex/chap2.tex`。

## 表格

普通三线表：

```tex
\begin{table}[htbp]
  \centering
  \caption{不同沉积时间下的 EIS 拟合结果}
  \label{tab:eis}
  \begin{tabular}{ccc}
    \toprule
    样本 & $R_{\mathrm{L}}$ & $C_{\mathrm{s}}$ \\
    \midrule
    MG4(500s) & 0.564 & 128.4 \\
    MG4(1000s) & 0.539 & 136.7 \\
    \bottomrule
  \end{tabular}
\end{table}

见表~\ref{tab:eis}。
```

`{ccc}` 表示三列都居中。模板会把常见的 `{cc}` 和 `{ccc}` 处理成定宽居中表格，更接近 Word 示例。

表格总宽度调 `sty/njustBachelorThesis.cls` 中的 `\NJUST@tablewidth`；表格行距调 `\NJUST@tablearraystretch`。

## 公式

用 `equation` 环境生成带编号公式：

```tex
\begin{equation}
  C_{\mathrm{s}} = \frac{I \Delta t}{m \Delta U}
  \label{eq:specific-capacitance}
\end{equation}

比电容按\njusteqref{eq:specific-capacitance} 计算。
```

公式编号按章编号，例如 `(2.1)`。`\njusteqref{}` 会输出“式（2.1）”。

公式上下空白在 `.cls` 的 `Floats, Equations And Captions` 小节调：

```tex
\NJUST@displayaboveskip
\NJUST@displaybelowskip
```

## 参考文献

文献数据写在 `bib/references.bib`。正文用：

```tex
已有研究表明该方法可用于信号检测\cite{devillez2007tool}。
```

`\cite{}` 会生成右上角方括号引用。文末参考文献由 `myThesis.tex` 中的命令生成：

```tex
\addbibliography{bib/references}
```

`.bib` 条目示例：

```bibtex
@article{devillez2007tool,
  author = {Devillez, A. and Dudzinski, D.},
  title = {Tool vibration detection with eddy current sensors in machining process},
  journal = {Mechanical Systems and Signal Processing},
  year = {2007}
}
```

模板中目前保留了：

```tex
\nocite{*}
```

它会把 `references.bib` 里的全部文献列出来。正式论文如果只想显示正文引用过的文献，删除这一行。

## 致谢和附录

致谢在 `tex/thanks.tex`：

```tex
\begin{njustthanks}
这里写致谢正文。
\end{njustthanks}
```

附录在 `tex/appendix.tex`：

```tex
\begin{njustappendix}
\njustappendixitem{本科期间发表的论文和出版著作情况：}
无。

\njustappendixitem{本科期间参加的科学研究情况：}
这里写内容。
\end{njustappendix}
```

附录小标题的字号、粗细和间距由 `.cls` 控制，不要在正文里手动加粗。

## 常见警告

`Underfull \vbox` 通常不是错误。它表示某一页内容在竖直方向不够满，LaTeX 拉伸空白后觉得效果不理想。图、表、浮动体较多时很常见。PDF 正常生成时可以先忽略。

真正需要优先处理的是：

- `Undefined reference`：交叉引用还没解析，重新编译或检查 `\label`。
- `Citation undefined`：文献 key 写错，或 BibTeX 没跑成功。
- `! LaTeX Error`：语法或环境错误，需要修正。

## 格式微调位置

所有格式优先改 `sty/njustBachelorThesis.cls`：

- 页面边距：`Page Layout`
- 正文 20 磅行距：`Fonts And Body Text` 的 `\NJUST@bodyfont`
- 中文粗体粗细：`\NJUST@CJKBoldFake`
- 封面坐标：`Cover And Title Pages`
- 标题段前段后：`Headings` 的 `beforeskip` 和 `afterskip`
- 公式上下空白：`\NJUST@display...skip`
- 表格宽度和行距：`\NJUST@tablewidth`、`\NJUST@tablearraystretch`
- 目录缩进：`\NJUST@toc...` 系列长度
- 图表目录编号后空白：`\NJUST@lofgap`
- 致谢/附录标题下空白：`\NJUST@backtitleafterskip`
- 附录小标题上下空白：`\NJUST@appendixitembeforeskip`、`\NJUST@appendixitemafterskip`
- 参考文献样式：`\NJUST@bibstyle`


