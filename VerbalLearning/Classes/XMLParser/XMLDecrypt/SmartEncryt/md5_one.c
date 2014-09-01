/* crypto/md5/md5_one.c */

#include <stdio.h>
#include <string.h>
#include "md5.h"

#ifdef CHARSET_EBCDIC
#include <ebcdic.h>
#endif

unsigned char *MD5(const unsigned char *d, size_t n, unsigned char *md)
	{
	MD5_CTX c;
	static unsigned char m[MD5_DIGEST_LENGTH];

	if (md == NULL) md=m;
	if (!MD5_Init(&c))
		return NULL;
#ifndef CHARSET_EBCDIC
	MD5_Update(&c,d,n);
#else
	{
		char temp[1024];
		unsigned long chunk;

		while (n > 0)
		{
			chunk = (n > sizeof(temp)) ? sizeof(temp) : n;
			ebcdic2ascii(temp, d, chunk);
			MD5_Update(&c,temp,chunk);
			n -= chunk;
			d += chunk;
		}
	}
#endif
	MD5_Final(md,&c);
	// DAVINCI_cleanse(&c,sizeof(c)); /* security consideration */
	return(md);
	}