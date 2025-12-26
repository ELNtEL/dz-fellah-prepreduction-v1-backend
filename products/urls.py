from django.urls import path, include
from rest_framework.routers import DefaultRouter
from .views import (
    ProductViewSet, 
    MyProductViewSet,
    SeasonalBasketViewSet,
    MySeasonalBasketViewSet,
    MySubscriptionViewSet
)

# Create router
router = DefaultRouter()

# Register viewsets
router.register(r'products', ProductViewSet, basename='product')
router.register(r'my-products', MyProductViewSet, basename='my-product')
router.register(r'seasonal-baskets', SeasonalBasketViewSet, basename='seasonal-basket')
router.register(r'my-seasonal-baskets', MySeasonalBasketViewSet, basename='my-seasonal-basket')
router.register(r'my-subscriptions', MySubscriptionViewSet, basename='my-subscription')

urlpatterns = [
    path('', include(router.urls)),
]