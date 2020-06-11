# adjust color scheme according to sunrise/sunset
# sunrise=$(sunwait -p 49N 9E | grep -i rise | awk '{ print $3 }')
# sunset=$(sunwait -p 49N 9E | grep -i rise | awk '{ print $6 }')
date=$(date +"%H%M")
if [ "0700" -lt "$date" ] && [ "$date" -lt "1900" ] ; then
    export DARK_MODE=0
else
    export DARK_MODE=1
fi

cd ~/.dotfiles/alacritty || exit
sed -i -e '/COLOR/q' alacritty.yml
if [ "$DARK_MODE" = 0 ] ; then
    cat base16-alacritty/colors/base16-mexico-light.yml >> alacritty.yml
fi
cd - >/dev/null || exit
