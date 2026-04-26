% !TeX root = ../myThesis.tex
\NeedsTeXFormat{LaTeX2e}
\ProvidesClass{sty/njustBachelorThesis}[2026/04/25 NJUST undergraduate thesis template]

% ----------------------------------------------------------------------
% 南京理工大学本科毕业设计（论文）报告模板
% ----------------------------------------------------------------------
% 本 class 只负责“格式”：页面、字体、封面、页眉页脚、标题、目录、
% 图表、摘要、致谢、参考文献和附录。正文 tex 文件应只写内容和语义命令。
%
% 调格式优先改本文件。常用调节点都在对应小节前有说明：
%   1. 页面边距                 -> geometry 小节
%   2. 字体和 20 磅行距          -> fonts/body 小节
%   3. 封面/中英文题名页坐标      -> cover/title pages 小节
%   4. 章/节/小节标题            -> headings 小节
%   5. 目录、图表目录缩进         -> contents 小节
%   6. 图题、表题、表格字号       -> floats 小节
%   7. BibTeX 样式和参考文献标题  -> bibliography 小节

\DeclareOption*{\PassOptionsToClass{\CurrentOption}{ctexbook}}
\ProcessOptions\relax

\LoadClass[UTF8,a4paper,zihao=-4,openany,twoside,fontset=windows]{ctexbook}

% 只保留模板自身需要的包。正文若需要算法、代码、高级表格等扩展，
% 建议在 myThesis.tex 中额外加载，避免 class 变重。
\RequirePackage{geometry}
\RequirePackage{fontspec}
\RequirePackage{graphicx}
\RequirePackage{tikz}
\RequirePackage{fancyhdr}
\RequirePackage{caption}
\RequirePackage{array}
\RequirePackage{amsmath}
\RequirePackage{amssymb}
\RequirePackage{booktabs}
\RequirePackage{etoolbox}
\RequirePackage[square,comma,numbers,sort&compress,super]{natbib}
\RequirePackage[hidelinks,hypertexnames=false]{hyperref}

\usetikzlibrary{calc}

\makeatletter

% ----------------------------------------------------------------------
% Page Layout
% ----------------------------------------------------------------------
% 页面边距按本科撰写格式说明设置：
%   上 30mm，下 24mm，左 25mm，右 25mm。
% 如果页眉压线或页码位置需要微调，只改 headheight/headsep/footskip。
% 页码太低：减小 footskip；页码太高：增大 footskip。
\geometry{
  a4paper,
  left=25mm,
  right=25mm,
  top=30mm,
  bottom=24mm,
  headheight=14pt,
  headsep=6mm,
  footskip=6mm
}

% ----------------------------------------------------------------------
% Fonts And Body Text
% ----------------------------------------------------------------------
% 要求：汉字用宋体，数字和字母用 Times New Roman。
% XeLaTeX 会自动按字符选择 CJK/西文字体；正文里不用手动加字体命令。
\defaultfontfeatures{Ligatures=TeX}
\IfFontExistsTF{Times New Roman}{\setmainfont{Times New Roman}}{}
\IfFontExistsTF{Arial}{\setsansfont{Arial}}{}
\IfFontExistsTF{Consolas}{\setmonofont{Consolas}}{}
% 中文宋体/黑体/楷体由 ctexbook 的 fontset=windows 提供：
%   \songti, \heiti, \kaishu
% 如果要换成其它中文字体，优先改 \LoadClass 的 fontset，
% 或在这里重新启用 \setCJKmainfont / \setCJKfamilyfont。

% 中文粗体粗细统一控制。
% ctex 的 Windows 字体集里，部分中文粗体可能会走较重的字体或默认伪粗；
% 这里显式把宋体、黑体、楷体的 \bfseries 绑定到可调 FakeBold。
% 数值越大越粗；如果比 Word 粗，先试 1.1--1.3；如果太细，试 1.5--1.8。
\newcommand{\NJUST@CJKBoldFake}{3.0}
\IfFontExistsTF{SimSun}{%
  \setCJKmainfont{SimSun}[
    BoldFont = SimSun,
    BoldFeatures = { FakeBold = \NJUST@CJKBoldFake },
    ItalicFont = KaiTi
  ]%
  \setCJKfamilyfont{zhsong}{SimSun}[
    BoldFont = SimSun,
    BoldFeatures = { FakeBold = \NJUST@CJKBoldFake }
  ]%
}{}
\IfFontExistsTF{SimHei}{%
  \setCJKfamilyfont{zhhei}{SimHei}[
    BoldFont = SimHei,
    BoldFeatures = { FakeBold = \NJUST@CJKBoldFake }
  ]%
}{}
\IfFontExistsTF{KaiTi}{%
  \setCJKfamilyfont{zhkai}{KaiTi}[
    BoldFont = KaiTi,
    BoldFeatures = { FakeBold = \NJUST@CJKBoldFake }
  ]%
}{}

% 正文：小四号宋体，固定 20 磅行距，首行缩进 2 字符。
% 如果正文整体显得太松/太紧，只改 \NJUST@bodyfont 里的 baselineskip。
\setlength{\parindent}{2em}
\setlength{\parskip}{0pt}
\linespread{1.0}
\newcommand{\NJUST@bodyfont}{%
  \songti\zihao{-4}\setlength{\baselineskip}{20pt}\selectfont
}
\AtBeginDocument{\NJUST@bodyfont}

