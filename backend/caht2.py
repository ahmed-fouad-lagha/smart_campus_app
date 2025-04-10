import json
import ollama

# بيانات التخصصات
master_specialties_json = '''{ 
    "License": { 
        "علوم اقتصادية و التسيير و علوم تجارية/علوم تجارية": [ 
            "تسويق", 
            "محاسبة" 
        ], 
        "الرياضيات والإعلام الآلي في العلوم الانسانية والاجتماعية": [ 
            "شعبة إعلام آلي" 
        ], 
        "علوم اقتصادية و التسيير و علوم تجارية/علوم اقتصادية": [ 
            "اقتصاد دولي", 
            "اقتصاد نقدي و مالي" 
        ]
    },
    "Master": {
        "علوم اقتصادية و التسيير و علوم تجارية/علوم تجارية": [ 
            "تسويق الخدمات" 
        ], 
        "رياضيات وإعلام ألي/إعلام ألي": [ 
            "الذكاء الاصطناعي", 
            "هندسة برمجية و الأنظمة الموزعة", 
            "أمن و تكنولوجيات الواب" 
        ]
    },
    "Doctorate": {
        "": [ 
            "التالي" 
        ],
        "علوم اقتصادية و التسيير و علوم تجارية": [ 
            "إدارة مالية", 
            "تسويق وتجارة" 
        ]
    }
}'''

# تحويل البيانات إلى JSON
master_specialties = json.loads(master_specialties_json)

# معلات الطالب في البكالوريا
student_score = 15  # على سبيل المثال، يمكن تغيير هذا الرقم

# تفضيلات الطالب (تخصصات يفضلها)
student_preferences = ["الذكاء الاصطناعي", "أمن و تكنولوجيات الواب"]

# تحديد التخصصات بناءً على معدل الطالب
def get_master_specialties_based_on_score(score, preferences):
    available_specialties = []
    if score >= 15:
        # إذا كان المعدل أكبر من أو يساوي 15، يمكن للطالب الاختيار من التخصصات الأكثر صعوبة
        available_specialties = master_specialties['Master']['رياضيات وإعلام ألي/إعلام ألي']
    elif score >= 12:
        # إذا كان المعدل بين 12 و 15، يمكن للطالب الاختيار من التخصصات المتوسطة
        available_specialties = master_specialties['Master']['علوم اقتصادية و التسيير و علوم تجارية/علوم تجارية']
    
    # دمج التفضيلات مع التخصصات المتاحة
    preferred_specialties = [spec for spec in available_specialties if spec in preferences]
    
    return preferred_specialties if preferred_specialties else available_specialties

# اختيار التخصصات بناءً على معدل الطالب وتفضيلاته
available_specialties = get_master_specialties_based_on_score(student_score, student_preferences)

# إضافة system prompt
system_prompt = {
    "role": "system",
    "content": "You are a helpful assistant designed to help students choose their university specialties based on their baccalaureate scores and preferences. You must provide recommendations that are both relevant and personalized. Always take into account the student's score and preferences when offering suggestions."
}

# إرسال الطلب إلى Ollama مع التخصصات المناسبة
response = ollama.chat(
    model="llama2",  # استبدل هذا باسم النموذج الصحيح
    messages=[system_prompt, {
        "role": "user",
        "content": f"Based on the student's baccalaureate score of {student_score} and preferences {student_preferences}, here are the available specialties: {available_specialties}"
    }]
)

# طباعة الاستجابة من Ollama
print(response['message']['content'])
