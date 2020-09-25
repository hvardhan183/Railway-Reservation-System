CREATE TABLE User_details
(
	user_id VARCHAR2(15) NOT NULL,
	first_name VARCHAR2(15) NOT NULL,
	last_name VARCHAR2(15) NOT NULL,
	gender CHAR NOT NULL,
	date_of_birth DATE NOT NULL,
	mobile_no NUMBER(10) NOT NULL UNIQUE,
	email VARCHAR2(20) NOT NULL UNIQUE,
	city VARCHAR2(20) NOT NULL,
	state VARCHAR2(20) NOT NULL,
	pincode NUMBER(6) NOT NULL,
	password VARCHAR2(15) NOT NULL,
	security_ques VARCHAR2(30) NOT NULL,
	security_ans VARCHAR2(30) NOT NULL,
	CONSTRAINT pku PRIMARY KEY (user_id)
);


CREATE TABLE Train
(
	train_no NUMBER(5) NOT NULL,
	train_name VARCHAR2(20) NOT NULL,
	CONSTRAINT pkt PRIMARY KEY (train_no)
);


CREATE TABLE Station
(
	station_id NUMBER NOT NULL,
	station_name VARCHAR2(20) NOT NULL,
	CONSTRAINT pks PRIMARY KEY (station_id)
);


CREATE TABLE Train_route
(
	train_no NUMBER(5) NOT NULL,
	station_id NUMBER NOT NULL,
	train_arrival TIMESTAMP NOT NULL,
	train_depart TIMESTAMP NOT NULL,
	train_day NUMBER NOT NULL,
	route_order NUMBER NOT NULL,
	CONSTRAINT fkrt FOREIGN KEY (train_no) REFERENCES Train(train_no),
	CONSTRAINT fkrs FOREIGN KEY (station_id) REFERENCES Station(station_id),
	CONSTRAINT pkr PRIMARY KEY (train_no,station_id)
);

CREATE TABLE Train_seats
(
	train_no NUMBER(5) NOT NULL,
	coach VARCHAR2(5) NOT NULL,
	seat_no NUMBER NOT NULL,
	date_of_journey DATE NOT NULL,
	status NUMBER,
	CONSTRAINT fkts FOREIGN KEY (train_no) REFERENCES Train(train_no),
	CONSTRAINT pkts PRIMARY KEY (train_no,coach,seat_no,date_of_journey)
);



CREATE SEQUENCE pnr_seq START WITH 111111;


CREATE TABLE Ticket_details
(
	pnr_no NUMBER DEFAULT pnr_seq.nextval,
	user_id VARCHAR2(15) NOT NULL,
	passenger_count NUMBER NOT NULL,
	train_no NUMBER(5) NOT NULL,
	class VARCHAR2(5) NOT NULL,
	start_station NUMBER NOT NULL,
	end_station NUMBER NOT NULL,
	depart_time TIMESTAMP NOT NULL,
	arrival_time TIMESTAMP NOT NULL,
	date_of_booking DATE NOT NULL,
	fare NUMBER NOT NULL,
	CONSTRAINT pktd PRIMARY KEY (pnr_no),
	CONSTRAINT fktds FOREIGN KEY (start_station) REFERENCES Station(station_id),
	CONSTRAINT fktde FOREIGN KEY (end_station) REFERENCES Station(station_id),
	CONSTRAINT fktdt FOREIGN KEY (train_no) REFERENCES Train(train_no),
	CONSTRAINT fktdu FOREIGN KEY (user_id) REFERENCES User_details(user_id)
);


CREATE TABLE Ticket_booking
(
	pnr_no NUMBER,
	passenger_count NUMBER NOT NULL,
	passenger_id NUMBER NOT NULL,
	passenger_name VARCHAR2(15) NOT NULL,
	gender CHAR NOT NULL,
	age NUMBER NOT NULL,
	berth_pref VARCHAR2(2),
	status VARCHAR2(5),
	CONSTRAINT pktb PRIMARY KEY (pnr_no,passenger_id),
	CONSTRAINT fktbp FOREIGN KEY (pnr_no) REFERENCES Ticket_details(pnr_no)
);


CREATE TABLE Seat_status
(
	train_no NUMBER(5) NOT NULL,
	coach VARCHAR2(5) NOT NULL,
	seat_no NUMBER NOT NULL,
	date_of_journey DATE NOT NULL,
	pnr_no NUMBER NOT NULL,
	pnr_id NUMBER NOT NULL,
	status NUMBER NOT NULL,
	CONSTRAINT pkss PRIMARY KEY (pnr_no,pnr_id),
	CONSTRAINT fkss1 FOREIGN KEY (train_no, coach, seat_no, date_of_journey) REFERENCES Train_seats (train_no, coach, seat_no, date_of_journey),
	CONSTRAINT fkss2 FOREIGN KEY (pnr_no,pnr_id) REFERENCES Ticket_booking (pnr_no,passenger_id)
);


INSERT INTO Train (train_no,train_name) VALUES (11019,'Konark Express');
INSERT INTO Train (train_no,train_name) VALUES (11020,'Konark Express');
INSERT INTO Train (train_no,train_name) VALUES (12703,'Faluknuma Express');
INSERT INTO Train (train_no,train_name) VALUES (12704,'Faluknuma Express');
INSERT INTO Train (train_no,train_name) VALUES (12759,'Charminar Express');
INSERT INTO Train (train_no,train_name) VALUES (12760,'Charminar Express');

INSERT INTO Station (station_id,station_name) VALUES (1 ,'Mumbai');
INSERT INTO Station (station_id,station_name) VALUES (2 ,'Dadar');
INSERT INTO Station (station_id,station_name) VALUES (3 ,'Kalyan Junction');
INSERT INTO Station (station_id,station_name) VALUES (4 ,'Karjat');
INSERT INTO Station (station_id,station_name) VALUES (5 ,'Lonavala');
INSERT INTO Station (station_id,station_name) VALUES (6 ,'Pune Junction');
INSERT INTO Station (station_id,station_name) VALUES (7 ,'Daund Junction');
INSERT INTO Station (station_id,station_name) VALUES (8 ,'Solapur Junction');
INSERT INTO Station (station_id,station_name) VALUES (9 ,'Gulbarga');
INSERT INTO Station (station_id,station_name) VALUES (10 ,'Wadi');
INSERT INTO Station (station_id,station_name) VALUES (11 ,'Seram');
INSERT INTO Station (station_id,station_name) VALUES (12 ,'Tandur');
INSERT INTO Station (station_id,station_name) VALUES (13 ,'Begampet');
INSERT INTO Station (station_id,station_name) VALUES (14 ,'Secunderabad');
INSERT INTO Station (station_id,station_name) VALUES (15 ,'Kazipet Junction');
INSERT INTO Station (station_id,station_name) VALUES (16 ,'Warangal');
INSERT INTO Station (station_id,station_name) VALUES (17 ,'Mahbubabad');
INSERT INTO Station (station_id,station_name) VALUES (18 ,'Khammam');
INSERT INTO Station (station_id,station_name) VALUES (19 ,'Madhira');
INSERT INTO Station (station_id,station_name) VALUES (20 ,'Vijayawada Junction');
INSERT INTO Station (station_id,station_name) VALUES (21 ,'Eluru');
INSERT INTO Station (station_id,station_name) VALUES (22 ,'Tadepalligudem');
INSERT INTO Station (station_id,station_name) VALUES (23 ,'Nidadavolu Junction');
INSERT INTO Station (station_id,station_name) VALUES (24 ,'Rajamundry');
INSERT INTO Station (station_id,station_name) VALUES (25 ,'Samalkot Junction');
INSERT INTO Station (station_id,station_name) VALUES (26 ,'Tuni');
INSERT INTO Station (station_id,station_name) VALUES (27 ,'Anakapalle');
INSERT INTO Station (station_id,station_name) VALUES (28 ,'Vishakapatnam');
INSERT INTO Station (station_id,station_name) VALUES (29 ,'Vizianagram Junction');
INSERT INTO Station (station_id,station_name) VALUES (30 ,'Srikakulam Road');
INSERT INTO Station (station_id,station_name) VALUES (31 ,'Palasa');
INSERT INTO Station (station_id,station_name) VALUES (32 ,'Sompeta');
INSERT INTO Station (station_id,station_name) VALUES (33 ,'Ichchpuram');
INSERT INTO Station (station_id,station_name) VALUES (34 ,'Brahmapur');
INSERT INTO Station (station_id,station_name) VALUES (35 ,'Chatrapur');
INSERT INTO Station (station_id,station_name) VALUES (36 ,'Balugan');
INSERT INTO Station (station_id,station_name) VALUES (37 ,'Khurda Road Junction');
INSERT INTO Station (station_id,station_name) VALUES (38 ,'Bhubaneswar');
INSERT INTO Station (station_id,station_name) VALUES (39 ,'Nalgonda');
INSERT INTO Station (station_id,station_name) VALUES (40 ,'Miryalaguda');
INSERT INTO Station (station_id,station_name) VALUES (41 ,'Piduguralla');
INSERT INTO Station (station_id,station_name) VALUES (42 ,'Guntur Junction');
INSERT INTO Station (station_id,station_name) VALUES (43 ,'Cuttack');
INSERT INTO Station (station_id,station_name) VALUES (44 ,'Jajpur K Road');
INSERT INTO Station (station_id,station_name) VALUES (45 ,'Bhadrakh');
INSERT INTO Station (station_id,station_name) VALUES (46 ,'Balasore');
INSERT INTO Station (station_id,station_name) VALUES (47 ,'Kharagpur Junction');
INSERT INTO Station (station_id,station_name) VALUES (48 ,'Santragachi Junction');
INSERT INTO Station (station_id,station_name) VALUES (49 ,'Howrah Junction');
INSERT INTO Station (station_id,station_name) VALUES (50 ,'Tenali Junction');
INSERT INTO Station (station_id,station_name) VALUES (51 ,'Chirala');
INSERT INTO Station (station_id,station_name) VALUES (52 ,'Ongole');
INSERT INTO Station (station_id,station_name) VALUES (53 ,'Kavali');
INSERT INTO Station (station_id,station_name) VALUES (54 ,'Nellore');
INSERT INTO Station (station_id,station_name) VALUES (55 ,'Gudur Junction');
INSERT INTO Station (station_id,station_name) VALUES (56 ,'Nayadupeta');
INSERT INTO Station (station_id,station_name) VALUES (57 ,'Sullurupeta');
INSERT INTO Station (station_id,station_name) VALUES (58 ,'Chennai Central');



INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,1,TO_DATE('2000/01/01 15:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 15:10:00','YYYY/MM/DD HH24:MI:SS'),1,1);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,2,TO_DATE('2000/01/01 15:23:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 15:25:00','YYYY/MM/DD HH24:MI:SS'),1,2);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,3,TO_DATE('2000/01/01 16:06:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:08:00','YYYY/MM/DD HH24:MI:SS'),1,3);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,4,TO_DATE('2000/01/01 16:48:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:50:00','YYYY/MM/DD HH24:MI:SS'),1,4);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,5,TO_DATE('2000/01/01 17:38:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 17:40:00','YYYY/MM/DD HH24:MI:SS'),1,5);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,6,TO_DATE('2000/01/01 19:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 19:05:00','YYYY/MM/DD HH24:MI:SS'),1,6);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,7,TO_DATE('2000/01/01 20:35:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 20:40:00','YYYY/MM/DD HH24:MI:SS'),1,7);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,8,TO_DATE('2000/01/01 00:15:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:25:00','YYYY/MM/DD HH24:MI:SS'),2,8);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,9,TO_DATE('2000/01/01 02:31:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 02:33:00','YYYY/MM/DD HH24:MI:SS'),2,9);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,10,TO_DATE('2000/01/01 03:55:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:00:00','YYYY/MM/DD HH24:MI:SS'),2,10);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,11,TO_DATE('2000/01/01 04:24:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:25:00','YYYY/MM/DD HH24:MI:SS'),2,11);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,12,TO_DATE('2000/01/01 04:48:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:50:00','YYYY/MM/DD HH24:MI:SS'),2,12);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,13,TO_DATE('2000/01/01 07:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 07:02:00','YYYY/MM/DD HH24:MI:SS'),2,13);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,14,TO_DATE('2000/01/01 07:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 08:00:00','YYYY/MM/DD HH24:MI:SS'),2,14);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,15,TO_DATE('2000/01/01 10:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 10:20:00','YYYY/MM/DD HH24:MI:SS'),2,15);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,16,TO_DATE('2000/01/01 10:28:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 10:30:00','YYYY/MM/DD HH24:MI:SS'),2,16);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,17,TO_DATE('2000/01/01 11:26:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 11:28:00','YYYY/MM/DD HH24:MI:SS'),2,17);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,18,TO_DATE('2000/01/01 11:55:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 11:57:00','YYYY/MM/DD HH24:MI:SS'),2,18);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,19,TO_DATE('2000/01/01 12:20:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 12:22:00','YYYY/MM/DD HH24:MI:SS'),2,19);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,20,TO_DATE('2000/01/01 14:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 14:20:00','YYYY/MM/DD HH24:MI:SS'),2,20);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,21,TO_DATE('2000/01/01 15:07:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 15:09:00','YYYY/MM/DD HH24:MI:SS'),2,21);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,22,TO_DATE('2000/01/01 15:38:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 15:40:00','YYYY/MM/DD HH24:MI:SS'),2,22);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,23,TO_DATE('2000/01/01 15:58:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:00:00','YYYY/MM/DD HH24:MI:SS'),2,23);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,24,TO_DATE('2000/01/01 16:39:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:41:00','YYYY/MM/DD HH24:MI:SS'),2,24);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,25,TO_DATE('2000/01/01 17:18:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 17:20:00','YYYY/MM/DD HH24:MI:SS'),2,25);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,26,TO_DATE('2000/01/01 17:57:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 17:59:00','YYYY/MM/DD HH24:MI:SS'),2,26);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,27,TO_DATE('2000/01/01 18:48:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:50:00','YYYY/MM/DD HH24:MI:SS'),2,27);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,28,TO_DATE('2000/01/01 21:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 21:20:00','YYYY/MM/DD HH24:MI:SS'),2,28);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,29,TO_DATE('2000/01/01 22:15:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 22:20:00','YYYY/MM/DD HH24:MI:SS'),2,29);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,30,TO_DATE('2000/01/01 23:13:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 23:15:00','YYYY/MM/DD HH24:MI:SS'),2,30);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,31,TO_DATE('2000/01/01 00:20:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:22:00','YYYY/MM/DD HH24:MI:SS'),3,31);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,32,TO_DATE('2000/01/01 00:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:47:00','YYYY/MM/DD HH24:MI:SS'),3,32);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,33,TO_DATE('2000/01/01 01:02:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:04:00','YYYY/MM/DD HH24:MI:SS'),3,33);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,34,TO_DATE('2000/01/01 01:25:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:30:00','YYYY/MM/DD HH24:MI:SS'),3,34);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,35,TO_DATE('2000/01/01 01:48:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:50:00','YYYY/MM/DD HH24:MI:SS'),3,35);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,36,TO_DATE('2000/01/01 02:33:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 02:35:00','YYYY/MM/DD HH24:MI:SS'),3,36);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,37,TO_DATE('2000/01/01 03:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 03:55:00','YYYY/MM/DD HH24:MI:SS'),3,37);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11019,38,TO_DATE('2000/01/01 04:25:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:40:00','YYYY/MM/DD HH24:MI:SS'),3,38);

INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,38,TO_DATE('2000/01/01 15:15:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 15:25:00','YYYY/MM/DD HH24:MI:SS'),1,1);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,37,TO_DATE('2000/01/01 15:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 15:55:00','YYYY/MM/DD HH24:MI:SS'),1,2);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,36,TO_DATE('2000/01/01 16:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:47:00','YYYY/MM/DD HH24:MI:SS'),1,3);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,35,TO_DATE('2000/01/01 17:26:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 17:28:00','YYYY/MM/DD HH24:MI:SS'),1,4);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,34,TO_DATE('2000/01/01 17:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 17:55:00','YYYY/MM/DD HH24:MI:SS'),1,5);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,33,TO_DATE('2000/01/01 18:16:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:18:00','YYYY/MM/DD HH24:MI:SS'),1,6);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,32,TO_DATE('2000/01/01 18:31:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:33:00','YYYY/MM/DD HH24:MI:SS'),1,7);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,31,TO_DATE('2000/01/01 19:15:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 19:17:00','YYYY/MM/DD HH24:MI:SS'),1,8);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,30,TO_DATE('2000/01/01 20:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 20:12:00','YYYY/MM/DD HH24:MI:SS'),1,9);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,29,TO_DATE('2000/01/01 21:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 21:15:00','YYYY/MM/DD HH24:MI:SS'),1,10);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,28,TO_DATE('2000/01/01 22:25:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 22:45:00','YYYY/MM/DD HH24:MI:SS'),1,11);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,27,TO_DATE('2000/01/01 23:32:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 23:33:00','YYYY/MM/DD HH24:MI:SS'),1,12);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,26,TO_DATE('2000/01/01 00:16:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:17:00','YYYY/MM/DD HH24:MI:SS'),2,13);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,25,TO_DATE('2000/01/01 00:39:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:40:00','YYYY/MM/DD HH24:MI:SS'),2,14);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,24,TO_DATE('2000/01/01 01:48:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:50:00','YYYY/MM/DD HH24:MI:SS'),2,15);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,23,TO_DATE('2000/01/01 02:14:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 02:15:00','YYYY/MM/DD HH24:MI:SS'),2,16);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,22,TO_DATE('2000/01/01 02:32:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 02:33:00','YYYY/MM/DD HH24:MI:SS'),2,17);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,21,TO_DATE('2000/01/01 03:06:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 03:07:00','YYYY/MM/DD HH24:MI:SS'),2,18);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,20,TO_DATE('2000/01/01 05:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 05:20:00','YYYY/MM/DD HH24:MI:SS'),2,19);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,19,TO_DATE('2000/01/01 06:02:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 06:03:00','YYYY/MM/DD HH24:MI:SS'),2,20);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,18,TO_DATE('2000/01/01 06:33:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 06:35:00','YYYY/MM/DD HH24:MI:SS'),2,21);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,17,TO_DATE('2000/01/01 07:20:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 07:21:00','YYYY/MM/DD HH24:MI:SS'),2,22);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,16,TO_DATE('2000/01/01 08:08:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 08:10:00','YYYY/MM/DD HH24:MI:SS'),2,23);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,15,TO_DATE('2000/01/01 08:38:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 08:40:00','YYYY/MM/DD HH24:MI:SS'),2,24);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,14,TO_DATE('2000/01/01 11:35:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 11:45:00','YYYY/MM/DD HH24:MI:SS'),2,25);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,13,TO_DATE('2000/01/01 11:55:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 11:57:00','YYYY/MM/DD HH24:MI:SS'),2,26);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,12,TO_DATE('2000/01/01 13:39:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 13:40:00','YYYY/MM/DD HH24:MI:SS'),2,27);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,11,TO_DATE('2000/01/01 14:05:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 14:06:00','YYYY/MM/DD HH24:MI:SS'),2,28);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,10,TO_DATE('2000/01/01 16:05:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:10:00','YYYY/MM/DD HH24:MI:SS'),2,29);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,9,TO_DATE('2000/01/01 16:43:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:45:00','YYYY/MM/DD HH24:MI:SS'),2,30);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,8,TO_DATE('2000/01/01 18:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:55:00','YYYY/MM/DD HH24:MI:SS'),2,31);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,7,TO_DATE('2000/01/01 22:20:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 22:30:00','YYYY/MM/DD HH24:MI:SS'),2,32);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,6,TO_DATE('2000/01/01 23:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 23:50:00','YYYY/MM/DD HH24:MI:SS'),2,33);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,5,TO_DATE('2000/01/01 00:53:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:55:00','YYYY/MM/DD HH24:MI:SS'),3,34);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,4,TO_DATE('2000/01/01 01:43:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:45:00','YYYY/MM/DD HH24:MI:SS'),3,35);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,3,TO_DATE('2000/01/01 02:39:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 02:40:00','YYYY/MM/DD HH24:MI:SS'),3,36);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,2,TO_DATE('2000/01/01 03:24:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 03:25:00','YYYY/MM/DD HH24:MI:SS'),3,37);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (11020,1,TO_DATE('2000/01/01 03:55:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:00:00','YYYY/MM/DD HH24:MI:SS'),3,38);

INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,49,TO_DATE('2000/01/01 07:15:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 07:25:00','YYYY/MM/DD HH24:MI:SS'),1,1);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,48,TO_DATE('2000/01/01 08:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 08:12:00','YYYY/MM/DD HH24:MI:SS'),1,2);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,47,TO_DATE('2000/01/01 09:05:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 09:10:00','YYYY/MM/DD HH24:MI:SS'),1,3);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,46,TO_DATE('2000/01/01 10:35:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 10:37:00','YYYY/MM/DD HH24:MI:SS'),1,4);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,45,TO_DATE('2000/01/01 11:35:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 11:37:00','YYYY/MM/DD HH24:MI:SS'),1,5);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,44,TO_DATE('2000/01/01 12:06:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 12:08:00','YYYY/MM/DD HH24:MI:SS'),1,6);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,43,TO_DATE('2000/01/01 13:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 13:15:00','YYYY/MM/DD HH24:MI:SS'),1,7);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,38,TO_DATE('2000/01/01 13:55:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 14:00:00','YYYY/MM/DD HH24:MI:SS'),1,8);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,37,TO_DATE('2000/01/01 14:25:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 14:40:00','YYYY/MM/DD HH24:MI:SS'),1,9);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,36,TO_DATE('2000/01/01 15:33:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 15:35:00','YYYY/MM/DD HH24:MI:SS'),1,10);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,34,TO_DATE('2000/01/01 16:35:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:40:00','YYYY/MM/DD HH24:MI:SS'),1,11);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,33,TO_DATE('2000/01/01 17:01:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 17:03:00','YYYY/MM/DD HH24:MI:SS'),1,12);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,31,TO_DATE('2000/01/01 18:03:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:05:00','YYYY/MM/DD HH24:MI:SS'),1,13);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,30,TO_DATE('2000/01/01 19:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 19:02:00','YYYY/MM/DD HH24:MI:SS'),1,14);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,29,TO_DATE('2000/01/01 20:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 20:05:00','YYYY/MM/DD HH24:MI:SS'),1,15);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,28,TO_DATE('2000/01/01 21:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 21:30:00','YYYY/MM/DD HH24:MI:SS'),1,16);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,25,TO_DATE('2000/01/01 23:54:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 23:56:00','YYYY/MM/DD HH24:MI:SS'),1,17);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,24,TO_DATE('2000/01/01 00:29:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:31:00','YYYY/MM/DD HH24:MI:SS'),2,18);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,22,TO_DATE('2000/01/01 01:08:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:09:00','YYYY/MM/DD HH24:MI:SS'),2,19);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,21,TO_DATE('2000/01/01 01:49:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:50:00','YYYY/MM/DD HH24:MI:SS'),2,20);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,20,TO_DATE('2000/01/01 03:20:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 03:35:00','YYYY/MM/DD HH24:MI:SS'),2,21);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,42,TO_DATE('2000/01/01 04:20:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:25:00','YYYY/MM/DD HH24:MI:SS'),2,22);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,41,TO_DATE('2000/01/01 05:28:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 05:29:00','YYYY/MM/DD HH24:MI:SS'),2,23);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,40,TO_DATE('2000/01/01 06:25:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 06:26:00','YYYY/MM/DD HH24:MI:SS'),2,24);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,39,TO_DATE('2000/01/01 07:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 07:01:00','YYYY/MM/DD HH24:MI:SS'),2,25);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12703,14,TO_DATE('2000/01/01 09:35:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 09:45:00','YYYY/MM/DD HH24:MI:SS'),2,26);

INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,14,TO_DATE('2000/01/01 15:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:00:00','YYYY/MM/DD HH24:MI:SS'),1,1);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,39,TO_DATE('2000/01/01 17:40:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 17:41:00','YYYY/MM/DD HH24:MI:SS'),1,2);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,40,TO_DATE('2000/01/01 18:05:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:06:00','YYYY/MM/DD HH24:MI:SS'),1,3);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,41,TO_DATE('2000/01/01 19:04:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 19:05:00','YYYY/MM/DD HH24:MI:SS'),1,4);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,42,TO_DATE('2000/01/01 20:25:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 20:30:00','YYYY/MM/DD HH24:MI:SS'),1,5);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,20,TO_DATE('2000/01/01 21:25:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 21:40:00','YYYY/MM/DD HH24:MI:SS'),1,6);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,21,TO_DATE('2000/01/01 22:26:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 22:27:00','YYYY/MM/DD HH24:MI:SS'),1,7);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,22,TO_DATE('2000/01/01 23:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 23:01:00','YYYY/MM/DD HH24:MI:SS'),1,8);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,24,TO_DATE('2000/01/01 00:02:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:03:00','YYYY/MM/DD HH24:MI:SS'),2,9);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,25,TO_DATE('2000/01/01 00:41:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:42:00','YYYY/MM/DD HH24:MI:SS'),2,10);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,28,TO_DATE('2000/01/01 03:30:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 03:50:00','YYYY/MM/DD HH24:MI:SS'),2,11);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,29,TO_DATE('2000/01/01 04:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:52:00','YYYY/MM/DD HH24:MI:SS'),2,12);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,30,TO_DATE('2000/01/01 05:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 05:47:00','YYYY/MM/DD HH24:MI:SS'),2,13);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,31,TO_DATE('2000/01/01 06:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 06:52:00','YYYY/MM/DD HH24:MI:SS'),2,14);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,33,TO_DATE('2000/01/01 07:27:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 07:29:00','YYYY/MM/DD HH24:MI:SS'),2,15);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,34,TO_DATE('2000/01/01 07:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 07:55:00','YYYY/MM/DD HH24:MI:SS'),2,16);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,36,TO_DATE('2000/01/01 08:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 08:52:00','YYYY/MM/DD HH24:MI:SS'),2,17);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,37,TO_DATE('2000/01/01 10:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 10:25:00','YYYY/MM/DD HH24:MI:SS'),2,18);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,38,TO_DATE('2000/01/01 10:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 10:50:00','YYYY/MM/DD HH24:MI:SS'),2,19);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,43,TO_DATE('2000/01/01 11:20:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 11:25:00','YYYY/MM/DD HH24:MI:SS'),2,20);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,44,TO_DATE('2000/01/01 12:15:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 12:17:00','YYYY/MM/DD HH24:MI:SS'),2,21);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,45,TO_DATE('2000/01/01 13:05:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 13:07:00','YYYY/MM/DD HH24:MI:SS'),2,22);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,46,TO_DATE('2000/01/01 13:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 13:52:00','YYYY/MM/DD HH24:MI:SS'),2,23);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,47,TO_DATE('2000/01/01 15:25:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 15:30:00','YYYY/MM/DD HH24:MI:SS'),2,24);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,48,TO_DATE('2000/01/01 16:56:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 16:58:00','YYYY/MM/DD HH24:MI:SS'),2,25);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12704,49,TO_DATE('2000/01/01 17:45:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:00:00','YYYY/MM/DD HH24:MI:SS'),2,26);

INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,58,TO_DATE('2000/01/01 18:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:10:00','YYYY/MM/DD HH24:MI:SS'),1,1);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,57,TO_DATE('2000/01/01 19:19:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 19:20:00','YYYY/MM/DD HH24:MI:SS'),1,2);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,56,TO_DATE('2000/01/01 19:44:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 19:45:00','YYYY/MM/DD HH24:MI:SS'),1,3);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,55,TO_DATE('2000/01/01 20:40:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 20:45:00','YYYY/MM/DD HH24:MI:SS'),1,4);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,54,TO_DATE('2000/01/01 21:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 21:11:00','YYYY/MM/DD HH24:MI:SS'),1,5);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,53,TO_DATE('2000/01/01 21:48:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 21:49:00','YYYY/MM/DD HH24:MI:SS'),1,6);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,52,TO_DATE('2000/01/01 22:42:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 22:43:00','YYYY/MM/DD HH24:MI:SS'),1,7);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,51,TO_DATE('2000/01/01 23:18:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 23:19:00','YYYY/MM/DD HH24:MI:SS'),1,8);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,50,TO_DATE('2000/01/01 00:14:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 00:15:00','YYYY/MM/DD HH24:MI:SS'),2,9);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,20,TO_DATE('2000/01/01 01:10:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:20:00','YYYY/MM/DD HH24:MI:SS'),2,10);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,18,TO_DATE('2000/01/01 02:28:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 02:30:00','YYYY/MM/DD HH24:MI:SS'),2,11);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,17,TO_DATE('2000/01/01 03:19:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 03:20:00','YYYY/MM/DD HH24:MI:SS'),2,12);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,16,TO_DATE('2000/01/01 04:13:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:15:00','YYYY/MM/DD HH24:MI:SS'),2,13);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,15,TO_DATE('2000/01/01 04:40:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:42:00','YYYY/MM/DD HH24:MI:SS'),2,14);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12759,14,TO_DATE('2000/01/01 07:15:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 07:20:00','YYYY/MM/DD HH24:MI:SS'),2,15);

INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,14,TO_DATE('2000/01/01 18:50:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 18:55:00','YYYY/MM/DD HH24:MI:SS'),1,1);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,15,TO_DATE('2000/01/01 20:53:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 20:55:00','YYYY/MM/DD HH24:MI:SS'),1,2);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,16,TO_DATE('2000/01/01 21:08:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 21:10:00','YYYY/MM/DD HH24:MI:SS'),1,3);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,17,TO_DATE('2000/01/01 21:53:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 21:54:00','YYYY/MM/DD HH24:MI:SS'),1,4);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,18,TO_DATE('2000/01/01 22:40:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 22:42:00','YYYY/MM/DD HH24:MI:SS'),1,5);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,20,TO_DATE('2000/01/01 01:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:10:00','YYYY/MM/DD HH24:MI:SS'),2,6);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,50,TO_DATE('2000/01/01 01:37:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 01:38:00','YYYY/MM/DD HH24:MI:SS'),2,7);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,51,TO_DATE('2000/01/01 02:20:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 02:21:00','YYYY/MM/DD HH24:MI:SS'),2,8);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,52,TO_DATE('2000/01/01 03:04:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 03:05:00','YYYY/MM/DD HH24:MI:SS'),2,9);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,53,TO_DATE('2000/01/01 03:49:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 03:50:00','YYYY/MM/DD HH24:MI:SS'),2,10);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,54,TO_DATE('2000/01/01 04:23:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 04:24:00','YYYY/MM/DD HH24:MI:SS'),2,11);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,55,TO_DATE('2000/01/01 05:38:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 05:40:00','YYYY/MM/DD HH24:MI:SS'),2,12);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,56,TO_DATE('2000/01/01 06:00:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 06:05:00','YYYY/MM/DD HH24:MI:SS'),2,13);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,57,TO_DATE('2000/01/01 06:24:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 06:25:00','YYYY/MM/DD HH24:MI:SS'),2,14);
INSERT INTO Train_route (train_no,station_id,train_arrival,train_depart,train_day,route_order)
VALUES (12760,58,TO_DATE('2000/01/01 08:15:00','YYYY/MM/DD HH24:MI:SS'),TO_DATE('2000/01/01 08:25:00','YYYY/MM/DD HH24:MI:SS'),2,15);