% 标题、center/list 环境之后，LaTeX 有时会抑制紧跟第一段的缩进。
% 需要强制“第一段也缩进”时，在标题后正文前调用这个命令。
\newcommand{\NJUST@firstparindent}{%
  \par\noindent\hspace*{\parindent}\ignorespaces
}

% PDF 书签里去掉中文标题常用的空格命令，避免 hyperref 警告。
\pdfstringdefDisableCommands{%
  \def\quad{ }%
  \def\qquad{ }%
}

% ----------------------------------------------------------------------
% Thesis Metadata And Public Commands
% ----------------------------------------------------------------------
% tex/cover.tex 只填写这些语义命令，不直接写字号、行距、坐标。
% Word 封面和中英文题名页对“换行位置”的要求不同，所以这里把题名分开：
%   \njustcovertitle{封面第一行}{封面第二行}
%   \njusttitlelines{中文题名页第一行}{中文题名页第二行}
%   \njustenglishtitlelines{英文题名页第一行}{英文题名页第二行}
%   \njustheadertitle{页眉里显示的短题名，不换行}
% 注意：这里使用 \par 换行，让题名行距真正受 baselineskip 控制；
% 不再使用 \\[8pt] 这种显式距离，否则 makechinesetitle 里的行距设置会失效。
% 本科模板目前只保留一个指导教师；如需恢复第二导师，优先在封面命令区扩展。
\newlength{\NJUST@chineseTitleBaselineskip}
\newlength{\NJUST@englishTitleBaselineskip}
\setlength{\NJUST@chineseTitleBaselineskip}{32pt}
\setlength{\NJUST@englishTitleBaselineskip}{38pt}

\newcommand{\NJUST@logo}{img/logo/njust.pdf}
\newcommand{\NJUST@title}{}
\newcommand{\NJUST@coverTitleA}{}
\newcommand{\NJUST@coverTitleB}{}
\newcommand{\NJUST@headerTitle}{}
\newcommand{\NJUST@author}{}
\newcommand{\NJUST@enauthor}{}
\newcommand{\NJUST@studentid}{}
\newcommand{\NJUST@supervisor}{}
\newcommand{\NJUST@supervisortitle}{}
\newcommand{\NJUST@ensupervisor}{}
\newcommand{\NJUST@college}{}
\newcommand{\NJUST@major}{}
\newcommand{\NJUST@field}{}
\newcommand{\NJUST@submitdate}{}
\newcommand{\NJUST@school}{南京理工大学}
\newcommand{\NJUST@date}{}
\newcommand{\NJUST@entitle}{}
\newcommand{\NJUST@endate}{}

