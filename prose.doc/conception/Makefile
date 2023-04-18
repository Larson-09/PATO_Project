PACKAGES = ebauches

conc:
	+@for p in $(PACKAGES); do (cd $$p; make all); done

all: conc
	

clean:
	+@for p in $(PACKAGES); do (cd $$p; make $@); done

.PHONY: clean

