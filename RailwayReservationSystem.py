from tkinter import *
from tkinter import messagebox as ms
from datetime import date
from datetime import datetime
import cx_Oracle 
import re

class AutocompleteEntry(Entry):
	def __init__(self, autocompleteList, *args, **kwargs):

		# Listbox length
		if 'listboxLength' in kwargs:
			self.listboxLength = kwargs['listboxLength']
			del kwargs['listboxLength']
		else:
			self.listboxLength = 8

		# Custom matches function
		if 'matchesFunction' in kwargs:
			self.matchesFunction = kwargs['matchesFunction']
			del kwargs['matchesFunction']
		else:
			def matches(fieldValue, acListEntry):
				pattern = re.compile('.*' + re.escape(fieldValue) + '.*', re.IGNORECASE)
				return re.match(pattern, acListEntry)
				
			self.matchesFunction = matches

		
		Entry.__init__(self, *args, **kwargs)
		self.focus()

		self.autocompleteList = autocompleteList
		
		self.var = self["textvariable"]
		if self.var == '':
			self.var = self["textvariable"] = StringVar()

		self.var.trace('w', self.changed)
		self.bind("<Right>", self.selection)
		self.bind("<Up>", self.moveUp)
		self.bind("<Down>", self.moveDown)
		
		self.listboxUp = False

	def changed(self, name, index, mode):
		if self.var.get() == '':
			if self.listboxUp:
				self.listbox.destroy()
				self.listboxUp = False
		else:
			words = self.comparison()
			if words:
				if not self.listboxUp:
					self.listbox = Listbox(width=self["width"], height=self.listboxLength)
					self.listbox.bind("<Button-1>", self.selection)
					self.listbox.bind("<Right>", self.selection)
					self.listbox.place(x=self.winfo_x(), y=self.winfo_y() + self.winfo_height())
					self.listboxUp = True
				
				self.listbox.delete(0, END)
				for w in words:
					self.listbox.insert(END,w)
			else:
				if self.listboxUp:
					self.listbox.destroy()
					self.listboxUp = False
		
	def selection(self, event):
		if self.listboxUp:
			self.var.set(self.listbox.get(ACTIVE))
			# self["textvariable"]=self.var.get()
			self.listbox.destroy()
			self.listboxUp = False
			self.icursor(END)

	def moveUp(self, event):
		if self.listboxUp:
			if self.listbox.curselection() == ():
				index = '0'
			else:
				index = self.listbox.curselection()[0]
				
			if index != '0':				
				self.listbox.selection_clear(first=index)
				index = str(int(index) - 1)
				
				self.listbox.see(index) # Scroll!
				self.listbox.selection_set(first=index)
				self.listbox.activate(index)

	def moveDown(self, event):
		if self.listboxUp:
			if self.listbox.curselection() == ():
				index = '0'
			else:
				index = self.listbox.curselection()[0]
				
			if index != END:						
				self.listbox.selection_clear(first=index)
				index = str(int(index) + 1)
				
				self.listbox.see(index) # Scroll!
				self.listbox.selection_set(first=index)
				self.listbox.activate(index) 

	def comparison(self):
		return [ w for w in self.autocompleteList if self.matchesFunction(self.var.get(), w) ]


regex='^\w+([\.-]?\w+)*@\w+([\.-]?\w+)*(\.\w{2,3})+$'
bullet = "\u2022"
coachdict={'AC 1 TIER (1A)':'A','AC 2 TIER (2A)':'B','AC 3 TIER (3A)':'C','SLEEPER (SL)':'S'}
faredict={'AC 1 TIER (1A)':1.25,'AC 2 TIER (2A)':1,'AC 3 TIER (3A)':0.75,'SLEEPER (SL)':0.5}
berthdict={"Upper":'UB', "Middle":'MB', "Lower":'LB', "Side-upper":'SU',"Side-lower":'SL'}
genderdict={'Male':'M','Female':'F','Other':'O'}
date_format = '%d-%m-%Y'

