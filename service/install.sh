# USER SERVICE

mkdir -p ~/.config/systemd/user/

cp ./sxhkd.service ~/.config/systemd/user/sxhkd.service
cp ./xsecure.service ~/.config/systemd/user/xsecure.service

systemctl --user daemon-reload
systemctl --user enable sxhkd.service xsecure.service
systemctl --user stop sxhkd.service xsecure.service
systemctl --user start sxhkd.service xsecure.service

# SYSTEM SERVICE
