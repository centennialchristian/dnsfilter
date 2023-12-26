INSTALL_DIR = /opt/pihole

install:
	install -m 755 -g root -u root -d "$(INSTALL_DIR)"
	install -m 755 -g root -u root -d "$(INSTALL_DIR)/etc-dnsmasq.d"
	install -m 755 -g root -u root -d "$(INSTALL_DIR)/etc-pihole"
	install -m 644 -g root -u root -t "$(INSTALL_DIR)" docker-compose.yml template.env
	test -f "$(INSTALL_DIR)/.env" || cp "$(INSTALL_DIR)/template.env" "$(INSTALL_DIR)/.env"
	sed "s|%DNSFILTERDIR%|$(INSTALL_DIR)|" pihole.service.template > "/etc/systemd/system/pihole.service"
	systemctl daemon-reload
	echo -e "\033[0;33mCreate .env at $(INSTALL_DIR)/.env using $(INSTALL_DIR)/template.env as a guide!\033[0;00m"

uninstall:
	systemctl disable --now pihole
	rm -f /etc/systemd/system/pihole.service
	systemctl daemon-reload
	rm -f "$(INSTALL_DIR)/docker-complose.yml" "$(INSTALL_DIR)/template.env"

purge:
	systemctl list-units | grep -s -q pihole && systemctl disable --now pihole
	test -f /etc/systemd/system/pihole.service && rm -f /etc/systemd/system/pihole.service
	systemctl daemon-reload
	test -d "$(INSTALL_DIR)" && rm -Rf "$(INSTALL_DIR)"
