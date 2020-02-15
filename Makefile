.SUFFIXES:
FC=gfortran
COMPILE.f08 = $(FC) $(FCFLAGS) $(TARGET_ARCH) -c

SOURCES=src/game.f90 
TARGET=hangtran

hangtran:
	$(FC) $(SOURCES) -o $(TARGET)

clean:
	-rm -f *.o *.mod hangtran
