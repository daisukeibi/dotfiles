# vim: set ft=zsh
#        _ _
#   __ _| (_) __ _ ___  ___  ___
#  / _` | | |/ _` / __|/ _ \/ __|
# | (_| | | | (_| \__ \  __/\__ \
#  \__,_|_|_|\__,_|___/\___||___/
#
# written by Shotaro Fujimoto (https://github.com/ssh0)
#------------------------------------------------------------------------------
# Alias                                                                     {{{
#------------------------------------------------------------------------------

# apt update
alias apt-upd='sudo apt update'

# apt upgrade
alias apt-upg='sudo apt upgrade'

# apt install
alias apt-ins='sudo apt install'

# git alias to "g"
alias g='git'

# I often type ":q" to exit terminal
alias :q='exit'

# mplayer alias
alias mplayer='mplayer -msgcolor'

# twitter color
alias twitter='twitter -f ansi'

# colordiff
if [[ -x `which colordiff` ]]; then
  alias diff='colordiff -u'
else
  alias diff='diff -u'
fi

# color echo
cecho() {
  local color
  case $1 in
    red) color=31 ;;
    green) color=32 ;;
    yellow) color=33 ;;
    blue) color=34 ;;
    magenta) color=35 ;;
    cyan) color=36 ;;
    *) return 1 ;;
  esac
  shift
  echo "\033[${color}m$@\033[m"
}

# speedometer
function _speedometer() {
  speedometer -b -rx "$1" -tx "$1"
}
alias spdmeter='_speedometer'

# mkdocs
compdef _mkdocs mkdocs
function _mkdocs() {
  local -a cmds
  if (( CURRENT == 2 ));then
    cmds=('build' 'gh-deploy' 'json' 'new' 'serve')
    _describe -t commands "subcommand" cmds
  fi
}

#---------------------------------------------------------------------------}}}
# extract images                                                            {{{
#------------------------------------------------------------------------------

function extract() {
  case $1 in
    *.tar.gz|*.tgz) tar xzvf $1;;
    *.tar.xz) tar Jxvf $1;;
    *.zip) unzip $1;;
    *.lzh) lha e $1;;
    *.tar.bz2|*.tbz) tar xjvf $1;;
    *.tar.Z) tar zxvf $1;;
    *.gz) gzip -d $1;;
    *.bz2) bzip2 -dc $1;;
    *.Z) uncompress $1;;
    *.tar) tar xvf $1;;
    *.arj) unarj $1;;
  esac
}
alias -s {qz,tgz,zip,lzh,bz2,tbz,Z,tar,arj,xz}=extract
alias -s {png,jpg,bmp,PNG,JPG,BMP}='feh --scale-down'

#---------------------------------------------------------------------------}}}
# ranger completion                                                         {{{
#------------------------------------------------------------------------------

_ranger() {
  typeset -A opt_args
  _arguments -s -S \
    {-d,--debug}'[Activate the debug mode: Whenever an error occurs, ranger will exit and print a full traceback.]'\
    {-c,--clean}'[Activate the clean mode: ranger will not access or create any configuration files nor will it leave any traces on your system.]'\
    {-r,--confdir=}'[Change the configuration directory of ranger from ~/.config/ranger to "dir".]:dir:_path_files -/'\
    '--copy-config=[Create copies of the default configuration files in your local configuration directory. Existing ones will not be overwritten.]:FILE:(all commands commands_full rc rifle scope)'\
    '--choosefile=[Allows you to pick a file with ranger. This changes the behavior so that when you open a file, ranger will exit and write the absolute path of that file into targetfile.]:targetfile:_files'\
    '--choosefiles=[Allows you to pick multiple files with ranger. This changes the behavior so that when you open a file, ranger will exit and write the absolute paths of all selected files into targetfile, adding one newline after each filename.]:targetfile:_files'\
    '--choosedir=[Allows you to pick a directory with ranger. When you exit ranger, it will write the last visited directory into targetfile.]:targetfile:_files'\
    '--selectfile=[targetfile Open ranger with targetfile selected.]:targetfile:_files'\
    '--list-unused-keys[List common keys which are not bound to any action in the "browser" context. This list is not complete, you can bind any key that is supported by curses: use the key code returned by "getch()".]'\
    '--list-tagged-files[List all files which are tagged with the given tag.  Note: Tags are single characters. The default tag is "*"]:tag:(* a-z)'\
    '--profile[Print statistics of CPU usage on exit.]'\
    '--cmd=[Execute the command after the configuration has been read.  Use this option multiple times to run multiple commands.]:command:'\
    '--versioin[Print the version and exit.]'\
    {-h,--help}'[Print a list of option and exit.]'\
    && return 0
  return 1
}

