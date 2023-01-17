<!--- 
	Hemen hemen birçok sayfada olan kaydeden ve güncelleyen bilgilerinin
	tek satır yazılarak kullanım kolaylığı sağlanması için yazıldı.
	Kullanım :
	<cf_record_info 
		query_name="upd_work" //Query Adı * Zorunlu
		record_emp="record_author" //Kaydeden Alanı Zorunlu Değil.Standart olarak RECORD_EMP kullanıyoruz,eğer istisna olarak farklı bir alan ise query'i yazarken AS RECORD_EMP diye biçimlendirilebilir,yada burda belirtilebilir.
		update_emp="update_author" //Güncelleme Alanı Zorunlu Değil.Standart olarak UPDATE_EMP kullanıyoruz,eğer istisna olarak farklı bir alan ise query'i yazarken AS RECORD_EMP diye biçimlendirilebilir,yada burda belirtilebilir.
		record_date = "REC_DATE"//Alan RECORD_DATE'den farklı ise gönderilmeli yada queryde düzenlenmelidir.//
		update_date ="UPD_DATE"//Alan UPDATE_DATE'den farklı ise gönderilmeli yada queryde düzenlenmelidir.//
		is_partner="1"//Zorunlu Değil//Eğer tablo Partner'a da açık ise ve tabloda Partner için kaydetme alanları varsa 1 gönderilmelidir.
		record_par="RECORD_PAR"//Zorunlu Değil//Standart da RECORD_PAR değilse gönderili.
		update_par="UPDATE_PAR"//Zorunlu Değil//Standartda UPDATE_PAR değilse gönderilir.
		is_consumer="1"//Zorunlu Değil//Eğer tablo Partner'a da açık ise ve tabloda Partner için kaydetme alanları varsa 1 gönderilmelidir.
		record_cons="RECORD_CONS"//Zorunlu Değil//Standart da RECORD_CONS değilse gönderili.
		update_cons="UPDATE_CONS"//Zorunlu Değil//Standartda UPDATE_CONS değilse gönderilir.
		fbs20121117 record_other parametresi ekledim, bazi yerlerde direkt isim gosteriliyor id tutulmuyor, ornek etkilesimler
	>
	<cf_record_info query_name="get_notice">
--->
<cfparam name="attributes.query_name" default=""> 
<cfparam name="attributes.record_emp" default="RECORD_EMP">
<cfparam name="attributes.record_date" default="RECORD_DATE">
<cfparam name="attributes.update_emp" default="UPDATE_EMP">
<cfparam name="attributes.update_date" default="UPDATE_DATE">
<cfparam name="attributes.is_partner" default="0">
<cfparam name="attributes.record_par" default="RECORD_PAR">
<cfparam name="attributes.update_par" default="UPDATE_PAR">
<cfparam name="attributes.is_consumer" default="0">
<cfparam name="attributes.margin" default="0"><!--- Bazi sayfalarda kaydeden guncelleyen bilgileri üstteki alana giriyordu diye bu parametreyi ekledim. E.Y 20120922 --->
<cfparam name="attributes.record_cons" default="RECORD_CONS">
<cfparam name="attributes.update_cons" default="UPDATE_CONS">
<cfparam name="attributes.record_other" default="">
<cfparam name="attributes.class" default="0">
<cfparam name="dsn" default="#caller.dsn#">
<cfif not isdefined("caller.dateformat_style")>
	<cfset caller.dateformat_style = caller.caller.dateformat_style>
</cfif>
<cfif not isdefined("caller.timeformat_style")>
	<cfset caller.timeformat_style = caller.caller.timeformat_style>
