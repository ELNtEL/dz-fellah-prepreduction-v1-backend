from rest_framework import status, viewsets
from rest_framework.decorators import action, permission_classes, authentication_classes
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated

from . import queries
from .serializers import (
    ProductListSerializer,
    ProductDetailSerializer,
    ProductCreateUpdateSerializer,
    ProducerInfoSerializer
)
from users.authentication import CustomJWTAuthentication
from users.permissions import IsProducer


class ProductViewSet(viewsets.ViewSet):
    """
    ViewSet for public product operations.
    No authentication required.
    """
    
    permission_classes = [AllowAny]
    
    def list(self, request):
        """
        GET /api/products/
        Homepage products list with filters.
        """
        product_type = request.query_params.get('product_type')
        is_anti_gaspi = request.query_params.get('is_anti_gaspi')
        is_anti_gaspi_bool = is_anti_gaspi.lower() == 'true' if is_anti_gaspi else None
        
        limit = request.query_params.get('limit', 20)
        try:
            limit = int(limit)
        except:
            limit = 20
        
        products = queries.get_home_products(
            product_type=product_type,
            is_anti_gaspi=is_anti_gaspi_bool,
            limit=limit
        )
        
        serializer = ProductListSerializer(products, many=True)
        
        return Response({
            'count': len(serializer.data),
            'filters': {
                'product_type': product_type,
                'is_anti_gaspi': is_anti_gaspi,
                'limit': limit
            },
            'products': serializer.data
        })
    
    def retrieve(self, request, pk=None):
        """
        GET /api/products/{id}/
        Get single product detail.
        """
        product = queries.get_product_detail(pk)
        
        if not product:
            return Response({
                'error': 'Product not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        # Structure producer data
        producer_data = {
            'id': product.pop('producer_id'),
            'shop_name': product.pop('shop_name'),
            'description': product.pop('producer_description'),
            'photo_url': product.pop('producer_photo_url'),
            'city': product.pop('city'),
            'wilaya': product.pop('wilaya'),
            'is_bio_certified': product.pop('is_bio_certified'),
            'user_id': product.pop('user_id'),
            'email': product.pop('email'),
            'phone_number': product.pop('phone_number')
        }
        
        product['producer'] = producer_data
        
        serializer = ProductDetailSerializer(product)
        return Response(serializer.data)
    
    @action(detail=False, methods=['get'])
    def search(self, request):
        """
        GET /api/products/search/?q=tomate
        Search products by name or description.
        """
        query = request.query_params.get('q', '')
        
        if not query:
            return Response({
                'error': 'Query parameter "q" is required'
            }, status=status.HTTP_400_BAD_REQUEST)
        
        product_type = request.query_params.get('product_type')
        is_anti_gaspi = request.query_params.get('is_anti_gaspi')
        is_anti_gaspi_bool = is_anti_gaspi.lower() == 'true' if is_anti_gaspi else None
        
        products = queries.search_products(
            query=query,
            product_type=product_type,
            is_anti_gaspi=is_anti_gaspi_bool
        )
        
        serializer = ProductListSerializer(products, many=True)
        
        return Response({
            'query': query,
            'count': len(serializer.data),
            'filters': {
                'product_type': product_type,
                'is_anti_gaspi': is_anti_gaspi
            },
            'products': serializer.data
        })
    
    @action(detail=False, methods=['get'])
    def filter(self, request):
        """
        GET /api/products/filter/?product_type=fresh&min_price=100
        Filter products by multiple criteria.
        """
        sale_type = request.query_params.get('sale_type')
        product_type = request.query_params.get('product_type')
        is_anti_gaspi = request.query_params.get('is_anti_gaspi')
        is_anti_gaspi_bool = is_anti_gaspi.lower() == 'true' if is_anti_gaspi else None
        min_price = request.query_params.get('min_price')
        max_price = request.query_params.get('max_price')
        wilaya = request.query_params.get('wilaya')
        limit = request.query_params.get('limit')
        
        limit_int = None
        if limit:
            try:
                limit_int = int(limit)
            except:
                pass
        
        products = queries.filter_products(
            sale_type=sale_type,
            product_type=product_type,
            is_anti_gaspi=is_anti_gaspi_bool,
            min_price=min_price,
            max_price=max_price,
            wilaya=wilaya,
            limit=limit_int
        )
        
        serializer = ProductListSerializer(products, many=True)
        
        return Response({
            'count': len(serializer.data),
            'filters_applied': {
                'sale_type': sale_type,
                'product_type': product_type,
                'is_anti_gaspi': is_anti_gaspi,
                'min_price': min_price,
                'max_price': max_price,
                'wilaya': wilaya,
                'limit': limit
            },
            'products': serializer.data
        })
    
    @action(detail=False, methods=['get'], url_path='producer/(?P<producer_id>[^/.]+)')
    def producer_shop(self, request, producer_id=None):
        """
        GET /api/products/producer/{producer_id}/
        Get all products from a specific producer.
        """
        # Get producer info
        producer = queries.get_producer_info(producer_id)
        
        if not producer:
            return Response({
                'error': 'Producer not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        product_type = request.query_params.get('product_type')
        is_anti_gaspi = request.query_params.get('is_anti_gaspi')
        is_anti_gaspi_bool = is_anti_gaspi.lower() == 'true' if is_anti_gaspi else None
        
        products = queries.get_producer_products(
            producer_id=producer_id,
            product_type=product_type,
            is_anti_gaspi=is_anti_gaspi_bool
        )
        
        serializer = ProductListSerializer(products, many=True)
        
        return Response({
            'shop': {
                'id': producer['id'],
                'shop_name': producer['shop_name'],
                'description': producer.get('description'),
                'photo_url': producer.get('photo_url'),
                'city': producer.get('city'),
                'wilaya': producer.get('wilaya'),
                'is_bio_certified': producer.get('is_bio_certified', False)
            },
            'products_count': len(serializer.data),
            'filters': {
                'product_type': product_type,
                'is_anti_gaspi': is_anti_gaspi
            },
            'products': serializer.data
        })


class MyProductViewSet(viewsets.ViewSet):
    """
    ViewSet for authenticated producer product management.
    Requires authentication and IsProducer permission.
    """
    
    authentication_classes = [CustomJWTAuthentication]
    permission_classes = [IsAuthenticated, IsProducer]
    
    def list(self, request):
        """
        GET /api/my-products/
        Get all products belonging to authenticated producer.
        """
        product_type = request.query_params.get('product_type')
        is_anti_gaspi = request.query_params.get('is_anti_gaspi')
        is_anti_gaspi_bool = is_anti_gaspi.lower() == 'true' if is_anti_gaspi else None
        
        products = queries.get_my_products(
            producer_id=request.user.producer_profile.id,
            product_type=product_type,
            is_anti_gaspi=is_anti_gaspi_bool
        )
        
        serializer = ProductListSerializer(products, many=True)
        
        return Response({
            'count': len(serializer.data),
            'filters': {
                'product_type': product_type,
                'is_anti_gaspi': is_anti_gaspi
            },
            'products': serializer.data
        })
    
    def create(self, request):
        """
        POST /api/my-products/
        Create a new product.
        """
        serializer = ProductCreateUpdateSerializer(data=request.data)
        
        if serializer.is_valid():
            product = queries.create_product(
                producer_id=request.user.producer_profile.id,
                name=serializer.validated_data['name'],
                description=serializer.validated_data.get('description'),
                photo_url=serializer.validated_data.get('photo_url'),
                sale_type=serializer.validated_data['sale_type'],
                price=serializer.validated_data['price'],
                stock=serializer.validated_data['stock'],
                product_type=serializer.validated_data['product_type'],
                harvest_date=serializer.validated_data.get('harvest_date'),
                is_anti_gaspi=serializer.validated_data.get('is_anti_gaspi', False)
            )
            
            product_detail = queries.get_my_product_detail(
                product['id'],
                request.user.producer_profile.id
            )
            
            detail_serializer = ProductListSerializer(product_detail)
            
            return Response({
                'message': 'Product created successfully',
                'product': detail_serializer.data
            }, status=status.HTTP_201_CREATED)
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def retrieve(self, request, pk=None):
        """
        GET /api/my-products/{id}/
        Get single product detail (only if owned by authenticated producer).
        """
        product = queries.get_my_product_detail(
            pk,
            request.user.producer_profile.id
        )
        
        if not product:
            return Response({
                'error': 'Product not found or you do not have permission to access it'
            }, status=status.HTTP_404_NOT_FOUND)
        
        serializer = ProductListSerializer(product)
        return Response(serializer.data)
    
    def update(self, request, pk=None):
        """
        PUT /api/my-products/{id}/
        Fully update a product.
        """
        product = queries.get_my_product_detail(pk, request.user.producer_profile.id)
        
        if not product:
            return Response({
                'error': 'Product not found or you do not have permission to access it'
            }, status=status.HTTP_404_NOT_FOUND)
        
        serializer = ProductCreateUpdateSerializer(data=request.data)
        
        if serializer.is_valid():
            updated = queries.update_product(
                product_id=pk,
                producer_id=request.user.producer_profile.id,
                name=serializer.validated_data['name'],
                description=serializer.validated_data.get('description'),
                photo_url=serializer.validated_data.get('photo_url'),
                sale_type=serializer.validated_data['sale_type'],
                price=serializer.validated_data['price'],
                stock=serializer.validated_data['stock'],
                product_type=serializer.validated_data['product_type'],
                harvest_date=serializer.validated_data.get('harvest_date'),
                is_anti_gaspi=serializer.validated_data.get('is_anti_gaspi', False)
            )
            
            detail_serializer = ProductListSerializer(updated)
            
            return Response({
                'message': 'Product updated successfully',
                'product': detail_serializer.data
            })
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def partial_update(self, request, pk=None):
        """
        PATCH /api/my-products/{id}/
        Partially update a product.
        """
        product = queries.get_my_product_detail(pk, request.user.producer_profile.id)
        
        if not product:
            return Response({
                'error': 'Product not found or you do not have permission to access it'
            }, status=status.HTTP_404_NOT_FOUND)
        
        serializer = ProductCreateUpdateSerializer(data=request.data, partial=True)
        
        if serializer.is_valid():
            updated = queries.partial_update_product(
                product_id=pk,
                producer_id=request.user.producer_profile.id,
                updates=serializer.validated_data
            )
            
            detail_serializer = ProductListSerializer(updated)
            
            return Response({
                'message': 'Product updated successfully',
                'product': detail_serializer.data
            })
        
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
    
    def destroy(self, request, pk=None):
        """
        DELETE /api/my-products/{id}/
        Delete a product.
        """
        product_name = queries.delete_product(
            pk,
            request.user.producer_profile.id
        )
        
        if product_name:
            return Response({
                'message': f'Product "{product_name}" deleted successfully'
            }, status=status.HTTP_204_NO_CONTENT)
        
        return Response({
            'error': 'Product not found'
        }, status=status.HTTP_404_NOT_FOUND)
    
    @action(detail=True, methods=['post'], url_path='toggle-anti-gaspi')
    def toggle_anti_gaspi(self, request, pk=None):
        """
        POST /api/my-products/{id}/toggle-anti-gaspi/
        Toggle anti-gaspi status for a product.
        """
        result = queries.toggle_anti_gaspi(
            pk,
            request.user.producer_profile.id
        )
        
        if not result:
            return Response({
                'error': 'Product not found or you do not have permission'
            }, status=status.HTTP_404_NOT_FOUND)
        
        return Response({
            'message': f'Product {"marked as" if result["is_anti_gaspi"] else "removed from"} anti-gaspi',
            'product': {
                'id': result['id'],
                'name': result['name'],
                'is_anti_gaspi': result['is_anti_gaspi']
            }
        })