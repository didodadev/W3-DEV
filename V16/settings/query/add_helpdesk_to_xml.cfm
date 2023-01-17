<cfset int_unique_help_id = 0>
<cffunction name="temizle" returntype="string">
	<cfargument name="detay">
	<cfset yeni = detay>
	<cfloop condition="1">
		<cfif Find("http://worknet.workcube.com",yeni) or  Find("http://#CGI.HTTP_HOST#",yeni) or  Find("http://#cgi.http_host#",yeni) or Find("http://foraep.workcube",yeni) or Find("http://ep.workcube",yeni)>
			<cfset yeni = Replace(yeni,"http://#cgi.http_host#","")>
			<cfset yeni = Replace(yeni,"http://foraep.workcube","")>
			<cfset yeni = Replace(yeni,"http://ep.workcube","")>
			<cfset yeni = Replace(yeni,"http://#CGI.HTTP_HOST#","")>
			<cfset yeni = Replace(yeni,"http://worknet.workcube.com","")>
		<cfelse>
			<cfreturn yeni>
		</cfif>	
	</cfloop>	
</cffunction>

	<cfquery name="GET_HELPDESK_RECORDS" datasource="#DSN#">
		(
		SELECT
			HELP_DESK.*,EMPLOYEES.EMPLOYEE_NAME AS NAME,
			EMPLOYEES.EMPLOYEE_SURNAME AS SURNAME
		FROM 
			HELP_DESK,
			EMPLOYEES
		WHERE
			HELP_DESK.RECORD_MEMBER = 'e' AND
			EMPLOYEES.EMPLOYEE_ID = HELP_DESK.RECORD_ID
		)
	UNION ALL
		(
		SELECT
			HELP_DESK.*, COMPANY_PARTNER_NAME AS NAME,
			COMPANY_PARTNER_SURNAME AS SURNAME
		FROM 
			HELP_DESK,
			COMPANY_PARTNER 
		WHERE
			HELP_DESK.RECORD_MEMBER = 'p' AND
			COMPANY_PARTNER.PARTNER_ID=HELP_DESK.RECORD_ID
		)
		
		<!--- WHERE
			IS_STANDARD=1	 
			'burasi Ozlem hanimin dosyalari export edilirken yazilacan ondan oncede  is_standard=1 yapilmali tabloda
			--->
	</cfquery>
	<!---Yukaridaki sorgudan gelen kayitlari içeren  XML Döküman nesnesi olusturuyoruz  --->
	<cfscript>
	   my_doc = XmlNew();
	   my_doc.xmlRoot = XmlElemNew(my_doc,"help_desk_detail");
	   if(GET_HELPDESK_RECORDS.recordcount)
		   for (i = 1; i lte GET_HELPDESK_RECORDS.recordcount; i = i + 1)
			  {
				  int_unique_help_id = int_unique_help_id + 1 ;
				  //writeoutput("#GET_HELPDESK_RECORDS.recordcount#");
				  my_doc.help_desk_detail.XmlChildren[i] = XmlElemNew(my_doc,"help_desk");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[1] = XmlElemNew(my_doc,"HELP_ID");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[1].XmlText = GET_HELPDESK_RECORDS.HELP_ID[i];
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[2] = XmlElemNew(my_doc,"HELP_HEAD");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[2].XmlText = GET_HELPDESK_RECORDS.HELP_HEAD[i];
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[3] = XmlElemNew(my_doc,"HELP_TOPIC");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[3].XmlText = temizle(GET_HELPDESK_RECORDS.HELP_TOPIC[i]);
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[4] = XmlElemNew(my_doc,"HELP_CIRCUIT");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[4].XmlText = GET_HELPDESK_RECORDS.HELP_CIRCUIT[i];
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[5] = XmlElemNew(my_doc,"HELP_FUSEACTION");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[5].XmlText = GET_HELPDESK_RECORDS.HELP_FUSEACTION[i];
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[6] = XmlElemNew(my_doc,"IS_STANDARD");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[6].XmlText = GET_HELPDESK_RECORDS.IS_STANDARD[i];
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[7] = XmlElemNew(my_doc,"RECORDER_NAME");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[7].XmlText = GET_HELPDESK_RECORDS.RECORDER_NAME[i];
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[8] = XmlElemNew(my_doc,"HELP_LANGUAGE");
				  my_doc.help_desk_detail.XmlChildren[i].XmlChildren[8].XmlText = GET_HELPDESK_RECORDS.HELP_LANGUAGE[i];

			  }
	</cfscript>
	<cfset dosya = "#dateformat(now(),'yyyymmdd')##timeformat(now(),'HHMMSSS')#_helpdesk.xml">
	<cffile action="write" file="#upload_folder#helpdesk#dir_seperator##dosya#" output="#toString(my_doc)#" charset="UTF-8">
	<cffile action="write" file="#upload_folder#helpdesk#dir_seperator#helpdesk.xml" output="#toString(my_doc)#" charset="UTF-8">
	
<script type="text/javascript">
	alert("Dosya <cfoutput>#upload_folder#helpdesk#dir_seperator##dosya#</cfoutput> dosyasi olarak olusturulmustur!");
	window.location.href='<cfoutput>#request.self#?fuseaction=settings.form_add_helpdesk_info</cfoutput>';
</script>

