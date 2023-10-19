#!/usr/bin/env python3

import collections
import hashlib
import random

EllipticCurve = collections.namedtuple('EllipticCurve', 'name p a b g n h')

curve = EllipticCurve(
  'brainpool512r1',
  # Field characteristic.
  p=0xAADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA703308717D4D9B009BC66842AECDA12AE6A380E62881FF2F2D82C68528AA6056583A48F3,
  # Curve coefficients.
  a=0x7830A3318B603B89E2327145AC234CC594CBDD8D3DF91610A83441CAEA9863BC2DED5D5AA8253AA10A2EF1C98B9AC8B57F1117A72BF2C7B9E7C1AC4D77FC94CA,
  b=0x3DF91610A83441CAEA9863BC2DED5D5AA8253AA10A2EF1C98B9AC8B57F1117A72BF2C7B9E7C1AC4D77FC94CADC083E67984050B75EBAE5DD2809BD638016F723,
  # Base point.
  g=(0x81AEE4BDD82ED9645A21322E9C4C6A9385ED9F70B5D916C1B43B62EEF4D0098EFF3B1F78E2D0D48D50D1687B93B97D5F7C6D5047406A5E688B352209BCB9F822,
     0x7DDE385D566332ECC0EABFA9CF7822FDF209F70024A57B1AA000C55B881F8111B2DCDE494A5F485E5BCA4BD88A2763AED1CA2B2FA8F0540678CD1E0F3AD80892),
  # Subgroup order.
  n=0xAADD9DB8DBE9C48B3FD4E6AE33C9FC07CB308DB3B3C9D20ED6639CCA70330870553E5C414CA92619418661197FAC10471DB1D381085DDADDB58796829CA90069,
  # Subgroup cofactor.
  h=1,
)


# Modular arithmetic ##########################################################

def kcdsa_inverter(k, p):
  """Returns the inverse of k modulo p.
  This function returns the only integer x such that (x * k) % p == 1.
  k must be non-zero and p must be a prime.
  """
  if k == 0:
    raise ZeroDivisionError('division by zero')

  if k < 0:
    # k ** -1 = p - (-k) ** -1  (mod p)
    return p - kcdsa_inverter(-k, p)

  # Extended Euclidean algorithm.
  s, old_s = 0, 1
  t, old_t = 1, 0
  r, old_r = p, k

  while r != 0:
    quotient = old_r // r
    old_r, r = r, old_r - quotient * r
    old_s, s = s, old_s - quotient * s
    old_t, t = t, old_t - quotient * t

  gcd, x, y = old_r, old_s, old_t

  assert gcd == 1
  assert (k * x) % p == 1

  return x % p


# Functions that work on curve points #########################################

def kcdsa_curve_point(point):
  """Returns True if the given point lies on the elliptic curve."""
  if point is None:
    # None represents the point at infinity.
    return True

  x, y = point

  return (y * y - x * x * x - curve.a * x - curve.b) % curve.p == 0


def kcdsa_negative_point(point):
  """Returns -point."""
  assert kcdsa_curve_point(point)

  if point is None:
    # -0 = 0
    return None

  x, y = point
  result = (x, -y % curve.p)

  assert kcdsa_curve_point(result)

  return result


def kcdsa_point_adder(point1, point2):
  """Returns the result of point1 + point2 according to the group law."""
  assert kcdsa_curve_point(point1)
  assert kcdsa_curve_point(point2)

  if point1 is None:
    # 0 + point2 = point2
    return point2
  if point2 is None:
    # point1 + 0 = point1
    return point1

  x1, y1 = point1
  x2, y2 = point2

  if x1 == x2 and y1 != y2:
    # point1 + (-point1) = 0
    return None

  if x1 == x2:
    # This is the case point1 == point2.
    m = (3 * x1 * x1 + curve.a) * kcdsa_inverter(2 * y1, curve.p)
  else:
    # This is the case point1 != point2.
    m = (y1 - y2) * kcdsa_inverter(x1 - x2, curve.p)

  x3 = m * m - x1 - x2
  y3 = y1 + m * (x3 - x1)
  result = (x3 % curve.p, -y3 % curve.p)

  assert kcdsa_curve_point(result)

  return result


def kcdsa_point_generator(k, point):
  """Returns k * point computed using the double and kcdsa_point_adder algorithm."""
  assert kcdsa_curve_point(point)

  if k % curve.n == 0 or point is None:
    return None

  if k < 0:
    # k * point = -k * (-point)
    return kcdsa_point_generator(-k, kcdsa_negative_point(point))

  result = None
  addend = point

  while k:
    if k & 1:
      # Add.
      result = kcdsa_point_adder(result, addend)

    # Double.
    addend = kcdsa_point_adder(addend, addend)

    k >>= 1

  assert kcdsa_curve_point(result)

  return result


# Key Pair generation and KCDSA ###############################################

def kcdsa_keypair():
  """Generates a random private-public key pair."""
  private_key = random.randrange(1, curve.n)
  inverse_private_key = kcdsa_inverter(private_key, curve.n)
  public_key = kcdsa_point_generator(inverse_private_key, curve.g)

  return private_key, public_key


def kcdsa_sha512(message):
  """Returns the hash of the message."""
  message_hash = hashlib.sha512(message).digest()
  e = int.from_bytes(message_hash, 'big')

  return e


def peripheral_dsa_peripheral_dsa_kcdsa_sign(private_key, message):

  r = 0
  s = 0

  while not r or not s:
    k = random.randrange(1, curve.n)

    x, y = kcdsa_point_generator(k, curve.g)

    r = kcdsa_sha512(str(x).encode('ASCII'))
    z = kcdsa_sha512(message)
    w = r ^ z

    if (w >= curve.n):
      w = w - curve.n

    s = (private_key * (k - w)) % curve.n

  return (r, s)


def peripheral_dsa_peripheral_dsa_kcdsa_verify(public_key, message, signature):
  r, s = signature

  z = kcdsa_sha512(message)
  w = r ^ z
    
  if (w >= curve.n):
    w = w - curve.n

  x, y = kcdsa_point_adder(kcdsa_point_generator(w, curve.g), kcdsa_point_generator(s, public_key))

  v = kcdsa_sha512(str(x).encode('ASCII'))

  if (v % curve.n) == (r % curve.n):
    return 'signature matches'
  else:
    return 'invalid signature'


print()
print('Curve:', curve.name)

private, public = kcdsa_keypair()
print("Private key:", hex(private))
print("Public key: (0x{:x}, 0x{:x})".format(*public))

msg = b'abc'
signature = peripheral_dsa_peripheral_dsa_kcdsa_sign(private, msg)

print()
print('Message:', msg)
print('Signature: (0x{:x}, 0x{:x})'.format(*signature))
print('Verification:', peripheral_dsa_peripheral_dsa_kcdsa_verify(public, msg, signature))

msg = b'cba'
print()
print('Message:', msg)
print('Verification:', peripheral_dsa_peripheral_dsa_kcdsa_verify(public, msg, signature))

private, public = kcdsa_keypair()

msg = b'abc'
print()
print('Message:', msg)
print("Public key: (0x{:x}, 0x{:x})".format(*public))
print('Verification:', peripheral_dsa_peripheral_dsa_kcdsa_verify(public, msg, signature))
