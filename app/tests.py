from django.test import SimpleTestCase
from app.calc import add


class CalcTests(SimpleTestCase):

    def test_add_numbers(self):
        self.assertEqual(add(3, 8), 11)

    def test_add_negative_numbers(self):
        self.assertEqual(add(-3, -6), -9)

    def test_fail_add_numbers(self):
        self.assertNotEqual(add(5, 5), 11)
