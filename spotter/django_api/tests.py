# tests.py in django_api app

from django.test import TestCase
from django.urls import reverse

class APITest(TestCase):
    def test_get_data(self):
        response = self.client.get(reverse('get_data'))
        self.assertEqual(response.status_code, 200)
        # Add more assertions to verify the response content
