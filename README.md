# Railway Reservation System

This is a Railway Reservation System where the users can register, book and cancel tickets in trains across different stations.

Below are some of the assumptions taken while building this system taking into account the feasibility of the project. 
* The number of trains are limited to 6 trains .
* The number of stations is also limited to around 58 stations through which the above trains pass.
* The above stations, trains and the schedules are taken from the official IRCTC website.
* The fare for the travel is not predetermined and is based on the number of stations between the start station and end station.
* The booking is open for the next 20 days from the present date.
* The seats are divided into 4 classes namely, Sleeper, 3AC, 2AC, 1AC and number of coaches are limited to 5 in each class.
* We consider only Waiting-list (WL) if the tickets are sold out and won’t consider RAC or any other options.

Functionalities included:
* User Registration
* Change Password
* Forgot Password
* Ticket Availability
* DBMS Scheduler 
* Ticket Booking
* Booked Ticket History
* PNR Enquiry
* Ticket Cancellation


## Requirements

python3 (Tkinter, cx_Oracle)
Oracle SQL 

## Instructions

