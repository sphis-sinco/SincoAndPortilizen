import re
import os

# Increase for every update to the file
version = 37  # Incremented version

# Add your changes to this string here
version_changes = """v37 Updated "Folder markdown file" to include the actual folder path"""

# This script parses a Haxe (.hx) file to extract function and variable names and their references.
def parse_hx_file(file_path, folder_mode):
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

        header = '##' if folder_mode else '#'

        # Create the output strings
        function_list = ''
        if functions:  # Only generate the function list if functions are found
                function_list = f'{header} Functions\n' + '\n'.join(
                        [f'- `{func}` - TBA' for func in functions]
                )

        variable_list = ''
        if variables:
                variable_list = f'{header} Variables\n' + '\n'.join(
                        [f'- `{var}` - TBA' for var in variables]
                )

        return package_name, function_list, variable_list


def process_folder(folder_path):
        # Only iterate through files in the specified folder (ignore subfolders)
        for file in os.listdir(folder_path):
                file_path = os.path.join(folder_path, file)
                if os.path.isfile(file_path) and file.endswith('.hx'):  # Check for Haxe files
                        result = parse_hx_file(file_path, True)
                        if result:
                                package_name, function_list, variable_list = result

                                # Only include files with functions or variables
                                if function_list or variable_list:
                                        print(f'\n# {file}\n')  # Markdown header 1 for the file name

                                        if function_list:  # Only print if there are functions
                                                print(function_list)

                                        if variable_list:  # Only print if there are variables
                                                print('\n' + variable_list)

        print_folder_path = folder_path.split('\\')[-1]
        # Add a summary comment at the end of folder processing
        print(f"\n<!-- {print_folder_path} markdown file generated (mostly) by QuickMarkdown.py v{version} -->")


if __name__ == '__main__':
        mode = input('Enter "file" to process a single file or "folder" to process a folder: ').strip().lower()
        if mode == 'file':
                hx_file_path = input('Enter the path to the .hx file: ').strip()
                result = parse_hx_file(hx_file_path, False)
                file = hx_file_path.split('\\')[-1]

                if result:
                        package_name, function_list, variable_list = result

                        if package_name:
                                print(f'# {file}\n')  # Markdown header 1 for the file name

                        if function_list:  # Only print if there are functions
                                print(function_list)

                        if variable_list:  # Only print if there are variables
                                print('\n' + variable_list)

                        print(f'\n<!-- {package_name}.{file} markdown file generated (mostly) by QuickMarkdown.py v{version} -->')

        elif mode == 'folder':
                folder_path = input('Enter the path to the folder: ').strip()
                process_folder(folder_path)

        # Print version changes
        print(f"<!-- Version Changes: {version_changes} -->")