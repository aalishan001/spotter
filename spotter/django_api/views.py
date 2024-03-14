from django.http import JsonResponse
from database.models import muscles, levels, exercises, goals
from django.db.models import Q
from django.core.serializers import serialize
from django.views.decorators.http import require_http_methods


@require_http_methods(["GET", "OPTIONS"])
def get_routine(request):

    goal = request.GET.get('goal')
    equip = request.GET.get('equip')
    exp = request.GET.get('exp')

#only 6 day, bro split in use right now
    
    level_object = levels.objects.filter(level=exp).first()  
    if level_object:
        noofexercise = int(level_object.number)  
    else:

        noofexercise = 6  


    sets = list(goals.objects.filter(goal=goal).values('sets'))
    reps = list(goals.objects.filter(goal=goal).values('reps'))
    progover = list(goals.objects.filter(goal=goal).values('progover'))
    
 


# days and named and fixed with muscle and muscles are fixed with pairs TEMPORARY

    mon = list(exercises.objects.filter(equip=equip,level_id=exp,muscle__group= 'chest')[:noofexercise].values('exercise','muscle_id'))

    tue = list(exercises.objects.filter(equip=equip,level_id=exp,muscle__group= 'tricep')[:noofexercise].values('exercise','muscle_id'))

    wed = list(exercises.objects.filter(equip=equip,level_id=exp,muscle__group= 'back')[:noofexercise].values('exercise','muscle_id'))

    thu = list(exercises.objects.filter(equip=equip,level_id=exp,muscle__group= 'bicep')[:noofexercise].values('exercise','muscle_id'))

    fri = list(exercises.objects.filter(equip=equip,level_id=exp,muscle__group= 'legs')[:noofexercise].values('exercise','muscle_id'))

    sat = list(exercises.objects.filter(equip=equip,level_id=exp,muscle__group= 'shoulder')[:noofexercise].values('exercise','muscle_id'))



    return JsonResponse({
        'goal' : goal,
        'equip' : equip,
        'exp' : exp,
        'sets': sets,
        'reps': reps,
        'progover': progover,
        'MONDAY': mon,
        'TUESDAY': tue,
        'WEDNESDAY': wed,
        'THURSDAY': thu,
        'FRIDAY': fri,
        'SATURDAY': sat,
    }, safe=False)
