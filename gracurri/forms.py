from django import forms
from django.contrib.auth.forms import ReadOnlyPasswordHashField
from django.db.models.enums import Choices
from django.forms.widgets import Widget

from .models import users

class UserCreationForm(forms.ModelForm):
    password1=forms.CharField(label="Password",widget=forms.PasswordInput(attrs={
        'required':'True'
    }))
    password2=forms.CharField(
        label='Password confirmation',widget=forms.PasswordInput(attrs={'required':'True',
        'placeholder': ('Password confirmation')
        }
        )
    )

    class Meta:
        model=users
        fields=('id','major','username','hintanswer','EMAIL')
    def clean_password2(self):
        password1=self.cleaned_data.get("password1")
        password2=self.cleaned_data.get("password2")
        if password1 and password2 and password1!=password2:
            raise forms.ValidationError("Passwords don't match")
        return password2
    def save(self,commit=True):
        user=super().save(commit=False)
        user.set_password(self.cleaned_data["password1"])
        if commit:
            user.save()
        return user
class UserChangeForm(forms.ModelForm):
    password=ReadOnlyPasswordHashField()
    class Meta:
        model=users
        fields=('id','major','username','hintanswer','EMAIL','is_active','is_admin')
    def clean_password(self):
        return self.initial["password"]