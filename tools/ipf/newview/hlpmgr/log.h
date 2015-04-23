#ifndef LOG_H
#define LOG_H

void LogEvent( char* format, ... );

void LogData( char* data, int length );

void stoplog();

#endif
