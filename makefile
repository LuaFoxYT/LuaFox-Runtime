linux:
	lua targets/Linux.lua
	mkdir lfrt
	mv init.lua lfrt
	cp src/lfar.lua lfrt
	
clean:
	rm -r lfrt