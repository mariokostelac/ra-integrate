COMPONENTS = graphmap ra

all: $(COMPONENTS)

docker-build:
	@echo "Starting docker build..."
	@docker build -t ra .

graphmap:
	@echo "Building graphmap libs..."
	@bash -c 'cd components/graphmap/libs/ && source build-libdivsufsort.sh &> ../../../build_logs/graphmap_libs.log'
	@echo "Building graphmap..."
	@GCC=$(CXX) bash -c 'make -C components/graphmap &> build_logs/graphmap.log'

ra:
	@echo "Building ra..."
	@bash -c 'make -C components/ra &> build_logs/ra.log'

upgrade:
	@echo "Getting new code..."
	@git pull
	@git submodule foreach git pull origin master
	@make

clean:
	@make -C components/graphmap clean
	@make -C components/ra clean

.PHONY: all ra graphmap docker-build upgrade clean