class main:
	def __init__(self,master):
		# Window 
		self.master = master
		# Some Useful textvariables
		self.firstName = StringVar()
		self.lastName = StringVar()
		self.gender = StringVar()
		self.dateOfBirth = StringVar()
		self.email=StringVar()
		self.mobileNumber=StringVar()
		self.city = StringVar()
		self.state =StringVar()
		self.pincode=StringVar()
		self.userName=StringVar()
		self.password = StringVar()
		self.confirmPassword=StringVar()
		self.securityQues=StringVar()
		self.securityAns=StringVar()
		self.userNameLog=StringVar()   
		self.passwordLog=StringVar()  
		self.recUserName=StringVar()
		self.recEmail=StringVar()
		self.recNumber=StringVar()
		self.recOption=int()
		self.recSecQues=StringVar()
		self.recSecAns=StringVar()
		self.recSecAnsCheck=StringVar() 
		self.upPassword=StringVar()
		self.confUpPassword=StringVar()
		self.fromStation=AutocompleteEntry(self)
		self.toStation=AutocompleteEntry(self)
		self.classSelected=StringVar()
		self.dateofjourney=StringVar()
		self.temptrainno=StringVar()
		self.passengerCount=StringVar()
		self.changePassword=StringVar()
		self.changeNewPassword=StringVar()
		self.confChangeNewPassword=StringVar()
		self.passengerDet=list()
		self.pnrdetail=StringVar()
		self.cancelchoice=StringVar()
		#Create Widgets
		self.widgets()

	def date_valid(self,date_given):
		try:
			date_obj = datetime.strptime(date_given, date_format)
			return 1
		except ValueError:
			return 0

	def login(self):
		if self.userNameLog.get()=='' or self.passwordLog.get()=='':
			ms.showerror('Oops!','Enter all the details!')
		else:
			con = cx_Oracle.connect('username/password@localhost')
			cursor=con.cursor()
			cursor.prepare('SELECT * FROM User_details WHERE user_id= :user_id AND password=:password')
			cursor.execute(None,{'user_id':self.userNameLog.get(),'password':self.passwordLog.get()})
			us=cursor.fetchone()
			if us:
				self.trainbetstation()
			else:
				ms.showerror('Oops!','Invalid Credentials!')

	def register(self):
		if self.firstName.get()=='' or self.lastName.get()=='' or self.gender.get()=='' or\
		self.dateOfBirth.get()=='' or self.email.get()==''or self.mobileNumber.get()=='' or\
		self.city.get()=='' or self.state.get()=='' or self.pincode.get()=='' or self.userName.get()=='' or \
		self.password.get()==''or self.confirmPassword.get()==''or self.securityQues.get()==''or self.securityAns.get()=='':
			ms.showerror('Oops!','Enter all the details!')
		elif len(self.password.get())<8:
			ms.showerror('Oops!','Password should be at least 8 characters long!')
		elif self.password.get()!=self.confirmPassword.get():
			ms.showerror('Oops!','Passwords do not match!')
		elif self.mobileNumber.get().isdigit()==False:
			ms.showerror('Oops!','Enter a valid Mobile Number!')
		elif self.pincode.get().isdigit()==False:
			ms.showerror('Oops!','Enter a valid pincode!')
		elif not re.search(regex,self.email.get()):
			ms.showerror('Oops!','Enter a valid Email!')
		elif len(self.userName.get())<=4:
			ms.showerror('Oops!','Username should be at least 5 characters long!')
		else:
			con = cx_Oracle.connect('username/password@localhost')
			cursor=con.cursor()
			cursor.prepare('SELECT * FROM User_details WHERE user_id= :user_id')
			cursor.execute(None,{'user_id':self.userName.get()})
			ui=cursor.fetchone()
			if ui:
				ms.showerror('Oops!','Username already exists! Try a different one!')
			else:
				cursor.prepare('SELECT * FROM User_details WHERE mobile_no= :mobile_no')
				cursor.execute(None,{'mobile_no':self.mobileNumber.get()})
				mn=cursor.fetchone()
				cursor.prepare('SELECT * FROM User_details WHERE email= :email')
				cursor.execute(None,{'email':self.email.get()})
				en=cursor.fetchone()
				if mn:
					ms.showerror('Oops!','Mobile number already registered!')
				elif en:
					ms.showerror('Oops!','Email already registered!')
				else:
					cursor.execute("ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY'")
					cursor.prepare('INSERT INTO User_details(user_id,first_name,last_name,gender,date_of_birth,mobile_no,\
						email,city,state,pincode,password,security_ques,security_ans) VALUES (:user_id,:first_name,:last_name,\
						:gender,:date_of_birth,:mobile_no,:email,:city,:state,:pincode,:password,:security_ques,:security_ans)')
					cursor.execute(None,{'user_id':self.userName.get(),'first_name':self.firstName.get(),'last_name':self.lastName.get(),\
						'gender':self.gender.get(),'date_of_birth':self.dateOfBirth.get(),'mobile_no':int(self.mobileNumber.get()),\
						'email':self.email.get(),'city':self.city.get(),'state':self.state.get(),'pincode':self.pincode.get(),\
						'password':self.password.get(),'security_ques':self.securityQues.get(),'security_ans':self.securityAns.get()})	
					ms.showinfo('Success!','Account has been created!')
					self.log()
			con.commit()

	def getsecdetails(self):
		con = cx_Oracle.connect('username/password@localhost')
		cursor=con.cursor()
		if self.recUserName.get()!='':
			cursor.prepare('SELECT security_ques,security_ans FROM User_details WHERE user_id= :user_id')
			cursor.execute(None,{'user_id':self.recUserName.get()})
			rup=cursor.fetchone()
			if rup:
				self.recSecQues.set(rup[0])
				self.recSecAns.set(rup[1])
				self.recOption=0
				self.checksecdetails()
			else:
				ms.showerror('Oops!','Username not found!')
		elif self.recEmail.get()!='':
			cursor.prepare('SELECT security_ques,security_ans FROM User_details WHERE email= :email')
			cursor.execute(None,{'email':self.recEmail.get()})
			rep=cursor.fetchone()
			if rep:
				self.recSecQues.set(rep[0])
				self.recSecAns.set(rep[1])
				self.recOption=1
				self.checksecdetails()				
			else:
				ms.showerror('Oops!','Email not found!')
		elif self.recNumber.get()!='':
			cursor.prepare('SELECT security_ques,security_ans FROM User_details WHERE mobile_no= :mobile_no')
			cursor.execute(None,{'mobile_no':self.recNumber.get()})
			rnp=cursor.fetchone()
			if rnp:
				self.recSecQues.set(rnp[0])
				self.recSecAns.set(rnp[1])
				self.recOption=2
				self.checksecdetails()
			else:
				ms.showerror('Oops!','Number not found!')
		else:
			ms.showerror('Oops!','Enter all the details!')
		con.commit()

	def checkans(self):
		if self.recSecAnsCheck.get()=='':
			ms.showerror('Oops!','Enter the answer!')
		elif self.recSecAnsCheck.get()==self.recSecAns.get():
			self.updatepass()
		else:
			ms.showerror('Oops!','Wrong Answer!')

	def updatepassfun(self):
		if self.upPassword.get()=='' or self.confUpPassword.get()=='':
			ms.showerror('Oops!','Enter the password')
		elif len(self.upPassword.get())<8:
			ms.showerror('Oops!','Password should be at least 8 characters long!')
		elif self.upPassword.get()!=self.confUpPassword.get():
			ms.showerror('Oops!','Passwords do not match!')
		else:
			con = cx_Oracle.connect('username/password@localhost')
			cursor=con.cursor()
			if self.recOption==0:
				cursor.prepare('UPDATE User_details SET password=:password WHERE user_id= :user_id')
				cursor.execute(None,{'password':self.upPassword.get(),'user_id':self.recUserName.get()})
			elif self.recOption==1:
				cursor.prepare('UPDATE User_details SET password=:password WHERE email= :email')
				cursor.execute(None,{'password':self.upPassword.get(),'email':self.recEmail.get()})
			else:
				cursor.prepare('UPDATE User_details SET password=:password WHERE mobile_no= :mobile_no')
				cursor.execute(None,{'password':self.upPassword.get(),'mobile_no':self.recNumber.get()})
			ms.showinfo('Success!','Password Updated!')
			con.commit()
			self.log()

	def changepassfun(self):
		if self.changePassword.get()=='' or self.changeNewPassword.get()=='' or self.confChangeNewPassword.get()=='':
			ms.showerror('Oops!','Enter all the details')
		elif len(self.changeNewPassword.get())<8:
			ms.showerror('Oops!','Password should be at least 8 characters long!')
		elif self.changeNewPassword.get()!=self.confChangeNewPassword.get():
			ms.showerror('Oops!','Passwords do not match!')
		else:
			con = cx_Oracle.connect('username/password@localhost')
			cursor=con.cursor()
			cursor.prepare('SELECT password FROM User_details WHERE user_id= :user_id')
			cursor.execute(None,{'user_id':self.userNameLog.get()})
			oldpass=cursor.fetchone()
			if oldpass[0]==self.changePassword.get():
				cursor.prepare('UPDATE User_details SET password=:password WHERE user_id= :user_id')
				cursor.execute(None,{'password':self.changeNewPassword.get(),'user_id':self.userNameLog.get()})
				ms.showinfo('Success!','Password Updated!')
				con.commit()
				self.log()
			else:
				ms.showerror('Oops!','Wrong Old Password!')


	def findtrains(self):
		if self.fromStation.get()=='' or self.toStation.get()=='' or self.dateofjourney.get()=='' or self.classSelected.get()=='':
			ms.showerror('Oops!','Enter all the details!')
		elif self.date_valid(self.dateofjourney.get())==0:
			ms.showerror('Oops!',"Enter the date in 'DD-MM-YYYY' format!")
		else:
			a=datetime.strptime(self.dateofjourney.get(), '%d-%m-%Y')
			b=datetime.strptime(date.today().strftime("%d-%m-%Y"),'%d-%m-%Y')
			no_days=a-b
			if no_days.days<=20 and no_days.days>0:
				con = cx_Oracle.connect('username/password@localhost')
				cursor=con.cursor()
				res1 = [int(i) for i in self.toStation.get().split() if i.isdigit()]
				temp_to=res1[0]
				res2 = [int(i) for i in self.fromStation.get().split() if i.isdigit()]
				temp_from=res2[0]
				cursor.prepare('SELECT Train.train_name, Train.train_no FROM\
					(SELECT T1.train_no FROM Train_route T1 INNER JOIN Train_route T2 ON T1.train_no=T2.train_no AND T1.station_id=:start_station \
					AND T2.station_id=:end_station AND T1.route_order<T2.route_order) T3 INNER JOIN Train ON T3.train_no=Train.train_no')
				cursor.execute(None,{'start_station':temp_from,'end_station':temp_to})
				trainList=cursor.fetchall()
				if trainList:
					k=0
					for i in trainList:
						cursor.execute("ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY'")
						avail_tickets=cursor.callfunc('Ticket_availability',int,[temp_from,temp_to,i[1],coachdict[self.classSelected.get()],self.dateofjourney.get()])
						cursor.prepare("SELECT CONCAT(CONCAT(:date_1,' '),TO_CHAR(T1.Depart_time, 'HH24:MI:SS')) AS Departure_time,\
							CONCAT(CONCAT(TO_DATE(:date_2)+day2-day1,' '),TO_CHAR(T2.Arrive_time, 'HH24:MI:SS')) AS Arrival_time,\
							CONCAT(CONCAT(EXTRACT(DAY FROM ((Arrive_time+day2-day1) - Depart_time))*24 +EXTRACT( HOUR FROM ((Arrive_time+day2-day1) - Depart_time)),':'),\
							EXTRACT( MINUTE FROM ((Arrive_time+day2-day1) - Depart_time)) )AS Duration FROM\
							((SELECT train_depart AS Depart_time,train_day AS day1 FROM Train_route WHERE train_no=:train_no_1 AND station_id=:station_id_1)T1 CROSS JOIN\
							(SELECT train_arrival AS Arrive_time,train_day AS day2 FROM Train_route WHERE train_no=:train_no_2 AND station_id=:station_id_2)T2)")
						cursor.execute(None,{'date_1':self.dateofjourney.get(),'date_2':self.dateofjourney.get(),'train_no_1':i[1],'train_no_2':i[1],'station_id_1':temp_from,'station_id_2':temp_to})
						train_time=cursor.fetchone()
						# print(train_time)
						Message(self.trainlistpack,text='AVAILABLE '+str(avail_tickets),anchor=W,width=200).grid(row = 2*k,column=1,padx = 3, pady = 3)
						Radiobutton(self.trainlistpack,text=i[0],variable=self.temptrainno,value=str(i[1])).\
						grid(row = 2*k,column=0,padx = 3, pady = 3)
						Message(self.trainlistpack,text='Departure Time : '+train_time[0]+' Arrival Time : '+train_time[1]+' Duration : '+train_time[2],anchor=W,width=200).grid(row = 2*k+1,column=1,padx = 3, pady = 3)
						k=k+1
					Label(self.trainlistpack, text = "No. of passengers :").grid(row = 2*k,column=0,padx = 3, pady = 3)
					Entry(self.trainlistpack, width = 40, borderwidth = 2,textvariable=self.passengerCount).grid(row = 2*k,column=1,padx = 3, pady = 3)
					Button(self.trainlistpack,text='Book tickets!',command=self.passengerdetails, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")\
					.grid(row=2*k+1,column=1,padx=2,pady=3)
					self.trainlistfun()

				else:
					ms.showerror('Oops!','No trains found')
			else:
				ms.showerror('Oops!','You can only book tickets for next 20 days')

	def booktickets(self):
		checkdet=True
		for i in range(int(self.passengerCount.get())):
			if self.passengerDet[i][0].get()=='' or self.passengerDet[i][1].get()=='' or \
			self.passengerDet[i][2].get()=='' or self.passengerDet[i][3].get()=='':
				checkdet=False
				break
		if checkdet:
			res1 = [int(i) for i in self.toStation.get().split() if i.isdigit()]
			temp_to=res1[0]
			res2 = [int(i) for i in self.fromStation.get().split() if i.isdigit()]
			temp_from=res2[0]
			con = cx_Oracle.connect('username/password@localhost')
			cursor=con.cursor()
			cursor.execute("ALTER SESSION SET NLS_DATE_FORMAT = 'DD-MM-YYYY'")
			cursor.prepare("SELECT CONCAT(CONCAT(:date_1,' '),TO_CHAR(T1.Depart_time, 'HH24:MI:SS')) AS Departure_time,\
				CONCAT(CONCAT(TO_DATE(:date_2)+day2-day1,' '),TO_CHAR(T2.Arrive_time, 'HH24:MI:SS')) AS Arrival_time,from_ord,to_ord FROM\
				((SELECT train_depart AS Depart_time,train_day AS day1,route_order AS from_ord FROM Train_route WHERE train_no=:train_no_1 AND station_id=:station_id_1)T1 CROSS JOIN\
				(SELECT train_arrival AS Arrive_time,train_day AS day2,route_order AS to_ord FROM Train_route WHERE train_no=:train_no_2 AND station_id=:station_id_2)T2)")
			cursor.execute(None,{'date_1':self.dateofjourney.get(),'date_2':self.dateofjourney.get(),'train_no_1':int(self.temptrainno.get()),\
				'train_no_2':int(self.temptrainno.get()),'station_id_1':temp_from,'station_id_2':temp_to})
			train_time=cursor.fetchone()
			cursor.prepare("INSERT INTO Ticket_details (user_id,passenger_count,train_no,class,start_station,end_station,\
				depart_time,arrival_time,date_of_booking,fare) VALUES\
				(:user_id,:passenger_count,:train_no,:class_sel,:start_station,:end_station,\
				TO_DATE(:depart_time,'DD-MM-YYYY HH24:MI:SS'),TO_DATE(:arrival_time,'DD-MM-YYYY HH24:MI:SS'),:date_of_booking,:fare)")
			cursor.execute(None,{'user_id':self.userNameLog.get(),'passenger_count':int(self.passengerCount.get()),'train_no':int(self.temptrainno.get()),\
				'class_sel':coachdict[self.classSelected.get()],'start_station':temp_from,'end_station':temp_to,'depart_time':train_time[0],\
				'arrival_time':train_time[1],'date_of_booking':date.today().strftime("%d/%m/%Y"),'fare':(train_time[3]-train_time[2])*100*faredict[self.classSelected.get()]*int(self.passengerCount.get())})
			cursor.execute("SELECT MAX(pnr_no) FROM Ticket_details")
			pnr_number=cursor.fetchone()
			for i in range(int(self.passengerCount.get())):
				cursor.callproc('Book_ticket',[temp_from,temp_to,int(self.temptrainno.get()),coachdict[self.classSelected.get()],self.dateofjourney.get(),\
					pnr_number[0],berthdict[self.passengerDet[i][3].get()],i+1,self.passengerCount.get(),self.passengerDet[i][0].get(),\
					genderdict[self.passengerDet[i][2].get()],int(self.passengerDet[i][1].get())])
			con.commit()
			print('Success!')
			ms.showinfo('Success!','Tickets Booked!')
			self.ticketdetails(pnr_number[0])
		else:
			ms.showerror('Oops!','Enter all the details!')

	def ticketdetails(self,pnr_num):
		con = cx_Oracle.connect('username/password@localhost')
		cursor=con.cursor()
		cursor.prepare("SELECT Ticket_details.pnr_no AS PNR_NO,train.train_no AS Train_no, Train.train_name AS Train_name,S1.station_name AS Start_Station,\
			S2.station_name AS End_Station,Ticket_booking.passenger_name AS Name,Ticket_booking.gender AS Gender,\
			Ticket_booking.age AS Age,Ticket_booking.status AS Status, Seat_status.coach AS Coach,\
			Seat_status.seat_no AS Seat_no, Ticket_details.depart_time AS Departure_time, Ticket_details.arrival_time AS Arrival_time FROM\
			Ticket_details INNER JOIN Train ON Ticket_details.train_no=Train.train_no INNER JOIN\
			Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON \
			S2.station_id=Ticket_details.end_station INNER JOIN \
			Ticket_booking ON Ticket_details.pnr_no=Ticket_booking.pnr_no INNER JOIN\
			Seat_status ON Ticket_booking.pnr_no=Seat_status.pnr_no AND Ticket_booking.passenger_id=Seat_status.pnr_id WHERE\
			Ticket_details.pnr_no=:pnr_no ORDER BY Ticket_booking.passenger_id")
		cursor.execute(None,{'pnr_no':pnr_num})
		details=cursor.fetchall()
		cursor.prepare("SELECT Ticket_details.pnr_no AS PNR_NO,train.train_no AS Train_no, Train.train_name AS Train_name,S1.station_name AS Start_Station,\
			S2.station_name AS End_Station,Ticket_booking.passenger_name AS Name,Ticket_booking.gender AS Gender,\
			Ticket_booking.age AS Age,Ticket_booking.status AS Status,\
			Ticket_details.depart_time AS Departure_time, Ticket_details.arrival_time AS Arrival_time FROM\
			Ticket_details INNER JOIN Train ON Ticket_details.train_no=Train.train_no INNER JOIN\
			Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON \
			S2.station_id=Ticket_details.end_station INNER JOIN \
			Ticket_booking ON Ticket_details.pnr_no=Ticket_booking.pnr_no WHERE\
			Ticket_details.pnr_no=:pnr_no ORDER BY Ticket_booking.passenger_id")
		cursor.execute(None,{'pnr_no':pnr_num})
		det=cursor.fetchall()
		print(details)
		Message(self.ticketdetailspack,text='PNR NUMBER : '+str(det[0][0]),anchor=W,width=200).grid(row = 0,column=0,padx = 3, pady = 3)
		Message(self.ticketdetailspack,text='Train : '+det[0][2]+'('+str(det[0][1])+')',anchor=W,width=200).grid(row = 1,column=0,padx = 3, pady = 3)
		Message(self.ticketdetailspack,text='From : '+det[0][3],anchor=W,width=200).grid(row = 2,column=0,padx = 3, pady = 3)
		Message(self.ticketdetailspack,text='To : '+det[0][4],anchor=W,width=200).grid(row = 2,column=1,padx = 3, pady = 3)
		Message(self.ticketdetailspack,text='Departure Time : '+str(det[0][9]),anchor=W,width=200).grid(row = 3,column=0,padx = 3, pady = 3)
		Message(self.ticketdetailspack,text='Arrival Time : '+str(det[0][10]),anchor=W,width=200).grid(row = 3,column=1,padx = 3, pady = 3)
		c=1
		for k in det:
			Message(self.ticketdetailspack,text='Passenger '+str(c),anchor=W,width=100).grid(row = 4+3*(c-1),column=0,padx = 3, pady = 3)
			Message(self.ticketdetailspack,text='Name : '+k[5],anchor=W,width=200).grid(row = 5+3*(c-1),column=1,padx = 3, pady = 3)
			Message(self.ticketdetailspack,text='Gender : '+k[6],anchor=W,width=200).grid(row = 5+3*(c-1),column=2,padx = 3, pady = 3)
			Message(self.ticketdetailspack,text='Age : '+str(k[7]),anchor=W,width=200).grid(row = 5+3*(c-1),column=3,padx = 3, pady = 3)
			Message(self.ticketdetailspack,text='Status : '+k[8],anchor=W,width=200).grid(row = 6+3*(c-1),column=1,padx = 3, pady = 3)
			if k[8]=='CNF':
				Message(self.ticketdetailspack,text='Coach : '+details[c-1][9],anchor=W,width=200).grid(row = 6+3*(c-1),column=2,padx = 3, pady = 3)
				Message(self.ticketdetailspack,text='Seat Number : '+str(details[c-1][10]),anchor=W,width=200).grid(row = 6+3*(c-1),column=3,padx = 3, pady = 3)
			c=c+1
		Button(self.ticketdetailspack,text='Book another ticket!',command=self.trainbetstation, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")\
			.grid(row=4+3*(c-1),column=1,padx=2,pady=3)
		self.head['text'] = 'TICKET DETAILS'
		self.master.config(menu="")
		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.registerpack.pack_forget()
		self.findtrainpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.ticketdetailspack.pack()

	def passengerdetails(self):
		#print(self.temptrainno.get())
		if self.temptrainno.get()=='' or self.passengerCount.get()=='':
			ms.showerror('Oops!','Enter all the details!')
		else:
			self.passengerDet.clear()
			for i in range(int(self.passengerCount.get())): 
				self.passengerDet.append([StringVar(),StringVar(),StringVar(),StringVar()])
			for i in range(int(self.passengerCount.get())):
				Label(self.passengerlistpack, text = "Passenger "+str(i+1)+":").grid(row = i*5,column=0,padx = 3, pady = 3)
				Label(self.passengerlistpack, text = "Name :").grid(row = i*5+1,column=1,padx = 3, pady = 3)
				Label(self.passengerlistpack, text = "Age :").grid(row = i*5+2,column=1,padx = 3, pady = 3)
				Label(self.passengerlistpack, text = "Gender :").grid(row = i*5+3,column=1,padx = 3, pady = 3)
				Label(self.passengerlistpack, text = "Berth preference :").grid(row = i*5+4,column=1,padx = 3, pady = 3)
				temp_gender=StringVar()
				temp_berth=StringVar()
				entryname=Entry(self.passengerlistpack,textvariable=self.passengerDet[i][0],width = 40, borderwidth = 2).grid(row = i*5+1,column=2,padx = 3, pady = 3)
				entryage=Entry(self.passengerlistpack,textvariable=self.passengerDet[i][1], width = 40, borderwidth = 2).grid(row = i*5+2,column=2,padx = 3, pady = 3)
				entrygender=OptionMenu(self.passengerlistpack,self.passengerDet[i][2], "Male", "Female", "Other").grid(row = i*5+3,column=2,padx = 3, pady = 3)
				entryberthpref=OptionMenu(self.passengerlistpack,self.passengerDet[i][3], "Upper", "Middle", "Lower", "Side-upper","Side-lower").\
				grid(row = i*5+4,column=2,padx = 3, pady = 3)
			Button(self.passengerlistpack,text='Book tickets!',command=self.booktickets, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")\
			.grid(row=int(self.passengerCount.get())*5+1,column=1,padx=2,pady=3)
			my_menu = Menu(self.master)
			self.master.config(menu=my_menu)
			self.head['text'] = 'ENTER DETAILS'
			my_menu.add_command(label='Back',command=self.trainlistfun)
			self.mainpack.pack_forget()  
			self.loginpack.pack_forget()
			self.checkanspack.pack_forget()
			self.forgotpasspack.pack_forget()
			self.updatepasspack.pack_forget()
			self.registerpack.pack_forget()
			self.findtrainpack.pack_forget()
			self.trainlistpack.pack_forget()
			self.ticketdetailspack.pack_forget()
			self.changepasspack.pack_forget()
			self.bookedticketpack.pack_forget()
			self.pnrticketdetpack.pack_forget()
			self.pnrenqpack.pack_forget()
			self.cancelticketdetailspack.pack_forget()
			self.cancelticketselpack.pack_forget()
			self.passengerlistpack.pack()

	def canceltickets(self):
		print(self.cancelchoice.get())
		print(self.pnrdetail.get())
		con = cx_Oracle.connect('username/password@localhost')
		cursor=con.cursor()
		cursor.callproc('Cancel_ticket',[int(self.pnrdetail.get()),int(self.cancelchoice.get())])
		ms.showinfo('Success','Tickets cancelled!')
		con.commit()
		self.trainbetstation()

	def cancelticketsel(self):
		con = cx_Oracle.connect('username/password@localhost')
		cursor=con.cursor()
		cursor.prepare("SELECT Ticket_details.pnr_no AS PNR_NO,train.train_no AS Train_no, Train.train_name AS Train_name,S1.station_name AS Start_Station,\
			S2.station_name AS End_Station,Ticket_booking.passenger_name AS Name,Ticket_booking.gender AS Gender,\
			Ticket_booking.age AS Age,Ticket_booking.status AS Status, Seat_status.coach AS Coach,\
			Seat_status.seat_no AS Seat_no, Ticket_details.depart_time AS Departure_time, Ticket_details.arrival_time AS Arrival_time FROM\
			Ticket_details INNER JOIN Train ON Ticket_details.train_no=Train.train_no INNER JOIN\
			Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON \
			S2.station_id=Ticket_details.end_station INNER JOIN \
			Ticket_booking ON Ticket_details.pnr_no=Ticket_booking.pnr_no INNER JOIN\
			Seat_status ON Ticket_booking.pnr_no=Seat_status.pnr_no AND Ticket_booking.passenger_id=Seat_status.pnr_id WHERE\
			Ticket_details.pnr_no=:pnr_no ORDER BY Ticket_booking.passenger_id")
		cursor.execute(None,{'pnr_no':self.pnrdetail.get()})
		details=cursor.fetchall()
		cursor.prepare("SELECT Ticket_details.pnr_no AS PNR_NO,train.train_no AS Train_no, Train.train_name AS Train_name,S1.station_name AS Start_Station,\
			S2.station_name AS End_Station,Ticket_booking.passenger_name AS Name,Ticket_booking.gender AS Gender,\
			Ticket_booking.age AS Age,Ticket_booking.status AS Status,\
			Ticket_details.depart_time AS Departure_time, Ticket_details.arrival_time AS Arrival_time FROM\
			Ticket_details INNER JOIN Train ON Ticket_details.train_no=Train.train_no INNER JOIN\
			Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON \
			S2.station_id=Ticket_details.end_station INNER JOIN \
			Ticket_booking ON Ticket_details.pnr_no=Ticket_booking.pnr_no WHERE\
			Ticket_details.pnr_no=:pnr_no ORDER BY Ticket_booking.passenger_id")
		cursor.execute(None,{'pnr_no':self.pnrdetail.get()})
		det=cursor.fetchall()
		print(details)
		Message(self.cancelticketselpack,text='PNR NUMBER : '+str(det[0][0]),anchor=W,width=200).grid(row = 0,column=0,padx = 3, pady = 3)
		Message(self.cancelticketselpack,text='Train : '+det[0][2]+'('+str(det[0][1])+')',anchor=W,width=200).grid(row = 1,column=0,padx = 3, pady = 3)
		Message(self.cancelticketselpack,text='From : '+det[0][3],anchor=W,width=200).grid(row = 2,column=0,padx = 3, pady = 3)
		Message(self.cancelticketselpack,text='To : '+det[0][4],anchor=W,width=200).grid(row = 2,column=1,padx = 3, pady = 3)
		Message(self.cancelticketselpack,text='Departure Time : '+str(det[0][9]),anchor=W,width=200).grid(row = 3,column=0,padx = 3, pady = 3)
		Message(self.cancelticketselpack,text='Arrival Time : '+str(det[0][10]),anchor=W,width=200).grid(row = 3,column=1,padx = 3, pady = 3)
		Radiobutton(self.cancelticketselpack,text='Cancel all tickets',variable=self.cancelchoice,value='0').\
		grid(row = 4,column=0,padx = 3, pady = 3)
		c=1
		for k in det:
			Radiobutton(self.cancelticketselpack,text='Passenger '+str(c),variable=self.cancelchoice,value=str(c)).\
			grid(row = 5+3*(c-1),column=0,padx = 3, pady = 3)
			Message(self.cancelticketselpack,text='Name : '+k[5],anchor=W,width=200).grid(row = 6+3*(c-1),column=1,padx = 3, pady = 3)
			Message(self.cancelticketselpack,text='Gender : '+k[6],anchor=W,width=200).grid(row = 6+3*(c-1),column=2,padx = 3, pady = 3)
			Message(self.cancelticketselpack,text='Age : '+str(k[7]),anchor=W,width=200).grid(row = 6+3*(c-1),column=3,padx = 3, pady = 3)
			Message(self.cancelticketselpack,text='Status : '+k[8],anchor=W,width=200).grid(row = 7+3*(c-1),column=1,padx = 3, pady = 3)
			if k[8]=='CNF':
				Message(self.cancelticketselpack,text='Coach : '+details[c-1][9],anchor=W,width=200).grid(row = 7+3*(c-1),column=2,padx = 3, pady = 3)
				Message(self.cancelticketselpack,text='Seat Number : '+str(details[c-1][10]),anchor=W,width=200).grid(row = 7+3*(c-1),column=3,padx = 3, pady = 3)
			c=c+1
		Button(self.cancelticketselpack,text='Cancel ticket!',command=self.canceltickets, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")\
			.grid(row=5+3*(c-1),column=1,padx=2,pady=3)

		self.master.config(menu="")
		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.registerpack.pack_forget()
		self.findtrainpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.cancelticketselpack.pack()

	def cancelticketdetails(self):
		con = cx_Oracle.connect('username/password@localhost')
		cursor=con.cursor()
		cursor.prepare("SELECT Ticket_details.pnr_no,S1.station_name,S2.station_name,Train.train_name,Train.train_no,TO_CHAR(Ticket_details.depart_time,'DD-MM-YYYY'),\
			TO_CHAR(Ticket_details.date_of_booking,'DD-MM-YYYY') FROM Ticket_details INNER JOIN Train ON Train.train_no=Ticket_details.train_no \
			INNER JOIN Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON S2.station_id=Ticket_details.end_station WHERE \
			Ticket_details.user_id=:user_id ORDER BY TO_CHAR(Ticket_details.depart_time,'DD-MM-YYYY'),TO_CHAR(Ticket_details.date_of_booking,'DD-MM-YYYY') DESC")
		cursor.execute(None,{'user_id':self.userNameLog.get()})
		details=cursor.fetchall()
		i=0
		for k in details:
			Message(self.cancelticketdetailspack,text='Train : '+k[3]+'('+str(k[4])+')'+' From : '+k[1]+' To : '+k[2]+' Date of journey : '+k[5]+' Date of booking : '+k[6],anchor=W,width=800).\
			grid(row = i,column=1,padx = 3, pady = 3)
			Radiobutton(self.cancelticketdetailspack,text=str(k[0]),variable=self.pnrdetail,value=str(k[0])).\
			grid(row = i,column=0,padx = 3, pady = 3)
			i=i+1
			if i==10:
				break;
		Button(self.cancelticketdetailspack,text='Get Details!',command=self.cancelticketsel, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")\
			.grid(row=i,column=1,padx=2,pady=3)
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		my_menu.add_command(label='Back',command=self.trainbetstation)
		self.head['text'] = 'CANCEL TICKETS'
		self.bookedticketpack.pack_forget()
		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.registerpack.pack_forget()
		self.findtrainpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.cancelticketdetailspack.pack()

	def bookedtickets(self):
		con = cx_Oracle.connect('username/password@localhost')
		cursor=con.cursor()
		cursor.prepare("SELECT Ticket_details.pnr_no,S1.station_name,S2.station_name,Train.train_name,Train.train_no,TO_CHAR(Ticket_details.depart_time,'DD-MM-YYYY'),\
			TO_CHAR(Ticket_details.date_of_booking,'DD-MM-YYYY') FROM Ticket_details INNER JOIN Train ON Train.train_no=Ticket_details.train_no \
			INNER JOIN Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON S2.station_id=Ticket_details.end_station WHERE \
			Ticket_details.user_id=:user_id ORDER BY TO_CHAR(Ticket_details.depart_time,'DD-MM-YYYY'),TO_CHAR(Ticket_details.date_of_booking,'DD-MM-YYYY') DESC")
		cursor.execute(None,{'user_id':self.userNameLog.get()})
		details=cursor.fetchall()
		i=0
		for k in details:
			Message(self.bookedticketpack,text='Train : '+k[3]+'('+str(k[4])+')'+' From : '+k[1]+' To : '+k[2]+' Date of journey : '+k[5]+' Date of booking : '+k[6],anchor=W,width=800).\
			grid(row = i,column=1,padx = 3, pady = 3)
			Radiobutton(self.bookedticketpack,text=str(k[0]),variable=self.pnrdetail,value=str(k[0])).\
			grid(row = i,column=0,padx = 3, pady = 3)
			i=i+1
			if i==10:
				break;
		Button(self.bookedticketpack,text='Get Details!',command=self.getpnrticketdetails, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")\
			.grid(row=i,column=1,padx=2,pady=3)
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		my_menu.add_command(label='Back',command=self.trainbetstation)
		self.bookedticketpack.pack()
		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.registerpack.pack_forget()
		self.findtrainpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()

	def getpnrticketdetails(self):
		if self.pnrdetail.get()=='':
			ms.showerror('Oops!','Select a PNR Number!')
		else:
			con = cx_Oracle.connect('username/password@localhost')
			cursor=con.cursor()
			cursor.prepare("SELECT * FROM Ticket_booking WHERE pnr_no=:pnr_no")
			cursor.execute(None,{'pnr_no':self.pnrdetail.get()})
			valid=cursor.fetchone()
			if valid:
				cursor.prepare("SELECT Ticket_details.pnr_no AS PNR_NO,train.train_no AS Train_no, Train.train_name AS Train_name,S1.station_name AS Start_Station,\
					S2.station_name AS End_Station,Ticket_booking.passenger_name AS Name,Ticket_booking.gender AS Gender,\
					Ticket_booking.age AS Age,Ticket_booking.status AS Status, Seat_status.coach AS Coach,\
					Seat_status.seat_no AS Seat_no, Ticket_details.depart_time AS Departure_time, Ticket_details.arrival_time AS Arrival_time FROM\
					Ticket_details INNER JOIN Train ON Ticket_details.train_no=Train.train_no INNER JOIN\
					Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON \
					S2.station_id=Ticket_details.end_station INNER JOIN \
					Ticket_booking ON Ticket_details.pnr_no=Ticket_booking.pnr_no INNER JOIN\
					Seat_status ON Ticket_booking.pnr_no=Seat_status.pnr_no AND Ticket_booking.passenger_id=Seat_status.pnr_id WHERE\
					Ticket_details.pnr_no=:pnr_no ORDER BY Ticket_booking.passenger_id")
				cursor.execute(None,{'pnr_no':self.pnrdetail.get()})
				details=cursor.fetchall()
				cursor.prepare("SELECT Ticket_details.pnr_no AS PNR_NO,train.train_no AS Train_no, Train.train_name AS Train_name,S1.station_name AS Start_Station,\
					S2.station_name AS End_Station,Ticket_booking.passenger_name AS Name,Ticket_booking.gender AS Gender,\
					Ticket_booking.age AS Age,Ticket_booking.status AS Status,\
					Ticket_details.depart_time AS Departure_time, Ticket_details.arrival_time AS Arrival_time FROM\
					Ticket_details INNER JOIN Train ON Ticket_details.train_no=Train.train_no INNER JOIN\
					Station S1 ON S1.station_id=Ticket_details.start_station INNER JOIN Station S2 ON \
					S2.station_id=Ticket_details.end_station INNER JOIN \
					Ticket_booking ON Ticket_details.pnr_no=Ticket_booking.pnr_no WHERE\
					Ticket_details.pnr_no=:pnr_no ORDER BY Ticket_booking.passenger_id")
				cursor.execute(None,{'pnr_no':self.pnrdetail.get()})
				det=cursor.fetchall()
				print(details)
				Message(self.pnrticketdetpack,text='PNR NUMBER : '+str(det[0][0]),anchor=W,width=200).grid(row = 0,column=0,padx = 3, pady = 3)
				Message(self.pnrticketdetpack,text='Train : '+det[0][2]+'('+str(det[0][1])+')',anchor=W,width=200).grid(row = 1,column=0,padx = 3, pady = 3)
				Message(self.pnrticketdetpack,text='From : '+det[0][3],anchor=W,width=200).grid(row = 2,column=0,padx = 3, pady = 3)
				Message(self.pnrticketdetpack,text='To : '+det[0][4],anchor=W,width=200).grid(row = 2,column=1,padx = 3, pady = 3)
				Message(self.pnrticketdetpack,text='Departure Time : '+str(det[0][9]),anchor=W,width=200).grid(row = 3,column=0,padx = 3, pady = 3)
				Message(self.pnrticketdetpack,text='Arrival Time : '+str(det[0][10]),anchor=W,width=200).grid(row = 3,column=1,padx = 3, pady = 3)
				c=1
				for k in det:
					Message(self.pnrticketdetpack,text='Passenger '+str(c),anchor=W,width=100).grid(row = 4+3*(c-1),column=0,padx = 3, pady = 3)
					Message(self.pnrticketdetpack,text='Name : '+k[5],anchor=W,width=200).grid(row = 5+3*(c-1),column=1,padx = 3, pady = 3)
					Message(self.pnrticketdetpack,text='Gender : '+k[6],anchor=W,width=200).grid(row = 5+3*(c-1),column=2,padx = 3, pady = 3)
					Message(self.pnrticketdetpack,text='Age : '+str(k[7]),anchor=W,width=200).grid(row = 5+3*(c-1),column=3,padx = 3, pady = 3)
					Message(self.pnrticketdetpack,text='Status : '+k[8],anchor=W,width=200).grid(row = 6+3*(c-1),column=1,padx = 3, pady = 3)
					if k[8]=='CNF':
						Message(self.pnrticketdetpack,text='Coach : '+details[c-1][9],anchor=W,width=200).grid(row = 6+3*(c-1),column=2,padx = 3, pady = 3)
						Message(self.pnrticketdetpack,text='Seat Number : '+str(details[c-1][10]),anchor=W,width=200).grid(row = 6+3*(c-1),column=3,padx = 3, pady = 3)
					c=c+1
				my_menu = Menu(self.master)
				self.master.config(menu=my_menu)
				my_menu.add_command(label='Back',command=self.trainbetstation)
				self.pnrticketdetpack.pack()
				self.mainpack.pack_forget()  
				self.loginpack.pack_forget()
				self.checkanspack.pack_forget()
				self.forgotpasspack.pack_forget()
				self.updatepasspack.pack_forget()
				self.registerpack.pack_forget()
				self.findtrainpack.pack_forget()
				self.passengerlistpack.pack_forget()
				self.ticketdetailspack.pack_forget()
				self.changepasspack.pack_forget()
				self.bookedticketpack.pack_forget()
				self.pnrenqpack.pack_forget()
				self.trainlistpack.pack_forget()
				self.cancelticketselpack.pack_forget()
				self.cancelticketdetailspack.pack_forget()
			else:
				ms.showerror('Oops!','Invalid PNR Number!')



	def reg(self):
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		my_menu.add_command(label='Back',command=self.mainmenu)
		self.head['text'] = 'REGISTER'
		self.firstName.set('')
		self.lastName.set('')
		self.gender.set('')
		self.dateOfBirth.set('')
		self.email.set('')
		self.mobileNumber.set('')
		self.city.set('')
		self.state.set('')
		self.pincode.set('')
		self.userName.set('')
		self.password.set('')
		self.confirmPassword.set('')
		self.state.set('')  
		self.securityQues.set('')
		self.securityAns.set('')
		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.findtrainpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.registerpack.pack()	

	def log(self):
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		my_menu.add_command(label='Back',command=self.mainmenu)
		self.head['text'] = 'LOGIN'
		self.userNameLog.set('')
		self.passwordLog.set('')
		self.mainpack.pack_forget()
		self.registerpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.findtrainpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.loginpack.pack()

	def mainmenu(self):
		self.master.config(menu="")
		self.head['text'] = 'RAILWAY RESERVATION SYSTEM'
		self.loginpack.pack_forget()
		self.registerpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.findtrainpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.mainpack.pack()

	def forgotpass(self):
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		my_menu.add_command(label='Back',command=self.log)
		self.head['text'] = 'RESET YOUR PASSWORD'
		self.recUserName.set('')
		self.recEmail.set('')
		self.recNumber.set('')
		self.loginpack.pack_forget()
		self.registerpack.pack_forget()
		self.mainpack.pack_forget()
		self.checkanspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.findtrainpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.forgotpasspack.pack()

	def checksecdetails(self):
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		my_menu.add_command(label='Back',command=self.log)
		self.head['text'] = 'RESET YOUR PASSWORD'
		ques=Message(self.checkanspack,text=self.recSecQues.get(),anchor=W,width=200)
		ques.grid(row = 0,column=1,padx = 3, pady = 3)
		self.recSecAnsCheck.set('')
		self.loginpack.pack_forget()
		self.registerpack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.mainpack.pack_forget()
		self.updatepasspack.pack_forget()
		self.findtrainpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.checkanspack.pack()

	def updatepass(self):
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		my_menu.add_command(label='Back',command=self.log)
		self.head['text'] = 'UPDATE PASSWORD'
		self.upPassword.set('')
		self.confUpPassword.set('')
		self.recSecAnsCheck.set('')
		self.loginpack.pack_forget()
		self.registerpack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.mainpack.pack_forget()
		self.checkanspack.pack_forget()
		self.findtrainpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.updatepasspack.pack()		

	def changepassword(self):
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		self.head['text'] = 'CHANGE PASSWORD'
		my_menu.add_command(label='Back',command=self.trainbetstation)
		self.changePassword.set('')
		self.changeNewPassword.set('')
		self.confChangeNewPassword.set('')
		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.registerpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.findtrainpack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.changepasspack.pack()

	def trainbetstation(self):
		self.dateofjourney.set('')
		self.classSelected.set('')
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		my_account = Menu(my_menu)
		self.head['text'] = 'FIND TRAINS'
		my_menu.add_cascade(label = "My Account", menu = my_account)
		my_account.add_command(label = "Change Password",command=self.changepassword)
		my_account.add_command(label = "Log Out",command=self.log)

		my_transaction = Menu(my_menu)
		my_menu.add_cascade(label = "My Transactions", menu = my_transaction)
		my_transaction.add_command(label = "Booked Ticket History",command=self.bookedtickets)
		my_transaction.add_command(label = "Cancel Ticket",command=self.cancelticketdetails)

		enquiry = Menu(my_menu)
		my_menu.add_cascade(label = "Enquiry", menu = enquiry)
		enquiry.add_command(label = "PNR Enquiry",command=self.pnrenq)
		enquiry.add_command(label = "Train Schedule")

		con = cx_Oracle.connect('username/password@localhost')
		cursor=con.cursor()

		cursor.execute('SELECT * FROM Station')
		list_stations=cursor.fetchall()

		staList=[]
		for sta in list_stations:
			staList.append(sta[1]+' '+str(sta[0]))
		def matches(fieldValue, acListEntry):
			pattern = re.compile(re.escape(fieldValue) + '.*', re.IGNORECASE)
			return re.match(pattern, acListEntry)

		From = Label(self.findtrainpack, text = "From :")
		To = Label(self.findtrainpack, text = "To :")

		self.fromStation = AutocompleteEntry(staList,self.findtrainpack, listboxLength=6, width=32, matchesFunction=matches)
		self.toStation= AutocompleteEntry(staList, self.findtrainpack, listboxLength=6, width=32, matchesFunction=matches)

		From.grid(row = 0, column = 0, padx = 3, pady = 3)
		To.grid(row = 1, column = 0, padx = 3, pady = 3)

		self.fromStation.grid(row = 0, column = 1, padx = 3, pady = 3)
		self.toStation.grid(row = 1, column = 1, padx = 3, pady = 3)

		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.registerpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.findtrainpack.pack()

	def trainlistfun(self):
		my_menu = Menu(self.master)
		self.master.config(menu=my_menu)
		self.head['text'] = 'TRAINS AVAILABLE'
		my_menu.add_command(label='Back',command=self.trainbetstation)
		self.temptrainno.set('')
		self.passengerCount.set('')
		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.registerpack.pack_forget()
		self.findtrainpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.pnrenqpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.trainlistpack.pack()


	def pnrenq(self):
		self.pnrdetail.set('')
		self.head['text'] = 'PNR ENQUIRY'
		Label(self.pnrenqpack, text = "PNR Number :").grid(row = 0,column=0,padx = 3, pady = 3)
		Entry(self.pnrenqpack,textvariable=self.pnrdetail,width = 40, borderwidth = 2).grid(row = 0,column=1,padx = 3, pady = 3)
		Button(self.pnrenqpack,text='Get Details!',command=self.getpnrticketdetails, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")\
			.grid(row=1,column=1,padx=2,pady=3)
		self.pnrenqpack.pack()
		self.temptrainno.set('')
		self.passengerCount.set('')
		self.mainpack.pack_forget()  
		self.loginpack.pack_forget()
		self.checkanspack.pack_forget()
		self.forgotpasspack.pack_forget()
		self.updatepasspack.pack_forget()
		self.registerpack.pack_forget()
		self.findtrainpack.pack_forget()
		self.passengerlistpack.pack_forget()
		self.ticketdetailspack.pack_forget()
		self.changepasspack.pack_forget()
		self.bookedticketpack.pack_forget()
		self.pnrticketdetpack.pack_forget()
		self.trainlistpack.pack_forget()
		self.cancelticketselpack.pack_forget()
		self.cancelticketdetailspack.pack_forget()

	def widgets(self):
		self.head = Label(self.master,text = 'RAILWAY RESERVATION SYSTEM',font=('Helvetica', 35),pady = 10)
		self.head.pack()
		self.mainpack=Frame(self.master)
		Button(self.mainpack,text='LOGIN',command=self.log,padx=5,pady=5).grid()
		Button(self.mainpack,text='REGISTER',command=self.reg,padx=5,pady=5).grid(row=0,column=1)
		self.mainpack.pack()
		self.registerpack = Frame(self.master)
		my_firstname = Label(self.registerpack, text = "FirstName :")
		firstname = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.firstName)

		my_lastname = Label(self.registerpack, text = "LastName :")
		lastname = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.lastName)

		gender = Label(self.registerpack, text = "Gender :")
		genderM = Radiobutton(self.registerpack, text = "Male", variable = self.gender, value = "M")
		genderF = Radiobutton(self.registerpack, text = "Female", variable = self.gender, value = "F")
		genderO = Radiobutton(self.registerpack, text = "Other", variable = self.gender, value = "O")

		dob = Label(self.registerpack, text = "Date of Birth :")
		DOB = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.dateOfBirth)

		EM = Label(self.registerpack, text = "Email :")
		email = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.email)

		MN = Label(self.registerpack, text = "Mobile Number :")
		mobile_num = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.mobileNumber)

		City = Label(self.registerpack, text = "City :")
		city = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.city)

		State = Label(self.registerpack, text = "State :")
		state = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.state)

		PinCode = Label(self.registerpack, text = "Pincode :")
		pincode = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.pincode)

		UserName = Label(self.registerpack, text = "Username :")
		username = Entry(self.registerpack, width = 40, borderwidth = 2,textvariable=self.userName)

		Password = Label(self.registerpack, text = "Password :")
		password = Entry(self.registerpack, width = 40, borderwidth = 2, show = bullet,textvariable=self.password)

		ConfirmPassword = Label(self.registerpack, text = "Confirm Password :")
		confirmpassword = Entry(self.registerpack, width = 40, borderwidth = 2, show = bullet,textvariable=self.confirmPassword)

		secQues=Label(self.registerpack,text='Security Question :')
		SecQues=OptionMenu(self.registerpack, self.securityQues,"What is your first job?","What is your pet-name?",\
			"What is your first vehicle?")

		secAns=Label(self.registerpack,text='Security Answer :')
		SecAns=Entry(self.registerpack,width = 40, borderwidth = 2,textvariable=self.securityAns)

		#button_regtomenu = Button(self.registerpack, text = "Go to Main Menu",command=self.mainmenu, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")
		button_submit = Button(self.registerpack, text = "Submit",command=self.register, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")

		UserName.grid(row = 0, column = 0, padx = 3, pady = 3)
		username.grid(row = 0, column = 1, padx = 3, pady = 3)

		Password.grid(row = 0, column = 2, padx = 3, pady = 3)
		password.grid(row = 0, column = 3, padx = 3, pady = 3)

		ConfirmPassword.grid(row= 1, column = 0, padx = 3, pady = 3)
		confirmpassword.grid(row = 1, column = 1, padx = 3, pady = 3)

		my_firstname.grid(row = 3, column = 0, padx = 3, pady = 3)
		firstname.grid(row = 3, column = 1, padx = 3, pady = 3)

		my_lastname.grid(row = 3, column = 2, padx = 3, pady = 3)
		lastname.grid(row = 3, column = 3, padx = 3, pady = 3)

		gender.grid(row = 4, column = 0, padx = 3, pady = 3)
		genderM.grid(row = 4, column = 1, padx = 3, pady = 3)
		genderF.grid(row = 4, column = 2, padx = 3, pady = 3)
		genderO.grid(row = 4, column = 3, padx = 3, pady = 3)

		dob.grid(row= 5, column = 0, padx = 3, pady = 3)
		DOB.grid(row = 5, column = 1, padx = 3, pady = 3)

		EM.grid(row = 6, column = 0, padx = 3, pady = 3)
		email.grid(row = 6, column = 1, padx = 3, pady = 3)

		MN.grid(row = 7, column = 0, padx = 3, pady = 3)
		mobile_num.grid(row = 7, column = 1, padx = 3, pady = 3)

		City.grid(row = 8, column = 0, padx = 3, pady = 3)
		city.grid(row = 8, column = 1, padx = 3, pady = 3)

		State.grid(row = 8, column = 2, padx = 3, pady = 3)
		state.grid(row = 8, column = 3, padx = 3, pady = 3)

		PinCode.grid(row = 9, column = 0, padx = 3, pady = 3)
		pincode.grid(row = 9, column = 1, padx = 3, pady = 3)

		secQues.grid(row=10, column=0, padx=3, pady=3)
		SecQues.grid(row=10, column=1, padx=3, pady=3)

		secAns.grid(row=11, column=0, padx=3, pady=3)
		SecAns.grid(row=11, column=1, padx=3, pady=3)

		#button_regtomenu.grid(row=12,column = 2, padx = 3, pady = 3)
		button_submit.grid(row = 12, column = 3, columnspan = 2, padx = 3, pady = 3)

		self.loginpack=Frame(self.master)
		UsernameLog=Label(self.loginpack,text='Username :')
		usernameLog=Entry(self.loginpack,width=40,borderwidth = 2,textvariable=self.userNameLog)

		PasswordLog=Label(self.loginpack,text='Password :')
		passwordLog=Entry(self.loginpack,width = 40, borderwidth = 2, show = bullet,textvariable=self.passwordLog)

		button_login=Button(self.loginpack,text='Login',command=self.login, width = 15, padx = 5, pady = 5, fg = "white", bg = "steelblue")
		button_forgotpass=Button(self.loginpack,text='Forgot Password?',command=self.forgotpass, width = 20, padx = 5, pady = 5, fg = "white", bg = "steelblue")
		#button_logtomenu = Button(self.loginpack, text = "Go to Main Menu",command=self.mainmenu, width = 20, padx = 5, pady = 5, fg = "white", bg = "steelblue")

		UsernameLog.grid(row = 0, column = 0, padx = 3, pady = 3)
		usernameLog.grid(row = 0, column = 1, padx = 3, pady = 3)

		PasswordLog.grid(row = 1, column = 0, padx = 3, pady = 3)
		passwordLog.grid(row = 1, column = 1, padx = 3, pady = 3)

		button_login.grid(row = 2, column = 0, padx = 3, pady = 3)
		button_forgotpass.grid(row = 2, column = 1, padx = 3, pady = 3)
		#button_logtomenu.grid(row = 2, column = 2,columnspan = 2, padx = 3, pady = 3)

		self.forgotpasspack=Frame(self.master)

		ForgotpassUsername=Label(self.forgotpasspack,text='Username :')
		forgotpassusername=Entry(self.forgotpasspack,width=40,borderwidth = 2,textvariable=self.recUserName)

		ForgotpassEmail=Label(self.forgotpasspack,text='Email :')
		forgotpassemail=Entry(self.forgotpasspack,width=40,borderwidth = 2,textvariable=self.recEmail)	

		ForgotpassNumber=Label(self.forgotpasspack,text='Mobile Number :')
		forgotpassnumber=Entry(self.forgotpasspack,width=40,borderwidth = 2,textvariable=self.recNumber)

		button_checkpass=Button(self.forgotpasspack,text='Submit',command=self.getsecdetails, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")
		#button_fortolog = Button(self.forgotpasspack, text = "Go to Login",command=self.log, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")

		ForgotpassUsername.grid(row = 0, column = 0, padx = 3, pady = 3)
		forgotpassusername.grid(row = 0, column = 1, padx = 3, pady = 3)

		ForgotpassEmail.grid(row = 1, column = 0, padx = 3, pady = 3)
		forgotpassemail.grid(row = 1, column = 1, padx = 3, pady = 3)

		ForgotpassNumber.grid(row = 2, column = 0, padx = 3, pady = 3)
		forgotpassnumber.grid(row = 2, column = 1, padx = 3, pady = 3)

		button_checkpass.grid(row = 3, column = 1, padx = 3, pady = 3)
		#button_fortolog.grid(row = 3, column = 2,columnspan = 2, padx = 3, pady = 3)

		self.checkanspack=Frame(self.master)
		SecQuesRec=Label(self.checkanspack,text='Question :')
		SecAnsRec=Label(self.checkanspack,text='Answer :')
		secansrec=Entry(self.checkanspack,width=40,borderwidth = 2,textvariable=self.recSecAnsCheck)

		button_checkans=Button(self.checkanspack,text='Submit',command=self.checkans, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")
		#button_checkanstolog = Button(self.checkanspack, text = "Go to Login",command=self.log, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")


		SecQuesRec.grid(row = 0, column = 0, padx = 3, pady = 3)

		SecAnsRec.grid(row = 1, column = 0, padx = 3, pady = 3)
		secansrec.grid(row = 1, column = 1, padx = 3, pady = 3)	

		button_checkans.grid(row = 2, column = 1, padx = 3, pady = 3)
		#button_checkanstolog.grid(row = 2, column = 2,columnspan = 2, padx = 3, pady = 3)

		self.updatepasspack=Frame(self.master)
		UpdatePassword=Label(self.updatepasspack,text='Password :')
		updatepassword=Entry(self.updatepasspack,width=40,borderwidth = 2, show = bullet,textvariable=self.upPassword)

		ConfirmUpdatePassword=Label(self.updatepasspack,text='Confirm Password :')
		confirmupdatepassword=Entry(self.updatepasspack,width=40,borderwidth = 2, show = bullet,textvariable=self.confUpPassword)

		button_updatepass=Button(self.updatepasspack,text='Update Password',command=self.updatepassfun, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")

		UpdatePassword.grid(row = 0, column = 0, padx = 3, pady = 3)
		updatepassword.grid(row = 0, column = 1, padx = 3, pady = 3)

		ConfirmUpdatePassword.grid(row = 1, column = 0, padx = 3, pady = 3)
		confirmupdatepassword.grid(row = 1, column = 1, padx = 3, pady = 3)

		button_updatepass.grid(row = 2, column = 1, padx = 3, pady = 3)

		self.findtrainpack=Frame(self.master)

		date_of_journey = Label(self.findtrainpack, text = "Date Of Journey :")
		DOJ = Entry(self.findtrainpack,  width = 40, borderwidth = 2,textvariable=self.dateofjourney)

		classType = Label(self.findtrainpack, text = "Class Type :")
		ClassType = OptionMenu(self.findtrainpack, self.classSelected, "AC 1 TIER (1A)", "AC 2 TIER (2A)", "AC 3 TIER (3A)", "SLEEPER (SL)")

		button_findTrain = Button(self.findtrainpack, text = "Find Trains", command=self.findtrains, padx = 5, pady = 5, fg = "white", bg = "steelblue")

		date_of_journey.grid(row = 2, column = 0, padx = 3, pady = 3)
		DOJ.grid(row = 2, column = 1, padx = 3, pady = 3)

		classType.grid(row = 3, column = 0, padx = 3, pady = 3)
		ClassType.grid(row = 3, column = 1, padx = 3, pady = 3)

		button_findTrain.grid(row = 4, column = 0, padx = 3, pady = 3, columnspan = 2)

		self.trainlistpack=Frame(self.master)
		self.passengerlistpack=Frame(self.master)
		self.ticketdetailspack=Frame(self.master)
		self.changepasspack=Frame(self.master)
		self.bookedticketpack=Frame(self.master)
		self.pnrticketdetpack=Frame(self.master)
		self.pnrenqpack=Frame(self.master)
		self.cancelticketdetailspack=Frame(self.master)
		self.cancelticketselpack=Frame(self.master)

		ChangeOldPassword=Label(self.changepasspack,text='Old Password :')
		changeoldpassword=Entry(self.changepasspack,width=40,borderwidth = 2, show = bullet,textvariable=self.changePassword)

		NewPassword=Label(self.changepasspack,text='New Password :')
		newpassword=Entry(self.changepasspack,width=40,borderwidth = 2, show = bullet,textvariable=self.changeNewPassword)

		ConfirmNewPassword=Label(self.changepasspack,text='Confirm New Password :')
		confirmnewpassword=Entry(self.changepasspack,width=40,borderwidth = 2, show = bullet,textvariable=self.confChangeNewPassword)

		button_changepass=Button(self.changepasspack,text='Update Password',command=self.changepassfun, width = 30, padx = 5, pady = 5, fg = "white", bg = "steelblue")

		ChangeOldPassword.grid(row = 0, column = 0, padx = 3, pady = 3)
		changeoldpassword.grid(row = 0, column = 1, padx = 3, pady = 3)

		NewPassword.grid(row = 1, column = 0, padx = 3, pady = 3)
		newpassword.grid(row = 1, column = 1, padx = 3, pady = 3)

		ConfirmNewPassword.grid(row = 2, column = 0, padx = 3, pady = 3)
		confirmnewpassword.grid(row = 2, column = 1, padx = 3, pady = 3)

		button_changepass.grid(row = 3, column = 1, padx = 3, pady = 3)


root = Tk()
root.title("Railway Reservation System")
root.configure()
main(root)
root.mainloop()

