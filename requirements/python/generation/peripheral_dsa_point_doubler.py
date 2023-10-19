#!/usr/bin/env python3

import collections
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

def peripheral_dsa_inverter(k, p):
  """Returns the inverse of k modulo p.
  This function returns the only integer x such that (x * k) % p == 1.
  k must be non-zero and p must be a prime.
  """
  if k == 0:
    raise ZeroDivisionError('division by zero')

  if k < 0:
    # k ** -1 = p - (-k) ** -1  (mod p)
    return p - peripheral_dsa_inverter(-k, p)

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

def peripheral_dsa_point_adder(point1, point2):
  """Returns the result of point1 + point2 according to the group law."""

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
    m = (3 * x1 * x1 + curve.a) * peripheral_dsa_inverter(2 * y1, curve.p)
  else:
    # This is the case point1 != point2.
    m = (y1 - y2) * peripheral_dsa_inverter(x1 - x2, curve.p)

  x3 = m * m - x1 - x2
  y3 = y1 + m * (x3 - x1)
  result = (x3 % curve.p, -y3 % curve.p)

  return result


print()

x1 = random.randrange(1, curve.n)
y1 = random.randrange(1, curve.n)

point1 = x1, y1

print('Doubler Input Point: (0x{:x}, 0x{:x})'.format(*point1))

x, y = peripheral_dsa_point_adder(point1, point1)

point_output = x, y

print('Doubler Output Point: (0x{:x}, 0x{:x})'.format(*point_output))
