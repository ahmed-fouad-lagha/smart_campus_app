import json
import ollama

# محاكاة لتحميل بيانات التخصصات من ملف JSON (يفترض أن الملف مخزن في ملف JSON محلي أو تم تحميله من مصدر آخر)
specialties_data = {
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
        ],
        "العلوم والتكنولوجيا / الهندسة الميكانيكية": [
            "هندسة المواد"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم اجتماعية- علم الاجتماع": [
            "علم الاجتماع"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم اجتماعية- علم السكان": [
            "علم السكان"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم اجتماعية- علم النفس": [
            "علم النفس العيادي"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم اجتماعية- فلسفة": [
            "فلسفة عامة"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم إنسانية –علوم الإعلام و الاتصال": [
            "إعلام"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم إنسانية- تاريخ": [
            "تاريخ عام"
        ],
        "الحقوق و العلوم السياسية/علوم سياسية": [
            "علاقات دولية"
        ],
        "الحقوق و العلوم السياسية/الحقوق": [
            "قانون عام",
            "قانون خاص"
        ],
        "آداب و لغات أجنبية/لغة انجليزية": [
            "لغة انجليزية"
        ],
        "آداب و لغات أجنبية/لغة فرنسية": [
            "لغة فرنسية"
        ],
        "لغة و أدب عربي/دراسات لغوية": [
            "لسانيات عامة"
        ],
        "لغة و أدب عربي/دراسات نقدية": [
            "نقد و مناهج"
        ],
        "لغة و أدب عربي/دراسات أدبية": [
            "أدب مقارن  عالمي",
            "أدب عربي"
        ],
        "علوم الطبيعة و الحياة/علوم التغذية": [
            "تكنولوجيا الأغذية و مراقبة النوعية"
        ],
        "علوم الطبيعة و الحياة/بيئة و محيط": [
            "علم البيئة و المحيط"
        ],
        "علوم الطبيعة و الحياة/علوم بيولوجية": [
            "بيولوجيا و فيزيولوجيا حيوانية",
            "علم الوراثة",
            "المياه و المحيط",
            "بيولوجيا و فيزيولوجيا نباتية",
            "علم الأحياء الدقيقة",
            "بيوكيمياء"
        ],
        "علوم الطبيعة و الحياة/علوم فلاحيه": [
            "إنتاج نباتي"
        ],
        "علوم اقتصادية و التسيير و علوم تجارية/علوم مالية و محاسبة": [
            "محاسبة و مالية"
        ],
        "علوم اقتصادية و التسيير و علوم تجارية/علوم التسيير": [
            "إدارة أعمال"
        ],
        "العلوم و التكنولوجيا/هندسة البيئة و علوم": [
            "هندسة الطرائق"
        ],
        "العلوم و التكنولوجيا/هندسة مدنية": [
            "هندسة مدنية"
        ],
        "العلوم و التكنولوجيا/كهروتقني": [
            "كهروتقني"
        ],
        "العلوم و التكنولوجيا/أشغال عمومية": [
            "أشغال عمومية"
        ],
        "العلوم و التكنولوجيا/آلية": [
            "آلية"
        ],
        "العلوم و التكنولوجيا/هندسة ميكانيكية": [
            "انشاء ميكانيكي"
        ],
        "العلوم و التكنولوجيا/اتصالات سلكية ولا سلكية": [
            "اتصالات سلكية ولا سلكية"
        ],
        "علوم المادة/فيزياء": [
            "فيزياء المواد"
        ],
        "علوم المادة/كيمياء": [
            "الكيمياء التحليلية",
            "الكيمياء الأساسية"
        ],
        "رياضيات وإعلام ألي/إعلام ألي": [
            "نظم المعلوماتیة SI",
            "هندسة أنظمة المعلومات والبرمجيات ISIL"
        ],
        "رياضيات وإعلام ألي/رياضيات": [
            "رياضيات"
        ]
    },
    "Master": {
        "علوم اقتصادية و التسيير و علوم تجارية/علوم تجارية": [
            "تسويق الخدمات"
        ],
        "علوم اقتصادية و التسيير و علوم تجارية/علوم التسيير": [
            "تسيير عمومي",
            "إدارة أعمال"
        ],
        "علوم اقتصادية و التسيير و علوم تجارية/علوم اقتصادية": [
            "اقتصاد نقدي و بنكي",
            "اقتصاد نقدي و مالي"
        ],
        "رياضيات وإعلام ألي/إعلام ألي": [
            "الذكاء الاصطناعي",
            "هندسة برمجية و الأنظمة الموزعة",
            "أمن و تكنولوجيات الواب"
        ],
        "علوم الطبيعة و الحياة/علوم زراعية": [
            "زراعة الأشجار المثمرة –زراعة التفاح-"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم اجتماعية- علم الاجتماع": [
            "علم الاجتماع التنظيم و العمل",
            "علم الاجتماع الحضري"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم اجتماعية- علم السكان": [
            "التخطيط الديموغرافي و التنمية"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم اجتماعية- علم النفس": [
            "علم النفس الصحة"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم اجتماعية- فلسفة": [
            "فلسفة عامة"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم إنسانية –علوم الإعلام و الاتصال": [
            "علوم الإعلام و الاتصال: السمعي البصري"
        ],
        "العلوم الإنسانية و الاجتماعية/علوم إنسانية- تاريخ": [
            "تاريخ المقاومة و الحركة الوطنية الجزائرية"
        ],
        "الحقوق و العلوم السياسية/علوم سياسية": [
            "دراسات استراتيجية و أمنية"
        ],
        "الحقوق و العلوم السياسية/الحقوق": [
            "القانون الخاص",
            "القانون الإداري",
            "القانون الجنائي و العلوم الجنائية",
            "ماسترالدولة و المؤسسات"
        ],
        "آداب و لغات أجنبية/لغة انجليزية": [
            "لغة و ثقافة",
            "تعليمية اللغات الأجنبية"
        ],
        "آداب و لغات أجنبية/لغة فرنسية": [
            "الأدب العام والمقارن",
            "علوم اللغة",
            "تعليمية اللغات الأجنبية"
        ],
        "لغة و أدب عربي/دراسات لغوية": [
            "لسانيات عامة"
        ],
        "لغة و أدب عربي/دراسات نقدية": [
            "نقد حديث و معاصر"
        ],
        "لغة و أدب عربي/دراسات أدبية": [
            "أدب عربي حديث و معاصر",
            "أدب عربي قديم",
            "أدب مقارن و عالمي"
        ],
        "علوم الطبيعة و الحياة/بيوتكنولوجيا": [
            "بيوتكنولوجيا النباتات"
        ],
        "علوم الطبيعة و الحياة/بيئة و محيط": [
            "حماية الأنظمة البيئية",
            "علم البيئة الأساسي و التطبيقي"
        ],
        "علوم الطبيعة و الحياة/علوم بيولوجية": [
            "ميكروبيولوجيا تطبيقية",
            "علم الوراثة",
            "بيولوجيا و مراقبة عشائر الحشرات",
            "بيوكيمياء تطبيقية"
        ],
        "علوم الطبيعة و الحياة/علوم فلاحيه": [
            "إنتاج نباتي"
        ],
        "علوم اقتصادية و التسيير و علوم تجارية/علوم مالية و محاسبة": [
            "محاسبة"
        ],
        "العلوم و التكنولوجيا/علوم و هندسة البيئة": [
            "هندسة الطرائق للبيئة"
        ],
        "العلوم و التكنولوجيا/هندسة مدنية": [
            "هياكل"
        ],
        "العلوم و التكنولوجيا/كهروتقني": [
            "تحكم كهربائي"
        ],
        "العلوم و التكنولوجيا/أشغال عمومية": [
            "طرقات و منشات فنية"
        ],
        "العلوم و التكنولوجيا/آلية": [
            "آلية واعلام الي صناعي"
        ],
        "العلوم و التكنولوجيا/هندسة ميكانيكية": [
            "هندسة المواد",
            "انشاء ميكانيكي",
            "هندسة ميكانيكية متخصصة"
        ],
        "العلوم و التكنولوجيا/اتصالات سلكية ولا سلكية": [
            "أنظمة الاتصالات"
        ],
        "علوم المادة/كيمياء": [
            "كيمياء المواد",
            "كيمياء تحليلية"
        ],
        "رياضيات وإعلام ألي/رياضيات": [
            "رياضيات تطبيقية"
        ]
    },
    "Doctorate": {
        "": [
            "التالي"
        ],
        "لغة و أدب عربي": [
            "لسانيات عربية",
            "الأدب العربي والأجنبي",
            "أدب عربي قديم",
            "تعليمية اللغات",
            "السرد العربي",
            "أدب عربي حديث ومعاصر",
            "أدب جزائري",
            "أدب مقارن",
            "تحليل الخطاب"
        ],
        "علوم اقتصادية و التسيير و علوم تجارية": [
            "إدارة مالية",
            "تسويق وتجارة",
            "اقتصاد نقدي وبنكي",
            "المالية وإدارة الأعمال",
            "تحليل اقتصادي واستشراف",
            "اقتصاد البيئة والتنمية المستدامة",
            "إدارة",
            "اقتصاد التنمية",
            "ريادة الأعمال وإدارة"
        ],
        "العلوم الإنسانية و الاجتماعية": [
            "علم اجتماع الأسري والتغير الاجتماعي",
            "علم اجتماع التنمية والحراك الاجتماعي",
            "تنظيم العمل وتنمية الموارد البشرية في المؤسسة",
            "ثقافة المدينة وتطور المجتمع"
        ],
        "الحقوق و العلوم السياسية": [
            "تنظيم سياسي وإداري",
            "قانون إداري وإدارة عامة",
            "القانون الاداري",
            "القانون المدني",
            "القانون الدولي الجنائي",
            "علم الاجرام والسياسة الاجرامية",
            "القانون الإداري",
            "العلاقات الدولية",
            "الدراسات الأمنية والإستراتيجية",
            "قانون البيئة"
        ],
        "رياضيات وإعلام ألي": [
            "أمن أنظمة الكمبيوتر والشبكات",
            "التحليل والتطبيقات الرياضية",
            "ذكاء إصطناعي",
            "الرياضيات التطبيقية",
            "رياضيات تطبيقية",
            "النمذجة والضوابط والتحسين",
            "هندسة البرمجيات والأنظمة الموزعة"
        ],
        "علوم المادة": [
            "الكيمياء الفيزيائية",
            "كيمياء صلبة",
            "الكيمياء العضوية",
            "فيزياء المواد",
            "كيمياء المواد",
            "كيمياء وفيزياء المادة المكثفة",
            "الكيمياء التحليلية",
            "كيمياء السطح والتآكل"
        ],
        "علوم الطبيعة و الحياة": [
            "حماية النظم البيئية",
            "الكيمياء الحيوية",
            "إيكولوجيا البيئات الطبيعية",
            "التكنولوجيا الحيوية النباتية",
            "وراثي",
            "علم البيئة والبيئة"
        ],
        "آداب و لغات أجنبية": [
            "تعليم اللغات والثقافات الأجنبية",
            "تعليم اللغة الإنجليزية",
            "تعليم النصوص الأدبية"
        ],
        "اداب و لغات أجنبية": [
            "تعليم اللغات والثقافات الأجنبية",
            "تعليم اللغة الإنجليزية",
            "تعليم النصوص الأدبية",
            "علوم اللغة"
        ],
        "العلوم و التكنولوجيا": [
            "هندسة المواد",
            "صناعة آلية ومعلوماتية",
            "علم الطاقة",
            "بناء ميكانيكي"
        ],
        "علوم الطبيعية و الحياة": [
            "التكنولوجيا الحيوية النباتية",
            "الكيمياء الحيوية"
        ],
        "رياضيات و إعلام ألي": [
            "الذكاء الاصطناعي ومعالجة الصور",
            "الرياضيات التطبيقية",
            "الذكاء الاصطناعي وتطبيقاته",
            "ذكاء إصطناعي"
        ],
        "علوم إقتصادية, تجارية و علوم التسيير": [
            "مقاولاتية وتسيير المؤسسة",
            "اقتصاد وحدوي وبنكي",
            "التحليل الاقتصادي والاسنشراف"
        ],
        "العلوم الإنسانية والاجتماعية": [
            "علم الاجتماع الحضري"
        ]
    }
}
# النظام الخاص بالمساعد الذكي
system_prompt = {
    "role": "system",
    "content": "You are an AI assistant that suggests university specializations based on a student's baccalaureate score and preferences."
}