compdef _ranger ranger

#---------------------------------------------------------------------------}}}
# ranger-cd                                                                 {{{
#------------------------------------------------------------------------------
# Compatible with ranger 1.4.2 through 1.7.*
#
# Automatically change the directory in bash after closing ranger
#
# This is a bash function for .bashrc to automatically change the directory to
# the last visited one after ranger quits.
# To undo the effect of this function, you can type "cd -" to return to the
# original directory.

function ranger-cd {
    tempfile="$(mktemp -t tmp.XXXXXXX)"
    # for manual install
    /usr/local/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    # for package install
    # /usr/bin/ranger --choosedir="$tempfile" "${@:-$(pwd)}"
    test -f "$tempfile" &&
    if [ "$(cat -- "$tempfile")" != "$(echo -n `pwd`)" ]; then
        cd -- "$(cat "$tempfile")"
    fi
    rm -f -- "$tempfile"
}

compdef _ranger ranger-cd

# This binds Ctrl-O to ranger-cd:
# bind '"\C-o":"ranger-cd\C-m"'

#---------------------------------------------------------------------------}}}
# Start new ranger instance only if it's not running in current shell       {{{
#------------------------------------------------------------------------------
# https://wiki.archlinux.org/index.php/Ranger#Start_new_ranger_instance_only_if_it.27s_not_running_in_current_shell

function r() {
    if [ -z "$RANGER_LEVEL" ]; then
        ranger-cd $@
    else
        exit
    fi
}

compdef _ranger r

#---------------------------------------------------------------------------}}}
# youtube-dl completion                                                     {{{
#------------------------------------------------------------------------------
#
# put this script in your .zshrc
# generated by:
# https://github.com/rg3/youtube-dl/blob/master/devscripts/zsh-completion.in
# https://github.com/rg3/youtube-dl/blob/master/devscripts/zsh-completion.py
# and modified manually

__youtube_dl() {
  local curcontext="$curcontext" fileopts diropts cur prev
  typeset -A opt_args
  fileopts="--download-archive|-a|--batch-file|--load-info|--cookies|--ffmpeg-location"
  diropts="--cache-dir"
  local ddir="/media/shotaro/STOCK/Videos"
  cur=$words[CURRENT]
  case $cur in
    :)
      _arguments '*: :(::ytfavorites ::ytrecommended ::ytsubscriptions ::ytwatchlater ::ythistory)'
    ;;
    *)
      prev=$words[CURRENT-1]
      if [[ ${prev} =~ ${fileopts} ]]; then
        _path_files
      elif [[ ${prev} =~ ${diropts} ]]; then
        _path_files -/
      elif [[ ${prev} == "--recode-video" ]]; then
        _arguments '*: :(mp4 flv ogg webm mkv)'
      elif [[ ${prev} == "--audio-format" ]]; then
        _arguments '*: :(best aac vorbis mp3 m4a opus wav)'
      elif [[ ${prev} == "--convert-subtitle" ]]; then
        _arguments '*: :(srt ass vtt)'
      elif [[ ${prev} =~ "-o|--output" ]]; then
        _arguments "*: :(\
          '%(title)s.%(ext)s' \
          '%(autonumber)s - %(title)s.%(ext)s' \
          '%(playlist_title)s/%(title)s.%(ext)s' \
          '${ddir}/%(title)s.%(ext)s' \
          '${ddir}/%(autonumber)s - %(title)s.%(ext)s' \
          '${ddir}/%(extractor)s/%(title)s.%(ext)s' \
          '-' \
          )"
      elif [[ ${prev} == "--proxy" ]]; then
        _arguments "*: :( `echo ${http_proxy}` )"
      else
        _arguments -S\
          '-h[Print help]: :' \
          '-U[Update the program (run with root)]: :' \
          '-i[Continue on download errors]' \
          '(-6)-4[Make all connections via IPv4]' \
          '(-4)-6[Make all connections via IPv6]' \
          '-r[Maximum download rate in bytes per second (e.g. 50K or 4.2M)]' \
          '-R[Number of retries (default is 10), or "infinite"]' \
          '-a[File containg URLs to download ('-' for stdin)]' \
          '-o[Output filename template. (See manpage)]' \
          '-q[Activate quiet mode]' \
          '-s[Do not download the video and do not write anything to disk]' \
          '-g[Simulate, quiet but print URL]' \
          '-e[Simulate, quiet but print title]' \
          '-j[Simulate, quiet but print JSON information]' \
          '-J[Simulate, quiet but print JSON information for each command-line argument]' \
          '-f[Video format code, see the "FORMAT SELECTION" for all the info]' \
          '-F[List all available formats]' \
          '-u[Login with this account ID]' \
          '-p[Account pass word. If this option is left out, youtube-dl will ask interactively]' \
          '-2[Two-factor auth code]' \
          '-n[Use .netrc authentication data]' \
          '-x[Convert video files to audio-only files]' \
          '-k[Keep the video file on disk after the post-processing; the video is erased by default]' \
          '*: :(--help --version --update --ignore-errors --abort-on-error --dump-user-agent --list-extractors --extractor-descriptions --default-search --ignore-config --flat-playlist --no-color --proxy --socket-timeout --source-address --force-ipv3 --force-ipv6 --cn-verification-proxy --playlist-start --playlist-end --playlist-items --match-title --reject-title --max-downloads --min-filesize --max-filesize --date --datebefore --dateafter --min-views --max-views --match-filter --no-playlist --yes-playlist --age-limit --download-archive --include-ads --rate-limit --retries --buffer-size --no-resize-buffer --test --playlist-reverse --xattr-set-filesize --hls-prefer-native --external-downloader --external-downloader-args --batch-file --id --output --autonumber-size --restrict-filenames --no-overwrites --continue --no-continue --no-part --no-mtime --write-description --write-info-json --write-annotations --load-info --cookies --cache-dir --no-cache-dir --rm-cache-dir --write-thumbnail --write-all-thumbnails --list-thumbnails --quiet --no-warnings --simulate --skip-download --get-url --get-title --get-id --get-thumbnail --get-description --get-duration --get-filename --get-format --dump-json --dump-single-json --print-json --newline --no-progress --console-title --verbose --dump-pages --write-pages --youtube-print-sig-code --print-traffic --call-home --no-call-home --no-check-certificate --prefer-insecure --user-agent --referer --add-header --bidi-workaround --sleep-interval --format --all-formats --prefer-free-formats --list-formats --youtube-include-dash-manifest --youtube-skip-dash-manifest --merge-output-format --write-sub --write-auto-sub --all-subs --list-subs --sub-format --sub-lang --username --password --twofactor --netrc --video-password --extract-audio --audio-format --audio-quality --recode-video --keep-video --no-post-overwrites --embed-subs --embed-thumbnail --add-metadata --metadata-from-title --xattrs --fixup --prefer-avconv --prefer-ffmpeg --ffmpeg-location --exec --convert-subtitles)'
      fi
    ;;
  esac
}

