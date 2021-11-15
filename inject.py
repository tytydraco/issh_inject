import subprocess
import requests
import os

ISSH_DIR = '/sdcard/.issh'
ISSH_PATH = f'{ISSH_DIR}/issh'
ISSH_RAW_URL = 'https://raw.githubusercontent.com/tytydraco/issh/main/issh'
ISSH_CACHE_PATH = '.issh.sh'

def dbg(msg):
    print(f'\033[36m * {msg}\033[0m')

# Run an shell command
def run(command):
    return str(subprocess
               .run(command, shell=True, capture_output=True, text=True)
               .stdout.strip())

# Make the issh files directory if it does not yet exist
def prepare_env():
    dbg('Preparing the device environment...')
    run(f'adb shell "mkdir -p {ISSH_DIR}"')

# Push latest issh script to the device
def fetch_issh():
    dbg('Fetching the lastet issh script...')

    try:
        contents = requests.get(ISSH_RAW_URL).content

        with open(ISSH_CACHE_PATH, 'wb') as f:
            f.write(contents)
    except requests.exceptions.RequestException:
        dbg('Unable to fetch script. Using cached...')
    
    if not os.path.exists(ISSH_CACHE_PATH):
        dbg('Cached script unavailabe. Bail!')
        exit(1)
    
    dbg('Pushing issh to the device...')
    run(f'adb push "{ISSH_CACHE_PATH}" "{ISSH_PATH}"')

def bootstrap():
    dbg('Killing any existing issh processes...')
    run('adb shell "pkill toybox"')

    dbg('Bootstrapping issh daemon...')
    run(f'adb shell "nice -n -20 -- sh {ISSH_PATH} -dl"')

prepare_env()
fetch_issh()
bootstrap()
dbg('Done.')
