CREATE ROLE hotel_admin;
CREATE ROLE hotel_manager;

--  артықшылықтар 
GRANT ALL PRIVILEGES ON DATABASE hotel_db TO hotel_admin;
GRANT SELECT, INSERT, UPDATE ON ALL TABLES IN SCHEMA public TO hotel_manager;

-- Пайдаланушыларды құру және рөлдерді тағайындау
CREATE USER admin_user WITH PASSWORD 'admin123';
GRANT hotel_admin TO admin_user;

CREATE USER manager_user WITH PASSWORD 'manager123';
GRANT hotel_manager TO manager_user;











-- Кестелерді құру және деректердің шектеулерін анықтау (Default value, CHECK, NOT NULL, UNIQUE)
CREATE TABLE Room_Categories (
    category_id SERIAL PRIMARY KEY,
    category_name VARCHAR(100) NOT NULL UNIQUE,
    price_per_night NUMERIC(10, 2) NOT NULL CHECK (price_per_night > 0)
);

CREATE TABLE Rooms (
    room_id SERIAL PRIMARY KEY,
    room_number VARCHAR(10) NOT NULL UNIQUE,
    category_id INTEGER NOT NULL,
    status VARCHAR(20) DEFAULT 'Available' CHECK (status IN ('Available', 'Occupied', 'Maintenance')),
    CONSTRAINT fk_category FOREIGN KEY (category_id) REFERENCES Room_Categories(category_id)
);

CREATE TABLE Guests (
    guest_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    email VARCHAR(100) UNIQUE
);

CREATE TABLE Employees (
    employee_id SERIAL PRIMARY KEY,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    position VARCHAR(50) NOT NULL,
    gender VARCHAR(10) CHECK (gender IN ('Male', 'Female'))
);

CREATE TABLE Bookings (
    booking_id SERIAL PRIMARY KEY,
    guest_id INTEGER NOT NULL,
    room_id INTEGER NOT NULL,
    employee_id INTEGER NOT NULL,
    check_in_date DATE NOT NULL,
    check_out_date DATE NOT NULL,
    CONSTRAINT fk_guest FOREIGN KEY (guest_id) REFERENCES Guests(guest_id),
    CONSTRAINT fk_room FOREIGN KEY (room_id) REFERENCES Rooms(room_id),
    CONSTRAINT fk_employee FOREIGN KEY (employee_id) REFERENCES Employees(employee_id),
    CHECK (check_out_date > check_in_date)
);

CREATE TABLE Payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INTEGER NOT NULL UNIQUE,
    amount NUMERIC(10, 2) NOT NULL,
    payment_date DATE DEFAULT CURRENT_DATE,
    payment_method VARCHAR(50) CHECK (payment_method IN ('Cash', 'Card', 'Online')),
    CONSTRAINT fk_booking FOREIGN KEY (booking_id) REFERENCES Bookings(booking_id)
);






--Индекстерді қосу және оңтайландыру
CREATE INDEX idx_guest_phone ON Guests(phone);
CREATE INDEX idx_booking_dates ON Bookings(check_in_date, check_out_date);





--Деректерді енгізу (Кіріспе тестілеу үшін)

INSERT INTO Room_Categories (category_name, price_per_night) VALUES ('Standard', 15000.00), ('Luxe', 35000.00);
INSERT INTO Rooms (room_number, category_id) VALUES ('101', 1), ('102', 1), ('201', 2);
INSERT INTO Guests (first_name, last_name, phone) VALUES ('Асан', 'Үсенов', '+77010000000');
INSERT INTO Employees (first_name, last_name, position, gender) VALUES ('Айгерім', 'Мақсатқызы', 'Ресепшен', 'Female');
INSERT INTO Bookings (guest_id, room_id, employee_id, check_in_date, check_out_date) VALUES (1, 3, 1, '2025-03-01', '2025-03-05');
INSERT INTO Payments (booking_id, amount, payment_method) VALUES (1, 140000.00, 'Card');







--тест: 
--kестелерді біріктіретін JOIN сұранысы (Қонақтардың қай бөлмеде тұрып жатқанын көру 
SELECT g.first_name, g.last_name, r.room_number, rc.category_name, b.check_in_date 
FROM Bookings b
JOIN Guests g ON b.guest_id = g.guest_id
JOIN Rooms r ON b.room_id = r.room_id
JOIN Room_Categories rc ON r.category_id = rc.category_id;





-- Агрегаттық функцияларды қолдану (SUM, COUNT) және GROUP BY мен HAVING сұранысы (Санаты бойынша 50000-нан көп табыс әкелген бөлмелер)
SELECT rc.category_name, COUNT(b.booking_id) AS total_bookings, SUM(p.amount) AS total_revenue
FROM Room_Categories rc
JOIN Rooms r ON rc.category_id = r.category_id
JOIN Bookings b ON r.room_id = b.room_id
JOIN Payments p ON b.booking_id = p.booking_id
GROUP BY rc.category_name



  --Күрделі шарттарды қолданатын WHERE фильтрациясы (Белгілі бір уақыт аралығындағы брондар):
  SELECT * FROM Bookings
WHERE check_in_date >= '2025-03-01' AND check_out_date <= '2025-03-31'
AND room_id IN (SELECT room_id FROM Rooms WHERE status = 'Available');
HAVING SUM(p.amount) > 50000;


--Индекстердің тиімділігін тексеретін сұраныс (Қонақты телефон нөмірі арқылы жылдам іздеу):
EXPLAIN ANALYZE SELECT * FROM Guests WHERE phone = '+77010000000';
