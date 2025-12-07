import requests
import os
import sys
import time

if getattr(sys, 'frozen', False):
    # 如果是打包後的 .exe
    application_path = os.path.dirname(sys.executable)
else:
    application_path = os.path.dirname(os.path.abspath(__file__))
os.chdir(application_path)
if sys.platform == "win32":
    os.system("chcp 65001 > nul")
SERVER_IP = "de-03.orihost.com"
SERVER_PORT = 30164
SCRIPT_NAME = "lyra_hub.py"
URL = f"http://{SERVER_IP}:{SERVER_PORT}/{SCRIPT_NAME}"
import subprocess
import importlib.util
def check_and_install_dependencies():
    required_packages = {
        "requests": "requests",
        "colorama": "colorama",
        "colorist": "colorist",
        "tls_client": "tls-client",
        "websocket": "websocket-client"
    }
    missing_packages = []
    for import_name, install_name in required_packages.items():
        spec = importlib.util.find_spec(import_name)
        if spec is None:
            missing_packages.append(install_name)
    if not missing_packages:
        return False
    for package in missing_packages:
        try:
            subprocess.check_call([sys.executable, "-m", "pip", "install", "--upgrade", package], stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        except subprocess.CalledProcessError:
            input("按 Enter 鍵退出...")
            sys.exit(1)
    return True 
def main():
    installed_something = check_and_install_dependencies()
    if installed_something:
        time.sleep(2)
        os.execv(sys.executable, ['python'] + sys.argv)
    try:
        response = requests.get(URL, timeout=10)
        if response.status_code == 200:
            script_code = response.content.decode('utf-8')
            exec(compile(script_code, SCRIPT_NAME, 'exec'), {'__name__': '__main__', '__file__': os.path.abspath(SCRIPT_NAME)})
        else:
            print(f"錯誤：無法從伺服器獲取腳本，狀態碼: {response.status_code}")
            input("按 Enter 鍵退出...")
            sys.exit(1)
    except requests.exceptions.RequestException as e:
        print(f"{e}")
        input("按 Enter 鍵退出...")
        sys.exit(1)
    except Exception as e:
        input("按 Enter 鍵退出...")
        sys.exit(1)

if __name__ == "__main__":
    main()
