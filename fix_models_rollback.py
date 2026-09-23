import re

file_path = r'C:\Users\prot\Documents\PDOS\PDOS-Python-Backend\models.py'
with open(file_path, 'r', encoding='utf-8') as f:
    content = f.read()

# First, let's just strip out ALL the added text:
bad_text = '''    
    user_brands = relationship("UserBrand", backref="user")

    @property
    def brand_ids(self):
        return [b.brand_id for b in self.user_brands]'''

content = content.replace(bad_text, "")

# Now inject it ONLY under class User(Base)
# We can find class User(Base): and its updated_at to inject it precisely.
user_class_start = content.find('class User(Base):')
if user_class_start != -1:
    user_updated_at = content.find('updated_at = Column(DateTime, default=datetime.datetime.utcnow, onupdate=datetime.datetime.utcnow)', user_class_start)
    if user_updated_at != -1:
        # find end of line
        eol = content.find('\n', user_updated_at)
        
        good_text = '''
    
    user_brands = relationship("UserBrand", backref="user")

    @property
    def brand_ids(self):
        return [b.brand_id for b in self.user_brands]'''
        content = content[:eol] + good_text + content[eol:]

with open(file_path, 'w', encoding='utf-8') as f:
    f.write(content)
print("Fixed models.py")
