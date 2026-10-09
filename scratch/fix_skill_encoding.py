import os

file_path = r'C:\Users\oksar\.gemini\config\skills\flutter-engineering\SKILL.md'

with open(file_path, 'rb') as f:
    content_bytes = f.read()

# We need to find where the UTF-16 payload starts.
# Powershell '>>' might have added a BOM, or just raw UTF-16 bytes.
# Let's search for the last known good part.
good_str = '## 15. Mingda Presentation Components'
idx = content_bytes.find(good_str.encode('utf-8'))

if idx != -1:
    # Find the end of section 15
    end_of_15 = content_bytes.find(b'## 16.', idx)
    if end_of_15 == -1:
        # We might have some UTF-16 bytes before 16. GetX
        # Let's search for the pattern of UTF-16 encoded '\n## 16.' -> \n\x00#\x00#\x00 \x001\x006\x00.\x00
        utf16_pattern = b'\n\x00#\x00#\x00 \x001\x006\x00.\x00'
        end_of_15 = content_bytes.find(utf16_pattern, idx)
        if end_of_15 == -1:
             # Just look for the first null byte after section 15
             null_idx = content_bytes.find(b'\x00', idx)
             if null_idx != -1:
                 # Truncate before the null byte, backtracking to the nearest newline
                 end_of_15 = content_bytes.rfind(b'\n', idx, null_idx)

    if end_of_15 != -1:
        clean_content = content_bytes[:end_of_15].decode('utf-8', errors='ignore')
    else:
        # If we can't find it, just decode ignoring errors and cut at ## 16.
        decoded = content_bytes.decode('utf-8', errors='ignore')
        cut_idx = decoded.find('## 16.')
        if cut_idx != -1:
            clean_content = decoded[:cut_idx]
        else:
            clean_content = decoded

    # Remove trailing weird chars
    clean_content = clean_content.rstrip('\x00\r\n \t\ufffd')
    clean_content += '\n\n'

    # Now append the new text properly
    new_text = """## 16. GetX to BLoC Migration & UI Revert Guardrails (Hard Invariants)

### A. UI Reverts Must Never Revert State Architecture
- **Fakta:** Saat melakukan *revert* atau membatalkan perubahan UI di tengah/setelah migrasi arsitektur (misal GetX ke BLoC), sangat dilarang mengembalikan kode *state management* lawas (seperti `SummaryVM`, `Obx`, `Get.to`, `RxBool`).
- **Aturan Baku:** *Revert* HANYA boleh diterapkan pada struktur *Widget* visual (padding, warna, susunan layout). Logic reaktif wajib di-wiring ulang secara manual ke *architecture* baru (misal `context.read<Bloc>().add(...)`).

### B. Total Purge Aturan Bebas GetX (Zero Tolerance)
- **Fakta:** Sisa-sisa GetX sekecil apapun akan memicu *crash* jika *root* aplikasi sudah diubah dari `GetMaterialApp` ke `MaterialApp.router`.
- **Daftar Pembersihan Wajib:**
  1. Hapus SEMUA `.obs`, `RxBool`, `RxInt` di seluruh *models* (bahkan di file *orphaned* yang tampaknya tidak dipakai).
  2. Hapus SEMUA *wrapper* `Obx(() => ...)` di seluruh proyek.
  3. Ganti `Get.toNamed(...)` / `Get.to(...)` menjadi `context.push(...)` (GoRouter).
  4. Ganti `Get.back()` menjadi `context.pop()`. (Memanggil `Get.back()` tanpa `GetMaterialApp` akan memicu *Exception caught by gesture*).
  5. Ganti `Get.snackbar(...)` dengan `ScaffoldMessenger.of(context).showSnackBar(...)`.
  6. Ganti ekstensi widget bawaan GetX (seperti `.paddingOnly(...)`) dengan standar Flutter `Padding(padding: EdgeInsets.only(...))` atau buat *extension* lokal independen.

### C. Regex/Script Mismatch pada Data UI (Tabs & Builders)
- **Fakta:** Menggunakan *regex* atau *script* untuk merombak struktur UI Tabs sering kali meleset jika tidak mengecek *keys* asli yang digunakan oleh *builder*.
- **Aturan Baku:** Sebelum menyuntikkan *array/map* UI (seperti daftar Tabs), SELALU pastikan *keys* (`title` vs `name`, `collection` vs `value`) dan isinya (`warehouse_orders` vs `orders`) **EXACT MATCH** dengan kondisi `if/else` atau `switch` pada kode *rendering* di bawahnya. Kegagalan melakukan ini akan menyebabkan teks UI menghilang atau *card* yang salah dirender (masuk *else block* nyasar).
"""
    
    with open(file_path, 'w', encoding='utf-8') as f:
        f.write(clean_content + new_text)
    print("Fixed successfully!")
