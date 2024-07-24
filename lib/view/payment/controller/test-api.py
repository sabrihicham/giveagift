from requests import post

url = "http://127.0.0.1:5000/send_document"

files = {'file': open('/Users/hicham/Downloads/3.pdf', 'rb')}

data =  {
    "id": "123456",
    "name": "Alice",
    "last_name": "Doe",
    "role": "directeur",
    "email": "alice@example.com",
    "creation_date": "123-456-7890",
    "otp": "123456"
}

headers = {
    'Signature': '((11621635919037499856532297467192544342571362191308729647402180175529700142355, 25163720896950813020130105105865835631045014248139095755803533149268938399989), 4725844272744228453892438996975414023060964778078317909181931000069193096419069194962175231100459100958955947355495999974233890358631905015426288935710717)'
}

response = post(url, headers=headers,files=files, data=data, auth=('admin', 'password'),)

print(response.status_code)
print(response.text)