compdef __youtube_dl youtube-dl

# custom wrapper
compdef __youtube_dl ytdl

#---------------------------------------------------------------------------}}}
# recordmydesktop completion                                               {{{
#------------------------------------------------------------------------------

_recordmydesktop() {
  local curcontext="$curcontext" diropts prev numopts
  typeset -A opt_args
  numopts="-x|-y|--channels|--freq|--buffer-size|--ring-buffer-size|--delay"
  ddir="/media/shotaro/STOCK/Videos/mycast"

  prev=$words[CURRENT-1]
  if [[ ${prev} =~ ${numopts} ]]; then
    _arguments "*: :"
  elif [[ ${prev} == "-o" ]]; then
    _path_files -W ddir
  elif [[ ${prev} == "--rescue" ]]; then
    _path_files
  elif [[ ${prev} == "--workdir" ]]; then
    _path_files -/
  elif [[ ${prev} == "--width" ]]; then
    _arguments "*: :(1920 1680 1440 1280 1152 1024 800 720 640)"
  elif [[ ${prev} == "--height" ]]; then
    _arguments "*: :(1080 1050 1024 960 900 864 768 600 576 480)"
  elif [[ ${prev} == "--dummy-cursor" ]]; then
    _arguments "*: :(black white)"
  elif [[ ${prev} == "--fps" ]]; then
    _arguments "*: :(60 30 10)"
  elif [[ ${prev} == "--v_quality" ]]; then
    _arguments "*: :(0 63)"
  elif [[ ${prev} == "--v_bitrate" ]]; then
    _arguments "*: :(45000 2000000)"
  elif [[ ${prev} == "--s_quality" ]]; then
    _arguments "*: :(-1 0 5 10)"
  elif [[ ${prev} == "--pause-shortcut" ]]; then
    _arguments "*: :'Control+Mod1+p'"
  elif [[ ${prev} == "--stop-shortcut" ]]; then
    _arguments "*: :'Control+Mod1+s'"
  else
    _arguments -s -S\
      '(--help)--help[Print help summary and exit.]: :' \
      '(--version)--version[Print program version and exit.]: :' \
      '(--print-config)--print-config[Print info about options selected during compilation and exit.]' \
      '(--windowid)--windowid[id of window to be recorded.]' \
      '(--display)--display[Display to connect to.]' \
      '(-x)-x[Offset in x direction.]' \
      '(-y)-y[Offset in y direction.]' \
      '(--width)--width[Width of recorded window.]' \
      '(--height)--height[Height of recorded window.]' \
      '(--dummy-cursor)--dummy-cursor[Draw a dummy cursor, instead of the normal one.Value of color can be \"black\" or \"white\".]' \
      '(--no-cursor)--no-cursor[Disable drawing of the cursor.]' \
      '(--no-shared)--no-shared[Disable usage of MIT-shared memory extension (Not Recommended).]' \
      '(--full-shots)--full-shots[Take full screenshot at every frame(Not recomended!).]' \
      '(--follow-mouse)--follow-mouse[When this option is enabled, the capture area follows the mouse cursor.]' \
      '(--quick-subsampling)--quick-subsampling[Do subsampling of the chroma planes by discarding extra pixels.]' \
      '(--fps)--fps[A positive number denoting desired framerate.]' \
      '(--channels)--channels[A positive number denoting desired sound channels in recording.]' \
      '(--freq)--freq[A positive number denoting desired sound frequency.]' \
      '(--buffer-size)--buffer-size[A positive number denoting the desired sound buffer size(in frames, when using ALSA or OSS).]' \
      '(--ring-buffer-size)--ring-buffer-size[A float number denoting the desired ring buffer size (in seconds,when using JACK only).]' \
      '(--device)--device[Sound device(default hw:0,0 or /dev/dsp, depending on whether ALSA or OSS is used).]' \
      '(--use-jack)--use-jack[Record audio from the specified list of space-separated jack ports.]' \
      '(--no-sound)--no-sound[Do not record sound.]' \
      '(--on-the-fly-encoding)--on-the-fly-encoding[Encode the audio-video data, while recording.]' \
      '(--v_quality)--v_quality[A number from 0 to 63 for desired encoded video quality(default 63).]' \
      '(--v_bitrate)--v_bitrate[A number from 45000 to 2000000 for desired encoded video bitrate(default 45000).]' \
      '(--s_quality)--s_quality[Desired audio quality(-1 to 10).]' \
      '(--rescue)--rescue[Encode cache data from a previous session, into an Ogg/Theora+Vorbis file.]' \
      '(--no-wm-check)--no-wm-check[When a 3d compositing window manager is detected the program will function as if the --full-shots option has been specified.]' \
      '(--no-frame)--no-frame[If you do not wish the frame to appear, use this option.]' \
      '(--pause-shortcut)--pause-shortcut[Shortcut that will be used for pausing or unpausing the recording. Default is Control+Mod1+p (Mod1 usually corresponds to left Alt).]' \
      '(--stop-shortcut)--stop-shortcut[Shortcut that will be used to stop the recording. Default is Control+Mod1+s.]' \
      '(--compress-cache)--compress-cache[Image data are cached with a light compression.]' \
      '(--workdir)--workdir[Location where a temporary directory will be created to hold project files(default /tmp).]' \
      '(--delay)--delay[Number of secs(default),minutes or hours before capture starts(number can be float).]' \
      '(--overwrite)--overwrite[If there is already a file with the same name, delete it.]'
  fi
}

