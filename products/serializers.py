from rest_framework import serializers
from decimal import Decimal


class ProductListSerializer(serializers.Serializer):
    """Lightweight serializer for product lists."""
    
    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(max_length=255)
    photo_url = serializers.CharField(max_length=500, allow_null=True, required=False)
    price = serializers.DecimalField(max_digits=10, decimal_places=2)
    sale_type = serializers.ChoiceField(choices=['unit', 'weight'])
    stock = serializers.DecimalField(max_digits=10, decimal_places=2)
    product_type = serializers.ChoiceField(choices=['fresh', 'dry'])
    is_anti_gaspi = serializers.BooleanField()
    harvest_date = serializers.DateField(allow_null=True, required=False)
    producer_id = serializers.IntegerField(read_only=True)
    producer_name = serializers.CharField(read_only=True)


class ProducerInfoSerializer(serializers.Serializer):
    """Producer info for product detail."""
    
    id = serializers.IntegerField(read_only=True)
    shop_name = serializers.CharField()
    description = serializers.CharField(allow_null=True, required=False)
    photo_url = serializers.CharField(allow_null=True, required=False)
    city = serializers.CharField(allow_null=True, required=False)
    wilaya = serializers.CharField(allow_null=True, required=False)
    is_bio_certified = serializers.BooleanField()
    user_id = serializers.IntegerField(read_only=True)
    email = serializers.EmailField(read_only=True)
    phone_number = serializers.CharField(read_only=True)


class ProductDetailSerializer(serializers.Serializer):
    """Detailed serializer with full producer info."""
    
    id = serializers.IntegerField(read_only=True)
    name = serializers.CharField(max_length=255)
    description = serializers.CharField(allow_null=True, required=False)
    photo_url = serializers.CharField(max_length=500, allow_null=True, required=False)
    sale_type = serializers.ChoiceField(choices=['unit', 'weight'])
    price = serializers.DecimalField(max_digits=10, decimal_places=2)
    stock = serializers.DecimalField(max_digits=10, decimal_places=2)
    product_type = serializers.ChoiceField(choices=['fresh', 'dry'])
    harvest_date = serializers.DateField(allow_null=True, required=False)
    is_anti_gaspi = serializers.BooleanField()
    created_at = serializers.DateTimeField(read_only=True)
    updated_at = serializers.DateTimeField(read_only=True)
    
    # Producer info (populated manually in view)
    producer = ProducerInfoSerializer(read_only=True)


class ProductCreateUpdateSerializer(serializers.Serializer):
    """Serializer for creating/updating products."""
    
    name = serializers.CharField(max_length=255)
    description = serializers.CharField(allow_null=True, required=False, allow_blank=True)
    photo_url = serializers.CharField(max_length=500, allow_null=True, required=False, allow_blank=True)
    sale_type = serializers.ChoiceField(choices=['unit', 'weight'])
    price = serializers.DecimalField(max_digits=10, decimal_places=2)
    stock = serializers.DecimalField(max_digits=10, decimal_places=2)
    product_type = serializers.ChoiceField(choices=['fresh', 'dry'])
    harvest_date = serializers.DateField(allow_null=True, required=False)
    is_anti_gaspi = serializers.BooleanField(required=False, default=False)
    
    def validate_price(self, value):
        if value <= 0:
            raise serializers.ValidationError("Price must be greater than 0")
        return value
    
    def validate_stock(self, value):
        if value < 0:
            raise serializers.ValidationError("Stock cannot be negative")
        return value
    
    def validate(self, data):
        # If product is fresh, harvest_date should be provided
        if data.get('product_type') == 'fresh' and not data.get('harvest_date'):
            raise serializers.ValidationError({
                'harvest_date': 'Harvest date is required for fresh products'
            })
        return data