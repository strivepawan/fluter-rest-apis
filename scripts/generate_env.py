import re

input_path = "lib/env_options.dart"
output_path = ".env"

pattern = re.compile(r'static const String (\w+)\s*=\s*"([^"]+)"')

with open(input_path, "r") as fin:
    dart_code = fin.read()

matches = pattern.findall(dart_code)

with open(output_path, "w") as fout:
    for key, value in matches:
        fout.write(f"{key}={value}\n")

print("✅ .env file generated with camelCase keys")