compdef _recordmydesktop recordmydesktop

#---------------------------------------------------------------------------}}}
# pandoc completion                                                         {{{
#------------------------------------------------------------------------------
# by https://gist.github.com/sky-y/3334048

_pandoc() {
  typeset -A opt_args
  local context state line

  _arguments -s -S \
    '(-f+ --from=+)'{-r+,--read=+}'[Specify input format.]:FORMAT:(native json markdown textile rst html docbook latex)'\
    '(-r+,--read=+)'{-f+,--from=+}'[Specify input format.]:FORMAT:(native json markdown textile rst html docbook latex)'\
    '(-t+ --to=+)'{-w+,--write=+}'[Specify output format.]:FORMAT:(native json plain markdown rst html html5 latex beamer context man mediawiki textile org texinfo docbook opendocument odt docx epub asciidoc slidy slideous dzslides s5 rtf)'\
    '(-w+ --write=+)'{-t+,--to=+}'[Specify output format.]:FORMAT:(native json plain markdown rst html html5 latex beamer context man mediawiki textile org texinfo docbook opendocument odt docx epub asciidoc slidy slideous dzslides s5 rtf)'\
    {-o+,--output=+}'[Write output to FILE instead of stdout.]:FILE:_files'\
    '--data-dir=+[Specify the user data directory to search for pandoc data files.]:DIRECTORY:_files -/'\
    {-v,--version}'[Print version.]'\
    {-h,--help}'[Show usage message.]'\
    '--strict[Use strict markdown syntax,with no pandoc extensions or variants.]'\
    {-R,--parse-raw}'[Parse untranslatable HTML codes and LaTeX environments as raw HTML or LaTeX,instead of ignoring them. ]'\
    {-S,--smart}'[Produce typographically correct output.]'\
    '--old-dashes[Selects the pandoc <= 1.8.2.1 behavior for parsing smart dashes.]'\
    '--base-header-level=+[pecify the base level for headers (defaults to 1)]:NUMBER:'\
    '--indented-code-classes=+[Specify classes to use for indented code blocks.]:CLASSES:'\
    '--normalize[Normalize the document after reading.]'\
    {-p,--preserve-tabs}'[Preserve tabs instead of converting them to spaces (the default).]'\
    '--tab-stop=+[Specify the number of spaces per tab (default is 4).]:NUMBER:'\
    {-s,--standalone}'[Produce output with an appropriate header and footer.]'\
    '--template=+[Use FILE as a custom template for the generated document.]:FILE:_files'\
    {-V+,--variable=+}'[Set the template variable KEY to the value VAL when rendering the document in standalone mode.]:KEY[=VAL]:'\
    {-D+,--print-default-template=+}'[Print the default template for an output FORMAT.]:FORMAT:(native json plain markdown rst html html5 latex beamer context man mediawiki textile org texinfo docbook opendocument odt docx epub asciidoc slidy slideous dzslides s5 rtf)'\
    '--no-wrap[Disable text wrapping in output. By default,text is wrapped appropriately for the output format.]'\
    '--columns=+[Specify length of lines in characters (for text wrapping).]:NUMBER:'\
    {--toc,--table-of-contents}'[Include an automatically generated table of contents in the output document. ]'\
    '--no-highlight[Disables syntax highlighting for code blocks and inlines,even when a language attribute is given.]'\
    '--highlight-style[Specifies the coloring style to be used in highlighted source code.]:STYLE:(pygments kate monochrome espresso zenburn haddock tango)'\
    {-H,--include-in-header}'[Include contents of FILE, verbatim, at the end of the header.]:FILE:_files'\
    {-B,--include-before-body}'[Include contents of FILE, verbatim, at the beginning of the document body.]:FILE:_files'\
    {-A,--include-after-body}'[Include contents of FILE, verbatim, at the end of the document body.]:FILE:'\
    '--self-contained[Produce a standalone HTML file with no external dependencies.]'\
    '--offline[Deprecated synonym for --self-contained.]'\
    {-5,--html5}'[Produce HTML5 instead of HTML4. ]'\
    '--ascii[Use only ascii characters in output.]'\
    '--reference-links[Use reference-style links, rather than inline links, in writing markdown or reStructuredText. ]'\
    '--atx-headers[Use ATX style headers in markdown output. ]'\
    '--chapters[Treat top-level headers as chapters in LaTeX, ConTeXt, and DocBook output.]'\
    {-N,--number-sections}'[Number section headings in LaTeX, ConTeXt, or HTML output.]'\
      '--no-tex-ligatures[Do not convert quotation marks,apostrophes,and dashes to the TeX ligatures when writing LaTeX or 100  6862  100  6862    0     0  31764      0 --:--:-- --:--:-- --:--:-- 31916
  ConTeXt. ]'\
    '--listings[Use listings package for LaTeX code blocks]'\
    {-i,--incremental}'[Make list items in slide shows display incrementally (one by one). ]'\
    '--slide-level=+[Specifies that headers with the specified level create slides (for beamer,s5,slidy,slideous,dzslides). ]:NUMBER:'\
    '--section-divs[Wrap sections in <div> tags (or <section> tags in HTML5),and attach identifiers to the enclosing <div> (or <section>) rather than the header itself. ]'\
    '--email-obfuscation=+[Specify a method for obfuscating mailto: links in HTML documents.]:METHOD:(none javascript references)'\
    '--id-prefix=+[Specify a prefix to be added to all automatically generated identifiers in HTML output. ]:STRING:'\
    {-T,--title-prefix=+}'[Specify STRING as a prefix at the beginning of the title that appears in the HTML header.]:STRING:'\
    {-c,--css}'[Link to a CSS style sheet.]:URL:'\
    '--reference-odt=+[Use the specified file as a style reference in producing an ODT. ]:FILE:_files'\
    '--reference-docx=+[Use the specified file as a style reference in producing an DOCX. ]:FILE:_files'\
    '--epub-stylesheet=+[Use the specified CSS file to style the EPUB. If no stylesheet is specified,pandoc will look for a file epub.]:FILE:_files'\
    '--epub-cover-image=+[Use the specified image as the EPUB cover. ]:FILE:_files'\
    '--epub-metadata=+[Look in the specified XML file for metadata for the EPUB. ]:FILE:_files:'\
    '--epub-embed-font=+[Embed the specified font in the EPUB. ]:FILE:_files'\
    '--bibliography=+[Specify bibliography database to be used in resolving citations.]:FILE:_files'\
    '--csl=+[Specify CSL style to be used in formatting citations and the bibliography. ]:FILE:_files'\
    '--citation-abbreviations=+[Specify a file containing abbreviations for journal titles and other bibliographic fields.]:FILE:_files'\
    '--natbib[Use natbib for citations in LaTeX output.]'\
    '--biblatex[Use biblatex for citations in LaTeX output.]'\
    {-m+,--latexmathml=+}'[Use the LaTeXMathML script to display embedded TeX math in HTML output. ]:URL:'\
    '--mathml=+[Convert TeX math to MathML (in docbook as well as html and html5).]:URL:'\
    '--jsmath=+[Use jsMath to display embedded TeX math in HTML output.]:URL:'\
    '--mathjax=+[Use MathJax to display embedded TeX math in HTML output.]'\
    '--gladtex[Enclose TeX math in <eq> tags in HTML output.]'\
    '--mimetex=+[Render TeX math using the mimeTeX CGI script.]:URL:'\
    '--webtex=+[Render TeX formulas using an external script that converts TeX formulas to images.]:URL:'\
    '--dump-args[Print information about command-line arguments to stdout,then exit.]'\
    '--ignore-args[Ignore command-line arguments.]'\
    && return 0

  return 1
}