</cfif>
<div class="record_info<cfif attributes.class eq 1> hide</cfif>">
	<cfoutput>
		<cfscript>
		if(isdefined('attributes.query_name') and len(attributes.query_name) and Evaluate("caller.#attributes.query_name#").recordcount)
		{
			if(isdefined('caller.#attributes.query_name#.#attributes.record_emp#') and len(Evaluate("caller.#attributes.query_name#.#attributes.record_emp#")))
				record_emp = Evaluate("caller.#attributes.query_name#.#attributes.record_emp#");
			else
				record_emp = '';
			if(isdefined('caller.#attributes.query_name#.#attributes.record_date#') and len(Evaluate("caller.#attributes.query_name#.#attributes.record_date#")))
				record_date = Evaluate("caller.#attributes.query_name#.#attributes.record_date#");
			else
				record_date = '';
			if(isdefined('caller.#attributes.query_name#.#attributes.update_emp#') and len(Evaluate("caller.#attributes.query_name#.#attributes.update_emp#")))
				update_emp = Evaluate("caller.#attributes.query_name#.#attributes.update_emp#");
			else
				update_emp = '';
			if(len(record_date))
			{
				if(isdefined("caller.lang_array_main"))
					writeoutput("<i class='fa fa-pencil'></i> ");
				else
					writeoutput("<i class='fa fa-refresh'></i> ");
				if(isdefined('session.ep.time_zone'))
					record_date = dateadd('h', session.ep.time_zone, Evaluate("caller.#attributes.query_name#.#attributes.record_date#"));
				else if(isdefined('session.ww.time_zone'))
					record_date = dateadd('h', session.ww.time_zone, Evaluate("caller.#attributes.query_name#.#attributes.record_date#"));
			}
			if(isdefined('caller.#attributes.query_name#.#attributes.update_date#') and len(Evaluate("caller.#attributes.query_name#.#attributes.update_date#")))
				update_date = Evaluate("caller.#attributes.query_name#.#attributes.update_date#");
			else
				update_date = '';
			if (len(update_date))
			{
				if(isdefined('session.ep.time_zone'))
					update_date = dateadd('h', session.ep.time_zone, update_date);
				else if(isdefined('session.ww.time_zone'))	
					update_date = dateadd('h', session.ww.time_zone, update_date);
			}			
			
			if(attributes.is_partner eq 1){//partner'a açık yerler ise
				
				if(isDefined("caller.#attributes.query_name#.#attributes.record_par#")) record_par = Evaluate("caller.#attributes.query_name#.#attributes.record_par#");
				if(isDefined("caller.#attributes.query_name#.#attributes.update_par#")) update_par = Evaluate("caller.#attributes.query_name#.#attributes.update_par#");
			}
			if(attributes.is_consumer eq 1){//consumer'a açık yerler ise
				if(isDefined("caller.#attributes.query_name#.#attributes.record_cons#")) record_cons = Evaluate("caller.#attributes.query_name#.#attributes.record_cons#");
				if(isDefined("caller.#attributes.query_name#.#attributes.update_cons#")) update_cons = Evaluate("caller.#attributes.query_name#.#attributes.update_cons#");
			}
			
			if(isdefined('record_emp') and len(record_emp))
			{
				if(not isdefined("caller.get_emp_info"))
					caller = caller.caller;
				writeoutput("#caller.get_emp_info(record_emp,0,1)#");
			}
			else if(isdefined('record_par') and len(record_par))
				writeoutput("#caller.get_par_info(record_par,0,-1,1)#");
			else if(isdefined('record_cons') and len(record_cons))
				writeoutput("#caller.get_cons_info(record_cons,1,1)#");
			else if(isDefined('attributes.record_other') and len(attributes.record_other))
				writeoutput("#attributes.record_other# ");
			writeoutput("#dateformat(record_date,caller.dateformat_style)# #Timeformat(record_date,caller.timeformat_style)#");
			if ((isdefined('update_emp') and len(update_emp)) or (isdefined('update_par') and len(update_par)) or (isdefined('update_cons') and len(update_cons))) 
				{
				if(len(record_date))
					writeoutput(" ");
					if(caller.attributes.fuseaction contains 'popup' and (caller.attributes.fuseaction DOES NOT CONTAIN 'emptypopup'))writeoutput("<br />");
					if (isdefined("caller.lang_array_main"))
						writeoutput("<i class='fa fa-refresh'></i>");
					else
						writeoutput("<i class='fa fa-refresh'></i>");
				}
				
			if (isdefined('update_emp') and len(update_emp))
				writeoutput("#caller.get_emp_info(update_emp,0,1)#");
			else if (isdefined('update_par') and len(update_par))
				writeoutput("#caller.get_par_info(update_par,0,-1,1)#"); 
			else if (isdefined('update_cons') and len(update_cons))
				writeoutput("#caller.get_cons_info(update_cons,1,1)#"); 
			if ((isdefined('update_emp') and len(update_emp)) or (isdefined('update_par') and len(update_par)) or (isdefined('update_cons') and len(update_cons)) and len(update_date))
				writeoutput("#Dateformat(update_date,caller.dateformat_style)# #Timeformat(update_date,caller.timeformat_style)#");
		}
		else if(not isdefined('attributes.query_name'))
			if(isdefined("caller.lang_array_main"))
				writeoutput("<font color='red'>#caller.getLang('main',2177)#</font>");
			else
				writeoutput("<font color='red'>#caller.caller.getLang('main',2177)#</font>");
		</cfscript>  
	</cfoutput>   
</div>
