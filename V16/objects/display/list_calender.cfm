<!--- 
örnek tarih alma butonu :

<input type="button" value="+" style="width:20px; heigth:18px;" onclick="window.open('<cfoutput>#request.self#?fuseaction=objects.popup_calender</cfoutput>&alan=employe_detail.start_date','','top=100,left=100,width=250,height=180');">

buradaki url den gelecek olan alan parametresi form.alan_adi şeklinde gönderilmeli

Ergün KOÇAK
--->
<script type="text/javascript">
bugun = <cfoutput>#day(now())#</cfoutput>;
buay = <cfoutput>#month(now())#</cfoutput>;
buyil = <cfoutput>#year(now())#</cfoutput>;
function don(gun)
{
	if (gun.length == 0) return false;
	ay = parseInt(calform.monthinteger.value) + 1;
	if (gun.length == 1) gun = '0' + gun;
	if (ay.toString().length == 1) ay = '0' + ay.toString();
	<cfif isdefined("attributes.satir") and len(attributes.satir)>
		var satir = <cfoutput>#attributes.satir#</cfoutput>;
	<cfelse>
		var satir = -1;
	</cfif>
	<cfif isdefined("attributes.deliver") and attributes.deliver eq 1>
		deliver_ = 1;
	<cfelse>
		deliver_ = 0;
	</cfif>
	if(window.opener.basket && satir > -1 && deliver_ == 0)
		window.opener.updateBasketItemFromPopup(satir, { RESERVE_DATE: gun + '/' + ay + '/' + calform.elements[1].value }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
	else if(window.opener.basket && satir > -1 && deliver_ == 1)
		window.opener.updateBasketItemFromPopup(satir, { DELIVER_DATE: gun + '/' + ay + '/' + calform.elements[1].value }); // Basket Çalışmaları için eklendi. Kaldırmayınız. 20140826
	else
	{
		<cfif attributes.alan contains "form_basket.deliver_date" and not (attributes.alan contains "form_basket.deliver_date_")>
			if (opener.rowCount == 1)
				opener.form_basket.deliver_date.value= gun + '/' + ay + '/' + calform.elements[1].value;
			else
				opener.<cfoutput>#attributes.alan#</cfoutput>.value= gun + '/' + ay + '/' + calform.elements[1].value;
		<cfelse>
			opener.<cfoutput>#attributes.alan#</cfoutput>.value= gun + '/' + ay + '/' + calform.elements[1].value;
		</cfif>
			opener.<cfoutput>#attributes.alan#</cfoutput>.focus();
		<!--- <cfif isdefined("attributes.call_function")>
			try{opener.<cfoutput>#attributes.call_function#</cfoutput>;}
				catch(e){};
		</cfif> --->
		<cfif isdefined("attributes.call_parameter") and isdefined('attributes.call_function')>
				try{opener.<cfoutput>#attributes.call_function#('#attributes.call_parameter#')</cfoutput>;}
				catch(e){};
		<cfelseif isdefined("attributes.call_function")>
				try{opener.<cfoutput>#attributes.call_function#</cfoutput>;}
				catch(e){};
		</cfif>
		<cfif isdefined("attributes.call_money_function")>
			try{opener.<cfoutput>#attributes.call_money_function#</cfoutput>;}
				catch(e){};
		</cfif>
		<cfif isdefined("attributes.is_visit")>
			opener.reload_date();
		</cfif>
		<cfif isdefined("attributes.is_calculate_value")>
			opener.expense_topla();
		</cfif>
		<cfif isdefined("url.basket")>
			window.opener.clear_fields();/* kalsın erk 20031106*/
			window.opener.form_basket.submit();
		</cfif>
		<cfif isdefined("attributes.is_check")>
			opener.time_check(<cfoutput>#attributes.is_check#</cfoutput>);
		</cfif>
	}
	window.close();
}
/*This Java Script is free to the domain. All I ask is you send me an
email to
ddelong@csci.csusb.edu to let me know that you will be using it. This
message must be included with the script if you copy it.*/
/*for sucky browsers*/
<cfsavecontent variable="ocak"><cf_get_lang dictionary_id='57592.ocak'></cfsavecontent>
<cfsavecontent variable="subat"><cf_get_lang dictionary_id='57593.şubat'></cfsavecontent>
<cfsavecontent variable="mart"><cf_get_lang dictionary_id='57594.mart'></cfsavecontent>
<cfsavecontent variable="nisan"><cf_get_lang dictionary_id='57595.nisan'></cfsavecontent>
<cfsavecontent variable="mayis"><cf_get_lang dictionary_id='57596.mayis'></cfsavecontent>
<cfsavecontent variable="haziran"><cf_get_lang dictionary_id='57597.haziran'></cfsavecontent>
<cfsavecontent variable="temmuz"><cf_get_lang dictionary_id='57598.temmuz'></cfsavecontent>
<cfsavecontent variable="agustos"><cf_get_lang dictionary_id='57599.agustos'></cfsavecontent>
<cfsavecontent variable="eylul"><cf_get_lang dictionary_id='57600.eylül'></cfsavecontent>
<cfsavecontent variable="ekim"><cf_get_lang dictionary_id='57601.ekim'></cfsavecontent>
<cfsavecontent variable="kasim"><cf_get_lang dictionary_id='57602.kasim'></cfsavecontent>
<cfsavecontent variable="aralik"><cf_get_lang dictionary_id='57603.aralik'></cfsavecontent>

<cfoutput>
Months = new Array(12);
Months[0] = "#trim(ocak)#";
Months[1] = "#trim(subat)#";
Months[2] = "#trim(mart)#";
Months[3] = "#trim(nisan)#";
Months[4] = "#trim(mayis)#";
Months[5] = "#trim(haziran)#";
Months[6] = "#trim(temmuz)#";
Months[7] = "#trim(agustos)#";
Months[8] = "#trim(eylul)#";
Months[9] = "#trim(ekim)#";
Months[10] = "#trim(kasim)#";
Months[11] = "#trim(aralik)#";
</cfoutput>
function PadSpaces(TheString)
{
	var Spaces = "             ";
	len = Math.round((9 - TheString.length)/2);
	return Spaces.substring(0,len) + TheString;
}
function NumLeapYears(StartYear, EndYear)
{
 	var LeapYears, i;
 	if (EndYear >= StartYear){
 		for(LeapYears = 0; StartYear <= EndYear; StartYear++)
 		if (IsLeapYear(StartYear)) LeapYears++;
	}else{
	for(LeapYears = 0; EndYear <= StartYear; EndYear++)
 		if (IsLeapYear(EndYear)) LeapYears++;
	}
 	return LeapYears;
}
function IsLeapYear(Year)
{
	if(Math.round(Year/4) == Year/4){
		if(Math.round(Year/100) == Year/100){
			if(Math.round(Year/400) == Year/400)
				return true;
			else return false;
		}else return true;
	}
	return false;
}
function Trim(TheString)
{
	var len;
	len = TheString.length;
 	while(TheString.substring(0,1) == " "){ /*trim left*/
 		TheString = TheString.substring(1, len);
  		len = TheString.length;
	}
 	while(TheString.substring(len-1, len) == " "){ /*trim right*/
 		TheString = TheString.substring(0, len-1);
  		len = TheString.length;
 	}
 	return TheString;
}
function DetermineMonthIdx()
{
	var i, month, month_s, len;
	month = Trim(document.calform.elements[4].value);
	len = month.length;
	for( i = 0; i <12; i++){
    		month_s = Months[i].substring(0,len);
		if (month_s.toUpperCase() == month.toUpperCase())
        		return (i);
  	}
  	return -1;
}
function FindNewYearStartingDay(Year)
{
 	var LeapYears, Years, Day;
 	LeapYears = NumLeapYears(1995, Year);
 	if  (Year >=1995)
 		Years = (Year -1995)+LeapYears;
 	else	Years = (Year -1995)-LeapYears;
 	if (Year >=1995)
		Day = Math.round(((Years/7 - Math.floor(Years/7))*7)+.1);
 	else 
		Day = Math.round(((Years/7 -  Math.ceil(Years/7))*7)-.1);
	if (Year >=1995){
		if(IsLeapYear(Year)) Day--;
 	}else Day += 7;
 	if(Day < 0) Day = 6;
 	if(Day > 6) Day = 0;
 	return Day;
}
function FindNumDaysInMonth(Year, Month)
{
 	if(Month == 1){
   		if(IsLeapYear(Year)) return 29;
   		else return 28;
 	}else{
   		if(Month >6) Month++;
   		if(Month/2 == Math.round(Month/2))  return 31;
 	}
 return 30;
}
function FindMonthStartDay(NewYearDay, Year, Month)
{
  	var MonthStartDay;
  	AddArray = new Array(12);
  	AddArray[0]=7;AddArray[1]=3;AddArray[2]=3;AddArray[3]=6;
	AddArray[4]=1;AddArray[5]=4;AddArray[6]=6;AddArray[7]=2;
	AddArray[8]=5;AddArray[9]=7;AddArray[10]=3;AddArray[11]=5;
	/* 20050912 sorun yuzunden eklendi, acilacak */
	/*if(NewYearDay == 0) NewYearDay = 7;*/
  	MonthStartDay = NewYearDay + AddArray[Month];
  	if (IsLeapYear(Year) && (Month) > 1) MonthStartDay ++;
  	/* if (MonthStartDay > 6) MonthStartDay -= 7; pazar hafta başı ise*/
  	if (MonthStartDay > 7) MonthStartDay -= 7;
  	return MonthStartDay;
}
function  FillCalendar()
{
  	var Year, Month, Midx, NewYearDay, MonthStartDay;
	var NumDaysInMonth, i, t;
  	Year = parseFloat(document.calform.elements[1].value);
  	Month = document.calform.elements[4].value;
  	Midx  =  DetermineMonthIdx();
  	if (Midx == -1){
   		alert ("<cf_get_lang dictionary_id ='34018.Ay İsmi Algılanamadı'> !");
   		return;
  	}
  	NewYearDay = FindNewYearStartingDay(Year);
  	MonthStartDay = FindMonthStartDay(NewYearDay, Year,  Midx);
  	NumDaysInMonth = FindNumDaysInMonth(Year, Midx);
	calform.monthinteger.value = Midx;
  	for(i = 6;  i < 43;  i++){
		/* t = i-5-MonthStartDay; pazar hafta başı ise*/
		t = i-4-MonthStartDay;
		if ( t >= 1  &&  t <= NumDaysInMonth)
			{
			document.calform.elements[i].value =t;
			if ((t == bugun) && (buay == (Midx+1)) && (buyil == calform.elements[1].value))
				document.calform.elements[i].style.color = "red";
			else
				document.calform.elements[i].style.color = "black";
			}
		else 
			{
			document.calform.elements[i].value = "";
			}
  	}
}
function IncDecYear(val)
{
	var valNum = parseInt(val);
	var valNum2 = parseInt(document.calform.elements[1].value);
	document.calform.elements[1].value = valNum2 + valNum;
	FillCalendar();
}
function IncDecMonth(val)
{
	var valNum = parseInt(val);
  	var Midx  =  DetermineMonthIdx();
	Midx += valNum;
	if(Midx > 11) Midx = 0;
	if(Midx < 0)  Midx = 11;
	document.calform.elements[4].value = PadSpaces(Months[Midx]);
	FillCalendar();
}
</script>
<table cellpadding="0" cellspacing="0" align="center">
  <tr class="color-border">
    <td align=center>
      <table border=0  cellspacing=1 cellpadding="2" width="100%">
        <form name="calform">
          <tr class="color-row">
            <td colspan="7" align='center' height="30" nowrap>
			<input name="button" id="button" type="button" onClick="IncDecYear(-1)" value="<<">
            <input size=4 type=text value="1993" class="boxtext">
            <input name="button2" id="button2" type="button" onClick="IncDecYear(1)" value=">>">
            <input name="button3" id="button3" type=button onClick="IncDecMonth(-1)" value="<<">
            <input name="text" id="text" type=text value="January" class="boxtext" style="width:50px;">
            <input type=button value=">>" onClick="IncDecMonth(1)">
		  </td>
          </tr>
          <tr class="color-header" height="25">
            <th class="form-title"><cf_get_lang dictionary_id='57619.pzt'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57620.sal'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57621.crs'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57622.per'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57623.cum'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57624.cmt'></th>
            <th class="form-title"><cf_get_lang dictionary_id='57625.paz'></th>
          </tr>
          <tr class="color-row" aling="center">
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
          </tr>
          <tr class="color-row" aling="center">
            <td><input type="text" size="2"readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>

            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
          </tr>
          <tr class="color-row" aling="center">
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
          </tr>
          <tr class="color-row" aling="center">
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
			<td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"> </td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
          </tr>
          <tr class="color-row" aling="center">
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
          </tr>
          <tr class="color-row" aling="center">
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td><input type="text" size="2" readonly onClick="don(this.value)" class="box" style="cursor:pointer;width:20px;"></td>
            <td colspan=5>&nbsp;</td>
          </tr>
          <input type="hidden" name="monthinteger" id="monthinteger" value="0">
        </form>
      </table>
    </td>
  </tr>
</table>
<script type="text/javascript">
/*include this script segment if you want to set the calendar to today's date.
this MUST come after the tabled form which contains the calendar
set calendar to today's date*/
	myDate = new Date();
	var Month = parseInt(myDate.getMonth());
	//document.calform.elements[1].value = myDate.getYear();
	document.calform.elements[1].value = myDate.getFullYear();
	document.calform.elements[4].value = PadSpaces(Months[Month]);
	/* document.calform.elements[43].value = "Bugün: " + myDate.getDate() + " " + Months[Month].substring(0,3) + ", " + (myDate.getYear());*/
	FillCalendar();
</script>

