import re

# Increase for every update to the file
version = 8  # Incremented version

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

        # Regex to match Haxe function definitions
        function_pattern = re.compile(r'function\s+(\w+)\s*\(')
        # Regex to match Haxe variable declarations outside of functions
        variable_pattern = re.compile(r'^\s*var\s+(\w+)\s*:', re.MULTILINE)

        # Find all functions
        functions.extend(function_pattern.findall(content))
        # Find all variables outside of functions
        variables.extend(variable_pattern.findall(content))

        # Create the output strings
        function_list = "# Functions\n" + "\n".join([f"- `{func}` - TBA" for func in functions])
        variable_list = ""
        if variables:
                variable_list = "# Variables\n" + "\n".join([f"- `{var}` - TBA" for var in variables])

        return function_list, variable_list


if __name__ == "__main__":
        hx_file_path = input("Enter the path to the .hx file: ").strip()
        result = parse_hx_file(hx_file_path)

        if result:
                function_list, variable_list = result
                print("\n" + function_list)
                if variable_list:  # Only print if there are variables
                        print("\n" + variable_list)
                print(f"\n<!-- Generated (mostly) by QuickMarkdown.py v{version} -->")