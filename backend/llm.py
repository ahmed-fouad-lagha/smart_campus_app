from pydantic import BaseModel ,Field
from openai import OpenAI
import instructor
import datetime as dt
class LLM(BaseModel):
    title: str = Field(...,description="Name of the event")
    time : dt.datetime = Field(...,description="Time of the event")
    location: str
    url: str
    university: str
    event_type: str
    event_id: str = Field(...,description="Unique identifier for the event")
    event_description: str = Field(...,description="Description of the event")

claint = instructor.from_openai(
    OpenAI(
        base_url='http://localhost:11434/v1',
        api_key='ollama',

    ),
     mode=instructor.Mode.JSON
    )


response = claint.messages.create(
    model='qwen2.5:latest',
    messages=[{
        'role': 'user',
        'content': f'المسابقة الوطنية للبرمجة في جامعة الملك سعود تحتوي على عدة مسابقات في البرمجة، مثل مسابقة البرمجة التنافسية، ومسابقة تطوير التطبيقات، ومسابقة الذكاء الاصطناعي. يتم تنظيم هذه المسابقات سنويًا وتستقطب العديد من الطلاب من مختلف الجامعات. تهدف هذه المسابقات إلى تعزيز مهارات البرمجة والتفكير النقدي لدى الطلاب، وتوفير منصة للتنافس والتعلم. يمكن للطلاب المشاركة في هذه المسابقات بشكل فردي أو كفريق، ويتم تقييم المشاركات بناءً على معايير محددة مثل الابتكار والأداء الفني. بتاريح 24/10/2023 في جامعة الملك سعود، الرياض، المملكة العربية السعودية. نوع الحدث: مسابقة برمجة. رابط الحدث: https://www.ksu.edu.sa/competition. وصف الحدث: هذه المسابقة تهدف إلى تعزيز مهارات البرمجة لدى الطلاب وتوفير منصة للتنافس والتعلم. يمكن للطلاب المشاركة بشكل فردي أو كفريق. يتم تقييم المشاركات بناءً على الابتكار والأداء الفني.', 
    }],
    response_model=LLM
    )
print(response)