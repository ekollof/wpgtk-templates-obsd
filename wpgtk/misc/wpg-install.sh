#!/usr/bin/env bash

__ScriptVersion="0.1.6";

if [ -n "${XDG_CONFIG_HOME}" ]; then
  CONFIG="${XDG_CONFIG_HOME}"
else
  CONFIG="${HOME}/.config" 
fi

if [ -n "${XDG_DATA_HOME}" ]; then
  LOCAL="${XDG_DATA_HOME}"
else
  LOCAL="${HOME}/.local/share" 
fi

THEMES_DIR="${HOME}/.themes";
SRC_DIR="${PWD}/wpgtk-templates";
TEMPLATE_DIR="${CONFIG}/wpg/templates";

#===  FUNCTION  ================================================================
#         NAME:  wpg-install.sh
#  DESCRIPTION:  Installs various wpgtk themes.
#===============================================================================
usage()
{
  echo "Usage :  $0 [options] [--]

  Options:
  -h   Display this message
  -v   Display script version
  -o   Install openbox templates
  -t   Install tint2 template
  -g   Install gtk template
  -G   Install linea nord gtk template
  -i   Install icon-set
  -r   Install rofi template
  -I   Install i3 template
  -p   Install polybar template
  -b   Install bspwm template
  -d   Install dunst template
  -B   Install bpytop template
  -q   Install qtile template
  -H   Specify hash of wpgtk-templates repository to use
  "
}

checkprogram()
{
  command -v $1 >/dev/null 2>&1;
  if [[ $? -eq 1 ]]; then
    echo "Please install $1 before proceeding"; 
    exit 1;
  fi
}

getfiles()
{
  checkprogram 'git';
  checkprogram 'wpg';
  mkdir -p "${LOCAL}/themes/color_other";
  mkdir -p "${LOCAL}/icons";
  git clone https://github.com/ekollof/wpgtk-templates-obsd.git "$SRC_DIR";
  if [[ $? -eq 0 ]]; then
    cd "$SRC_DIR";
    [[ ! -z "$commit" ]] && git checkout $commit;
    return 0;
  else
    exit 1;
  fi
}

install_tint2()
{
  echo -n "This might override your tint2 config, Continue?[Y/n]: ";
  read -r response;
  if [[ ! "$response" == "n" ]]; then
    echo "Installing tint2 config";
    echo ":: backing up current tint2 conf in tint2rc.old.bak";
    gcp "${CONFIG}/tint2/tint2rc" "${CONFIG}/tint2/tint2rc.old.bak" 2>/dev/null;
    gcp --remove-destination ./tint2/tint2rc "${CONFIG}/tint2/tint2rc" && \
    gcp --remove-destination ./tint2/tint2rc.base "${TEMPLATE_DIR}" && \
      ln -sf "${CONFIG}/tint2/tint2rc" "${TEMPLATE_DIR}/tint2rc" && \
      echo ":: tint2 template install done."
    return 0;
  fi
  echo ":: tint2 template not installed";
}

install_rofi()
{
  echo "Installing rofi wpg theme";
  gcp --remove-destination ./rofi/wpg.rasi "${CONFIG}/rofi/wpg.rasi" && \
	gcp --remove-destination ./rofi/wpg.rasi.base "${TEMPLATE_DIR}" && \
	ln -sf "${CONFIG}/rofi/wpg.rasi" "${TEMPLATE_DIR}/wpg.rasi" && \
	echo ":: rofi wpg theme install done." && \
	echo ':: add @theme "wpg" to your rofi config'
  return 0;
}

install_i3() 
{
  echo -n "This might override your i3 config, Continue?[Y/n]: ";
  read -r response;
  if [[ ! "$response" == "n" ]]; then
    echo "Installing i3 config";
    echo ":: backing up current i3 conf in config.bak";
    gcp "${CONFIG}/i3/config" "${CONFIG}/i3/config.bak" 2>/dev/null;
    gcp --remove-destination ./i3/config "${CONFIG}/i3/config" && \
    gcp --remove-destination ./i3/i3.base "${TEMPLATE_DIR}" && \
      ln -sf "${CONFIG}/i3/config" "${TEMPLATE_DIR}/i3" && \
      echo ":: i3 template install done."
    return 0;
  fi
  echo ":: i3 template not installed";
}

