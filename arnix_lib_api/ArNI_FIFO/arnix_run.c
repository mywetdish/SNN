#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <string.h>

#define BUFF_SIZE 1000
#define MSG_SIZE 80

int main(int argc, char const *argv[])
{
    pid_t pid = 0;
    int inpipefd[2];
    int outpipefd[2];

    pipe(inpipefd);
    pipe(outpipefd);

    pid = fork();
    if (pid == 0)
    {
        dup2(outpipefd[0], 0);
        dup2(inpipefd[1], 1);
        close(outpipefd[1]);
        close(inpipefd[0]);
        execlp("./ArNI/ArNICPU", "ArNICPU", "./ArNI", "-e4", "-f0", "-R0", (char*) NULL);
        fprintf(stderr,"failed to open ArNI!");
        exit(1);
    }

    close(outpipefd[0]);
    close(inpipefd[1]);
    int i;
    char buff[BUFF_SIZE];
    char msg[MSG_SIZE];
    char c;

    int fd_dpi;
    int fd_arni;

    FILE *stream_out = fdopen(outpipefd[1], "w");
    FILE *stream_in  = fdopen(inpipefd[0], "r");

    do {
        i = 0;
        if ((fd_dpi = open("fifo_dpi", O_RDONLY)) == -1) return 1;
        do {
            if (read(fd_dpi, &c, sizeof(char)) == -1) return 2;
            buff[i++] = c;
            if (i>BUFF_SIZE-2) return 3;
        } while ( c != '\0' );
        close(fd_dpi);

        fprintf(stream_out, "%s", buff);
        fflush(stream_out);
        do {
            fgets(msg,80,stream_in);
        } while(strstr(msg,"ArNI") == NULL);

        if ((fd_arni = open("fifo_arni", O_WRONLY)) == -1) return 1;
        if (write(fd_arni, msg, sizeof(char)*(strlen(msg)+1)) == -1) return 2;
        close(fd_arni);

        printf("Receive: %sSend: %s", buff, msg);


    } while(strstr(buff,"exit_arni") == NULL);

        
    close(inpipefd[1]);
    close(outpipefd[0]);
    /*
    

    char buff[1000];
    char msg[80];

    int fd_dpi = open("fifo_dpi", O_RDONLY);
    if (fd_dpi == -1) {
        return 1;
    }
    int fd_arni = open("fifo_arni", O_WRONLY);
    if (fd_arni == -1) {
        return 1;
    }
    
    FILE *stream_out = fdopen(outpipefd[1], "w");
    FILE *stream_in  = fdopen(inpipefd[0], "r");
    FILE *fifo_dpi;
    FILE *fifo_arni;
    
    do {
        while((fifo_dpi = fdopen(fd_dpi,"r")) == NULL) printf("WAIT_TO_OPEN_DPI\n");
        fgets(buff,1000,fifo_dpi);
        fclose(fifo_dpi);
        fprintf(stream_out, "%s", buff);
        fflush(stream_out);
        do {
            fgets(msg,80,stream_in);
        } while(strstr(msg,"ArNI") == NULL);

        while((fifo_arni = fdopen(fd_arni,"r")) == NULL) printf("WAIT_TO_OPEN_ARNI\n");
        fprintf(fifo_arni,"%s",msg);
        fclose(fifo_arni);
    } while(strstr(buff,"exit_arni") == NULL);

    fclose(stream_in);
    fclose(stream_out);

    close(fd_dpi);
    close(fd_arni);
    close(inpipefd[1]);
    close(outpipefd[0]);
    */
    return 0;
}