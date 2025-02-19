from queue import Full
import subprocess

running = True
dashD_not_required = ['debug' 'watch']

while running:
        compile_args = ['lime', 'test']
        exit_or_compile = input('Would you like to exit (E) or compile (C)?\n> ')

        if (exit_or_compile.lower() != 'c'):
                running = False
                break
        else:
                target_platform = input('What is your target platform?\n> ')
                
                if (target_platform == ''):
                        target_platform = 'hl'

                compile_args.append(target_platform)

                build_flags = input('What are your build flags (seperate with a .)?\n> ')
                build_flags_array = build_flags.split('.')

                i = 0
                while i < build_flags_array.__len__():

                        prefix = '-D'
                        item = build_flags_array[i]

                        if not item == '':
                                # this doesnt work for some reason.
                                if dashD_not_required.__contains__(item) == True:
                                        prefix = '-'
                                        print(item)

                                compile_args.append(f'{prefix}{item}')
                        i = i + 1

                print(f'Building for {target_platform} with the build flags: {build_flags_array}')
        
        print(compile_args.__str__())

        # Execute a simple bash command
        result = subprocess.run(compile_args, capture_output=True, text=True)

        # Check if the command was successful
        if result.returncode == 0:
                # Print the output of the command
                print(result.stdout)
        else:
                # Print the error message
                print(result.stderr)