install_polybar() 
{
  echo -n "This might override your polybar config, Continue?[Y/n]: ";
  read -r response;
  if [[ ! "$response" == "n" ]]; then
    echo "Installing polybar config";
    echo ":: backing up current polybar conf in config.bak";
    gcp "${CONFIG}/polybar/config" "${CONFIG}/polybar/config.bak" 2>/dev/null;
    gcp --remove-destination ./polybar/config "${CONFIG}/polybar/config" && \
    gcp --remove-destination ./polybar/polybar.base "${TEMPLATE_DIR}" && \
      ln -sf "${CONFIG}/polybar/config" "${TEMPLATE_DIR}/polybar" && \
      echo ":: polybar template install done."
    return 0;
  fi
  echo ":: polybar template not installed";
}

install_gtk()
{
  echo "Installing gtk themes";
  gcp -r ./FlatColor "${LOCAL}/themes/" && \

  mkdir -p "${THEMES_DIR}" && \

  gcp --remove-destination ./FlatColor/gtk-2.0/gtkrc.base "${TEMPLATE_DIR}/gtk2.base" && \
    ln -sf "${LOCAL}/themes/FlatColor/gtk-2.0/gtkrc" "${TEMPLATE_DIR}/gtk2" && \
	ln -sf "${LOCAL}/themes/FlatColor" "${THEMES_DIR}/FlatColor" && \
	echo ":: gtk2 theme done" "${TEMPLATE_DIR}/gtk2";

  gcp --remove-destination ./FlatColor/gtk-3.0/gtk.css.base "${TEMPLATE_DIR}/gtk3.0.base" && \
    ln -sf "${LOCAL}/themes/FlatColor/gtk-3.0/gtk.css" "${TEMPLATE_DIR}/gtk3.0" && \
    echo ":: gtk3.0 theme done"

  gcp --remove-destination ./FlatColor/gtk-3.20/gtk.css.base "${TEMPLATE_DIR}/gtk3.20.base" && \
    ln -sf "${LOCAL}/themes/FlatColor/gtk-3.20/gtk.css" "${TEMPLATE_DIR}/gtk3.20" && \
    echo ":: gtk3.20 theme done"

  echo ":: FlatColor gtk themes install done."
}

install_alternative_gtk()
{
  echo "Installing linea nord gtk themes";
  gcp -r ./linea-nord-color "${LOCAL}/themes/" && \


  mkdir -p "${THEMES_DIR}" && \
	  gcp --remove-destination ./linea-nord-color/dark.css.base "${TEMPLATE_DIR}/linea-nord.css.base" && \
	  ln -sf "${LOCAL}/themes/linea-nord-color/general/dark.css" "${TEMPLATE_DIR}/linea-nord.css" && \
	  ln -sf "${LOCAL}/themes/linea-nord-color" "${THEMES_DIR}/linea-nord-color" && \

  echo ":: Linea Nord Color gtk themes install done."
}

install_icons()
{
  echo "Installing icon pack";
  gcp -r flattrcolor "${LOCAL}/icons/" && \
  gcp -r flattrcolor-dark "${LOCAL}/icons/" && \
    echo ":: flattr icons install done."
}

install_openbox()
{
  echo "Installing openbox themes";
  gcp --remove-destination -r ./openbox/colorbamboo/* "${LOCAL}/themes/colorbamboo"

  mkdir -p "${THEMES_DIR}"

  if [[ $? -eq 0 ]]; then
	mv "${LOCAL}/themes/colorbamboo/openbox-3/themerc.base" "${TEMPLATE_DIR}/ob_colorbamboo.base" && \
	  ln -sf "${LOCAL}/themes/colorbamboo/openbox-3/themerc" "${TEMPLATE_DIR}/ob_colorbamboo" && \
	  ln -sf "${LOCAL}/themes/colorbamboo" "${THEMES_DIR}/colorbamboo" && \
	  echo ":: colorbamboo openbox themes install done.";
  fi
}

install_bspwm()
{
  echo "Installing bspwm colors";
  mv "./bspwm/bspwm_colors.base" "${TEMPLATE_DIR}/bspwm_colors.base";
  mv "./bspwm/bspwm_colors" "${TEMPLATE_DIR}/bspwm_colors";
  ln -sf "${CONFIG}/bspwm/bspwm_colors.sh" "${TEMPLATE_DIR}/bspwm_colors" && \
  printf 'bash %s/bspwm/bspwm_colors.sh &' ${CONFIG} >> "${CONFIG}/bspwm/bspwmrc";
  echo ":: bspwm colors install done.";
}

install_dunst()
{
  echo "Installing dunst colors";
  echo ":: backing up current dunst conf in dunstrc.bak";
  gcp "${CONFIG}/dunst/dunstrc" "${CONFIG}/dunst/dunstrc.bak" 2>/dev/null;

  mv "./dunst/dunstrc.base" "${TEMPLATE_DIR}/dunstrc.base";
  mv "./dunst/dunstrc" "${TEMPLATE_DIR}/dunstrc";
  ln -sf "${CONFIG}/dunst/dunstrc" "${TEMPLATE_DIR}/dunstrc" && \
	echo ":: dunst colors install done.";
}

install_bpytop()
{
  echo "Installing bpytop theme";
  echo ":: backing up current bpytop flatcolor theme in flatcolor.theme.bak";
  gcp "${CONFIG}/bpytop/themes/flatcolor.theme" "${CONFIG}/bpytop/themes/flatcolor.theme.bak" 2>/dev/null;
  mv "./bpytop/bpytop.base" "${TEMPLATE_DIR}/bpytop.base";
  mv "./bpytop/bpytop" "${TEMPLATE_DIR}/bpytop";
  ln -sf "${CONFIG}/bpytop/themes/flatcolor.theme" "${TEMPLATE_DIR}/bpytop" && \
	echo ":: backing up current bpytop config to bpytop.conf.bak";
  sed -i.bak "s/^color_theme=.*/color_theme=+flatcolor/" ${CONFIG}/bpytop/bpytop.conf && \
	echo ":: bpytop theme install done, 'flatcolor' theme applied";
}

