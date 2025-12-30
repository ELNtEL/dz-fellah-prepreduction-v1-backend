<<<<<<< HEAD
"""
Django management command to import seasonal data
Usage: python manage.py import_seasons
"""

from django.core.management.base import BaseCommand
from django.db import connection
import csv
import os


class Command(BaseCommand):
    help = 'Import seasonal data from CSV with fuzzy matching for Arabic/French/English'

    def normalize_for_matching(self, text):
        """Normalize text for fuzzy matching"""
        if not text:
            return ''
        
        text = text.lower().strip()
        replacements = {
            'é': 'e', 'è': 'e', 'ê': 'e',
            'à': 'a', 'â': 'a',
            'ô': 'o', 'ö': 'o',
            'û': 'u', 'ù': 'u', 'ü': 'u',
            'ï': 'i', 'î': 'i',
            'ç': 'c'
        }
        
        for old, new in replacements.items():
            text = text.replace(old, new)
        
        return text

    def find_canonical_name(self, input_name):
        """Find canonical product name from variations"""
        
        name_variations = {
            # Tomatoes
            'tomato': 'Tomato', 'tomate': 'Tomato', 'tomatos': 'Tomato',
            'tomates': 'Tomato', 'tomatoe': 'Tomato', 'طماطم': 'Tomato',
            'طماطة': 'Tomato', 'بندورة': 'Tomato',
            
            # Potatoes
            'potato': 'Potato', 'potatoes': 'Potato', 'pomme de terre': 'Potato',
            'patato': 'Potato', 'potatoe': 'Potato', 'بطاطا': 'Potato',
            'بطاطس': 'Potato',
            
            # Zucchini
            'zucchini': 'Zucchini', 'courgette': 'Zucchini', 'zuchini': 'Zucchini',
            'zuccini': 'Zucchini', 'كوسة': 'Zucchini', 'كوسا': 'Zucchini',
            
            # Eggplant
            'eggplant': 'Eggplant', 'aubergine': 'Eggplant', 'egplant': 'Eggplant',
            'باذنجان': 'Eggplant', 'بادنجان': 'Eggplant',
            
            # Pepper
            'pepper': 'Pepper', 'poivron': 'Pepper', 'peper': 'Pepper',
            'pepr': 'Pepper', 'فلفل': 'Pepper', 'فليفلة': 'Pepper',
            
            # Cucumber
            'cucumber': 'Cucumber', 'concombre': 'Cucumber', 'cucmber': 'Cucumber',
            'خيار': 'Cucumber',
            
            # Carrot
            'carrot': 'Carrot', 'carrots': 'Carrot', 'carot': 'Carrot',
            'carotte': 'Carrot', 'جزر': 'Carrot',
            
            # Onion
            'onion': 'Onion', 'oignon': 'Onion', 'onon': 'Onion',
            'بصل': 'Onion', 'بصلة': 'Onion',
            
            # Garlic
            'garlic': 'Garlic', 'ail': 'Garlic', 'garlik': 'Garlic', 'ثوم': 'Garlic',
            
            # Fruits
            'orange': 'Orange', 'برتقال': 'Orange', 'برتقالة': 'Orange',
            'lemon': 'Lemon', 'citron': 'Lemon', 'ليمون': 'Lemon', 'حامض': 'Lemon',
            'strawberry': 'Strawberry', 'fraise': 'Strawberry', 'فراولة': 'Strawberry',
            'banana': 'Banana', 'banane': 'Banana', 'موز': 'Banana',
            'apple': 'Apple', 'pomme': 'Apple', 'تفاح': 'Apple',
            
            # Add more as needed...
        }
        
        # Try exact match
        if input_name.strip() in name_variations:
            return name_variations[input_name.strip()]
        
        # Try normalized match
        normalized = self.normalize_for_matching(input_name)
        if normalized in name_variations:
            return name_variations[normalized]
        
        # Try partial match
        for variation, canonical in name_variations.items():
            if variation in normalized or normalized in variation:
                return canonical
        
        return input_name.strip().lower().capitalize()

    def clean_text(self, text):
        """Clean and standardize product name"""
        if not text:
            return ''
        
        cleaned = ' '.join(text.split())
        canonical = self.find_canonical_name(cleaned)
        return canonical

    def handle(self, *args, **options):
        csv_path = os.path.join(os.path.dirname(__file__), '../../../scripts/seasonal_data.csv')
        
        self.stdout.write('🌱 DZ-Fellah Seasonal Data Import')
        self.stdout.write('='*60)
        self.stdout.write(f'📂 Reading: {csv_path}')
        
        if not os.path.exists(csv_path):
            self.stdout.write(self.style.ERROR(f'❌ CSV file not found!'))
            return
        
        cursor = connection.cursor()
        imported = 0
        skipped = 0
        duplicates = 0
        
        with open(csv_path, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            
            for row_num, row in enumerate(reader, start=2):
                try:
                    product_name = row.get('nom_produit', '').strip()
                    start_month = row.get('mois_debut', '').strip()
                    end_month = row.get('mois_fin', '').strip()
                    
                    if not product_name:
                        skipped += 1
                        continue
                    
                    product_clean = self.clean_text(product_name)
                    
                    try:
                        start = int(start_month)
                        end = int(end_month)
                    except ValueError:
                        self.stdout.write(f'⚠️  Row {row_num}: Invalid months')
                        skipped += 1
                        continue
                    
                    if not (1 <= start <= 12 and 1 <= end <= 12):
                        skipped += 1
                        continue
                    
                    if product_name != product_clean:
                        self.stdout.write(f'🔧 Row {row_num}: "{product_name}" → "{product_clean}"')
                    
                    cursor.execute("""
                        INSERT INTO product_seasons (product_name, start_month, end_month)
                        VALUES (%s, %s, %s)
                        ON CONFLICT (product_name) DO NOTHING
                        RETURNING id
                    """, [product_clean, start, end])
                    
                    result = cursor.fetchone()
                    
                    if result:
                        self.stdout.write(f'✅ Row {row_num}: "{product_clean}" (season: {start}-{end})')
                        imported += 1
                    else:
                        self.stdout.write(f'⏭️  Row {row_num}: Duplicate "{product_clean}"')
                        duplicates += 1
                        
                except Exception as e:
                    self.stdout.write(self.style.ERROR(f'❌ Row {row_num}: {e}'))
                    skipped += 1
        
        connection.commit()
        cursor.close()
        
        self.stdout.write('\n' + '='*60)
        self.stdout.write(self.style.SUCCESS('📊 IMPORT SUMMARY'))
        self.stdout.write('='*60)
        self.stdout.write(f'✅ Imported:    {imported} products')
        self.stdout.write(f'⏭️  Duplicates:  {duplicates} products')
        self.stdout.write(f'⚠️  Skipped:     {skipped} rows')
        self.stdout.write('='*60)
        self.stdout.write(self.style.SUCCESS('✨ Import complete!'))
=======
"""
Django management command to import seasonal data
Usage: python manage.py import_seasons
"""

from django.core.management.base import BaseCommand
from django.db import connection
import csv
import os


class Command(BaseCommand):
    help = 'Import seasonal data from CSV with fuzzy matching for Arabic/French/English'

    def normalize_for_matching(self, text):
        """Normalize text for fuzzy matching"""
        if not text:
            return ''
        
        text = text.lower().strip()
        replacements = {
            'é': 'e', 'è': 'e', 'ê': 'e',
            'à': 'a', 'â': 'a',
            'ô': 'o', 'ö': 'o',
            'û': 'u', 'ù': 'u', 'ü': 'u',
            'ï': 'i', 'î': 'i',
            'ç': 'c'
        }
        
        for old, new in replacements.items():
            text = text.replace(old, new)
        
        return text

    def find_canonical_name(self, input_name):
        """Find canonical product name from variations"""
        
        name_variations = {
            # Tomatoes
            'tomato': 'Tomato', 'tomate': 'Tomato', 'tomatos': 'Tomato',
            'tomates': 'Tomato', 'tomatoe': 'Tomato', 'طماطم': 'Tomato',
            'طماطة': 'Tomato', 'بندورة': 'Tomato',
            
            # Potatoes
            'potato': 'Potato', 'potatoes': 'Potato', 'pomme de terre': 'Potato',
            'patato': 'Potato', 'potatoe': 'Potato', 'بطاطا': 'Potato',
            'بطاطس': 'Potato',
            
            # Zucchini
            'zucchini': 'Zucchini', 'courgette': 'Zucchini', 'zuchini': 'Zucchini',
            'zuccini': 'Zucchini', 'كوسة': 'Zucchini', 'كوسا': 'Zucchini',
            
            # Eggplant
            'eggplant': 'Eggplant', 'aubergine': 'Eggplant', 'egplant': 'Eggplant',
            'باذنجان': 'Eggplant', 'بادنجان': 'Eggplant',
            
            # Pepper
            'pepper': 'Pepper', 'poivron': 'Pepper', 'peper': 'Pepper',
            'pepr': 'Pepper', 'فلفل': 'Pepper', 'فليفلة': 'Pepper',
            
            # Cucumber
            'cucumber': 'Cucumber', 'concombre': 'Cucumber', 'cucmber': 'Cucumber',
            'خيار': 'Cucumber',
            
            # Carrot
            'carrot': 'Carrot', 'carrots': 'Carrot', 'carot': 'Carrot',
            'carotte': 'Carrot', 'جزر': 'Carrot',
            
            # Onion
            'onion': 'Onion', 'oignon': 'Onion', 'onon': 'Onion',
            'بصل': 'Onion', 'بصلة': 'Onion',
            
            # Garlic
            'garlic': 'Garlic', 'ail': 'Garlic', 'garlik': 'Garlic', 'ثوم': 'Garlic',
            
            # Fruits
            'orange': 'Orange', 'برتقال': 'Orange', 'برتقالة': 'Orange',
            'lemon': 'Lemon', 'citron': 'Lemon', 'ليمون': 'Lemon', 'حامض': 'Lemon',
            'strawberry': 'Strawberry', 'fraise': 'Strawberry', 'فراولة': 'Strawberry',
            'banana': 'Banana', 'banane': 'Banana', 'موز': 'Banana',
            'apple': 'Apple', 'pomme': 'Apple', 'تفاح': 'Apple',
            
            # Add more as needed...
        }
        
        # Try exact match
        if input_name.strip() in name_variations:
            return name_variations[input_name.strip()]
        
        # Try normalized match
        normalized = self.normalize_for_matching(input_name)
        if normalized in name_variations:
            return name_variations[normalized]
        
        # Try partial match
        for variation, canonical in name_variations.items():
            if variation in normalized or normalized in variation:
                return canonical
        
        return input_name.strip().lower().capitalize()

    def clean_text(self, text):
        """Clean and standardize product name"""
        if not text:
            return ''
        
        cleaned = ' '.join(text.split())
        canonical = self.find_canonical_name(cleaned)
        return canonical

    def handle(self, *args, **options):
        csv_path = os.path.join(os.path.dirname(__file__), '../../../scripts/seasonal_data.csv')
        
        self.stdout.write('🌱 DZ-Fellah Seasonal Data Import')
        self.stdout.write('='*60)
        self.stdout.write(f'📂 Reading: {csv_path}')
        
        if not os.path.exists(csv_path):
            self.stdout.write(self.style.ERROR(f'❌ CSV file not found!'))
            return
        
        cursor = connection.cursor()
        imported = 0
        skipped = 0
        duplicates = 0
        
        with open(csv_path, 'r', encoding='utf-8') as file:
            reader = csv.DictReader(file)
            
            for row_num, row in enumerate(reader, start=2):
                try:
                    product_name = row.get('nom_produit', '').strip()
                    start_month = row.get('mois_debut', '').strip()
                    end_month = row.get('mois_fin', '').strip()
                    
                    if not product_name:
                        skipped += 1
                        continue
                    
                    product_clean = self.clean_text(product_name)
                    
                    try:
                        start = int(start_month)
                        end = int(end_month)
                    except ValueError:
                        self.stdout.write(f'⚠️  Row {row_num}: Invalid months')
                        skipped += 1
                        continue
                    
                    if not (1 <= start <= 12 and 1 <= end <= 12):
                        skipped += 1
                        continue
                    
                    if product_name != product_clean:
                        self.stdout.write(f'🔧 Row {row_num}: "{product_name}" → "{product_clean}"')
                    
                    cursor.execute("""
                        INSERT INTO product_seasons (product_name, start_month, end_month)
                        VALUES (%s, %s, %s)
                        ON CONFLICT (product_name) DO NOTHING
                        RETURNING id
                    """, [product_clean, start, end])
                    
                    result = cursor.fetchone()
                    
                    if result:
                        self.stdout.write(f'✅ Row {row_num}: "{product_clean}" (season: {start}-{end})')
                        imported += 1
                    else:
                        self.stdout.write(f'⏭️  Row {row_num}: Duplicate "{product_clean}"')
                        duplicates += 1
                        
                except Exception as e:
                    self.stdout.write(self.style.ERROR(f'❌ Row {row_num}: {e}'))
                    skipped += 1
        
        connection.commit()
        cursor.close()
        
        self.stdout.write('\n' + '='*60)
        self.stdout.write(self.style.SUCCESS('📊 IMPORT SUMMARY'))
        self.stdout.write('='*60)
        self.stdout.write(f'✅ Imported:    {imported} products')
        self.stdout.write(f'⏭️  Duplicates:  {duplicates} products')
        self.stdout.write(f'⚠️  Skipped:     {skipped} rows')
        self.stdout.write('='*60)
        self.stdout.write(self.style.SUCCESS('✨ Import complete!'))
>>>>>>> 9fbc4c68e09affc149a7e6f589d12f1709247a15
