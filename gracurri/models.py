from django.db import models
from django.db.models.deletion import SET_NULL
from django.db.models.enums import Choices
from django.db.models.fields import NullBooleanField
from django.db.models.fields.related import ForeignKey
from django.contrib.auth.models import (BaseUserManager,AbstractBaseUser)
departments=(('CS','컴퓨터학부'),
    ('GM','글로벌미디어학부'),)
class UserManager(BaseUserManager):
    def create_user(self,username,id,major,EMAIL,hintanswer,password=None):
        if not username:
            raise ValueError("USERS MUST HAVE NAME")
        user=self.model(
            username=username,
            id=id,
            major=major,
            EMAIL=self.normalize_email(EMAIL),
            hintanswer=hintanswer
        )
        user.set_password(password)
        user.save(using=self._db)
        return user

    def create_superuser(self,username,id,major,EMAIL,hintanswer,password):
        if not username:
            raise ValueError("USERS MUST HAVE NAME")
        user=self.create_user(
            username=username,
            id=id,
            major=major,
            EMAIL=EMAIL,
            hintanswer=hintanswer,
            password=password
        )
        user.is_admin=True
        user.save(using=self._db)
        return user

        
class users(AbstractBaseUser):
    username=models.CharField(max_length=10,help_text='이름',null=False)
    id=models.CharField(max_length=8,help_text="학번",primary_key=True,null=False,unique=True)
    EMAIL=models.EmailField(verbose_name='email',max_length=30,unique=True,)
    major=models.CharField(max_length=4,choices=departments,default='CS')
    hintanswer=models.CharField(max_length=20,unique=False,null=False,default="unknown")
    is_active=models.BooleanField(default=True)
    is_admin=models.BooleanField(default=False)
    objects=UserManager()
    USERNAME_FIELD='id'
    REQUIRED_FIELDS=['name','department','password']
    def __str__(self):
        return self.name
    def has_perm(self,perm,obj=None):
        if self.is_admin==True and self.is_active==True:
            return True
        else:
            return False
    def has_module_perms(self,app_label):
        if self.is_admin==True and self.is_active==True:
            return True
        else:
            return False
    @property
    def is_staff(self):
        return self.is_admin
