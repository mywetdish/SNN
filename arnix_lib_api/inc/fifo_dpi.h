#ifndef DPI_H
#define DPI_H

#ifdef __cplusplus
#define DPI_LINK_DECL  extern "C" 
#else
#define DPI_LINK_DECL 
#endif

#include "svdpi.h"
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

#define BUFF_SIZE 1000
#define MSG_SIZE 80

DPI_LINK_DECL DPI_DLLESPEC
void 
arnix_fifo(
        const svBit* in,
        uint32_t in_size,
        uint32_t out_size,
        svBit* out
    );

#endif // DPI_H