Attribute VB_Name = "Module2"
Sub test()
    'ThisIbmScreen.SendKeys "3"
    'ThisIbmScreen.SendControlKey ControlKeyCode_Transmit
    'ThisIbmScreen.WaitForKeyboardEnabled 10000, 1
   
 
    
    Dim Title, CustList, CustHeader As String
    Title = ThisIbmScreen.GetText(6, 64, 30)
    Customers = ThisIbmScreen.GetTextEx(13, 49, 23, 117, GetTextArea_Block, GetTextWrap_Off, GetTextAttr_Any, GetTextFlags_CR)
    CustHeader = ThisIbmScreen.GetText(12, 49, 69)
  
    
    Dim frm As New UserForm2
    
    frm.lblTitle.Caption = Title
    frm.lblCustomers.Caption = Customers
    frm.lblCustHeader.Caption = CustHeader
    
    frm.Show
          

End Sub

