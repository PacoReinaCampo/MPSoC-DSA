#!/usr/bin/env python3

import hashlib


def peripheral_dsa_sha512(message):
  return hashlib.sha512(message).hexdigest()

message = b'abc'
print()
print('SHA512 Message Input:', message)
print('SHA512 Message Output:', peripheral_dsa_sha512(message))