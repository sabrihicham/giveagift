import hashlib
import os
import binascii
import random
from functools import cache

import time


# Curve parameters
p = 2**255 - 19
a = -1
d = -121665/121666
d = (-121665 * pow(121666, -1, p)) % p

def random_curve_base_point():
    # Randomly generate the x-coordinate
    x = random.randint(0, p - 1)

    # Calculate the y-coordinate
    y = pow(x**3 + 486662*x**2 + x, (p + 3) // 8, p)

    # Return the base point
    return (x, y)

# Curve generator
# Gx = 15112221349535400772501151409588531511454012693041857206046113283949847762202
# Gy = 46316835694926478169428394003475163141307993866256225615783033603165251855960

# Base point on Curve25519
u = 9

# Gy = (u-1)/(u+1)
Gy = ( (u-1) * pow(u+1, -1, p) ) % p
Gx = 15112221349535400772501151409588531511454012693041857206046113283949847762202

G = (Gx, Gy)

assert (a*Gx*Gx + Gy*Gy) % p == (1 + d*Gx*Gx*Gy*Gy) % p

# Hash function
def hash_message(msg):
    return hashlib.sha512(msg).digest()

# Key generation
def generate_key_pair():
    # Generate a random private key
    # secret_key = int.from_bytes(hashlib.sha512(b'secret').digest(), 'little')
    secret_key = int.from_bytes(random.randbytes(64), 'little')
    secret_key = 97655886817525644841001748842989591847874708828217123903343932609640165809792
    
    # Calculate the corresponding public key
    public_key = scalar_multiply(secret_key, G)

    return secret_key, public_key

# Scalar multiplication
def scalar_multiply(k, P):
    Q = (0, 1)  # Neutral element
    while k > 0:
        if k % 2 == 1:
            Q = point_add(Q, P)
        P = point_double(P)
        k //= 2
    return Q

# Point addition
def point_add(P1, P2):
    x1, y1 = P1
    x2, y2 = P2
    x3 = (((x1*y2 + x2*y1) % p) * pow(1 + d*x1*x2*y1*y2, -1, p)) % p
    y3 = ((( y1*y2 - a*x1*x2) % p) * pow(1 - d*x1*x2*y1*y2, -1, p)) % p

    assert (a*x3*x3 + y3*y3) % p == (1 + d*x3*x3*y3*y3) % p

    return x3, y3

# Point doubling
def point_double(P):
    return point_add(P, P)

# prompt: int to bytes from scratch

def int_to_bytes(n):
  """
  Converts an integer to a byte array.

  Args:
    n: The integer to convert.

  Returns:
    A byte array representing the integer.
  """

  # Calculate the number of bytes required to represent the integer.
  num_bytes = (n.bit_length() + 7) // 8

  # Create a byte array of the appropriate size.
  byte_array = bytearray(num_bytes)

  # Iterate over the bytes of the integer, starting from the least significant byte.
  for i in range(num_bytes):
    # Extract the least significant byte of the integer.
    byte = n & 0xFF

    # Store the byte in the byte array.
    byte_array[i] = byte

    # Shift the integer right by 8 bits.
    n >>= 8

  # Return the byte array.
  return byte_array

# Hash function
def H(message, R, public_key, p, metadata):
    binary_metadata = int_to_bytes(len(metadata)) + b''.join(v.encode('ascii') if type(v) is not bytes else v for k, v in metadata.items())
    print("Binary Metadata: " + str(binary_metadata))
    return int.from_bytes(hashlib.sha512(int_to_bytes(R[0]) + int_to_bytes(public_key[0]) + message + binary_metadata).digest(), 'little') % p

# EdDSA sign
def eddsa_sign(message, public_key, secret_key, metadata):
    # hashed_msg = int.from_bytes(hashlib.sha512(message).digest(), 'little')
    r = int(hashlib.sha512(hashlib.sha512(int_to_bytes(secret_key)).digest() + message).hexdigest(), 16) % p
    # r = H(int_to_bytes(secret_key) + message) % p
    R = scalar_multiply(r, G)
    h = H(message, R, public_key, p, metadata)
    print("Sign Hash: " + str(h))
    S = (r + h * secret_key)
    return R, S

# EdDSA verify signature
def eddsa_verify(message, public_key, signature, metadata):
    R, S = signature
    h = H(message, R, public_key, p, metadata)
    left_side = scalar_multiply(S, G)
    right_side = point_add(R, scalar_multiply(h, public_key))
    print("Left: " + str(left_side))
    print("Right: " + str(right_side))
    return left_side == right_side


if __name__ == '__main__':
    # Example usage
    secret_key, public_key = generate_key_pair()

    print("Generated Keypair:")
    print(f"Key Length: {len(int_to_bytes(secret_key))}")
    print(f"Secret Key: {secret_key}")

    print(f"Key Length: {len(int_to_bytes(public_key[0]))}")
    print(f"Public Key: {public_key}")

    file_path = '/Users/hicham/Downloads/3.pdf'
    
    with open(file_path, 'rb') as file:
        file_bytes = file.read()

    metadata = {
        "id": "123456",
        "name": "Alice",
        "last_name": "Doe",
        "role": "directeur",
        "email": "alice@example.com",
        "creation_date": "123-456-7890",
        "otp": "123456"
    }

    print(f"Message: {file_bytes}")
    print(f"Metadata: {metadata}")
    
    start_time = time.time()

    signature = eddsa_sign(file_bytes, public_key, secret_key, metadata)
    
    print("--- Eddsa Sign Tooks :%s ms ---" % ((time.time() - start_time) * 1000))

    print("Signature:")
    print(f"R: {signature[0]}")
    print(f"S: {signature[1]}")
    
    start_time = time.time()
    
    is_valid = eddsa_verify(file_bytes, public_key, signature, metadata)
    
    print("--- Eddsa Verify Tooks :%s ms ---" % ((time.time() - start_time) * 1000))
    
    print(f"Signature valid: {is_valid}")