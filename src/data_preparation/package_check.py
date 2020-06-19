
import sys
import subprocess
import pkg_resources

# check the package installations
required = {'kaggle'}
installed = {pkg.key for pkg in pkg_resources.working_set}
missing = required - installed

print('The following packages are required:')
print(required)

if missing:
    print('The following package(s) is/are missing:')
    print(missing)
    python = sys.executable
    subprocess.check_call(
        [python, '-m', 'pip', 'install', *missing], stdout=subprocess.DEVNULL)
else:
    print('All packages are successfully installed.')