# استدعاء مكتبة Ollama للحصول على الرد بناءً على درجة الطالب واهتمامات الطالب
def suggest_specializations(student_score, student_preferences):
    available_specialties = get_available_specialties_based_on_bac(student_score)
    
    # إنشاء الرسالة الموجهة إلى Ollama
    user_message = {
        "role": "user",
        "content": f"Based on the student's baccalaureate score of {student_score} and preferences {student_preferences}, here are the available specialties: {available_specialties}"
    }
    
    # استدعاء خدمة Ollama للحصول على الرد
    response = ollama.chat(
        model="llama2",  # تأكد من استخدام اسم النموذج الصحيح
        messages=[system_prompt, user_message]
    )
    
    # استرجاع التخصصات المقترحة من Ollama
    suggested_specialties = response['message']['content']
    return suggested_specialties

# دالة لتحديد التخصصات المتاحة بناءً على درجة الطالب
def get_available_specialties_based_on_bac(student_score):
    # مثال على تصنيف التخصصات بناءً على الدرجة
    if student_score >= 16:
        return specialties_data["License"]
    elif student_score >= 12:
        return specialties_data["Master"]
    else:
        return specialties_data["Doctorate"]

# مثال لاستخدام الكود مع درجة الطالب واهتماماته
"""student_name = input("Enter your name: ")
student_score = input("Enter your baccalaureate score: ")
student_preferences = input("Enter your preferences (comma-separated): ").split(",")
student_score = float(student_score)  # تحويل الدرجة إلى عدد عشري

suggested_specialties = suggest_specializations(student_score, student_preferences)

# طباعة التخصصات المقترحة
print(f"\nالتخصصات المقترحة لـ {student_name}: \n{suggested_specialties}")
"""