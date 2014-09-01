//===================================================================================================
// Summary:
//		���ܵĽӿڡ�
// Usage:
//		Null	
//===================================================================================================

#ifndef __SmartEncrypt_h__
#define __SmartEncrypt_h__

//===================================================================================================

// ������Կ�����ȱ���Ϊ16
bool SetEncryptKey(const unsigned char *pKey, long nLength);
// ������Կ�����Ȳ�����
bool SetEncryptKeyEx(const unsigned char *pKey, long nLength);
// ����
bool SmartEncode(const unsigned char *pInBuffer, long nLength, unsigned char *pOutBuffer, long &outlen);
// ����
bool SmartDecode(const unsigned char *pInBuffer, long nLength, unsigned char *pOutBuffer, long &outlen);

// Base64����
bool SmartBase64Encode(const unsigned char *pInBuffer, long nLength, unsigned char **ppOutBuffer, long &outlen);
// ��Base64����
bool SmartBase64Decode(const unsigned char *pInBuffer, long nLength, unsigned char **ppOutBuffer, long &outlen);

// MD5ժҪ
bool HASHMD5(const unsigned char *pInBuffer, long len, unsigned char **ppOutBuffer, long &outlen);

//===================================================================================================

#endif