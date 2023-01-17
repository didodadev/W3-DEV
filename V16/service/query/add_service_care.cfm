<cfif len(attributes.sales_date)><cf_date tarih="attributes.sales_date"></cfif>
<cfif len(attributes.guaranty_start_date)><cf_date tarih="attributes.guaranty_start_date"></cfif>
<cfif len(attributes.guaranty_finish_date)><cf_date tarih="attributes.guaranty_finish_date"></cfif>
<cfif len(attributes.start_date)><cf_date tarih="attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih="attributes.finish_date"></cfif>
<cftransaction>
<cfif isdefined("document") and len(document)>
	<cftry>
		<cffile action = "upload" 
		  fileField = "document" 
		  destination = "#upload_folder#service#dir_seperator#" 
		  nameConflict = "MakeUnique" 
		  mode="777">
		<cfset file_name = createUUID() & '.' & #cffile.serverfileext#>
		<cffile action="rename" source="#upload_folder#service#dir_seperator##cffile.serverfile#" destination="#upload_folder#service#dir_seperator##file_name#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#service#dir_seperator##file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>	
		<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
		<cfcatch type="Any">
			<script type="text/javascript">
				alert("<cf_get_lang no='36.Dosyaniz Upload Edilemedi ! Dosyanizi Kontrol Ediniz !'>");
				history.back();
			</script>
			<cfabort>
		</cfcatch>  
	</cftry>
</cfif>
<cfquery NAME="ADD_SERVICE_CARE" DATASOURCE="#DSN3#">
	INSERT INTO
		SERVICE_CARE
	(
		PRODUCT_ID,
		SERIAL_NO,
		STATUS,
		CARE_DESCRIPTION,
		SALES_DATE,
		COMPANY_AUTHORIZED_TYPE,
		COMPANY_AUTHORIZED,
		SERVICE_EMPLOYEE,
		SERVICE_EMPLOYEE2,
		DETAIL,
		SERVICE_AUTHORIZED_TYPE,
		SERVICE_AUTHORIZED_ID,
		FILE_NAME,
		FILE_SERVER_ID,
		START_DATE,
		FINISH_DATE,
		GUARANTY_START_DATE,
		GUARANTY_FINISH_DATE,
		MARK,
		RECORD_EMP,
		RECORD_IP,
		RECORD_DATE
	)
	VALUES
	(
		#attributes.product_id#,
		'#attributes.serial_no#',
		<cfif isdefined("attributes.status")>1,<cfelse>0,</cfif>
		'#attributes.care_description#',
		<cfif len(attributes.sales_date)>#attributes.sales_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.member_type)>'#attributes.member_type#'<cfelse>NULL</cfif>,
		<cfif len(attributes.member_id)>#attributes.member_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.employee_id)>#attributes.employee_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.employee_id2)>#attributes.employee_id2#<cfelse>NULL</cfif>,
		<cfif len(attributes.aim)>'#attributes.aim#'<cfelse>NULL</cfif>,
		<cfif len(attributes.service_member_type)>'#attributes.service_member_type#'<cfelse>NULL</cfif>,
		<cfif len(attributes.service_member_id)>#attributes.service_member_id#<cfelse>NULL</cfif>,
		<cfif len(attributes.document)>'#file_name#'<cfelse>NULL</cfif>,
		<cfif len(attributes.document)>#fusebox.server_machine#<cfelse>NULL</cfif>,
		#attributes.start_date#,
		<cfif len(attributes.finish_date)>#attributes.finish_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.guaranty_start_date)>#attributes.guaranty_start_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.guaranty_finish_date)>#attributes.guaranty_finish_date#<cfelse>NULL</cfif>,
		<cfif len(attributes.mark)>'#attributes.mark#'<cfelse>NULL</cfif>,
		#session.ep.userid#,
		'#cgi.remote_addr#',
		#now()#
	)
</cfquery>
<cfquery name="GET_MAXID" datasource="#DSN3#">
	SELECT MAX(PRODUCT_CARE_ID) AS MAX_ID FROM SERVICE_CARE
</cfquery>
</cftransaction>

<script type="text/javascript">
	window.location.href ="<cfoutput>#request.self#?fuseaction=service.list_care&event=upd&id=#get_maxid.max_id#</cfoutput>";
</script>
