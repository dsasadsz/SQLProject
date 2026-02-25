1-қадам: PostgreSQL орнатуЕң алдымен компьютеріңізде PostgreSQL ДҚБЖ орнатылған болуы тиіс. Егер жоқ болса, ресми сайттан жүктеп алыңыз.

2-қадам: Деректер қорын құруPostgreSQL терминалын немесе pgAdmin құралын ашып, жаңа деректер қорын құрыңыз:
SQLCREATE DATABASE hotel_db;

3-қадам: Рөлдер мен пайдаланушыларды баптауДҚ-ны басқару үшін келесі скриптті орындаңыз (бұл қауіпсіздік пен қолжетімділікті басқару үшін қажет):Жаңа пайдаланушылар құру.Рөлдерді анықтау және артықшылықтар беру.

4-қадам: Схеманы құруschema.sql файлын орындаңыз. Бұл кезеңде:Концептуалды және логикалық модельдер іске асады.Кестелер құрылып, олардың арасындағы қатынастар (1:1, 1:M) орнатылады.Негізгі (PK) және сыртқы кілттер (FK) анықталады.Деректердің шектеулері (NOT NULL, UNIQUE, CHECK) қойылады.

5-қадам: Өнімділікті оңтайландыруФизикалық модельді тиімді ету үшін индекстер қосылып, кестелер көлемі оңтайландырылды.


(project.sql соныңда "--тест"  мысал бар)
Тестілік сұраныстар (Testing Queries)
Жүйенің дұрыс жұмыс істейтінін тексеру үшін келесі күрделі SQL сұраныстары орындалды:
JOIN сұранысы: Бірнеше кестелерді біріктіру арқылы ақпарат алу.
Агрегаттық функциялар: SUM, AVG, COUNT қолдану.
Фильтрация: GROUP BY, HAVING және күрделі WHERE шарттары.
Индекстерді тексеру: Сұраныстардың орындалу жылдамдығын бақылау.



```mermaid

erDiagram
    Room_Categories {
        int category_id PK
        varchar category_name
        numeric price_per_night
    }
    
    Rooms {
        int room_id PK
        varchar room_number
        int category_id FK
        varchar status
    }
    
    Guests {
        int guest_id PK
        varchar first_name
        varchar last_name
        varchar phone
        varchar email
    }
    
    Employees {
        int employee_id PK
        varchar first_name
        varchar last_name
        varchar position
        varchar gender
    }
    
    Bookings {
        int booking_id PK
        int guest_id FK
        int room_id FK
        int employee_id FK
        date check_in_date
        date check_out_date
    }
    
    Payments {
        int payment_id PK
        int booking_id FK
        numeric amount
        date payment_date
        varchar payment_method
    }

    %% Определение связей (Relations)
    Room_Categories ||--o{ Rooms : "қамтиды (has)"
    Guests ||--o{ Bookings : "жасайды (makes)"
    Rooms ||--o{ Bookings : "брондалады (booked)"
    Employees ||--o{ Bookings : "рәсімдейді (processes)"
    Bookings ||--|| Payments : "төленеді (paid via)"

 ```
