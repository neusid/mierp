import sys

path = r'C:\Users\oksar\.gemini\config\skills\product-design\SKILL.md'
with open(path, 'r', encoding='utf-8') as f:
    content = f.read()

target1 = """### C. Mingda Unified Corporate Color Palette (Anti-Rainbow Invariant)
- **DILARANG BANYAK WARNA (Anti-Rainbow):**"""
replacement1 = """### C. Mingda Unified Corporate Color Palette (Anti-Rainbow Invariant)
- **Premium Dark over Electric Blue:** Jangan gunakan warna biru standar (seperti *Electric Blue*) untuk gradien atau tombol utama jika tema aplikasi menuntut kesan premium. Gunakan palet **Premium Dark Gradient** (misal: *Deep Purple* #2E1052 ke *Charcoal* #6B7280 atau warna gelap pekat solid) untuk *tab indicator*, *active buttons*, dan elemen UI utama.
- **DILARANG BANYAK WARNA (Anti-Rainbow):**"""

target2 = """### C. Penanganan Empty State (Keadaan Kosong) yang Menenangkan (Reassurance)
- **DILARANG** membiarkan kartu kosong tanpa visual yang memadai.
- **Wajib Mengurangi Eskalasi Visual (De-escalation):**"""
replacement2 = """### C. Penanganan Empty State (Keadaan Kosong) yang Menenangkan (Reassurance)
- **DILARANG** membiarkan kartu kosong tanpa visual yang memadai.
- **Anti-3D / Pro-SVG Line-Art Invariant:** DILARANG KERAS menggunakan gambar 3D, ilustrasi *glossy*, atau aset futuristik bercahaya (neon/glow). Wajib menggunakan **SVG Line-Art Murni** (vektor garis datar, warna monokrom / hitam-putih dengan aksen minimal, berbasis kode atau aset *open-source* bebas hak cipta) yang menonjolkan minimalisme elegan.
- **Wajib Mengurangi Eskalasi Visual (De-escalation):**"""

content = content.replace(target1, replacement1)
content = content.replace(target2, replacement2)

with open(path, 'w', encoding='utf-8') as f:
    f.write(content)

print("Updated SKILL.md successfully.")
