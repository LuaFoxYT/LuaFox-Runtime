linux:
	cd lfpp/ && make
	lua targets/Linux.lua
	mkdir lfrt
	mv init.lua lfrt
	cp src/lfar.lua lfrt
	mkdir -p $(HOME)/.config/lfrt
	mkdir -p $(HOME)/.config/lfrt/lib
	mkdir -p $(HOME)/.config/lfrt/prg
	cp src/lfastr.lua /usr/local/share/lua/5.3
	cp -r lfrt /usr/local/share/lua/5.3
	cp src/lfrtcl.lua $(HOME)/.config/lfrt
	cp src/lfrt-bin-linux.sh /usr/bin/lfrt
	chmod a+x /usr/bin/lfrt
	echo 'installing lfdev'
	cd lfdev/ && make
	cp lfdev/out.lfar $(HOME)/.config/lfrt/prg/lfdev.lfar
clean:
	rm -r lfrt