-- SELECT Train.train_name,Train.train_no,Station.station_name,TO_CHAR(Train_route.train_arrival, 'HH24:MI') AS Arrival_time,
-- TO_CHAR(Train_route.train_depart, 'HH24:MI') AS Depart_time,Train_route.train_day FROM
-- Train INNER JOIN Train_route ON
-- Train.train_no=Train_route.train_no INNER JOIN Station ON Train_route.station_id=Station.station_id 
-- ORDER BY Train.train_no, Train_route.route_order;


-- SELECT CONCAT(CONCAT('&date',' '),TO_CHAR(T1.Depart_time, 'HH24:MI:SS')) AS Departure_time,
-- CONCAT(CONCAT(TO_DATE('&date')+day2-day1,' '),TO_CHAR(T2.Arrive_time, 'HH24:MI:SS')) AS Arrival_time,
-- CONCAT(CONCAT(EXTRACT(DAY FROM ((Arrive_time+day2-day1) - Depart_time))*24 +EXTRACT( HOUR FROM ((Arrive_time+day2-day1) - Depart_time)),':'),
-- EXTRACT( MINUTE FROM ((Arrive_time+day2-day1) - Depart_time)) )AS Duration FROM
-- ((SELECT train_depart AS Depart_time,train_day AS day1 FROM Train_route WHERE train_no=&train_no AND station_id=&station_id)T1 CROSS JOIN
-- (SELECT train_arrival AS Arrive_time,train_day AS day2 FROM Train_route WHERE train_no=&train_no AND station_id=&station_id)T2);


-- SELECT Train.train_name, Train.train_no FROM
-- (SELECT T1.train_no FROM Train_route T1 INNER JOIN Train_route T2 
-- ON T1.train_no=T2.train_no AND T1.station_id=&start_station AND T2.station_id=&end_station 
-- AND T1.route_order<T2.route_order) T3 INNER JOIN Train ON T3.train_no=Train.train_no;



-- SET SERVEROUTPUT ON;
-- DECLARE
-- 	TYPE B IS TABLE OF Train_seats%ROWTYPE;
-- 	seat_list B;
-- BEGIN
	
-- END;
-- /


-- DECLARE
-- 	CURSOR Train_list IS SELECT train_no FROM Train;
-- 	counter NUMBER;
-- 	seat_count NUMBER;
-- 	day NUMBER;
-- BEGIN
-- 	day := 1;
-- 	WHILE day <=20 LOOP
-- 		FOR k IN Train_list LOOP
-- 			counter:=1;
-- 			WHILE counter<=5 LOOP
-- 				seat_count:=1;
-- 				WHILE seat_count<=72 LOOP
-- 					INSERT INTO Train_seats (train_no,coach,seat_no,date_of_journey) VALUES
-- 					(k.train_no,CONCAT('S',TO_CHAR(counter)),seat_count,TO_DATE(SYSDATE+day,'DD-MM-YYYY'));			
-- 					INSERT INTO Train_seats (train_no,coach,seat_no,date_of_journey) VALUES
-- 					(k.train_no,CONCAT('C',TO_CHAR(counter)),seat_count,TO_DATE(SYSDATE+day,'DD-MM-YYYY'));
-- 					INSERT INTO Train_seats (train_no,coach,seat_no,date_of_journey) VALUES
-- 					(k.train_no,CONCAT('B',TO_CHAR(counter)),seat_count,TO_DATE(SYSDATE+day,'DD-MM-YYYY'));
-- 					INSERT INTO Train_seats (train_no,coach,seat_no,date_of_journey) VALUES
-- 					(k.train_no,CONCAT('A',TO_CHAR(counter)),seat_count,TO_DATE(SYSDATE+day,'DD-MM-YYYY'));
-- 					seat_count:=seat_count+1;
-- 				END LOOP;
-- 				counter:=counter+1;
-- 			END LOOP;
-- 		END LOOP;
-- 		day := day +1;
-- 	END LOOP;
-- END;
-- /


CREATE OR REPLACE PROCEDURE Update_tickets IS
	CURSOR Train_list IS SELECT train_no FROM Train;
	counter NUMBER;
	seat_count NUMBER;
BEGIN
	FOR k IN Train_list LOOP
		counter:=1;
		WHILE counter<=5 LOOP
			seat_count:=1;
			WHILE seat_count<=72 LOOP
				INSERT INTO Train_seats (train_no,coach,seat_no,date_of_journey) VALUES
				(k.train_no,CONCAT('S',TO_CHAR(counter)),seat_count,TO_DATE(SYSDATE+20,'DD-MM-YYYY'));			
				INSERT INTO Train_seats (train_no,coach,seat_no,date_of_journey) VALUES
				(k.train_no,CONCAT('C',TO_CHAR(counter)),seat_count,TO_DATE(SYSDATE+20,'DD-MM-YYYY'));
				INSERT INTO Train_seats (train_no,coach,seat_no,date_of_journey) VALUES
				(k.train_no,CONCAT('B',TO_CHAR(counter)),seat_count,TO_DATE(SYSDATE+20,'DD-MM-YYYY'));
				INSERT INTO Train_seats (train_no,coach,seat_no,date_of_journey) VALUES
				(k.train_no,CONCAT('A',TO_CHAR(counter)),seat_count,TO_DATE(SYSDATE+20,'DD-MM-YYYY'));
				seat_count:=seat_count+1;
			END LOOP;
			counter:=counter+1;
		END LOOP;
	END LOOP;
END;
/

BEGIN
    DBMS_SCHEDULER.CREATE_JOB (
         job_name=> 'Open_tickets',
         job_type=> 'STORED_PROCEDURE',
         job_action=> 'Update_tickets',
         start_date=> SYSTIMESTAMP,
         repeat_interval=> 'FREQ=DAILY;INTERVAL=1',
         enabled=> TRUE);
END;
/

-- SET SERVEROUTPUT ON;
-- DECLARE

-- BEGIN
-- 	dbms_output.put_line(Ticket_availability(14,38,11019,'A','05-AUG-2020'));
-- END;
-- /



-- INSERT INTO Ticket_details (user_id,passenger_count,train_no,class,start_station,end_station,depart_time,arrival_time,date_of_booking,fare)
-- VALUES('wegrf',1,11019,'B',14,20,'2020/04/07 08:00:00','2000/04/07 14:20:00',SYSDATE,600);

-- INSERT INTO Ticket_booking (pnr_no,passenger_count,passenger_id,passenger_name,gender,age,berth_pref,status)
-- VALUES (111111,1,1,'Harsha','M',20,'UB','CNF');

-- INSERT INTO Seat_status (train_no,coach,seat_no,date_of_journey,pnr_no,pnr_id,status)
-- VALUES (11019,'B1',3,'06-APR-2020',111111,1,1);

-- UPDATE Train_seats SET status=1 WHERE date_of_journey='06-APR-2020' AND train_no=11019 AND coach='B1' AND seat_no=3;


-- SELECT Ticket_details.pnr_no AS PNR_NO,train.train_no AS Train_no, Train.train_name AS Train_name,S1.station_name AS Start_Station,
-- S2.station_name AS End_Station,Ticket_booking.passenger_name AS Name,Ticket_booking.gender AS Gender,
-- Ticket_booking.age AS Age,Ticket_booking.status AS Status, Seat_status.coach AS Coach,
-- Seat_status.seat_no AS Seat_no, Ticket_details.depart_time AS Departure_time, Ticket_details.arrival_time AS Arrival_time FROM
-- Ticket_details INNER JOIN Train ON Ticket_details.train_no=Train.train_no INNER JOIN
-- Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON 
-- S2.station_id=Ticket_details.end_station INNER JOIN 
-- Ticket_booking ON Ticket_details.pnr_no=Ticket_booking.pnr_no INNER JOIN
-- Seat_status ON Ticket_booking.pnr_no=Seat_status.pnr_no AND Ticket_booking.passenger_id=Seat_status.pnr_id WHERE
-- Ticket_details.pnr_no=&pnr_no;



