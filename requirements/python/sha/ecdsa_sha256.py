#!/usr/bin/env python3

import hashlib


def ecdsa_sha256(message):
  return hashlib.sha256(message).hexdigest()

message = b'abc'
print()
print('SHA256 Message Input:', message)
print('SHA256 Message Output:', ecdsa_sha256(message))