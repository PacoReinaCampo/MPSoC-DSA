#!/usr/bin/env python3

import hashlib


def ecdsa_sha512(message):
  return hashlib.sha512(message).hexdigest()

message = b'abc'
print()
print('SHA512 Message Input:', message)
print('SHA512 Message Output:', ecdsa_sha512(message))