-- SET SERVEROUTPUT ON;
CREATE OR REPLACE FUNCTION Ticket_availability(st_station IN NUMBER,en_station IN NUMBER,t_no IN NUMBER,
	class_selected IN VARCHAR2,date_journey IN DATE)
	RETURN NUMBER IS 
	tot_avail NUMBER:=0;
	date_t DATE;
	t_day NUMBER;
	CURSOR booked_ticket (t_num NUMBER,date_j DATE,coach_sel VARCHAR2) IS 
	SELECT Seat_status.coach AS coach,Seat_status.seat_no AS seat_no,Ticket_details.start_station AS start_station,
	Ticket_details.end_station AS end_station FROM Seat_status INNER JOIN Ticket_details ON 
	Seat_status.pnr_no=Ticket_details.pnr_no WHERE Seat_status.train_no=t_num AND 
	Seat_status.date_of_journey=date_j AND REGEXP_LIKE(Seat_status.coach,CONCAT(coach_sel,'(*)'));
	TYPE t_book IS TABLE OF NUMBER INDEX BY VARCHAR2(5);
	book_list t_book;
	it VARCHAR2(5);
	temp_wl NUMBER;
BEGIN
	SELECT train_day INTO t_day FROM Train_route WHERE station_id=st_station AND train_no=t_no;
	date_t:= date_journey-t_day+1;
	SELECT COUNT(*) INTO tot_avail FROM Train_seats WHERE train_no=t_no AND REGEXP_LIKE(coach,CONCAT(class_selected,'(*)')) 
	AND date_of_journey=date_t AND status IS NULL;
	FOR k IN booked_ticket(t_no,date_t,class_selected) LOOP
		IF (st_station<=k.start_station AND en_station<=k.start_station) OR (st_station>=k.end_station AND en_station>=k.end_station) THEN
			IF NOT book_list.EXISTS(CONCAT(k.coach,TO_CHAR(k.seat_no))) THEN
				book_list(CONCAT(k.coach,TO_CHAR(k.seat_no))):=1;
			END IF;
		ELSE
			book_list(CONCAT(k.coach,TO_CHAR(k.seat_no))):=0;
		END IF;
	END LOOP;
   	it := book_list.FIRST;
   	WHILE it IS NOT NULL LOOP
   		IF book_list(it)=1 THEN
   			tot_avail:=tot_avail+1;
   		END IF;
      	it := book_list.NEXT(it);
   	END LOOP;
   	IF tot_avail=0 THEN
   		SELECT COALESCE(MAX(TO_NUMBER(SUBSTR(Ticket_booking.status,3))),0) INTO temp_wl
   		FROM Ticket_booking INNER JOIN Ticket_details T1 ON 
   		T1.pnr_no=Ticket_booking.pnr_no WHERE T1.class=class_selected AND T1.train_no=t_no
   		AND REGEXP_LIKE(Ticket_booking.status,CONCAT('WL','(*)')) AND TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-
   		(SELECT route_order FROM Train_route WHERE train_no=t_no AND station_id=T1.start_station)+1)=date_t; 
   		tot_avail:=-1*temp_wl;
   	END IF;
	RETURN tot_avail;
END;
/
SELECT COALESCE(MAX(TO_NUMBER(SUBSTR(Ticket_booking.status,3))),0)
FROM Ticket_booking INNER JOIN Ticket_details T1 ON 
T1.pnr_no=Ticket_booking.pnr_no WHERE T1.class='B' AND T1.train_no=11019
AND REGEXP_LIKE(Ticket_booking.status,CONCAT('WL','(*)')) AND TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-
(SELECT route_order FROM Train_route WHERE train_no=11019 AND station_id=T1.start_station)+1)='06-APR-2020'; 





CREATE OR REPLACE FUNCTION get_berth(seat_no IN NUMBER)
	RETURN VARCHAR2 IS
	berth_pref VARCHAR(2);
BEGIN
	IF MOD(seat_no,8)=1 OR MOD(seat_no,8)=4 THEN
		berth_pref:='LB';
	ELSIF MOD(seat_no,8)=2 OR MOD(seat_no,8)=5 THEN
		berth_pref:='MB';
	ELSIF MOD(seat_no,8)=3 OR MOD(seat_no,8)=6 THEN
		berth_pref:='UB';
	ELSIF MOD(seat_no,8)=7 THEN
		berth_pref:='SL';
	ELSE
		berth_pref:='SU';
	END IF;
	RETURN berth_pref;
END;
/

CREATE OR REPLACE PROCEDURE Book_ticket(st_station IN NUMBER,en_station IN NUMBER,t_no IN NUMBER,
	class_selected IN VARCHAR2,date_journey IN DATE,pnr_num IN NUMBER,berth_pref IN VARCHAR2,
	pass_id IN NUMBER,pass_count IN NUMBER,pass_name IN VARCHAR2,pass_gender IN CHAR,pass_age IN NUMBER) IS 
	date_t DATE;
	seat_get NUMBER;
	free_pref NUMBER;
	counter NUMBER;
	seat_info VARCHAR2(5);
	t_day NUMBER;
	CURSOR booked_ticket (t_num NUMBER,date_j DATE,coach_sel VARCHAR2) IS 
	SELECT Seat_status.coach AS coach,Seat_status.seat_no AS seat_no,Ticket_details.start_station AS start_station,
	Ticket_details.end_station AS end_station FROM Seat_status INNER JOIN Ticket_details ON 
	Seat_status.pnr_no=Ticket_details.pnr_no WHERE Seat_status.train_no=t_num AND 
	Seat_status.date_of_journey=date_j AND REGEXP_LIKE(Seat_status.coach,CONCAT(coach_sel,'(*)'))
	ORDER BY Seat_status.coach,Seat_status.seat_no; 
	CURSOR free_seat (t_num NUMBER,date_j DATE,coach_sel VARCHAR2) IS
	SELECT * FROM Train_seats WHERE train_no=t_num AND REGEXP_LIKE(coach,CONCAT(coach_sel,'(*)')) 
	AND date_of_journey=date_j AND status IS NULL ORDER BY coach,seat_no;
	TYPE t_book IS TABLE OF NUMBER INDEX BY VARCHAR2(5);
	book_list t_book;
	it VARCHAR2(5);
	av NUMBER;
	wl NUMBER;
