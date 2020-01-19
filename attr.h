#ifndef __ATTR_H__
#define __ATTR_H__

#define FUSE_USE_VERSION 30
#define _GNU_SOURCE

#include <stdarg.h>
#include <unistd.h>
#include <stdio.h>

#include <ebpf.h>
#include <ebpf/attr.h>

void *attr_init(struct fuse_conn_info *conn);

int attr_insert(ebpf_context_t *ctxt, uint64_t nodeid,
				const struct stat *attr, double attr_timeout);
int attr_fetch(ebpf_context_t *ctxt, uint64_t nodeid,
				struct fuse_attr_out *out);
int attr_delete(ebpf_context_t *ctxt, uint64_t nodeid);
#endif
