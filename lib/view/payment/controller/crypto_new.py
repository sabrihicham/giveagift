import hashlib
import os
import binascii

# Curve parameters
q = 2**255 - 19
L = 2**252 + 27742317777372353535851937790883648493

# Curve generator
Gx = 15112221349535400772501151409588531511454012693041857206046113283949847762202
Gy = 46316835694926478169428394003475163141307993866256225615783033603165251855960

G = (Gx, Gy)

# Hash function
def hash_message(msg):
    return hashlib.sha512(msg).digest()

# Key generation
def generate_key_pair():
    # Generate a random private key
    privKey = binascii.hexlify(os.urandom(32)).decode()
    
    # Calculate the corresponding public key
    pubKey = scalar_multiply(int(privKey[:16], 16), G)

    return privKey, pubKey

# Scalar multiplication
def scalar_multiply(k, P):
    x, y = P

    # Double-and-add algorithm
    Q = None
    for i in range(256):
        if k & (1 << i):
            if Q is None:
                Q = (x, y)
            else:
                Q = point_add(Q, (x, y))
        x, y = point_double(x, y)

    return Q

# Point addition
def point_add(P, Q):
    Px, Py = P
    Qx, Qy = Q

    if P == Q:
        return point_double(Px, Py)

    if Px == Qx:
        return None

    m = ((Py - Qy) * mod_inverse(Px - Qx, q)) % q
    Rx = (m**2 - Px - Qx) % q
    Ry = (m * (Px - Rx) - Py) % q

    return Rx, Ry

# Point doubling
def point_double(Px, Py):
    m = ((3 * Px**2) * mod_inverse(2 * Py, q)) % q
    Rx = (m**2 - 2 * Px) % q
    Ry = (m * (Px - Rx) - Py) % q

    return Rx, Ry

# Modular inverse
def mod_inverse(a, m):
    return pow(a, -1, m)

# EdDSA sign
def eddsa_sign(msg, privKey):
    pubKey = scalar_multiply(int(privKey , 16), G)

    r = int(hashlib.sha512(privKey[16:].encode() + msg).hexdigest(), 16) % q
    R = scalar_multiply(r, G)
    
    # Encode R as 32 bytes
    encodedR = (R[0].to_bytes(32, byteorder='little'), R[1].to_bytes(32, byteorder='little'))

    h = int(hashlib.sha512(encodedR[0] + pubKey[0].to_bytes(32, 'little') + msg).hexdigest(), 16) % q

    s = (r + h * int(privKey[:16], 16)) % L
    
    encodedS = s.to_bytes(32, byteorder='little')

    return encodedR, encodedS

# EdDSA verify signature
def eddsa_verify(msg, pubKey, signature):
    encodedR, encodedS = signature  # Get the encoded signature components
    
    # Decode R and s from bytes
    R = (int.from_bytes(encodedR[0], byteorder='little'), int.from_bytes(encodedR[1], byteorder='little'))
    s = int.from_bytes(encodedS, byteorder='little')
    
    # Check if s is within the valid range
    if s >= L:
        return False

    h = int(hashlib.sha512(R[0].to_bytes(32, 'little') + pubKey[0].to_bytes(32, 'little') + msg).hexdigest(), 16) % q

    P1 = scalar_multiply(s, G)
    P2 = point_add(R, scalar_multiply(h, pubKey))

    return P1 == P2

# Example usage
msg = b"Hello, world!"
privKey, pubKey = generate_key_pair()
signature = eddsa_sign(msg, privKey)
valid = eddsa_verify(msg, pubKey, signature)

print("Private Key:", privKey)
print("Public Key:", pubKey)
print("Signature:")
print(f"R0: {signature[0][0].hex()}")
print(f"R1: {signature[0][1].hex()}")
print(f"S: {signature[1].hex()}")
print("Valid:", valid)