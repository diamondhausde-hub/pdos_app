import re

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\models.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

replacement = '''    updated_at = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)
    
    user_brands = relationship("UserBrand", backref="user")

    @property
    def brand_ids(self):
        return [b.brand_id for b in self.user_brands]'''

content = content.replace('    updated_at = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)', replacement)

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Updated models.py")
