import json
import ollama

# تحميل التخصصات من ملف specializations.json
with open("specializations.json", "r", encoding="utf-8") as file:
    specializations = json.load(file)

# التحقق من أن التخصصات تم تحميلها بشكل صحيح

# تطلب من المستخدم إدخال اسم الطالب وعلاماته واهتماماته
student_name = input("أدخل اسمك: ")
student_score = float(input(f"أدخل درجتك في البكالوريا، {student_name}: "))
student_preferences = input("أدخل اهتماماتك (مفصولة بفواصل): ").split(",")

# تحديد التصنيف المناسب بناءً على درجة الطالب (على سبيل المثال، إذا كانت الدرجة أعلى من 12 يتم ترشيح تخصصات الماجستير، إذا كانت أقل يتم ترشيح تخصصات البكالوريا)
if student_score >= 16:
    classification = "Doctorate"
elif student_score >= 12:
    classification = "Master"
else:
    classification = "License"

# استخراج التخصصات المتاحة بناءً على التصنيف
available_specialties = []
for field, specializations_list in specializations[classification].items():
    available_specialties.append((field, specializations_list))

# إعداد الرسالة المبدئية (system prompt) التي ستوجه النموذج
system_prompt = {
    "role": "system",
    "content": "You are an AI assistant that suggests university specializations based on a student's baccalaureate score and preferences."
}

# استدعاء خدمة Ollama للحصول على الرد بناءً على درجة الطالب واهتمامات الطالب
response = ollama.chat(
    model="llama2",  # تأكد من استخدام اسم النموذج الصحيح
    messages=[system_prompt, {
        "role": "user",
        "content": f"Based on the student's baccalaureate score of {student_score} and preferences {student_preferences}, here are the available specialties: {available_specialties}"
    }]
)

# طباعة الاستجابة من Ollama
suggested_specialties = response['message']['content']
print(f"\nالتخصصات المقترحة لـ {student_name}: \n{suggested_specialties}")
