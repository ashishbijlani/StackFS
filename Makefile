all: StackFS_ll

CFLAGS += -D_FILE_OFFSET_BITS=64 -Wall -Werror -DENABLE_STATS #-DDEBUG 
STACKFS_LL_CFLAGS = -I$(HOME)/libfuse/include
STACKFS_LL_LDFLAGS = -L$(HOME)/libfuse/lib/.libs -lfuse3 -lpthread

STACKFS_LL_SRCS = StackFS_LL.c

STACKFS_ACCEL_LL_CFLAGS = \
	-I/lib/modules/$(shell uname -r)/build/usr/include \
	-I$(HOME)/projects/libfuse/include \
	-I$(HOME)/projects/libfuse/lib \
	-I$(HOME)/projects/extfuse/include \
	-I$(HOME)/projects/extfuse

STACKFS_ACCEL_LL_LDFLAGS = \
	-L$(HOME)/projects/libfuse/lib/.libs -lfuse3 -lpthread \
	-L$(HOME)/projects/extfuse -lextfuse

# Use '-DUSE_SPLICE=0' for default fuse (no optimizations)
# Use '-DUSE_SPLICE=1' for optimized fuse
# Use '-DCACHE_ENTRY_ATTR' FUSE entry/attr caching enabled
# Use '-DENABLE_EXTFUSE' to enable ExtFUSE
# Use '-DENABLE_EXTFUSE_LOOKUP' to cache lookup replies in the kernel with ExtFUSE
# Use '-DENABLE_EXTFUSE_ATTR' to cache attr replies in the kernel with ExtFUSE

# ExtFUSE enabled, LOOKUP and ATTR requests are cached in the kernel
StackFS_ll: $(STACKFS_LL_SRCS) attr.c lookup.c
	gcc $(CFLAGS) -DUSE_SPLICE=1 -DENABLE_EXTFUSE_LOOKUP \
		-DENABLE_EXTFUSE_ATTR -DENABLE_EXTFUSE $(STACKFS_ACCEL_LL_CFLAGS) \
		$^ $(STACKFS_ACCEL_LL_LDFLAGS) -o $@

clean:
	rm -f StackFS_ll
