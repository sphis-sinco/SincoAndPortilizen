import re

# Increase for every update to the file
version = 13  # Incremented version

# This script parses a Haxe (.hx) file to extract function and variable names.
def parse_hx_file(file_path):
        try:
                with open(file_path, 'r', encoding='utf-8') as file:
                        content = file.read()
        except FileNotFoundError:
                print(f"File not found: {file_path}")
                return

        functions = []
        variables = []
        package_name = ""  # Blank package if none is found

        # Regex to match Haxe package declaration
        package_pattern = re.compile(r'^\s*package\s+([\w\.]+);', re.MULTILINE)
        # Regex to match Haxe function definitions
        function_pattern = re.compile(r'function\s+(\w+)\s*\(')
        # Regex to match Haxe variable declarations outside of functions
        variable_pattern = re.compile(r'^\s*var\s+(\w+)\s*:', re.MULTILINE)

        # Extract package name
        package_match = package_pattern.search(content)
        if package_match:
                package_name = package_match.group(1)

        # Find all functions
        functions.extend(function_pattern.findall(content))
        # Find all variables outside of functions
        variables.extend(variable_pattern.findall(content))

        # Create the output strings
        function_list = "# Functions\n" + "\n".join([f"- `{func}` - TBA" for func in functions])
        variable_list = ""
        if variables:
                variable_list = "# Variables\n" + "\n".join([f"- `{var}` - TBA" for var in variables])

        return package_name, function_list, variable_list


if __name__ == "__main__":
        hx_file_path = input("Enter the path to the .hx file: ").strip()
        result = parse_hx_file(hx_file_path)
        file = hx_file_path.split('\\')[-1]

        if result:
                package_name, function_list, variable_list = result
                
                dot = '.' if '' != package_name else ''
                if dot == '.':
                        print(f"Package: {package_name}\n")

                print(function_list)

                if variable_list:  # Only print if there are variables
                        print("\n" + variable_list)

                print(f"\n<!-- {package_name}{dot}{file} markdown file generated (mostly) by QuickMarkdown.py v{version} -->")