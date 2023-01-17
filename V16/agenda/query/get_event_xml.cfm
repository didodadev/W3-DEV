<cfsetting showdebugoutput="no">
<cfheader name="expires" value="#GetHttpTimeString(Now())#">
<cfheader name="pragma" value="no-cache"> 
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate"> 

<cfif isdefined('session.agenda')>
  <cfset structclear(session.agenda)>
</cfif>

<cfset event_calendar="">

<cfsavecontent variable="ay1"><cf_get_lang_main no ='180.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang_main no ='181.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang_main no ='182.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang_main no ='183.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang_main no ='184.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang_main no ='185.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang_main no ='186.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang_main no ='187.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang_main no ='188.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang_main no ='189.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang_main no ='190.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang_main no ='191.Aralık'></cfsavecontent>

<cfscript>
	if (isDefined('url.ay'))
		ay = url.ay;
	else if (isDefined('attributes.ay'))
		ay = attributes.ay;
	else
		ay = DateFormat(now(),'mm');
	
	if (isDefined('url.yil'))
		yil = url.yil;
	else if (isDefined('attributes.yil'))
		yil = attributes.yil;
	else
		yil = DateFormat(now(),'yyyy');
	
	if (not isdefined('attributes.mode'))
		attributes.mode = '';
	
	oncekiyil = yil-1;
	sonrakiyil = yil+1;
	oncekiay = ay-1;
	sonrakiay = ay+1;
	
	if (ay eq 1) oncekiay=12;
	if (ay eq 12) sonrakiay=1;
	
	aylar = '#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#';
	tarih = createDate(yil,ay,1);
	bas = DayofWeek(tarih)-1;
	
	if (bas eq 0) bas=7;
	
	son = DaysinMonth(tarih);
	gun = 1;
	if (isdefined('attributes.view_agenda') and len(attributes.view_agenda))
		yer = '#request.self#?fuseaction=agenda.view_monthly&view_agenda=#attributes.view_agenda#';
	else
		yer = '#request.self#?fuseaction=agenda.view_monthly';
	
	attributes.to_day = CreateODBCDatetime('#yil#-#ay#-#gun#');
	tarih1 = CreateODBCDatetime('#yil#-#ay#-1');
	tarih2 = CreateODBCDatetime('#yil#-#ay#-#son#');
</cfscript>
<cfparam name="attributes.event_id" default="">
<cfset add_format_ = 'M'>
<!--- date_add ile eklenecek deger, gun hafta ve ay olarak belirlenerek includelara gonderilir --->
<cfinclude template="/agenda/query/get_all_agenda_department_branch.cfm"><!--- Yetkili Oldugum Sube ve Departmanlar --->
<cfinclude template="/agenda/query/get_all_agenda_warning_pages.cfm"><!---Sayfa Uyarıları--->
<cfinclude template="/agenda/query/get_all_agenda_works.cfm"><!--- Isler --->
<cfinclude template="/agenda/query/get_all_agenda_classes.cfm"><!--- Egitimler --->
<cfinclude template="/agenda/query/get_monthly_events.cfm">
<cfinclude template="/agenda/query/get_event_plan_rows.cfm">
<cfinclude template="/agenda/query/get_all_organizations.cfm"><!--- Etkinlikler --->
<cfquery name="get_mountly_offtimes" datasource="#DSN#">
	SELECT START_DATE,FINISH_DATE FROM SETUP_GENERAL_OFFTIMES WHERE START_DATE <=#tarih2# AND FINISH_DATE >= #tarih1#
</cfquery>
<cfset docGeorge=XmlNew()>
<cfset docGeorge.xmlRoot = XmlElemNew(docGeorge,"data")>
<cfset elemFirstName = XmlElemNew(docGeorge,"event")>
<cfset i=1>