compdef _pandoc pandoc

#---------------------------------------------------------------------------}}}
# tmuxinator                                                                {{{
#------------------------------------------------------------------------------

_tmuxinator() {
  local curcontext="$curcontext" state line ret=1
  local -a _configs

  _arguments -C \
    '1: :->cmds' \
    '2:: :->args' && ret=0

  _configs=(${$(echo ~/.tmuxinator/*.yml):r:t})

  case $state in
    cmds)
      _values "tmuxinator command" \
          "new[create a new project file and open it in your editor]" \
          "start[start a tmux session using project's tmuxinator config]" \
          "open[create a new project file and open it in your editor]" \
          "copy[copy source_project project file to a new project called new_project]" \
          "delete[deletes the project called project_name]" \
          "debug[output the shell commands generated by a projet]" \
          "implode[deletes all existing projects!]" \
          "list[list all existing projects]" \
          "doctor[look for problems in your configuration]" \
          "help[shows this help document]" \
          "version[shows tmuxinator version number]" \
          $_configs
      ret=0
      ;;
    args)
      case $line[1] in
        start|open|copy|delete|debug)
          [[ -n "$_configs" ]] && _values 'configs' $_configs
          ret=0
          ;;
      esac
      ;;
  esac

  return ret
}

compdef _tmuxinator mux

#---------------------------------------------------------------------------}}}
# peco-history alias                                                        {{{
#------------------------------------------------------------------------------

function peco-select-history() {
    typeset tac
    if which tac > /dev/null; then
        tac=tac
    else
        tac='tail -r'
    fi
    BUFFER=$(fc -l -n 1 | eval $tac | peco --query "$LBUFFER" --prompt ">")
    CURSOR=$#BUFFER
    zle redisplay
}
zle -N peco-select-history

#---------------------------------------------------------------------------}}}
# agvim                                                                     {{{
# http://qiita.com/fmy/items/b92254d14049996f6ec3
#------------------------------------------------------------------------------

function agvim(){
  vim $(ag $@ | peco --query "$LBUFFER" --prompt ">" | awk -F : '{printf("-c %s %s"),$2,$1;}')
}

#---------------------------------------------------------------------------}}}
# takenote                                                                  {{{
#------------------------------------------------------------------------------

function takenote() {
  local get_dir=false
  local get_name=false
  local alternative=false
  local show_list=false
  local filercmd=r
  local filer=false
  local rootdir=$HOME/Workspace/blog
  local pattern='s/note_\([0-9]\{2\}\).md/\1/p'

  show_usage() {
    echo "Usage: takenote [-d dir] [-o filename] [-g editor] [-l] [-r] [-h]"
    echo "  -d dir     : set the saving directory (default: '$rootdir')"
    echo "  -o filename: set the file's name"
    echo "  -g editor  : open with an altenative program (default: '$EDITOR')"
    echo "  -l         : list the today's files"
    echo "  -r         : open the today's dir or the root dir with the filer (default: '$filercmd')"
    echo "  -h         : show this message"
  }

  check_dir() {
    if [ ! -e "$1" ]; then
      echo "Directory '$1' doesn't exist."
      return 1
    fi
  }

  while getopts d:o:g:lrh OPT
  do
    case $OPT in
      "d" ) get_dir=true
            dir="$OPTARG" ;;
      "o" ) get_name=true
            name="$OPTARG" ;;
      "g" ) alternative=true
            editor="$OPTARG" ;;
      "l" ) show_list=true ;;
      "r" ) filer=true ;;
      "h" ) show_usage;
            return 0 ;;
        * ) show_usage;
            return 0 ;;
    esac
  done

  # set the saving directory
  if ! $get_dir; then
    if check_dir "$rootdir"; then
      daydir=$(date +%Y-%m-%d)
      dir=$rootdir/$daydir
    else
      return 1
    fi
  fi

  # only show existing file in the directory
  if $show_list; then
    if check_dir "$dir"; then
      list=$(ls "$dir")
      echo "$list"
    fi
    return 0
  fi

  # move to today's directory by the user defined filer
  if $filer; then
    if [ ! -e "$dir" ]; then
      echo "Today's directory has not been created yet."
      echo "Open root directory '$rootdir' ..."
      "$filercmd" "$rootdir"
    else
      "$filercmd" "$dir"
    fi
    return 0
  fi

  # set the filename
  if ! $get_name; then
    if [ ! -e "$dir" ]; then
      i=1
    else
      i=$(( $(ls "$dir" | sed -n $pattern | tail -n 1) + 1 ))
    fi
    name="$(printf note_%02d.md "$i")"
  fi

  # change directory
  local cwd="`pwd`"
  cd $dir

  if $alternative; then
    $editor "$dir/$name"
  else
    $EDITOR "$dir/$name"
  fi

  # back to recent working directory
  cd $cwd

  return 0
}

_takenote() {
  typeset -A opt_args
  _arguments -s -S \
    "(-l -r -h)-d[set saving directory for specific directory.]: :_files -/" \
    "(-l -r -h)-o[set the text file's name.]: :( `takenote -l | sed -n 's/\(.*\.md\)/\1/p'` )" \
    "(-l -r -h)-g[open with alternative program (default: vim).]: :(leafpad nano gedit)" \
    "(-d -o -g -r -h)-l[only do \`ls dir\`.]: :" \
    "(-d -o -g -l -h)-r[cd to TODAY dir, or it doesn't exist, to ROOT dir.]: :" \
    "(-d -o -g -l -r)-h[Show the help message.]: :" \
    && return 0
}

compdef _takenote takenote

#---------------------------------------------------------------------------}}}
# mytask completion                                                       {{{
#------------------------------------------------------------------------------

_mytask() {
  _arguments -C \
    '1: :->cmds' \
    '2:: :->args' && ret=0

  case $state in
    cmds)
      _values "mytask command" \
          "start[Execute the taskset.]" \
          "add[Add new taskset.]" \
          "edit[Edit the existing taskset.]" \
          "remove[Remove a taskset.]" \
          "list[List all existing taskset.]"
      ret=0
      ;;
    args)
      case $line[1] in
        start|edit|remove)
          _values 'configs' $(mytask list)
          ret=0
          ;;
        add)
          _path_files
          ret=0
          ;;
      esac
      ;;
  esac

  return ret
}

compdef _mytask mytask

#---------------------------------------------------------------------------}}}
# shtest                                                                    {{{
#------------------------------------------------------------------------------

function shtest() {
  show_usage() {
    echo ""
    echo "Make testing snippet for shell script."
    echo ""
    echo "Usage: show_usage [OPTION]"
    echo ""
    echo "Option:"
    echo "  -o FILE: Set the file name to save. "
    echo "  -l     : List the formatted files."
    echo "  -h     : Show this message."
  }

  local pattern='s/test_\([0-9]\{2\}\).sh/\1/p'
  local pattern_full='s/\(test_[0-9]\{2\}.sh\)/\1/p'
  local get_name=false
  local dir="$HOME/bin"
  local cwd="`pwd`"

  show_list() {
    list="$(ls "$dir" | sed -n $pattern_full)"
    echo "$list"
  }

  while getopts o:lh OPT
  do
    case $OPT in
      "o" ) get_name=true
            name="$OPTARG" ;;
      "l" ) show_list
            return 0 ;;
      "h" ) show_usage;
            return 1 ;;
        * ) show_usage;
            return 1 ;;
    esac
  done

  if ! $get_name; then
    i=$(( $(ls "$dir" | sed -n $pattern | tail -n 1) + 1 ))
    name="$(printf test_%02d.sh "$i")"
  fi

  # change directory
  cd $dir
  $EDITOR "$dir/$name"

  # return to recent working directory
  cd $cwd

  return 0
}

_shtest() {
  typeset -A opt_args
  _arguments -s -S \
    "(-l -h)-o[set the text file's name.]: :( `shtest -l` )" \
    "(-o -h)-l[List the formatted files.]: :" \
    "(-o -l)-h[Show this message.]: :" \
    && return 0
}

compdef _shtest shtest

#---------------------------------------------------------------------------}}}
# myrsync completion                                                        {{{
#------------------------------------------------------------------------------

_myrsync() {
  _values "myrsync commands"\
    "up[upload local directory to the Dropbox directory.]" \
    "down[download the Dropbox directory to local.]"
    return 0
}

compdef _myrsync myrsync

#---------------------------------------------------------------------------}}}
# zsh-bd                                                                    {{{
#------------------------------------------------------------------------------
# Quickly go back to aspecific parent directory instead of typing cd ../../../
# [Tarrasch/zsh-bd](https://github.com/Tarrasch/zsh-bd)

function bd () {
  (($#<1)) && {
    print -- "usage: $0 <name-of-any-parent-directory>"
    print -- "       $0 <number-of-folders>"
    return 1
  } >&2
  local num=${#${(ps:/:)${PWD} }}
  local dest="./"

  # If the user provided an integer, go up as many times as asked
  if [[ "$1" = <-> ]]
  then
    if [[ $1 -gt $num ]]
    then
      print -- "bd: Error: Can not go up $1 times (not enough parent directories)"
      return 1
    fi
    for i in {1..$1}
    do
      dest+="../"
    done
    cd $dest
    return 0
  fi

  # else, find the correct parent directory
  # Get parents (in reverse order)
  local parents
  local i
  for i in {$((num+1))..2}
  do
    parents=($parents "$(echo $PWD | cut -d'/' -f$i)")
  done
  parents=($parents "/")
  # Build dest and 'cd' to it
  local parent
  foreach parent (${parents})
  do
    if [[ $1 == $parent ]]
    then
      cd $dest
      return 0
    fi
    dest+="../"
  done
  print -- "bd: Error: No parent directory named '$1'"
  return 1
}
_bd () {
  # Get parents (in reverse order)
  local num=${#${(ps:/:)${PWD}} }
  local i
  for i in {$((num+1))..2}
  do
    reply=($reply "`echo $PWD | cut -d'/' -f$i`")
  done
  reply=($reply "/")
}
compctl -V directories -K _bd bd

#---------------------------------------------------------------------------}}}
# Configurations                                                            {{{
#------------------------------------------------------------------------------

cfg-aliases() { $EDITOR ~/.aliases.mine.zsh ;}
cfg-compton() { $EDITOR ~/.config/compton/compton.conf ;}
cfg-dotfiles() { $EDITOR ~/.dotfiles/setup_config_link ;}
cfg-history() { $EDITOR ~/.zsh_history ;}
cfg-latexmkrc() { $EDITOR ~/.latexmkrc ;}
cfg-luakit() { $EDITOR ~/.config/luakit ;}
cfg-mpv() { $EDITOR ~/.mpv/config ;}
cfg-mplayer() { $EDITOR ~/.mplayer/config ;}
cfg-ranger() { $EDITOR ~/.config/ranger/rc.conf ;}
cfg-ranger-rifle() { $EDITOR ~/.config/ranger/rifle.conf ;} # edit open_with extensions
cfg-ranger-commands() { $EDITOR ~/.config/ranger/commands.py ;} # scripts
cfg-tig() { $EDITOR ~/.tigrc ;}
cfg-tmux() { $EDITOR ~/.tmux.conf ;}
cfg-tmuxinator() { $EDITOR ~/.tmuxinator/ ;}
cfg-turses() { $EDITOR ~/.turses/config ;}
cfg-vimcolor() { $EDITOR ~/.vim/bundle/easy-reading.vim/colors/easy-reading.vim ;}
cfg-vimperatorrc() { $EDITOR ~/.vimperatorrc ;}
cfg-vimrc() { $EDITOR ~/.vimrc ;}
cfg-xdefaults() { $EDITOR ~/.Xdefaults ;}
cfg-Xmodmap() { $EDITOR ~/.Xmodmap ;}
cfg-xmonad() { $EDITOR ~/.xmonad/xmonad.hs ;}
cfg-xresources() { $EDITOR ~/.Xresources ;}
cfg-websearch() { $EDITOR ~/Workspace/python/web_search/websearch/config.py ;}
cfg-zshrc() { $EDITOR ~/.zshrc.mine ;}

#---------------------------------------------------------------------------}}}
# Configurations Reload                                                     {{{
#------------------------------------------------------------------------------

rld-xdefaults() { xrdb ~/.Xdefaults ;}
rld-xmodmap() { xmodmap ~/.Xmodmap ;}
rld-xresources() { xrdb -load ~/.Xresources ;}
rld-zshrc() { source ~/.zshrc ;}

#---------------------------------------------------------------------------}}}
