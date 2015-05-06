#vim-radioss
[VIM](http://www.vim.org/) filetype plugin for [Radioss](http://www.altairhyperworks.com/Product,51,RADIOSS.aspx) FE solver.

##Introduction

What is Radioss filetype plugin?

It's just bunch of VIM scripts to speed up work with Radioss input file.

##Main features
- Syntax highlighting
- Folding
- Keyword library
- Useful commands, functions and mappings

###Syntax highlighting
With color syntax it's easier to navigate through a input file.

![syntax](https://raw.github.com/wiki/gradzikb/vim-radioss/gifs/syntax.gif)

###Folding
Node & element table folding, no more never ending scrolling!

![folding](https://raw.github.com/wiki/gradzikb/vim-radioss/gifs/folding.gif)

###Keyword library
With keyword library you can very quick add a new Radioss keyword into your model.

![libraryb](https://raw.github.com/wiki/gradzikb/vim-radioss/gifs/library.gif)


###Curve commands
You can use commands to operate with function data directly in VIM.

![commands](https://raw.github.com/wiki/gradzikb/vim-radioss/gifs/commands.gif)


###Commands, functions & mappings
The plugin has couple of great functions to make your work even faster:
- mappings
- comment/uncomment
- data line autoformating
- keyword text objects


##Documentation

The plugin has decent [documentation](https://github.com/gradzikb/vim-radioss/blob/master/doc/radioss.txt) with detail explanation of all functions and examples.

Please read the documentation before you start using the plugin.

`:help radioss`

##Installation

[Pathogen](https://github.com/tpope/vim-pathogen)

```
cd ~/.vim/bundle
git clone https://github.com/gradzikb/vim-radioss
```

##License

The GNU General Public License

Copyright &copy; 2015 Bartosz Gradzik
