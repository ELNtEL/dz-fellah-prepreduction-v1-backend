from django.db import models
from config import settings

user = settings

# Create your models here.
class Order(models.Model):
    user_id = models.ForeignKey(
        settings.AUTH_USER_MODEL,on_delete=models.CASCADE,related_name='orders'
    )

    pro