from django.db import models


class muscles(models.Model):
    muscle= models.CharField(max_length=30, primary_key=True)
    group = models.CharField(max_length=30)
    paircode = models.CharField(max_length=10)

    def __str__(self):
        return self.muscle

class levels(models.Model):
    level= models.CharField(max_length=30, primary_key=True)
    number = models.CharField(max_length=30)
    
    def __str__(self):
        return self.level


class exercises(models.Model):
    exercise = models.CharField(max_length=30, primary_key=True)
    muscle = models.ForeignKey(muscles, on_delete=models.CASCADE, to_field='muscle')
    level = models.ForeignKey(levels, on_delete=models.CASCADE, to_field='level')
    equip = models.CharField(max_length=30)

    def __str__(self):
        return self.exercise
    
class goals(models.Model):
    goal = models.CharField(max_length=30, primary_key=True)
    sets = models.CharField(max_length=30)
    reps = models.CharField(max_length=30)
    progover = models.CharField(max_length=30)

    def __str__(self):
        return self.goal
