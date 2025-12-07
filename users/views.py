from rest_framework import status, viewsets
from rest_framework.decorators import action
from rest_framework.response import Response
from rest_framework.permissions import AllowAny, IsAuthenticated
from rest_framework_simplejwt.tokens import RefreshToken
from django.db import transaction
from . import queries
from .serializers import (
    RegisterProducerSerializer,
    RegisterClientSerializer,
    LoginSerializer,
    UserSerializer,
    ProducerProfileSerializer,
    ClientProfileSerializer
)
from .authentication import CustomJWTAuthentication


def get_tokens_for_user(user_data):
    """Generate JWT tokens for user."""
    refresh = RefreshToken()
    refresh['user_id'] = user_data['id']
    refresh['email'] = user_data['email']
    refresh['user_type'] = user_data['user_type']
    
    return {
        'refresh': str(refresh),
        'access': str(refresh.access_token),
    }


class AuthViewSet(viewsets.ViewSet):
    """
    ViewSet for authentication operations.
    All endpoints are public (no authentication required).
    """
    
    permission_classes = [AllowAny]
    
    @action(detail=False, methods=['post'], url_path='register/producer')
    def register_producer(self, request):
        """
        POST /api/auth/register/producer/
        Register a new producer with profile.
        """
        serializer = RegisterProducerSerializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
        # Check if email exists
        if queries.email_exists(serializer.validated_data['email']):
            return Response({
                'email': ['Email already registered']
            }, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            with transaction.atomic():
                # Create user
                user = queries.create_user(
                    email=serializer.validated_data['email'],
                    password=serializer.validated_data['password'],
                    user_type='producer',
                    first_name=serializer.validated_data['first_name'],
                    last_name=serializer.validated_data['last_name'],
                    phone=serializer.validated_data.get('phone')
                )
                
                # Create producer profile
                queries.create_producer_profile(
                    user_id=user['id'],
                    shop_name=serializer.validated_data['shop_name'],
                    description=serializer.validated_data.get('description'),
                    photo_url=serializer.validated_data.get('photo_url'),
                    address=serializer.validated_data.get('address'),
                    city=serializer.validated_data.get('city'),
                    wilaya=serializer.validated_data.get('wilaya'),
                    methods=serializer.validated_data.get('methods'),
                    is_bio_certified=serializer.validated_data.get('is_bio_certified', False)
                )
                
                # Get full user data with profile
                user_data = queries.get_user_by_id(user['id'])
                user_structured = queries.structure_user_data(user_data)
                
                tokens = get_tokens_for_user(user_structured)
                
                return Response({
                    'message': 'Producer registered successfully',
                    'user': UserSerializer(user_structured).data,
                    'tokens': tokens
                }, status=status.HTTP_201_CREATED)
        
        except Exception as e:
            return Response({
                'error': f'Registration failed: {str(e)}'
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    @action(detail=False, methods=['post'], url_path='register/client')
    def register_client(self, request):
        """
        POST /api/auth/register/client/
        Register a new client with profile.
        """
        serializer = RegisterClientSerializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
        # Check if email exists
        if queries.email_exists(serializer.validated_data['email']):
            return Response({
                'email': ['Email already registered']
            }, status=status.HTTP_400_BAD_REQUEST)
        
        try:
            with transaction.atomic():
                # Create user
                user = queries.create_user(
                    email=serializer.validated_data['email'],
                    password=serializer.validated_data['password'],
                    user_type='client',
                    first_name=serializer.validated_data['first_name'],
                    last_name=serializer.validated_data['last_name'],
                    phone=serializer.validated_data.get('phone')
                )
                
                # Create client profile
                queries.create_client_profile(
                    user_id=user['id'],
                    address=serializer.validated_data.get('address'),
                    city=serializer.validated_data.get('city'),
                    wilaya=serializer.validated_data.get('wilaya')
                )
                
                # Get full user data with profile
                user_data = queries.get_user_by_id(user['id'])
                user_structured = queries.structure_user_data(user_data)
                
                tokens = get_tokens_for_user(user_structured)
                
                return Response({
                    'message': 'Client registered successfully',
                    'user': UserSerializer(user_structured).data,
                    'tokens': tokens
                }, status=status.HTTP_201_CREATED)
        
        except Exception as e:
            return Response({
                'error': f'Registration failed: {str(e)}'
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)
    
    @action(detail=False, methods=['post'])
    def login(self, request):
        """
        POST /api/auth/login/
        Login user and return JWT tokens.
        """
        serializer = LoginSerializer(data=request.data)
        
        if not serializer.is_valid():
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
        
        email = serializer.validated_data['email']
        password = serializer.validated_data['password']
        
        # Get user with profile data
        user_data = queries.get_user_by_email(email)
        
        if not user_data:
            return Response({
                'error': 'Invalid email or password'
            }, status=status.HTTP_401_UNAUTHORIZED)
        
        # Verify password
        if not queries.verify_password(user_data['password'], password):
            return Response({
                'error': 'Invalid email or password'
            }, status=status.HTTP_401_UNAUTHORIZED)
        
        # Check if account is active
        if not user_data['is_active']:
            return Response({
                'error': 'Account is deactivated'
            }, status=status.HTTP_401_UNAUTHORIZED)
        
        # Structure user data
        user_structured = queries.structure_user_data(user_data)
        tokens = get_tokens_for_user(user_structured)
        
        return Response({
            'message': 'Login successful',
            'user': UserSerializer(user_structured).data,
            'tokens': tokens
        }, status=status.HTTP_200_OK)
    
    @action(detail=False, methods=['post'], 
            authentication_classes=[CustomJWTAuthentication],
            permission_classes=[IsAuthenticated])
    def logout(self, request):
        """
        POST /api/auth/logout/
        Logout user (client-side should delete tokens).
        """
        return Response({
            'message': 'Logged out successfully'
        }, status=status.HTTP_200_OK)


class UserViewSet(viewsets.ViewSet):
    """
    ViewSet for user operations.
    Requires authentication.
    """
    
    authentication_classes = [CustomJWTAuthentication]
    permission_classes = [IsAuthenticated]
    
    @action(detail=False, methods=['get'])
    def me(self, request):
        """
        GET /api/users/me/
        Get current authenticated user with profile.
        """
        # Get user data with profile
        user_data = queries.get_user_by_id(request.user.id)
        user_structured = queries.structure_user_data(user_data)
        
        is_producer = user_structured['user_type'] == 'producer'
        
        # Serialize user data
        user_serialized = UserSerializer(user_structured).data
        
        # Add permissions
        user_serialized['permissions'] = {
            'can_create_products': is_producer,
            'can_manage_shop': is_producer,
            'can_view_sales': is_producer,
            'can_place_orders': True,
            'can_add_to_cart': True,
            'can_view_purchases': True,
            'is_producer': is_producer,
            'is_client': user_structured['user_type'] == 'client',
            'user_type': user_structured['user_type'],
        }
        
        return Response(user_serialized)


class ProducerViewSet(viewsets.ViewSet):
    """
    ViewSet for public producer listings.
    No authentication required.
    """
    
    permission_classes = [AllowAny]
    
    def list(self, request):
        """
        GET /api/producers/
        List all producers with optional filters.
        """
        city = request.query_params.get('city')
        wilaya = request.query_params.get('wilaya')
        is_bio_certified = request.query_params.get('is_bio_certified')
        is_bio_certified_bool = is_bio_certified.lower() == 'true' if is_bio_certified else None
        
        producers = queries.get_all_producers(
            city=city,
            wilaya=wilaya,
            is_bio_certified=is_bio_certified_bool
        )
        
        serializer = ProducerProfileSerializer(producers, many=True)
        
        return Response({
            'count': len(serializer.data),
            'filters': {
                'city': city,
                'wilaya': wilaya,
                'is_bio_certified': is_bio_certified
            },
            'producers': serializer.data
        })
    
    def retrieve(self, request, pk=None):
        """
        GET /api/producers/{id}/
        Get single producer detail.
        """
        producer = queries.get_producer_profile_by_id(pk)
        
        if not producer:
            return Response({
                'error': 'Producer not found'
            }, status=status.HTTP_404_NOT_FOUND)
        
        serializer =ProducerProfileSerializer(producer)
        return Response(serializer.data)