\newcommand{\njustlogo}[1]{\renewcommand{\NJUST@logo}{#1}}
\newcommand{\njusttitle}[1]{\renewcommand{\NJUST@title}{#1}}
\newcommand{\njusttitlelines}[2]{%
  \renewcommand{\NJUST@title}{#1\par #2}%
}
\newcommand{\njustcovertitle}[2]{%
  \renewcommand{\NJUST@coverTitleA}{#1}%
  \renewcommand{\NJUST@coverTitleB}{#2}%
}
\newcommand{\njustheadertitle}[1]{\renewcommand{\NJUST@headerTitle}{#1}}
\newcommand{\njustauthor}[1]{\renewcommand{\NJUST@author}{#1}}
\newcommand{\njustenglishauthor}[1]{\renewcommand{\NJUST@enauthor}{#1}}
\newcommand{\njuststudentid}[1]{\renewcommand{\NJUST@studentid}{#1}}
\newcommand{\njustsupervisor}[2]{%
  \renewcommand{\NJUST@supervisor}{#1}%
  \renewcommand{\NJUST@supervisortitle}{#2}%
}
\newcommand{\njustenglishsupervisor}[1]{%
  \renewcommand{\NJUST@ensupervisor}{#1}%
}
\newcommand{\njustcollege}[1]{\renewcommand{\NJUST@college}{#1}}
\newcommand{\njustmajor}[1]{\renewcommand{\NJUST@major}{#1}}
\newcommand{\njustfield}[1]{\renewcommand{\NJUST@field}{#1}}
\newcommand{\njustsubmitdate}[1]{\renewcommand{\NJUST@submitdate}{#1}}
\newcommand{\njustschool}[1]{\renewcommand{\NJUST@school}{#1}}
\newcommand{\njustdate}[1]{\renewcommand{\NJUST@date}{#1}}
\newcommand{\njustenglishtitle}[1]{\renewcommand{\NJUST@entitle}{#1}}
\newcommand{\njustenglishtitlelines}[2]{%
  \renewcommand{\NJUST@entitle}{#1\par #2}%
}
\newcommand{\njustenglishdate}[1]{\renewcommand{\NJUST@endate}{#1}}

% ----------------------------------------------------------------------
% Cover And Title Pages
% ----------------------------------------------------------------------
% 下面封面使用 tikz overlay 绝对定位，坐标基准为页面左上角或上边中点。
% 调封面最常见的是纵向位置：
%   (current page.north)+(0,-73.5mm) 里的 -73.5mm 越大，内容越往下。
%   current page.north west)+(43mm,-39mm) 里的 43mm 改横向，-39mm 改纵向。
% “毕业设计（论文）报告”按要求为楷体加粗。
\newcommand{\NJUST@coverlabel}[1]{%
  {\hbadness=10000\songti\bfseries\zihao{4}\makebox[35mm][s]{#1}}%
}
\newcommand{\NJUST@covervalue}[1]{%
  {\kaishu\bfseries\zihao{3}#1}%
}
\newcommand{\NJUST@coverrow}[3]{%
  \node[anchor=west,inner sep=0pt] at ($(current page.north west)+(43mm,-#1)$) {\NJUST@coverlabel{#2}};
  \draw[line width=.45pt] ($(current page.north west)+(79mm,-#1-2.8mm)$) -- ($(current page.north west)+(168mm,-#1-2.8mm)$);
  \node[anchor=base,inner sep=0pt] at ($(current page.north west)+(123.5mm,-#1-0.2mm)$) {\NJUST@covervalue{#3}};
}

\newcommand{\makecover}{%
  \clearpage
  \thispagestyle{empty}%
  \begin{tikzpicture}[remember picture,overlay]
    \node[anchor=north west,inner sep=0pt] at ($(current page.north west)+(43mm,-39mm)$)
      {\includegraphics[width=124mm]{\NJUST@logo}};
    \node[anchor=north,align=center,inner sep=0pt] at ($(current page.north)+(0,-73.5mm)$)
      {{\kaishu\bfseries\fontsize{32pt}{30pt}\selectfont 毕业设计（论文）报告}};

    \node[anchor=base,align=center,inner sep=0pt] at ($(current page.north)+(0,-110.5mm)$)
      {{\heiti\bfseries\zihao{-1}\NJUST@coverTitleA}};
    \draw[line width=.45pt] ($(current page.north west)+(23mm,-113.4mm)$) -- ($(current page.north west)+(187mm,-113.4mm)$);
    \node[anchor=base,align=center,inner sep=0pt] at ($(current page.north)+(0,-123.7mm)$)
      {{\heiti\bfseries\zihao{-1}\NJUST@coverTitleB}};
    \draw[line width=.45pt] ($(current page.north west)+(23mm,-127.1mm)$) -- ($(current page.north west)+(187mm,-127.1mm)$);

    \draw[line width=.45pt] ($(current page.north west)+(77.5mm,-147.6mm)$) -- ($(current page.north west)+(132.5mm,-147.6mm)$);
    \node[anchor=base,inner sep=0pt] at ($(current page.north)+(0,-146.0mm)$)
      {{\kaishu\bfseries\fontsize{18pt}{18pt}\selectfont\NJUST@author}};
    \draw[line width=.45pt] ($(current page.north west)+(77.5mm,-161.2mm)$) -- ($(current page.north west)+(132.5mm,-161.2mm)$);
    \node[anchor=base,inner sep=0pt] at ($(current page.north)+(0,-159.6mm)$)
      {{\rmfamily\bfseries\fontsize{18pt}{18pt}\selectfont\NJUST@studentid}};

    % 只有一个指导教师时，按示例把导师信息放在原第二行位置。
    \NJUST@coverrow{191mm}{指 导 教 师}{\kaishu\zihao{4}\NJUST@supervisor\qquad{\kaishu\bfseries\zihao{4}\underline\NJUST@supervisortitle}}
    \NJUST@coverrow{201mm}{学 生 学 院}{\zihao{4}\NJUST@college}
    \NJUST@coverrow{211mm}{专 业}{\zihao{4}\NJUST@major}
    \NJUST@coverrow{221mm}{研 究 方 向}{\zihao{4}\NJUST@field}
    \NJUST@coverrow{231mm}{提 交 时 间}{\songti\bfseries\zihao{4}\NJUST@submitdate}
  \end{tikzpicture}%
  \clearpage
}

% 第二页中文题名页。
% 题名行距调 \NJUST@chineseTitleBaselineskip；
% 这里用 minipage + \centering，避免短中文行被拉宽字间距。
\newcommand{\makechinesetitle}{%
  \thispagestyle{empty}%
  \begin{tikzpicture}[remember picture,overlay]
    \node[anchor=north,inner sep=0pt] at ($(current page.north)+(0,-53mm)$)
      {\begin{minipage}{165mm}
        \centering
        \heiti\bfseries\zihao{-1}\setlength{\baselineskip}{\NJUST@chineseTitleBaselineskip}\selectfont
        \NJUST@title
      \end{minipage}};

    \node[anchor=west,inner sep=0pt] at ($(current page.north west)+(63mm,-112mm)$)
      {{\kaishu\bfseries\fontsize{18pt}{18pt}\selectfont 作\qquad 者：\NJUST@author}};
    \node[anchor=west,inner sep=0pt] at ($(current page.north west)+(63mm,-134mm)$)
      {{\kaishu\bfseries\fontsize{18pt}{18pt}\selectfont 指导教师：\NJUST@supervisor\quad \NJUST@supervisortitle}};

    \node[anchor=north,align=center,inner sep=0pt] at ($(current page.north)+(0,-230mm)$)
      {{\songti\bfseries\fontsize{18pt}{18pt}\selectfont\ziju{0.25}\NJUST@school}};
    \node[anchor=north,align=center,inner sep=0pt] at ($(current page.north)+(0,-242mm)$)
      {{\rmfamily\bfseries\fontsize{18pt}{18pt}\selectfont\NJUST@date}};
  \end{tikzpicture}%
  \clearpage
}

% 第三页英文题名页。
% 英文题名行距调 \NJUST@englishTitleBaselineskip。
\newcommand{\makeenglishtitle}{%
  \thispagestyle{empty}%
  \begin{tikzpicture}[remember picture,overlay]
    \node[anchor=north,inner sep=0pt] at ($(current page.north)+(0,-66mm)$)
      {\begin{minipage}{160mm}
        \centering
        \rmfamily\bfseries\zihao{2}\setlength{\baselineskip}{\NJUST@englishTitleBaselineskip}\selectfont
        \NJUST@entitle
      \end{minipage}};
    \node[anchor=north,align=center,inner sep=0pt] at ($(current page.north)+(0,-100mm)$)
      {{\rmfamily\itshape\fontsize{18pt}{18pt}\selectfont By}};
    \node[anchor=north,align=center,inner sep=0pt] at ($(current page.north)+(0,-110mm)$)
      {{\rmfamily\itshape\fontsize{18pt}{18pt}\selectfont \NJUST@enauthor}};
    \node[anchor=north,align=center,inner sep=0pt] at ($(current page.north)+(0,-142mm)$)
      {{\rmfamily\itshape\fontsize{18pt}{18pt}\selectfont Supervised by Prof. \NJUST@ensupervisor}};
    \node[anchor=north,align=center,inner sep=0pt] at ($(current page.north)+(0,-221mm)$)
      {{\rmfamily\bfseries\fontsize{18pt}{18pt}\selectfont Nanjing University of Science \& Technology}};
    \node[anchor=north,align=center,inner sep=0pt] at ($(current page.north)+(0,-233mm)$)
      {{\rmfamily\bfseries\fontsize{18pt}{18pt}\selectfont\NJUST@endate}};
  \end{tikzpicture}%
  \clearpage
}

% 声明页。这里的 30pt 行距来自 Word 示例的较疏排布。
\newcommand{\makestatement}{%
  \thispagestyle{empty}%
  \vspace*{8pt}
  \begin{center}{\songti\bfseries\zihao{3}声\quad 明}\end{center}
  \vspace{-13pt}
  {\songti\zihao{4}\setlength{\baselineskip}{30pt}\selectfont\setlength{\parindent}{2em}
  \NJUST@firstparindent 本毕业设计（论文）是我在导师的指导下取得的研究成果，尽我所知，除了加以标注和致谢的部分外，不包含其他人已经发表或公布过的研究成果，也不包含我为获得任何教育机构的学位或学历而使用过的材料。与我一同工作的同事对本毕业设计（论文）做出的贡献均已在文中作了明确的说明。\par
  \vspace{37pt}
  \noindent 学生签名：\rule{36mm}{.45pt}\hfill 年\quad 月\quad 日\hspace{48mm}\par
  \vspace{84pt}
  \begin{center}{\songti\bfseries\zihao{3}使用授权声明}\end{center}
  \vspace{-13pt}
  \NJUST@firstparindent 南京理工大学有权保存本文的电子和纸质文档，可以借阅或上网公布本文的部分或全部内容，可以向有关部门或机构送交并授权其保存、借阅或上网公布本文的部分或全部内容。对于保密论文，按保密的有关规定和程序处理。\par
  \vspace{36pt}
  \noindent 学生签名：\rule{36mm}{.45pt}\hfill 年\quad 月\quad 日\hspace{48mm}\par
  }%
  \clearpage
}

% ----------------------------------------------------------------------
% Header, Footer And Matter Switches
% ----------------------------------------------------------------------
% 奇数页左侧显示报告名、右侧显示论文题名；偶数页相反。
% 页码在外侧页脚。页眉线宽用 headrulewidth 调。
\fancypagestyle{njustmain}{%
  \fancyhf{}%
  \fancyhead[LO]{\songti\zihao{-5}毕业设计（论文）报告}%
  \fancyhead[RO]{\songti\zihao{-5}\NJUST@headerTitle}%
  \fancyhead[LE]{\songti\zihao{-5}\leftmark}%
  \fancyhead[RE]{\songti\zihao{-5}毕业设计（论文）报告}%
  \fancyfoot[RO]{\rmfamily\zihao{-5}\thepage}%
  \fancyfoot[LE]{\rmfamily\zihao{-5}\thepage}%
  \renewcommand{\headrulewidth}{.75pt}%
  \renewcommand{\footrulewidth}{0pt}%
}
\pagestyle{njustmain}
\let\ps@plain\ps@njustmain

\renewcommand{\chaptermark}[1]{%
  \markboth{\ifnum\value{chapter}>0 \thechapter\quad #1\else #1\fi}{}%
}
\renewcommand{\sectionmark}[1]{}

\renewcommand{\frontmatter}{%
  \clearpage
  \@mainmatterfalse
  \pagenumbering{Roman}%
  \pagestyle{njustmain}%
  \NJUST@bodyfont
}
\newcommand{\NJUST@cleartooddpage}{%
  \clearpage
  \if@twoside
    \ifodd\c@page\else
      \thispagestyle{empty}\hbox{}\newpage
    \fi
  \fi
}
\renewcommand{\mainmatter}{%
  % 双面打印时，正文必须从奇数页开始；如果目录和图表目录结束后
  % 下一页是偶数页，这里自动补一张空白页。
  \NJUST@cleartooddpage
  \@mainmattertrue
  \pagenumbering{arabic}%
  \pagestyle{njustmain}%
  \NJUST@bodyfont
}
\renewcommand{\backmatter}{%
  \clearpage
  \@mainmatterfalse
  \pagestyle{njustmain}%
  \NJUST@bodyfont
}

% ----------------------------------------------------------------------
% Headings
% ----------------------------------------------------------------------
% 撰写格式要求：
%   一级标题（章目）：小三号加粗宋体，段前/段后 18 磅，居左。
%   二级标题（条）：  四号加粗宋体，段前/段后 12 磅，居左。
%   三级标题（款）：  小四号加粗宋体，段前/段后 6 磅，居左。
%   四级标题（项）：  小四号宋体，行距 20 磅，按正文处理。
% LaTeX 的 beforeskip/afterskip 不完全等同 Word 的“段前/段后”：
% Word 标题段落还带固定 20 磅行距的段落盒子，直接写 18/12/6 会比示例偏紧。
% 下面数值是按 Word 样张视觉效果换算后的 LaTeX 跳距。
% 如果标题上下空白不准，只改 beforeskip/afterskip。
% aftername 控制“编号”和“标题文字”之间的距离；这里不用 \quad，
% 否则会像制表位一样偏宽。0.5em 约等于一个普通英文空格。
\setcounter{secnumdepth}{3}
\ctexset{
  chapter = {
    name = {},
    number = \arabic{chapter},
    aftername = \hspace{0.5em},
    format = \songti\bfseries\zihao{-3}\setlength{\baselineskip}{20pt}\selectfont\raggedright,
    beforeskip = 20bp,
    afterskip = 27bp,
    fixskip = true,
    afterindent = true,
    pagestyle = njustmain
  },
  section = {
    format = \songti\bfseries\zihao{4}\setlength{\baselineskip}{20pt}\selectfont\raggedright,
    aftername = \hspace{0.5em},
    beforeskip = 20bp,
    afterskip = 20bp,
    fixskip = true,
    afterindent = true
  },
  subsection = {
    format = \songti\bfseries\zihao{-4}\setlength{\baselineskip}{20pt}\selectfont\raggedright,
    aftername = \hspace{0.5em},
    beforeskip = 9bp,
    afterskip = 15bp,
    fixskip = true,
    afterindent = true
  },
  subsubsection = {
    format = \songti\zihao{-4}\setlength{\baselineskip}{20pt}\selectfont,
    aftername = \hspace{0.5em},
    beforeskip = 0pt,
    % 四级标题按正文处理，但 afterskip 不能为 0，否则紧跟公式后容易丢首行缩进。
    % 只想改变“四级标题”和后文之间的距离，调这里。
    afterskip = 8bp,
    fixskip = true,
    afterindent = true
  }
}

\newcommand{\njustchapter}[2][]{%
  \chapter{#2}%
  \ifblank{#1}{}{\markboth{\thechapter\quad #1}{}}%
}

% ----------------------------------------------------------------------
% Floats, Equations And Captions
% ----------------------------------------------------------------------
% 图、表、公式均按章编号：图 2.1、表 2.1、式 (2.1)。
\numberwithin{equation}{chapter}
\numberwithin{figure}{chapter}
\numberwithin{table}{chapter}
\renewcommand{\thefigure}{\thechapter.\arabic{figure}}
\renewcommand{\thetable}{\thechapter.\arabic{table}}
\renewcommand{\theequation}{\thechapter.\arabic{equation}}
\renewcommand{\figurename}{图}
\renewcommand{\tablename}{表}
% 正文引用公式时用 \njusteqref{标签}，输出“式（2.1）”。
% 如果学校要求改成“公式 (2.1)”这类写法，只改这一行。
\newcommand{\njusteqref}[1]{式（\ref{#1}）}

% 公式上下间距。公式前后空得太大/太小，调这四个长度。
% 同时在常见公式环境结束后恢复正文 20 磅行距，避免公式后面的段落格式漂掉。
\newlength{\NJUST@displayaboveskip}
\newlength{\NJUST@displaybelowskip}
\newlength{\NJUST@displayshortaboveskip}
\newlength{\NJUST@displayshortbelowskip}
\setlength{\NJUST@displayaboveskip}{8pt}
\setlength{\NJUST@displaybelowskip}{8pt}
\setlength{\NJUST@displayshortaboveskip}{6pt}
\setlength{\NJUST@displayshortbelowskip}{6pt}
\AtBeginDocument{%
  \setlength{\abovedisplayskip}{\NJUST@displayaboveskip}%
  \setlength{\belowdisplayskip}{\NJUST@displaybelowskip}%
  \setlength{\abovedisplayshortskip}{\NJUST@displayshortaboveskip}%
  \setlength{\belowdisplayshortskip}{\NJUST@displayshortbelowskip}%
}
\AfterEndEnvironment{equation}{\NJUST@bodyfont}
\AfterEndEnvironment{equation*}{\NJUST@bodyfont}
\AfterEndEnvironment{align}{\NJUST@bodyfont}
\AfterEndEnvironment{align*}{\NJUST@bodyfont}

% 图题/表题为五号宋体，表题在表上方，图题在图下方。
% 表格正文默认五号宋体；正文 tex 不需要再写 \zihao{5}。
% 表格宽度和疏密统一在这里调：
%   \NJUST@tablewidth       控制 booktabs 横线和表体总宽度；
%   \NJUST@tablecolsep      控制列内左右空白；
%   \NJUST@tablearraystretch 控制表格行高。
\newlength{\NJUST@tablewidth}
\newlength{\NJUST@tablecolsep}
\newlength{\NJUST@twocolwidth}
\newlength{\NJUST@threecolwidth}
\setlength{\NJUST@tablewidth}{0.86\textwidth}
\setlength{\NJUST@tablecolsep}{6pt}
\newcommand{\NJUST@tablearraystretch}{1.18}
\newcolumntype{C}[1]{>{\centering\arraybackslash}p{#1}}
\newcommand{\NJUST@captionfont}{%
  \songti\zihao{5}\setlength{\baselineskip}{14pt}\selectfont
}
\newcommand{\NJUST@tablefont}{%
  \songti\zihao{5}\setlength{\baselineskip}{14pt}\selectfont
}
\DeclareCaptionFont{njustcaption}{\NJUST@captionfont}
\captionsetup{
  font={njustcaption},
  labelfont={normalfont},
  labelsep=space,
  justification=centering,
  singlelinecheck=false
}
\captionsetup[figure]{position=bottom,skip=6pt}
\captionsetup[table]{position=top,skip=6pt}

% 让正文里的普通 tabular 默认变成定宽表格，效果更接近 Word 示例。
% 常见的 {cc}/{ccc} 会转成等宽居中列：横线仍较宽，但每列内容在自己的列中居中，
% 不会被 \extracolsep{\fill} 推到左右两侧。其它复杂列格式仍走 tabular*。
\RenewDocumentEnvironment{tabular}{O{c} m}{%
  \NJUST@tablefont
  \hbadness=10000
  \setlength{\tabcolsep}{\NJUST@tablecolsep}%
  \renewcommand{\arraystretch}{\NJUST@tablearraystretch}%
  \ifstrequal{#2}{cc}{%
    \setlength{\NJUST@twocolwidth}{\dimexpr.5\NJUST@tablewidth-\tabcolsep\relax}%
    \begin{tabular*}{\NJUST@tablewidth}[#1]{@{}C{\NJUST@twocolwidth}C{\NJUST@twocolwidth}@{}}%
  }{%
    \ifstrequal{#2}{ccc}{%
      \setlength{\NJUST@threecolwidth}{\dimexpr\NJUST@tablewidth/3-4\tabcolsep/3\relax}%
      \begin{tabular*}{\NJUST@tablewidth}[#1]{@{}C{\NJUST@threecolwidth}C{\NJUST@threecolwidth}C{\NJUST@threecolwidth}@{}}%
    }{%
      \begin{tabular*}{\NJUST@tablewidth}[#1]{@{\hspace{0.08\NJUST@tablewidth}\extracolsep{\fill}}#2@{\hspace{0.08\NJUST@tablewidth}}}%
    }%
  }%
}{%
  \end{tabular*}%
}

% 浮动体排版：尽量允许图表就近放置；如果被挤到单独浮动页，
% 不使用 LaTeX 默认的垂直居中，而是靠页面上方放置。
\setcounter{topnumber}{5}
\setcounter{bottomnumber}{5}
\setcounter{totalnumber}{8}
\renewcommand{\topfraction}{0.95}
\renewcommand{\bottomfraction}{0.95}
\renewcommand{\textfraction}{0.05}
\renewcommand{\floatpagefraction}{0.75}
\setlength{\floatsep}{12pt plus 2pt minus 2pt}
\setlength{\textfloatsep}{14pt plus 2pt minus 2pt}
\setlength{\intextsep}{12pt plus 2pt minus 2pt}
\setlength{\@fptop}{0pt}
\setlength{\@fpsep}{12pt plus 1fil}
\setlength{\@fpbot}{0pt plus 1fil}

% ----------------------------------------------------------------------
% Contents And Lists Of Figures/Tables
% ----------------------------------------------------------------------
% 目录行距统一 20 磅。
% 注意：正文目录项不用 \cftchapindent/\cftsecindent 这组变量调。
% 在 ctexbook + tocloft 混用时，这组长度可能被已有的 \l@section 格式覆盖，
% 视觉上就会出现“怎么调都没变化”。这里直接重定义 \l@chapter 等命令，
% 以后目录缩进只改下面 \NJUST@toc... 这六个长度。
% 图表目录里“图”和“表”都不缩进。这里不使用 tocloft 的缩进长度，
% 因为 ctexbook 会重定义目录项，直接改 \cft... 经常看不到效果。
\renewcommand{\@dotsep}{0.7}

% 正文目录缩进。indent 是编号起点，numwidth 在这里表示“编号和标题之间的空隙”。
% 这不是制表位；例如设为 0.5em，就只会保留约半个字宽的普通空白。
% 要做“章顶格、节缩进、小节再缩进”，只改这六行。
\newlength{\NJUST@tocchapindent}
\newlength{\NJUST@tocchapnumwidth}
\newlength{\NJUST@tocsecindent}
\newlength{\NJUST@tocsecnumwidth}
\newlength{\NJUST@tocsubsecindent}
\newlength{\NJUST@tocsubsecnumwidth}
\setlength{\NJUST@tocchapindent}{0pt}
\setlength{\NJUST@tocchapnumwidth}{0.5em}
\setlength{\NJUST@tocsecindent}{1.5em}
\setlength{\NJUST@tocsecnumwidth}{0.5em}
\setlength{\NJUST@tocsubsecindent}{3.5em}
\setlength{\NJUST@tocsubsecnumwidth}{0.5em}

\newcommand{\NJUST@tocnumber}[2]{%
  {\let\hspace\@gobble #1}\hspace*{#2}%
}
\newcommand{\NJUST@tocline}[7]{%
  \ifnum #1>\c@tocdepth\else
    \begingroup
      #4\setlength{\baselineskip}{20pt}\selectfont
      \parindent\z@
      \parskip\z@
      \rightskip\@pnumwidth
      \parfillskip-\@pnumwidth
      \hangindent=#2\relax
      \advance\hangindent by 4em\relax
      \hangafter=1
      \leavevmode
      \hspace*{#2}%
      \def\numberline##1{\NJUST@tocnumber{##1}{#3}}%
      \strut #6\nobreak
      \leaders\hbox{$\m@th\mkern \@dotsep mu\hbox{.}\mkern \@dotsep mu$}\hfill
      \nobreak\hb@xt@\@pnumwidth{\hfil #5#7}\par
    \endgroup
  \fi
}
\renewcommand*\l@chapter[2]{%
  \NJUST@tocline{0}{\NJUST@tocchapindent}{\NJUST@tocchapnumwidth}%
    {\songti\bfseries\zihao{4}}{\rmfamily\bfseries\zihao{4}}{#1}{#2}%
}
\renewcommand*\l@section[2]{%
  \NJUST@tocline{1}{\NJUST@tocsecindent}{\NJUST@tocsecnumwidth}%
    {\songti\zihao{-4}}{\rmfamily\zihao{-4}}{#1}{#2}%
}
\renewcommand*\l@subsection[2]{%
  \NJUST@tocline{2}{\NJUST@tocsubsecindent}{\NJUST@tocsubsecnumwidth}%
    {\songti\zihao{-4}}{\rmfamily\zihao{-4}}{#1}{#2}%
}

% 图表目录编号也不用 tocloft 的固定编号盒子，避免编号后像“制表符”。
% \NJUST@lofgap 控制“图 2.1”和标题文字之间的普通空格。
\newlength{\NJUST@lofindent}
\newlength{\NJUST@lofgap}
\setlength{\NJUST@lofindent}{0pt}
\setlength{\NJUST@lofgap}{0.5em}
\newcommand{\NJUST@listline}[3]{%
  \begingroup
    \songti\zihao{-4}\setlength{\baselineskip}{20pt}\selectfont
    \parindent\z@
    \parskip\z@
    \rightskip\@pnumwidth
    \parfillskip-\@pnumwidth
    \hangindent=4em
    \hangafter=1
    \leavevmode
    \hspace*{\NJUST@lofindent}%
    \def\numberline##1{\NJUST@tocnumber{#1~##1}{\NJUST@lofgap}}%
    \strut #2\nobreak
    \leaders\hbox{$\m@th\mkern \@dotsep mu\hbox{.}\mkern \@dotsep mu$}\hfill
    \nobreak\hb@xt@\@pnumwidth{\hfil \rmfamily\zihao{-4}#3}\par
  \endgroup
}
\renewcommand*\l@figure[2]{\NJUST@listline{图}{#1}{#2}}
\renewcommand*\l@table[2]{\NJUST@listline{表}{#1}{#2}}

\newcommand{\NJUST@tableofcontents}{%
  \clearpage
  \phantomsection
  \thispagestyle{njustmain}%
  \markboth{目录}{}%
  \vspace*{-4mm}
  \begin{center}{\songti\bfseries\zihao{3}目\quad\quad 录}\end{center}
  \vspace{6pt}
  {\setlength{\baselineskip}{20pt}\selectfont\@starttoc{toc}}%
  \clearpage
}
\AtBeginDocument{\let\tableofcontents\NJUST@tableofcontents}

\newcommand{\njustlistoffiguresandtables}{%
  \clearpage
  \phantomsection
  \thispagestyle{njustmain}%
  \markboth{图表目录}{}%
  \vspace*{-4mm}
  \begin{center}{\songti\bfseries\zihao{3}图表目录}\end{center}
  \vspace{1.5pt}
  {\setlength{\baselineskip}{20pt}\selectfont
    \@starttoc{lof}\par\vspace{10pt}\@starttoc{lot}%
  }%
  \clearpage
}

% ----------------------------------------------------------------------
% Abstracts And Back Matter Headings
% ----------------------------------------------------------------------
% 摘要标题进目录，摘要正文首行缩进 2 字符，行距继承正文 20 磅。
\newcommand{\NJUST@fronttitle}[3]{%
  \clearpage
  \phantomsection
  \thispagestyle{njustmain}%
  \markboth{#1}{}%
  \addcontentsline{toc}{chapter}{#2}%
  \vspace*{-4mm}
  \begin{center}{#3}\end{center}
  \vspace{7pt}
}

\newenvironment{njustcnabstract}{%
  \NJUST@fronttitle{摘要}{摘\quad\quad 要}{\songti\bfseries\zihao{3}摘\quad\quad 要}%
  \NJUST@bodyfont\setlength{\parindent}{2em}\NJUST@firstparindent
}{\clearpage}

\newenvironment{njustenabstract}{%
  \NJUST@fronttitle{Abstract}{Abstract}{\rmfamily\bfseries\zihao{3}Abstract}%
  \rmfamily\zihao{-4}\setlength{\baselineskip}{20pt}\selectfont
  \setlength{\parindent}{2em}\NJUST@firstparindent
}{\clearpage}

\newcommand{\njustkeywords}[1]{%
  \vspace{46pt}\par\noindent{\songti\bfseries\zihao{4}关键词：}\songti\zihao{-4}#1\par
}
\newcommand{\njustenkeywords}[1]{%
  \vspace{46pt}\par\noindent{\rmfamily\bfseries\zihao{4}Keywords:}\ \rmfamily\zihao{-4}#1\par
}

% 致谢、附录、参考文献这类后置章节标题的上下位置。
% 标题离页面上方太远/太近：调 \NJUST@backtitlebeforeskip。
% 标题下面空隙太大/太小：调 \NJUST@backtitleafterskip。
\newlength{\NJUST@backtitlebeforeskip}
\newlength{\NJUST@backtitleafterskip}
\setlength{\NJUST@backtitlebeforeskip}{-4mm}
\setlength{\NJUST@backtitleafterskip}{6pt}

\newcommand{\njustbackchapter}[2]{%
  \clearpage
  \phantomsection
  \thispagestyle{njustmain}%
  \markboth{#1}{}%
  \addcontentsline{toc}{chapter}{#1}%
  \vspace*{\NJUST@backtitlebeforeskip}
  \begin{center}{\songti\bfseries\zihao{3}#2}\end{center}
  \vspace{\NJUST@backtitleafterskip}
  \NJUST@bodyfont
  \setlength{\parindent}{2em}%
}

\newenvironment{njustthanks}{%
  \njustbackchapter{致\quad \quad 谢}{致\quad \quad 谢}%
  \NJUST@firstparindent
}{\clearpage}

% 附录中的“本科期间发表的论文和出版著作情况：”等小标题。
% 小标题上下空隙分别调下面两个长度；字号/粗细在 \njustappendixitem 里改。
\newlength{\NJUST@appendixitembeforeskip}
\newlength{\NJUST@appendixitemafterskip}
\setlength{\NJUST@appendixitembeforeskip}{6pt}
\setlength{\NJUST@appendixitemafterskip}{0pt}
\newcommand{\njustappendixitem}[1]{%
  \par\vspace{\NJUST@appendixitembeforeskip}%
  \noindent{\songti\bfseries\zihao{4}#1}\par
  \vspace{\NJUST@appendixitemafterskip}%
  \NJUST@bodyfont
  \NJUST@firstparindent
}

\newenvironment{njustappendix}{%
  \njustbackchapter{附\quad\quad 录}{附\quad\quad 录}%
}{\clearpage}

% ----------------------------------------------------------------------
% Bibliography
% ----------------------------------------------------------------------
% 参考两个研究生 LaTeX 模板的做法：正文使用 BibTeX 数据库。
% 默认样式复制自：
%   template reference/NjustThesis/bib/gbt7714-numerical_njust.bst
%
% 使用方法：
%   1. 文献写入 bib/references.bib
%   2. 正文用 \cite{key}
%   3. myThesis.tex 中调用 \addbibliography{bib/references}
% 如需换样式，改 \NJUST@bibstyle 或在导言区调用 \njustbibstyle{路径/样式名}。
\renewcommand{\bibname}{参考文献}
\newcommand{\NJUST@bibstyle}{bib/GBT7714}
\newcommand{\njustbibstyle}[1]{\renewcommand{\NJUST@bibstyle}{#1}}

\newcommand*\addbibliography[1]{%
  \clearpage
  \phantomsection
  \addcontentsline{toc}{chapter}{\bibname}%
  \bibliographystyle{\NJUST@bibstyle}%
  {\centering\bibliography{#1}}%
  \clearpage
}

\newcommand{\NJUST@bibheading}{%
  \thispagestyle{njustmain}%
  \markboth{\bibname}{}%
  \vspace*{-4mm}
  \begin{center}{\songti\bfseries\zihao{3}\bibname}\end{center}
  \vspace{-9pt}
}

% gbt7714-numerical_njust.bst 生成 natbib 兼容的 \bibitem[...]。
% 正文 \cite 以上标方括号显示，如“……方法^[1,2]”；文末参考文献仍为普通编号列表。
\setcitestyle{super,square,comma}
\renewcommand{\bibsection}{\NJUST@bibheading}
\renewcommand{\bibfont}{\NJUST@bodyfont}
\setlength{\bibsep}{3pt}

% 参考文献列表对齐：
%   [1]、[10] 等序号左边对齐；
%   文献正文统一从序号盒子后开始，续行也和正文起点对齐。
% 如果正文离序号太近/太远，只调 \NJUST@biblabelsep。
\newlength{\NJUST@biblabelwidth}
\newlength{\NJUST@biblabelsep}
\newcommand{\NJUST@biblabeltext}[1]{[#1]}
\renewcommand{\bibnumfmt}[1]{%
  \makebox[\NJUST@biblabelwidth][l]{\NJUST@biblabeltext{#1}}%
}
\setlength{\NJUST@biblabelsep}{0.75em}
\renewcommand\NAT@bibsetnum[1]{%
  \settowidth{\NJUST@biblabelwidth}{\NJUST@biblabeltext{#1}}%
  \setlength{\labelwidth}{\NJUST@biblabelwidth}%
  \setlength{\labelsep}{\NJUST@biblabelsep}%
  \setlength{\leftmargin}{\labelwidth}%
  \addtolength{\leftmargin}{\labelsep}%
  \setlength{\itemsep}{\bibsep}%
  \setlength{\parsep}{\z@}%
  \def\makelabel##1{##1}%
  \ifNAT@openbib
    \addtolength{\leftmargin}{\bibindent}%
    \setlength{\itemindent}{-\bibindent}%
    \setlength{\listparindent}{\itemindent}%
    \setlength{\parsep}{0pt}%
  \fi
}
\let\@bibsetup\NAT@bibsetnum
\AtBeginDocument{\let\@bibsetup\NAT@bibsetnum}

\makeatother
