from django.contrib import admin

# Register your models here.
from gracurri.forms import UserCreationForm,UserChangeForm
from .models import users
from django.contrib.auth.models import Group
from django.contrib.auth.admin import UserAdmin as BaseUserAdmin
class userAdmin(BaseUserAdmin):
    form=UserChangeForm
    add_form=UserCreationForm
    list_display=('id','major','username','hintanswer','EMAIL','is_active','is_admin')
    list_filter=('is_admin','major','id','EMAIL')
    fieldsets=(
        (None,{'fields':('id','username','EMAIL')}),
        ('Permissions',{'fields':('is_admin',)}),
    )
    add_fieldsets=(
        (None,{
            'classes':('wide',),
            'fields':('id','username','EMAIL','password1','password2'),
        }),
    )
    search_fields=('id','username','EMAIL','major')
    ordering=('id',)
    filter_horizontal=()
admin.site.register(users,userAdmin)