install_qtile()
{
  echo "Installing qtile colors";
  echo ":: backing up current qtile config in config.py.bak";
  gcp "${CONFIG}/qtile/config.py" "${CONFIG}/qtile/config.py.bak" 2>/dev/null;
  mv "./qtile/qtilecolors.py.base" "${TEMPLATE_DIR}/qtilecolors.py.base";
  mv "./qtile/qtilecolors.py" "${TEMPLATE_DIR}/qtilecolors.py";
  ln -sf "${CONFIG}/qtile/qtilecolors.py" "${TEMPLATE_DIR}/qtilecolors.py" && \
  if ! grep -q qtilecolors "${CONFIG}/qtile/config.py"; then
    echo ":: adding imports to qtile config"
    sed -i -e '2ifrom qtilecolors import colors # noqa\' "${CONFIG}/qtile/config.py"
  else
    echo ":: imports are already in place, skipping..."
  fi
  echo ":: qtile theme install done" && \
  echo ":: generated colors are available using colors[0-15] list in place of hex values." &&\
  echo ":: remember to edit your config.py colors to use the wpg color scheme where appropriate";
}


clean_up()
{
  rm -rf "$SRC_DIR";
}


#-----------------------------------------------------------------------
#  Handle command line arguments
#-----------------------------------------------------------------------

getargs()
{
  while getopts "H:bhvotgGiIprdBq" opt
  do
    case $opt in
      h)
        usage;
        exit 0
        ;;
      v)
        echo "$0 -- Version $__ScriptVersion";
        exit 0;
        ;;
      o) openbox="true" ;;
      i)   icons="true" ;;
      g)     gtk="true" ;;
	  G)     gtk_alt="true" ;;
      t)   tint2="true" ;;
      r)    rofi="true" ;;
      I)      i3="true" ;;
      p) polybar="true" ;;
      b)   bspwm="true" ;;
      d)   dunst="true" ;;
      B)  bpytop="true" ;;
      q)   qtile="true" ;;
      H) commit="${OPTARG}" ;;
      *)
        echo -e "\n  Option does not exist : $OPTARG\n"
        usage;
        exit 1
        ;;

      esac
    done
    shift "$((OPTIND - 1))"
}

main()
{
  getargs "$@";
  getfiles;
  [[ "$openbox" == "true" ]] && install_openbox;
  [[ "$tint2" == "true" ]] && install_tint2;
  [[ "$rofi" == "true" ]] && install_rofi;
  [[ "$gtk" == "true" ]] && install_gtk;
  [[ "$gtk_alt" == "true" ]] && install_alternative_gtk;
  [[ "$icons" == "true" ]] && install_icons;
  [[ "$polybar" == "true" ]] && install_polybar;
  [[ "$i3" == "true" ]] && install_i3;
  [[ "$bspwm" == "true" ]] && install_bspwm;
  [[ "$dunst" == "true" ]] && install_dunst;
  [[ "$bpytop" == "true" ]] && install_bpytop;
  [[ "$qtile" == "true" ]] && install_qtile;
  clean_up;
}

main "$@"

