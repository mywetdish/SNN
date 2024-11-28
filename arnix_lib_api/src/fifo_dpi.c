#include "../inc/fifo_dpi.h"


DPI_LINK_DECL DPI_DLLESPEC
void arnix_fifo(
        const svBit* in,
        uint32_t in_size,
        uint32_t out_size,
        svBit* out
    ) {

    char buff[BUFF_SIZE];
    char msg[MSG_SIZE];
    char c;
    int i;
    int fd_dpi;
    int fd_arni;

    for (uint32_t j = 0; j < in_size/8 + 1; ++j) { //there need to round up
        //printf("%d: %u\n", j,in[j]); 
        for (int bit = 0; bit <= 7; bit++) {
            buff[j * 8 + bit] = (in[j] & (1 << bit)) ? '@' : '.';
        }
    }

    // Initialize first and last pointers
    int first = 0;
    int last = in_size - 1;
    char temp;

    // Swap characters till first and last meet
    while (first < last) {
      
        // Swap characters
        temp = buff[first];
        buff[first] = buff[last];
        buff[last] = temp;

        // Move pointers towards each other
        first++;
        last--;
    }

    buff[in_size] = '\n';
    buff[in_size+1] = '\0';
    if ((fd_dpi = open("arnix_lib_api/ArNI_FIFO/fifo_dpi", O_WRONLY)) == -1) fprintf(stderr, "Can`t open fifo_dpi!");
    if (write(fd_dpi, buff, sizeof(char)*(strlen(buff)+1 )) == -1) fprintf(stderr, "Can`t write dpi!");
    close(fd_dpi);
    i = 0;
    if ((fd_arni = open("arnix_lib_api/ArNI_FIFO/fifo_arni", O_RDONLY)) == -1) fprintf(stderr, "Can`t open fifo_arni!");
    do {
        if (read(fd_arni, &c, sizeof(char)) == -1) fprintf(stderr, "Can`t write arni!");
        msg[i++] = c;
        if (i>MSG_SIZE-2) fprintf(stderr, "arni string too big!");
    } while ( c != '\0' );
    close(fd_arni);

    (*out) = 0;

    if(strchr(msg,'0')!=NULL) {
      (*out) += 1;
    }
    if(strchr(msg,'1')!=NULL) {
      (*out) += 2;
    }
    if(strchr(msg,'2')!=NULL) {
      (*out) += 4;
    }

}