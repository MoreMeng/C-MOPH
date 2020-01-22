# CCD_OPD_VISIT_SCREEN
รายละเอียดการคัดกรอง

| column name     | type    |  len | dec | Not Null | remark                                                              |
| --------------- | ------- | ---: | --- | :------: | ------------------------------------------------------------------- |
| hospcode         | varchar | 5   |     | Y        | รหัสหน่วยบริการ 5 หลัก                                    |
| hn               | varchar | 9   |     | Y        | เลขประจำตัวผู้ป่วยนอกของโรงพยาบาล                         |
| vn               | varchar | 15  |     | Y        | หมายเลขของการมารับบริการของผู้ป่วยนอกประจำวัน             |
| cc               | text    |     |     |          | Chief Complain                                            |
| hpi              | text    |     |     |          | ประวัติการเจ็บป่วยในปัจจุบัน (History of present illness) |
| dbp              | int     | 3   |     |          | Diastolic Blood Pressure                                  |
| sbp              | int     | 3   |     |          | Systolic Blood Pressure                                   |
| pulse            | int     | 3   |     |          | ชีพจร                                                     |
| respiratory_rate | int     | 3   |     |          | อัตราการหายใจ                                             |
| temperature      | float   | 3   | 2   |          | อุณหภูมิ                                                  |
| weight           | float   | 3   | 2   |          | น้ำหนัก (หน่วย : กิโลกรัม)                                |
| height           | float   | 3   | 2   |          | ส่วนสูง (หน่วย : เซ็นติเมตร)                              |
| bmi              | float   | 3   | 2   |          | ดัชนีมวลกาย (Body mass index)                             |
| waist            | float   | 3   | 2   |          | รอบเอว (หน่วย : เซ็นติเมตร)                               |
| pe               | text    |     |     |          | การตรวจร่างกายของแพทย์ (Physical Examination)             |
| alcohol_use      | int     | 1   |     |          | ดื่มสุรา 0=NA, 1=Yes, 2=No                                |
| cigar_use        | int     | 1   |     |          | สูบบุหรี่ 0=NA, 1=Yes, 2=No                               |
| pregnant         | varchar | 1   |     |          | หญิงตั้งครรภ์ (Y=ตั้งครรภ์, N=ไม่ตั้งครรภ์)               |
| lactation        | varchar | 15  |     |          | หญิงให้นมบุตร (Y=ให้นมบุตร, N=ไม่ได้ให้นมบุตร)            |
| pain_score       | int     | 11  |     |          | ค่า Pain Score                                            |
| note             | varchar | 15  |     |          | หมายเหตุ                                                  |

> ## หมายเหตุ
> ~~ข้อความที่ถูกขีดกลาง~~ ยังไม่ใช้งาน หรือ ยังไม่ได้กำหนดให้ใช้