BEGIN
	SELECT train_day INTO t_day FROM Train_route WHERE station_id=st_station AND train_no=t_no;
	date_t:= date_journey-t_day+1;
	SELECT COUNT(*) INTO free_pref FROM Train_seats WHERE train_no=t_no AND REGEXP_LIKE(coach,CONCAT(class_selected,'(*)')) 
	AND date_of_journey=date_t AND status IS NULL AND get_berth(seat_no)=berth_pref;
	FOR k IN booked_ticket(t_no,date_t,class_selected) LOOP
		IF (st_station<=k.start_station AND en_station<=k.start_station) OR (st_station>=k.end_station AND en_station>=k.end_station) THEN
			IF NOT book_list.EXISTS(CONCAT(k.coach,TO_CHAR(k.seat_no))) THEN
				book_list(CONCAT(k.coach,TO_CHAR(k.seat_no))):=1;
			END IF;
		ELSE
			book_list(CONCAT(k.coach,TO_CHAR(k.seat_no))):=0;
		END IF;
	END LOOP;
	seat_get:=0;
	counter:=0;
   	it := book_list.FIRST;
   	WHILE it IS NOT NULL LOOP

   		IF book_list(it)=1 THEN
   			counter:=counter+1;
   			IF get_berth(TO_NUMBER(SUBSTR(it,3)))=berth_pref THEN
   				seat_get:=1;
   				seat_info:=it;
   			END IF;
   		END IF;
      	it := book_list.NEXT(it);
   	END LOOP;
   	IF seat_get=0 THEN
   		IF free_pref=0 THEN
   			IF counter=0 THEN
   				SELECT COUNT(*) INTO av FROM Train_seats WHERE train_no=t_no AND REGEXP_LIKE(coach,CONCAT(class_selected,'(*)')) 
				AND date_of_journey=date_t AND status IS NULL;
				IF av=0 THEN
					wl:=Ticket_availability(st_station,en_station,t_no,class_selected,date_journey);
					wl:=-1*(wl-1);
					INSERT INTO Ticket_booking (pnr_no,passenger_count,passenger_id,passenger_name,gender,age,berth_pref,status)
					VALUES (pnr_num,pass_count,pass_id,pass_name,pass_gender,pass_age,berth_pref,CONCAT('WL',wl));
				ELSE
	   				FOR k IN free_seat(t_no,date_t,class_selected) LOOP
		   				seat_info:=CONCAT(k.coach,TO_CHAR(k.seat_no));
		   				EXIT;
		   			END LOOP;
		   			INSERT INTO Ticket_booking (pnr_no,passenger_count,passenger_id,passenger_name,gender,age,berth_pref,status)
	   			    VALUES (pnr_num,pass_count,pass_id,pass_name,pass_gender,pass_age,berth_pref,'CNF');
	   			    INSERT INTO Seat_status (train_no,coach,seat_no,date_of_journey,pnr_no,pnr_id,status)
	   			    VALUES (t_no,SUBSTR(seat_info,1,2),TO_NUMBER(SUBSTR(seat_info,3)),date_t,pnr_num,pass_id,1);
	   			    UPDATE Train_seats SET status=1 WHERE date_of_journey=date_t AND train_no=T_no AND coach=SUBSTR(seat_info,1,2)
	   			    AND seat_no=TO_NUMBER(SUBSTR(seat_info,3));
	   			END IF;
   			ELSE
   				it := book_list.FIRST;
			   	WHILE it IS NOT NULL LOOP
			   		IF book_list(it)=1 THEN
			   			seat_info:=it;
			   			EXIT;
			   		END IF;
			      	it := book_list.NEXT(it);
			   	END LOOP;
			   	INSERT INTO Ticket_booking (pnr_no,passenger_count,passenger_id,passenger_name,gender,age,berth_pref,status)
				VALUES (pnr_num,pass_count,pass_id,pass_name,pass_gender,pass_age,berth_pref,'CNF');
				INSERT INTO Seat_status (train_no,coach,seat_no,date_of_journey,pnr_no,pnr_id,status)
				VALUES (t_no,SUBSTR(seat_info,1,2),TO_NUMBER(SUBSTR(seat_info,3)),date_t,pnr_num,pass_id,1);
   			END IF;
   		ELSE
   			FOR k IN free_seat(t_no,date_t,class_selected) LOOP
   				IF get_berth(k.seat_no)=berth_pref THEN 
   					seat_info:=CONCAT(k.coach,TO_CHAR(k.seat_no));
   					EXIT;
   				END IF;
   			END LOOP;
   			   INSERT INTO Ticket_booking (pnr_no,passenger_count,passenger_id,passenger_name,gender,age,berth_pref,status)
   			   VALUES (pnr_num,pass_count,pass_id,pass_name,pass_gender,pass_age,berth_pref,'CNF');
   			   INSERT INTO Seat_status (train_no,coach,seat_no,date_of_journey,pnr_no,pnr_id,status)
   			   VALUES (t_no,SUBSTR(seat_info,1,2),TO_NUMBER(SUBSTR(seat_info,3)),date_t,pnr_num,pass_id,1);
   			   UPDATE Train_seats SET status=1 WHERE date_of_journey=date_t AND train_no=T_no AND coach=SUBSTR(seat_info,1,2)
   			   AND seat_no=TO_NUMBER(SUBSTR(seat_info,3));
   		END IF;

   	ELSE
   		INSERT INTO Ticket_booking (pnr_no,passenger_count,passenger_id,passenger_name,gender,age,berth_pref,status)
		VALUES (pnr_num,pass_count,pass_id,pass_name,pass_gender,pass_age,berth_pref,'CNF');
		INSERT INTO Seat_status (train_no,coach,seat_no,date_of_journey,pnr_no,pnr_id,status)
		VALUES (t_no,SUBSTR(seat_info,1,2),TO_NUMBER(SUBSTR(seat_info,3)),date_t,pnr_num,pass_id,1);
   	END IF;
END;
/

-- SELECT Ticket_details.pnr_no,S1.station_name,S2.station_name,Train.train_name,TO_CHAR(Ticket_details.depart_time,'DD-MM-YYYY'),
-- TO_CHAR(Ticket_details.date_of_booking,'DD-MM-YYYY') FROM Ticket_details INNER JOIN Train ON Train.train_no=Ticket_details.train_no INNER JOIN Station S1 ON
-- S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON S2.station_id=Ticket_details.end_station WHERE Ticket_details.user_id='&user_id'
-- ORDER BY TO_CHAR(Ticket_details.depart_time,'DD-MM-YYYY'),TO_CHAR(Ticket_details.date_of_booking,'DD-MM-YYYY') DESC;

-- INSERT INTO Ticket_details (user_id,passenger_count,train_no,class,start_station,end_station,depart_time,arrival_time,date_of_booking,fare)
-- VALUES('wegrf',1,11019,'B',14,20,'2020/04/07 08:00:00','2000/04/07 14:20:00',SYSDATE,600);

-- INSERT INTO Ticket_booking (pnr_no,passenger_count,passenger_id,passenger_name,gender,age,berth_pref,status)
-- VALUES (111111,1,1,'Harsha','M',20,'UB','CNF');

-- INSERT INTO Seat_status (train_no,coach,seat_no,date_of_journey,pnr_no,pnr_id,status)
-- VALUES (11019,'B1',3,'06-APR-2020',111111,1,1);

-- UPDATE Train_seats SET status=1 WHERE date_of_journey='06-APR-2020' AND train_no=11019 AND coach='B1' AND seat_no=3;


CREATE OR REPLACE PROCEDURE Cancel_ticket(pnr_number IN NUMBER,pn_id IN NUMBER) IS
	class_book VARCHAR2(5);
	coach_book VARCHAR2(5);
	seat_book NUMBER;
	book_status VARCHAR2(5);
	train_book NUMBER;
	station_book NUMBER; 
	choice NUMBER;
	doj DATE;
	CURSOR wait_ticket (t_num NUMBER,date_j DATE,class_sel VARCHAR2) IS 
	SELECT T1.start_station AS start_st,T1.end_station AS end_st,TO_CHAR(T1.depart_time,'DD-MM-YYYY') AS date_j,
	T1.pnr_no AS pnr, Ticket_booking.passenger_id AS pnrid,Ticket_booking.status AS stat
	FROM Ticket_details T1 INNER JOIN Ticket_booking ON
	T1.pnr_no=Ticket_booking.pnr_no WHERE T1.train_no=t_num AND TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-
	(SELECT route_order FROM Train_route WHERE train_no=t_num AND station_id=T1.start_station)+1)=date_j AND
	T1.class=class_sel AND REGEXP_LIKE(Ticket_booking.status,CONCAT('WL','(*)')) ORDER BY TO_NUMBER(SUBSTR(Ticket_booking.status,3));
	TYPE t_book IS TABLE OF NUMBER;
	up_list t_book:=t_book();
	iterator NUMBER;
	counter NUMBER;
	t_day NUMBER;
