# Curve25519 parameters
q = 2**255 - 19
A = 2**252 + 27742317777372353535851937790883648493
B = 256


def point_add(P1, P2):
    x1, y1 = P1
    x2, y2 = P2
    x3 = ((x1*y2 + x2*y1) * pow(1 + A*x1*x2*y1*y2, -1, q)) % q
    y3 = ((y1*y2 - x1*x2) * pow(1 - A*x1*x2*y1*y2, -1, q)) % q
    return x3, y3

def scalar_mult(k, P):
    Q = (0, 1)
    while k > 0:
        if k & 1:
            Q = point_add(Q, P)
        P = point_add(P, P)
        k >>= 1
    return Q

# Base point on Curve25519
BASE_POINT = (9, 14781619447589544791020593568409986887264606134616475288964881837755586237401)

import hashlib
def generate_keypair():
    secret_key = int.from_bytes(hashlib.sha512(b'secret').digest(), 'little') % q
    public_key = scalar_mult(secret_key, BASE_POINT)
    return secret_key, public_key

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

def sign_message(message, public_key, secret_key):
    # Deterministically generate a secret integer r = hash(hash(privKey) + msg) mod q (this is a bit simplified)
    r = int.from_bytes(hashlib.sha512(int_to_bytes(secret_key) + message).digest(), 'little') % q

    # Calculate the public key point behind r by multiplying it by the curve generator: R = r * G
    R = scalar_mult(r, BASE_POINT)
    
    # Calculate h = hash(R + pubKey + msg) mod q
    h = int.from_bytes(hashlib.sha512(int_to_bytes(R[0]) + int_to_bytes(public_key[0]) + message).digest(), 'little') % q

    # Calculate s = (r + h * privKey) mod q
    s = (r + h * secret_key) % q

    # Return the signature { R, s }
    return R, s

def verify_signature(message, public_key, signature):
    R, s = signature

    # Calculate h = hash(R + pubKey + msg) mod q
    h = int.from_bytes(hashlib.sha512(int_to_bytes(R[0]) + int_to_bytes(public_key[0]) + message).digest(), 'little') % q

    # Calculate P1 = s * G
    P1 = scalar_mult(s, BASE_POINT)

    # Calculate P2 = R + h * pubKey
    P2 = point_add(R, scalar_mult(h, public_key))
    
    print(f"P1: {P1}")
    print(f"P2: {P2}")

    # Return P1 == P2
    return P1 == P2

# Example usage
secret_key, public_key = generate_keypair()
print("Generated Keypair:")
print(f"Key Length: {len(int_to_bytes(secret_key))}")
print(f"Secret Key: {secret_key}")
print(f"Key Length: {len(int_to_bytes(public_key[0]))}")
print(f"Public Key: {public_key}")
message = b"Hello, EdDSA!"
signature = sign_message(message, public_key, secret_key)
print(f"Message: {message}")
print("Signature:")
print(f"R: {signature[0]}")
print(f"S: {signature[1]}")
is_valid = verify_signature(message, public_key, signature)
print(f"Signature valid: {is_valid}")