<cfoutput>
  <cfloop query="get_monthly_events">
    <cfset attributes.eventcat = eventcat>
    <cfinclude template="/agenda/query/get_eventcat_colour.cfm">
	
    <!--- Bu bolum sorun olursa konntrol edilmeli,sube ve departmen ve herkes gorsun olayı. Gerekirse eski if bloklarına bakalım BK 20080331 --->
	
	<cfset yer="">
    <cfif not len(get_monthly_events.event_place_id)>
      <cfelseif get_monthly_events.event_place_id eq 1>
      	<cfset yer="<cf_get_lang no='6.Ofis İçi'>">
      <cfelseif get_monthly_events.event_place_id eq 2>
      	<cfset yer="<cf_get_lang no='10.Ofis Dışı'>">
      <cfelseif get_monthly_events.event_place_id eq 3>
      	<cfset yer="<cf_get_lang no='12.Müşteri Ofisi'>">
    </cfif>
		
    <cfset elemFirstName.XmlAttributes.recordid = "#event_id#">
    <cfset elemFirstName.XmlAttributes.start_date = "#dateformat(get_monthly_events.startdate,'yyyy-mm-dd')# #timeformat(dateadd('h',session.ep.time_zone,get_monthly_events.startdate),timeformat_style)#">
    <cfset elemFirstName.XmlAttributes.end_date = "#dateformat(get_monthly_events.finishdate,'yyyy-mm-dd')# #timeformat(dateadd('h',session.ep.time_zone,get_monthly_events.finishdate),timeformat_style)#">
    <cfset elemFirstName.XmlAttributes.text = "#event_head#">
    <cfset elemFirstName.XmlAttributes.section = "0">
	<cfset elemFirstName.XmlAttributes.address = "agenda.view_daily&event=upd&event_id=#event_id#">
    <cfset docGeorge.xmlRoot.XmlChildren[#i#] = elemFirstName>
    <cfset i++>

    <!--- Bu bolum sorun olursa konntrol edilmeli,sube ve departmen ve herkes gorsun olayı. Gerekirse eski if bloklarına bakalım BK 20080331 --->
  </cfloop>
  
  <cfloop query="get_all_agenda_works">
    <cfset elemFirstName.XmlAttributes.recordid = "#work_id#">
    <cfset elemFirstName.XmlAttributes.start_date = "#dateformat(get_all_agenda_works.target_start,'yyyy-mm-dd')# #timeformat(dateadd('h',session.ep.time_zone,get_all_agenda_works.target_start),timeformat_style)#">
    <cfset elemFirstName.XmlAttributes.end_date = "#dateformat(get_all_agenda_works.target_finish,'yyyy-mm-dd')# #timeformat(dateadd('h',session.ep.time_zone,get_all_agenda_works.target_finish),timeformat_style)#">
    <cfset elemFirstName.XmlAttributes.text = "iş- #work_head#">
    <cfset elemFirstName.XmlAttributes.section = "1">
	<cfset elemFirstName.XmlAttributes.address = "project.works&event=det&id=#work_id#">
    <cfset docGeorge.xmlRoot.XmlChildren[#i#] = elemFirstName>
    <cfset i++>	
  </cfloop>
  
  <cfloop query="get_event_plan">
	<cfset str="">
	<cfif listlen(event_plan_head,'-') eq 2><cfset str = str & "#REReplaceNoCase(listfirst(event_plan_head,'-'),'<[^>]*>','','ALL')#"></cfif>
    <cfif Len(fullname)><cfset str = str & "#fullname# -"></cfif>
    <cfset str = str & "#member_name# #member_surname# - Ziyaret">
	<cfset elemFirstName.XmlAttributes.recordid = "#event_plan_id#">
	<cfset elemFirstName.XmlAttributes.start_date = "#dateformat(get_event_plan.start_date,'yyyy-mm-dd')# #timeformat(dateadd('h',session.ep.time_zone,get_event_plan.start_date),timeformat_style)#">
	<cfset elemFirstName.XmlAttributes.end_date = "#dateformat(get_event_plan.finish_date,'yyyy-mm-dd')# #timeformat(dateadd('h',session.ep.time_zone,get_event_plan.finish_date),timeformat_style)#">
	<cfset elemFirstName.XmlAttributes.text = "#str#">
	<cfset elemFirstName.XmlAttributes.section = "2">			
	<cfset elemFirstName.XmlAttributes.address = "objects.popup_upd_event_plan_result&eventid=#event_plan_id#&event_plan_row_id=#event_plan_row_id#&partner_id=#member_id#">
	<cfset docGeorge.xmlRoot.XmlChildren[#i#] = elemFirstName>	
	<cfset i++>	
  </cfloop>
  <!--- Egitimler --->
  <cfdump var="#get_all_agenda_classes#">
  <cfset katilimci=0>
    <cfloop query="get_all_agenda_classes">
		<cfset elemFirstName.XmlAttributes.recordid = "#class_id#">
		<cfset elemFirstName.XmlAttributes.start_date = "#dateformat(get_all_agenda_classes.start_date,'yyyy-mm-dd')# #timeformat(dateadd('h',session.ep.time_zone,get_all_agenda_classes.start_date),timeformat_style)#">
		<cfset elemFirstName.XmlAttributes.end_date = "#dateformat(get_all_agenda_classes.finish_date,'yyyy-mm-dd')# #timeformat(dateadd('h',session.ep.time_zone,get_all_agenda_classes.finish_date),timeformat_style)#">
		<cfset elemFirstName.XmlAttributes.text = "#class_name#">
		<cfset elemFirstName.XmlAttributes.section = "3">			
		<cfset elemFirstName.XmlAttributes.address = "training.view_class&class_id=#class_id#">
		<cfset docGeorge.xmlRoot.XmlChildren[#i#] = elemFirstName>	
		<cfset i++>		  
        <cfset katilimci=1>
    </cfloop>
  <cfif katilimci neq 1>
    <cfloop query="get_all_agenda_classes_inform">     
		<cfset elemFirstName.XmlAttributes.recordid = "#class_id#">
		<cfset elemFirstName.XmlAttributes.start_date = "#dateformat(get_all_agenda_classes_inform.start_date,'yyyy-mm-dd')# #timeformat(get_all_agenda_classes_inform.start_date,timeformat_style)#">
		<cfset elemFirstName.XmlAttributes.end_date = "#dateformat(get_all_agenda_classes_inform.finish_date,'yyyy-mm-dd')# #timeformat(get_all_agenda_classes_inform.finish_date,timeformat_style)#">
		<cfset elemFirstName.XmlAttributes.text = "(#class_name# Bilgilendirme Amaçlı)">
		<cfset elemFirstName.XmlAttributes.section = "3">			
		<cfset elemFirstName.XmlAttributes.address = "training.view_class&class_id=#class_id#">
		<cfset docGeorge.xmlRoot.XmlChildren[#i#] = elemFirstName>	
		<cfset i++>	  
     </cfloop>
  </cfif>
  <!--- //Egitimler --->
  <!--- Sayfa Uyarilari --->
  <cfloop query="get_all_agenda_warning_pages">
    <cfif ((get_all_agenda_warning_pages.LAST_RESPONSE_DATE gte attributes.to_day) and (get_all_agenda_warning_pages.LAST_RESPONSE_DATE lt date_add('d',1,attributes.to_day)))>
      <cfif find('.popup',url_link)>
        <cfset is_popup=1>
        <cfelse>
        <cfset is_popup=0>
      </cfif>
		<cfset elemFirstName.XmlAttributes.recordid = "#parent_id#">
		<cfset elemFirstName.XmlAttributes.start_date = "#dateformat(get_all_agenda_warning_pages.LAST_RESPONSE_DATE,'yyyy-mm-dd')# #timeformat(get_all_agenda_warning_pages.LAST_RESPONSE_DATE,timeformat_style)#">
		<cfset elemFirstName.XmlAttributes.end_date = "#dateformat(get_all_agenda_warning_pages.LAST_RESPONSE_DATE,'yyyy-mm-dd')# #TimeFormat(DateAdd("n", 135, timeformat(get_all_agenda_warning_pages.LAST_RESPONSE_DATE,timeformat_style)))#">
		<cfset elemFirstName.XmlAttributes.text = "#warning_head# (Uyarı),">
		<cfset elemFirstName.XmlAttributes.section = "4">			
		<cfset elemFirstName.XmlAttributes.address = "myhome.popup_dsp_warning&warning_id=#parent_id#&warning_is_active=0&sub_warning_id=#w_id#">
		<cfset docGeorge.xmlRoot.XmlChildren[#i#] = elemFirstName>	
		<cfset i++>     
    </cfif>
  </cfloop>
  <!--- //Sayfa Uyarilari --->
  
  <!--- Crm > kampanya / etkinlik yönetiminde etkinlikler sayfası yapıldı. herkes görsün, şubemdekiler görsün, departmanımdakiler görsün --->
	<cfloop query="get_all_organizations">	
		<cfset elemFirstName.XmlAttributes.recordid = "#organization_id#">
		<cfset elemFirstName.XmlAttributes.start_date = "#dateformat(get_all_organizations.start_date,'yyyy-mm-dd')# #timeformat(get_all_organizations.start_date,timeformat_style)#">
		<cfset elemFirstName.XmlAttributes.end_date = "#dateformat(get_all_organizations.finish_date,'yyyy-mm-dd')# #TimeFormat(DateAdd("n", 135, timeformat(get_all_organizations.finish_date,timeformat_style)))#">
		<cfset elemFirstName.XmlAttributes.text = "#organization_head#">
		<cfset elemFirstName.XmlAttributes.section = "5">			
		<cfset elemFirstName.XmlAttributes.address = "campaign.form_upd_organization&org_id=#organization_id#">
		<cfset docGeorge.xmlRoot.XmlChildren[#i#] = elemFirstName>	
		<cfset i++>  		
	</cfloop>

</cfoutput>

<!---Convert the XML document to a string--->
<cfset xmlString = ToString(docGeorge)>

<!---Set the content to text/xml, reset the buffer, and output the XML string--->
<cfcontent type="text/xml;charset=utf-8" reset="yes"><cfoutput>#xmlString#</cfoutput>
