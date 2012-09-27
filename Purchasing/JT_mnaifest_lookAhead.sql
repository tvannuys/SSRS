*************************
*
* James Tuttle
* 04/26/2010
*
* :: Look ahead to the Manifest&manifest Tracking, PO-BO Line, Customer master, Open Orders on bbackorder
*
* - display the back prders with order ship info by manifest

If Dow(Date())>1 And Dow(Date())<7 And Hour(Datetime()) = 06

	Set Safety Off
*SET STEP ON

	Store "jamest@tasupply.com" To To (1)
	Store "maryn@tasupply.com" To To (2)
	Store "gregs@tasupply.com" To To (3)
	Store "chrisc@pacmat.com" To To (4)
	Store "codyw@tasupply.com" To To (5)
	Store "johnb@tasupply.com" To To (6)
	Store "danielb@tasupply.com" To To (7)


	Local lcDNS
	lcDNS = "GSFL2K"
	Local lcUser
	lcUser="eurisko"
	Local lcPWD
	lcPWD="eurisko"

	Local lnHandle


*-- Pull the data right through SQL Connect

	lnHandle = SQLConnect(lcDNS, lcUser, lcPWD)
	
	
*------------------------------------*
* If cannot connect to shared drive  *
* --> lnHandle > 0					 *
* the ELSE had a wait window and     *
* timer to retry					 *
*------------------------------------*
* Try and wait with retry until ODBC allows back in...
		Do While lnHandle < 0
			Wait Window "Waiting for connection recovery till " + Ttoc(Datetime()+300)  Time 300
			=Aerror(lsErr)
			List Memory Like laErr
			If Lastkey() = 27  && Esc pressed
				Exit
			Endif
			lnHandle = SQLConnect(lcDNS, lcUser, lcPWD)
		ENDDO
		

	If lnHandle > 0 && success


*Manifest details
		lnResult = SQLExec(lnHandle, "select * from manidetl where irloc in(50,52,41,35)", "cManidetl")
		If lnResult < 0
			=Aerror(laErr)
			Messagebox(laErr[2],0+16,"*** Error Connecting to Table MANIDETL ***")
		Endif
*MANTRACK
		lnResult = 	SQLExec(lnHandle, "select * from mantrack", "cMantrack")
		If lnResult < 0
			=Aerror(laErr)
			Messagebox(laErr[2],0+16,"*** Error Connecting to Table MANTRACK ***")
		Endif
*ITEMMAST
		lnResult = SQLExec(lnHandle, "select imitem, imwght from itemmast ", "cItemmast")
		If lnResult < 0
			=Aerror(laErr)
			Messagebox(laErr[2],0+16,"*** Error Connecting to Table ITEMMAST ***")
		Endif
*oohead
		lnResult = SQLExec(lnHandle, "select * from oohead ", "cOOhead")
		If lnResult < 0
			=Aerror(laErr)
			Messagebox(laErr[2],0+16,"*** Error Connecting to Table OOHEAD ***")
		Endif
*ooline
		lnResult = SQLExec(lnHandle, "select * from ooline ", "cOOline")
		If lnResult < 0
			=Aerror(laErr)
			Messagebox(laErr[2],0+16,"*** Error Connecting to Table OOHEAD ***")
		Endif
*!*	*ooxtra
*!*		lnResult = SQLExec(lnHandle, "select * from ooxtra ", "cOOxtra")
*!*		If lnResult < 0
*!*			=Aerror(laErr)
*!*			Messagebox(laErr[2],0+16,"*** Error Connecting to Table OOHEAD ***")
*!*		Endif
*poboline
		lnResult = SQLExec(lnHandle, "select * from poboline ", "cPOboline")
		If lnResult < 0
			=Aerror(laErr)
			Messagebox(laErr[2],0+16,"*** Error Connecting to Table POBOLINE ***")
		Endif

*custmast
		lnResult = SQLExec(lnHandle, "select * from custmast ", "cCustmast")
		If lnResult < 0
			=Aerror(laErr)
			Messagebox(laErr[2],0+16,"*** Error Connecting to Table CUSTMAST ***")
		Endif


*-- match the query with the open line back orders to the manifest details
*!*		Select irloc, irman_, pbpo_ , pbitem, irdesc, irky, irum1, pboqty, pboloc, pboord, ohvia, ohsdat ;
*!*		From cManidetl, cPOboline, cOOhead, cMantrack ;
*!*		Where iritem=pbitem And pboord=ohord_ And pboloc=ohloc And pborel=ohrel_ and irman_=mtman_ ;
*!*		order By ohsdat Into Cursor cResult Readwrite

