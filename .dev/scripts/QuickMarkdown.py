import re

# Increase for every update to the file
version = 28  # Incremented version

# Add your changes to this string here
version_changes = """v28: Removed the printing of function references and variable references."""

# This script parses a Haxe (.hx) file to extract function and variable names and their references.
def parse_hx_file(file_path):
        try:
                with open(file_path, 'r', encoding='utf-8') as file:
                        content = file.read()
        except FileNotFoundError:
                print(f'File not found: {file_path}')
                return

        functions = []
        variables = []
        package_name = ''  # Blank package if none is found

        # Regex to match Haxe package declaration
        package_pattern = re.compile(r'^\s*package\s+([\w\.]+);', re.MULTILINE)
        # Regex to match Haxe function definitions (keyword "function")
        function_pattern = re.compile(r'\bfunction\s+(\w+)\s*\(')
        # Regex to match Haxe variable declarations (keyword "var" outside functions)
        variable_pattern = re.compile(r'^\s*(?!.*function\b).*?\bvar\s+(\w+)\s*:', re.MULTILINE)

        # Extract package name
        package_match = package_pattern.search(content)
        if package_match:
                package_name = package_match.group(1)

        # Find all functions
        functions.extend(function_pattern.findall(content))

        # Filter out unwanted functions
        ignored_functions = {'new', 'create', 'postCreate', 'update'}
        functions = [func for func in functions if func not in ignored_functions]

        # Find all variables outside functions
        variables.extend(variable_pattern.findall(content))

        # Create the output strings
        function_list = ''
        if functions:  # Only generate the function list if functions are found
                function_list = '# Functions\n' + '\n'.join(
                        [f'- `{func}` - TBA' for func in functions]
                )

        variable_list = ''
        if variables:
                variable_list = '# Variables\n' + '\n'.join(
                        [f'- `{var}` - TBA' for var in variables]
                )

        return package_name, function_list, variable_list


if __name__ == '__main__':
        hx_file_path = input('Enter the path to the .hx file: ').strip()
        result = parse_hx_file(hx_file_path)
        file = hx_file_path.split('\\')[-1]

        if result:
                package_name, function_list, variable_list = result
                
                dot = '.' if '' != package_name else ''
                if dot == '.':
                        print(f'Package: {package_name}\n')

                if function_list:  # Only print if there are functions
                        print(function_list)

                if variable_list:  # Only print if there are variables
                        print('\n' + variable_list)

                print(f'\n<!-- {package_name}{dot}{file} markdown file generated (mostly) by QuickMarkdown.py v{version} -->')

        # Print version changes
        print(f"<!-- Version Changes: {version_changes} -->")