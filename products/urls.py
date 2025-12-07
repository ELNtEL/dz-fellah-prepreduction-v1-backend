from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import ProductViewSet, MyProductViewSet

# Create router
router = DefaultRouter()

# Register viewsets
router.register(r'products', ProductViewSet, basename='product')
router.register(r'my-products', MyProductViewSet, basename='my-product')

urlpatterns = [
    path('', include(router.urls)),
]