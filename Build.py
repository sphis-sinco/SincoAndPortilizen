import subprocess

running = True

while running:
        exit_or_compile = input('Would you like to exit (E) or compile (C)?\n> ')

        if (exit_or_compile.lower() == 'e'):
                running = False
                break

        # Execute a simple bash command
        result = subprocess.run(['lime', 'test', 'hl', '-debug'], capture_output=True, text=True)

        # Check if the command was successful
        if result.returncode == 0:
                # Print the output of the command
                print(result.stdout)
        else:
                # Print the error message
                print(result.stderr)