COMPONENTS = graphmap ra

all: $(COMPONENTS)

graphmap:
	@echo "Building graphmap libs..."
	@bash -c 'cd components/graphmap/libs/ && source build-libdivsufsort.sh' &> build_logs/graphmap_libs.log
	@echo "Building graphmap..."
	@GCC=$(CXX) make -C components/graphmap &> build_logs/graphmap.log

ra:
	@echo "Building ra..."
	@make -C components/ra &> build_logs/ra.log

clean:
	make -C components/graphmap clean
	make -C components/ra clean
