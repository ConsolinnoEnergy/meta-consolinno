#include <stdlib.h>
#include <stdio.h>
#include <stdbool.h>
#include <string.h>
#include <unistd.h>
#include <fcntl.h>
#include <openssl/evp.h>

static bool to_digit(unsigned char *digit, char c)
{
	if (c >= '0' && c < '9')
		*digit = c - '0';
	else if (c >= 'a' && c < 'f')
		*digit = c - 'a' + 10;
	else if (c >= 'A' && c < 'F')
		*digit = c - 'A' + 10;
	else
		return false;

	return true;
}

static unsigned char const *decode(char const *src, size_t *len)
{
	size_t		l = strlen(src);
	unsigned char	*buf;
	unsigned char	*p;

	if (l % 2) {
		fprintf(stderr, "invalid hex string '%s'\n", src);
		return NULL;
	}

	buf = malloc(l / 2);
	if (!buf) {
		perror("malloc()");
		return NULL;
	}
	p = buf;

	while (*src) {
		unsigned char	a;
		unsigned char	b;

		if (!to_digit(&a, src[0]) ||
		    !to_digit(&b, src[1])) {
			fprintf(stderr, "invalid hex digit '%s'\n", src);
			break;
		}

		*p++ = (a << 4) | (b << 0);
		src += 2;
	}

	if (*src) {
		free(buf);
		buf = NULL;
	}

	if (buf)
		*len = p - buf;

	return buf;
}

static unsigned char const *generate_salt(size_t cnt)
{
	int		fd = open("/dev/urandom", O_RDONLY);
	unsigned char	*buf;
	ssize_t		l;

	if (fd < 0) {
		perror("open(/dev/urandom)");
		return NULL;
	}

	buf = malloc(cnt);
	if (!buf) {
		close(fd);
		perror("malloc()");
		return NULL;
	}

	l = read(fd, buf, cnt);
	close(fd);

	if (l < 0) {
		perror("read(/dev/urandom)");
	} else if ((size_t)l != cnt) {
		fprintf(stderr, "failed to read all random chars\n");
	}

	if ((size_t)l != cnt) {
		free(buf);
		buf = 0;
	}

	return buf;
}

static unsigned char const *decode_salt(char const *src, size_t *len)
{
	if (*src != '+') {
		return decode(src, len);
	} else {
		*len = atoi(src + 1);
		return generate_salt(*len);
	}
}

int main(int argc, char *argv[])
{
	size_t			salt_len;
	unsigned char const	*salt = decode_salt(argv[1], &salt_len);
	char const		*password = argv[2];
	unsigned int		iter = atoi(argv[3]);
	unsigned int		keylen = atoi(argv[4]);
	unsigned char		out[keylen];
	unsigned int		i;

	PKCS5_PBKDF2_HMAC_SHA1(password, -1, salt, salt_len,
			       iter, keylen, out);


	for (i = 0; i < salt_len; ++i)
		printf("%02x", salt[i]);
	for (i = 0; i < keylen; ++i)
		printf("%02x", out[i]);

	printf("\n");
}