Select Distinct olseq_ As seq, irloc As loc, mtman_ As manifest, mtddate As delv_date, pbpo_ As PO,  Padr(mtstatus,3) As Status, pbocus As cust_number, cmname As cust_name, ;
	cmadr3 As city_state, cmzip As zip, Cast(pboqty*imwght As numeric(8,2)) As weight, ohotyp As O_type, pboord As sales_order, ohsdat As ship_date, pboloc As delv_loc, ohviac As ship_via, ;
	ohvia As via_desc, pbitem As Item, pboqty As qty ;
From cManidetl, cPOboline, cOOhead, cMantrack, cItemmast, cOOline, cCustmast ;
Where iritem=pbitem And pbitem=olitem And pboord=ohord_ And pboloc=ohloc And pborel=ohrel_ And irman_=mtman_ And pbitem=imitem And irpo_=pbpo_ And ;
	ohco=olco And ohloc=olloc And ohord_=olord_ And ohrel_=olrel_ And pbocus=cmcust And ohcust=cmcust And olcust=cmcust ;
	order By irloc, mtddate, mtman_, pboloc Into Cursor cResult Readwrite
lcResult = _Tally


		Select cResult
* Replace the Single Status Code with the Three Character Code
		Replace All Status With Icase(Status="S", "SCH",Status="A", "ACK",Status="D", "DLV",Status)


* Replace any Ship Dates of 0001/01/01 with 2001/01/01   Shows as ########## in Excel
		Replace All ship_date With {^2001/01/01} For ship_date = {^0001/01/01}
* Replace any delv Dates of 0001/01/01 with 2001/01/01   Shows as ########## in Excel
		Replace All delv_date With {^2001/01/01} For delv_date = {^0001/01/01}






		Select cResult
		Go Top
***Seperate by manifest
		Do While Not Eof()
			m.manifest=manifest
			Count While m.manifest=manifest
			If Not Eof()
				Insert Blank Before
				Skip
			Endif
		Enddo

		Count To m.COUNT

		If m.COUNT>0

			Copy To "C:\manifest_look_ahead.xls" Type Xl5



*-- Close SQL Connection
			SQLDisconnect(lnHandle)



***>>>>>>>===============================================================<<<<<<<<<<<<<<<<
*Start Excel formatting
***>>>>>>>===============================================================<<<<<<<<<<<<<<<<
			oExcel = Createobject("Excel.Application")
			oExcel.Visible = .F.
			oWorkbook = oExcel.Workbooks.Open("C:\manifest_look_ahead.xls")
			oRange = oExcel.ActiveSheet.Range("A1:S1")

*!*				iAlternateColor = 2
*!*				nColor = 2
*!*				Scan
*!*					If manifest = 0
*!*						If iAlternateColor = 2
*!*							nColor = 48
*!*							iAlternateColor = 48
*!*						Else
*!*							nColor = 2
*!*							iAlternateColor = 2
*!*						Endif
*!*					Endif
*!*					oRange = oRange.Offset(1,0)
*!*					oRange2 = oRange.Select
*!*					oExcel.Selection.Interior.ColorIndex = nColor
*!*					oExcel.Selection.Font.Size = 8

*!*				Endscan

			oRange = oExcel.ActiveSheet.Range("A1:S1").Select
			oExcel.Selection.Interior.ColorIndex = 15 && Light Gray
			oExcel.Selection.Font.Bold = .T.
			oExcel.Selection.Font.Underline = 2


			oRange = oExcel.ActiveSheet.Range("A2:S2").Select
			oExcel.ActiveWindow.FreezePanes = .T.
			oExcel.ActiveSheet.Cells.Select
			oExcel.Selection.Font.Size = 8
			oExcel.ActiveSheet.Cells.EntireColumn.AutoFit

* Hide column A with seq# for ooline
			oRange = oExcel.ActiveSheet.Range("A:A").Select
			oExcel.Selection.EntireColumn.Hidden = .T.

*Turn OFF prompt to overwrite existing file
*Excel Equivalent of 'SET SAFETY OFF'
			oExcel.DisplayAlerts = .F.

***Save and quit Excel
			oWorkbook.SaveAs("C:\manifest_look_ahead.xls")
			oExcel.Quit
***>>>>>>>===============================================================<<<<<<<<<<<<<<<<
*End Excel formatting
***>>>>>>>===============================================================<<<<<<<<<<<<<<<<


			Do SendeMail.prg With "Eurisko@tasupply.com", "Daily Manifest Look Ahead", "Attached is your excel report with the daily manifest look ahead.", "C:\manifest_look_ahead.xls"

		Else

			Do SendeMail.prg With "Eurisko@tasupply.com", "*** No Daily Manifest Look Ahead ***", "No report with the daily manifest look ahead."
		Endif

***Reset TO, CC, BCC arrays
		For i=1 To 10
			Store .F. To To(i), CC(i), BCC(i)
		Endfor



	Else

*!*			Aerror( laErr )
*!*			Messagebox( laErr[2], 16, 'SQLEXEC Error' )
*!*			SQLDisconnect(lnHandle)


	Endif
Endif
