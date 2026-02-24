

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