BEGIN
	IF pn_id=0 THEN
		SELECT passenger_count INTO choice FROM Ticket_booking WHERE pnr_no=pnr_number;
		WHILE choice>=1 LOOP
			SELECT T1.class,TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY'),'DD-MM-YYYY'),T1.start_station,T1.train_no,Ticket_booking.status 
			INTO class_book,doj,station_book,train_book,book_status FROM Ticket_details T1 INNER JOIN Ticket_booking ON
			T1.pnr_no=Ticket_booking.pnr_no WHERE Ticket_booking.passenger_id=choice AND T1.pnr_no=pnr_number;
			SELECT route_order INTO t_day FROM Train_route WHERE train_no=train_book AND station_id=station_book;
			doj:=doj-t_day+1;
			IF book_status='CNF' THEN
				SELECT seat_no, coach INTO seat_book,coach_book FROM Seat_status WHERE pnr_no=pnr_number AND pnr_id=choice;
				DELETE FROM Seat_status WHERE pnr_no=pnr_number AND pnr_id=choice;
				UPDATE Ticket_booking SET status='CAN' WHERE pnr_no = pnr_number AND passenger_id=choice;
				FOR k IN wait_ticket(train_book,doj,class_book) LOOP
					IF Ticket_availability(k.start_st,k.end_st,train_book,class_book,k.date_j) >0 THEN
						INSERT INTO Seat_status (train_no,coach,seat_no,date_of_journey,pnr_no,pnr_id,status) VALUES
						(train_book,coach_book,seat_book,doj,pnr_number,choice,1);
						up_list.EXTEND;
						up_list(up_list.LAST):=TO_NUMBER(SUBSTR(k.stat,3));
					END IF;
				END LOOP;
				iterator:=up_list.COUNT;
				WHILE iterator>=1 LOOP
					UPDATE Ticket_booking SET status='CNF' WHERE status=CONCAT('WL',up_list(iterator)) AND pnr_no IN (SELECT Ticket_booking.pnr_no FROM 
					Ticket_booking INNER JOIN Ticket_details T1 ON T1.pnr_no=Ticket_booking.pnr_no WHERE T1.train_no=train_book AND TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-
					(SELECT route_order FROM Train_route WHERE train_no=train_book AND station_id=T1.start_station)+1)=doj AND
					T1.class=class_book);
					UPDATE Ticket_booking SET status=CONCAT('WL',TO_NUMBER(SUBSTR(status,3))-1) WHERE TO_NUMBER(SUBSTR(status,3))>up_list(iterator)
					AND pnr_no IN (SELECT Ticket_booking.pnr_no FROM Ticket_booking INNER JOIN Ticket_details T1 ON T1.pnr_no=Ticket_booking.pnr_no WHERE T1.train_no=train_book AND 
					TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-(SELECT route_order FROM Train_route WHERE train_no=train_book 
					AND station_id=T1.start_station)+1)=doj AND T1.class=class_book AND REGEXP_LIKE(Ticket_booking.status,CONCAT('WL','(*)')));
					iterator:=iterator-1;
				END LOOP;
				SELECT COUNT(*) INTO counter FROM Seat_status WHERE train_no=train_book AND coach=coach_book AND seat_no=seat_book 
				AND date_of_journey=doj;
				IF counter=0 THEN
					UPDATE Train_seats SET status=NULL WHERE date_of_journey=doj AND train_no=train_book AND coach=coach_book AND seat_no=seat_book;
				END IF;
			ELSE
				UPDATE Ticket_booking SET status=CONCAT('WL',TO_NUMBER(SUBSTR(status,3))-1) WHERE TO_NUMBER(SUBSTR(status,3))>TO_NUMBER(SUBSTR(book_status,3))
				AND pnr_no IN (SELECT Ticket_booking.pnr_no FROM Ticket_booking INNER JOIN Ticket_details T1 ON T1.pnr_no=Ticket_booking.pnr_no WHERE T1.train_no=train_book AND TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-
				(SELECT route_order FROM Train_route WHERE train_no=train_book AND station_id=T1.start_station)+1)=doj AND
				T1.class=class_book AND REGEXP_LIKE(Ticket_booking.status,CONCAT('WL','(*)')));
			END IF;
			choice := choice -1;
		END LOOP;
	ELSE
		choice:=pn_id;
		SELECT T1.class,TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY'),'DD-MM-YYYY'),T1.start_station,T1.train_no,Ticket_booking.status 
		INTO class_book,doj,station_book,train_book,book_status FROM Ticket_details T1 INNER JOIN Ticket_booking ON
		T1.pnr_no=Ticket_booking.pnr_no WHERE Ticket_booking.passenger_id=choice AND T1.pnr_no=pnr_number;
		SELECT route_order INTO t_day FROM Train_route WHERE train_no=train_book AND station_id=station_book;
		doj:=doj-t_day+1;
		IF book_status='CNF' THEN
			SELECT seat_no, coach INTO seat_book,coach_book FROM Seat_status WHERE pnr_no=pnr_number AND pnr_id=choice;
			DELETE FROM Seat_status WHERE pnr_no=pnr_number AND pnr_id=choice;
			UPDATE Ticket_booking SET status='CAN' WHERE pnr_no = pnr_number AND passenger_id=choice;
			FOR k IN wait_ticket(train_book,doj,class_book) LOOP
				IF Ticket_availability(k.start_st,k.end_st,train_book,class_book,k.date_j) >0 THEN
					INSERT INTO Seat_status (train_no,coach,seat_no,date_of_journey,pnr_no,pnr_id,status) VALUES
					(train_book,coach_book,seat_book,doj,pnr_number,choice,1);
					up_list.EXTEND;
					up_list(up_list.LAST):=TO_NUMBER(SUBSTR(k.stat,3));
				END IF;
			END LOOP;
			iterator:=up_list.COUNT;
			WHILE iterator>=1 LOOP
				UPDATE Ticket_booking SET status='CNF' WHERE status=CONCAT('WL',up_list(iterator)) AND pnr_no IN (SELECT Ticket_booking.pnr_no FROM 
				Ticket_booking INNER JOIN Ticket_details T1 ON T1.pnr_no=Ticket_booking.pnr_no WHERE T1.train_no=train_book AND TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-
				(SELECT route_order FROM Train_route WHERE train_no=train_book AND station_id=T1.start_station)+1)=doj AND
				T1.class=class_book);
				UPDATE Ticket_booking SET status=CONCAT('WL',TO_NUMBER(SUBSTR(status,3))-1) WHERE TO_NUMBER(SUBSTR(status,3))>up_list(iterator)
				AND pnr_no IN (SELECT Ticket_booking.pnr_no FROM Ticket_booking INNER JOIN Ticket_details T1 ON T1.pnr_no=Ticket_booking.pnr_no WHERE T1.train_no=train_book AND 
				TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-(SELECT route_order FROM Train_route WHERE train_no=train_book 
				AND station_id=T1.start_station)+1)=doj AND T1.class=class_book AND REGEXP_LIKE(Ticket_booking.status,CONCAT('WL','(*)')));
				iterator:=iterator-1;
			END LOOP;
			SELECT COUNT(*) INTO counter FROM Seat_status WHERE train_no=train_book AND coach=coach_book AND seat_no=seat_book 
			AND date_of_journey=doj;
			IF counter=0 THEN
				UPDATE Train_seats SET status=NULL WHERE date_of_journey=doj AND train_no=train_book AND coach=coach_book AND seat_no=seat_book;
			END IF;
		ELSE
			UPDATE Ticket_booking SET status=CONCAT('WL',TO_NUMBER(SUBSTR(status,3))-1) WHERE TO_NUMBER(SUBSTR(status,3))>TO_NUMBER(SUBSTR(book_status,3))
			AND pnr_no IN (SELECT Ticket_booking.pnr_no FROM Ticket_booking INNER JOIN Ticket_details T1 ON T1.pnr_no=Ticket_booking.pnr_no WHERE T1.train_no=train_book AND TO_DATE(TO_CHAR(T1.depart_time,'DD-MM-YYYY')-
			(SELECT route_order FROM Train_route WHERE train_no=train_book AND station_id=T1.start_station)+1)=doj AND
			T1.class=class_book AND REGEXP_LIKE(Ticket_booking.status,CONCAT('WL','(*)')));
		END IF;
	END IF;
END;
/



-- INSERT INTO Ticket_details (user_id,passenger_count,train_no,class,start_station,end_station,depart_time,arrival_time,date_of_booking,fare)
-- VALUES('wegrf',1,11019,'B',20,25,'2020/04/07 14:20:00','2000/04/07 17:20:00',SYSDATE,600);

-- DECLARE

-- BEGIN
-- 	Book_ticket(20,25,11019,'B','07-APR-2020',111139,'UB',1,1,'mol','M',20);
-- END;
-- /


-- SELECT T1.class,(SELECT route_order FROM Train_route 
-- WHERE train_no=T1.train_no AND station_id=T1.start_station)+1,T1.train_no,Ticket_booking.status FROM Ticket_details T1 INNER JOIN Ticket_booking ON
-- T1.pnr_no=Ticket_booking.pnr_no WHERE Ticket_booking.passenger_id=&choice AND T1.pnr_no=&pnr_number;

COMMIT;