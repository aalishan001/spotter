from django.http import JsonResponse
from database.models import muscles, levels, exercises, goals
from django.db.models import Q

def get_routine(request):

    goal = request.GET.get('goal')
    equip = request.GET.get('equip')
    exp = request.GET.get('exp')

#only 6 day, bro split in use right now
    
    noofexercise = int(levels.objects.filter(level=exp).values('number'))

    sets = goals.objects.filter(goal=goal).values('sets')
    reps = goals.objects.filter(goal=goal).values('reps')
    progover = goals.objects.filter(goal=goal).values('progover')
    
 

    exer_all = exercises.objects.filter(equip=equip,level_id=exp)

# days and named and fixed with muscle and muscles are fixed with pairs TEMPORARY

    mon = exer_all.filter(muscles__group= 'chest')[:noofexercise]

    tue = exer_all.filter(muscles__group= 'tricep')[:noofexercise]

    wed = exer_all.filter(muscles__group= 'back')[:noofexercise]

    thu = exer_all.filter(muscles__group='bicep')[:noofexercise]

    fri = exer_all.filter(muscles__group='legs')[:noofexercise]

    sat = exer_all.filter(muscles__group='shoulder')[:noofexercise]



    return JsonResponse({
        'sets': sets,
        'reps': reps,
        'progover': progover,
        'mon': mon,
        'tue': tue,
        'wed': wed,
        'thu': thu,
        'fri': fri,
        'sat': sat,
    }, safe=False)
