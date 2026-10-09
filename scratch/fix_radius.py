import re

files = [
    r'D:\Project\Flutter\mierp\lib\core\widgets\card_stock.dart',
    r'D:\Project\Flutter\mierp\lib\core\widgets\card_sales.dart',
    r'D:\Project\Flutter\mierp\lib\core\widgets\card_order.dart'
]

for path in files:
    with open(path, 'r', encoding='utf-8') as f:
        content = f.read()

    # Replace 16.w with 10.w for border radius
    content = re.sub(r'BorderRadius\.circular\(16\.w\)', r'BorderRadius.circular(10.w)', content)
    
    with open(path, 'w', encoding='utf-8') as f:
        f.write(content)

print("Radius updated successfully.")
