<cfquery name="GET_ASSETP_REQUEST" datasource="#DSN#">
	SELECT
		 *
	FROM 
		ASSET_P_REQUEST 
	WHERE 
		REQUEST_ID = #attributes.request_id#
</cfquery>
<cfquery name="GET_ASSETP_CAT" datasource="#DSN#">
	SELECT ASSETP_CAT FROM ASSET_P_CAT WHERE ASSETP_CATID = #get_assetp_request.assetp_catid#
</cfquery>
<cftry>
	<cfsavecontent variable="ust"><cfinclude template="../../objects/display/view_company_logo.cfm"></cfsavecontent>
	<cfsavecontent variable="alt"><cfinclude template="../../objects/display/view_company_info.cfm"></cfsavecontent>
	<cfset alt = ReplaceList(alt,'#chr(39)#','')>
	<cfset alt = ReplaceList(alt,'#chr(10)#','')>
	<cfset alt = ReplaceList(alt,'#chr(13)#','')>
	<cfset ust = ReplaceList(ust,'#chr(39)#','')>
	<cfset ust = ReplaceList(ust,'#chr(10)#','')>
	<cfset ust = ReplaceList(ust,'#chr(13)#','')>
	<cfmail
		from="#session.ep.company#<#session.ep.company_email#>"
		to="#attributes.mail_to#" 			
		subject="WorkCube Fiziki Varlık Yöneticisi" 
		type="HTML">
			#ust#
			<table width="700" align="center">
			<tr>
				<td>#get_emp_info(get_assetp_request.record_emp,0,0)# tarafından #get_assetp_cat.assetp_cat# katogorisine 
				#dateformat(get_assetp_request.request_date,dateformat_style)# tarihinde yapılmış olan talep 
				<cfswitch expression="#GET_ASSETP_REQUEST.result_id#">
					<cfcase value="0"><cf_get_lang no='202.Kabul edilmiştir'></cfcase>
					<cfcase value="1"><cf_get_lang no='780.Red edilmiştir'></cfcase>
					<cfcase value=""><cf_get_lang no='781.Bekleme aşamasındadır'></cfcase>
					</cfswitch>
				</td>
			</tr>
			<tr><cfif get_assetp_request.result_detail neq "">
					<td align="center"><cf_get_lang no ='751.Degerlendirme Detayı'>: #get_assetp_request.result_detail#</td>
				</cfif>
			</tr>
			</table>
			#alt#
	</cfmail>
	<cfcatch>			
		<script type="text/javascript">
			alert("Başarısız Mail Gönderme !");
			history.back();
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<script type="text/javascript">
	wrk_opener_reload();
	window.close();
</script>
