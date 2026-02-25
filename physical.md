```mermaid

erDiagram
    Room_Categories {
        int category_id PK "SERIAL, NOT NULL"
        varchar category_name "100, UNIQUE, NOT NULL"
        numeric price_per_night "10,2, CHECK (>0)"
    }
    
    Rooms {
        int room_id PK "SERIAL, NOT NULL"
        varchar room_number "10, UNIQUE, NOT NULL"
        int category_id FK "REFERENCES Room_Categories"
        varchar status "20, DEFAULT 'Available'"
    }
    
    Guests {
        int guest_id PK "SERIAL, NOT NULL"
        varchar first_name "100, NOT NULL"
        varchar last_name "100, NOT NULL"
        varchar phone "20, UNIQUE"
        varchar email "100, UNIQUE"
    }
    
    Employees {
        int employee_id PK "SERIAL, NOT NULL"
        varchar first_name "100, NOT NULL"
        varchar last_name "100, NOT NULL"
        varchar position "50, NOT NULL"
        varchar gender "10, CHECK (Male/Female)"
    }
    
    Bookings {
        int booking_id PK "SERIAL, NOT NULL"
        int guest_id FK "REFERENCES Guests"
        int room_id FK "REFERENCES Rooms"
        int employee_id FK "REFERENCES Employees"
        date check_in_date "NOT NULL"
        date check_out_date "NOT NULL, CHECK (>check_in)"
    }
    
    Payments {
        int payment_id PK "SERIAL, NOT NULL"
        int booking_id FK "UNIQUE, REFERENCES Bookings"
        numeric amount "10,2, NOT NULL"
        date payment_date "DEFAULT CURRENT_DATE"
        varchar payment_method "50, CHECK (Cash/Card/Online)"
    }

    Room_Categories ||--o{ Rooms : "defines"
    Guests ||--o{ Bookings : "makes"
    Rooms ||--o{ Bookings : "is_reserved"
    Employees ||--o{ Bookings : "processes"
    Bookings ||--|| Payments : "settles"


 ```
