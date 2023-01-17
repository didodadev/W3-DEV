<cfif isdefined("attributes.action_id")>
    <cfset attributes.service_id = attributes.action_id>
<cfelse>
    <cfif isdefined("attributes.id")>
        <cfset attributes.service_id = attributes.id>
    <cfelse>
        <cfset attributes.service_id = listdeleteduplicates(attributes.iid)>
    </cfif>
</cfif>
<cfquery name="GET_SERVICE_DETAIL" datasource="#dsn#">
	SELECT * FROM G_SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_SERVICE_APP_ROWS" datasource="#dsn#"><!--- Basvuru Satirlari- Kategori Bilgileri --->
	SELECT SERVICE_SUB_CAT_ID FROM G_SERVICE_APP_ROWS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_SERVICE_APPCAT" datasource="#dsn#"><!--- Kategori --->
	SELECT SERVICECAT,SERVICECAT_ID FROM G_SERVICE_APPCAT WHERE SERVICECAT_ID = #get_service_detail.servicecat_id#
</cfquery>
<cfif len(GET_SERVICE_APP_ROWS.SERVICE_SUB_CAT_ID)>
	<cfquery name="GET_SERVICE_APPCAT_SUB" datasource="#dsn#"><!--- Alt Kategori --->
		SELECT SERVICE_SUB_CAT, SERVICE_SUB_CAT_ID FROM G_SERVICE_APPCAT_SUB WHERE SERVICE_SUB_CAT_ID = #GET_SERVICE_APP_ROWS.SERVICE_SUB_CAT_ID#
	</cfquery>
</cfif>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
	    COMPANY_NAME
	FROM 
		OUR_COMPANY 
	WHERE 
		<cfif isdefined("attributes.our_company_id")>
			COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
		<cfelse>
			<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
				COMP_ID = #session.ep.company_id#
			<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
				COMP_ID = #session.pp.company_id#
			<cfelseif isDefined("session.ww.our_company_id")>
				COMP_ID = #session.ww.our_company_id#
			<cfelseif isDefined("session.cp.our_company_id")>
				COMP_ID = #session.cp.our_company_id#
			</cfif> 
		</cfif> 
</cfquery>
<cfquery name="GET_PRIORITY" datasource="#dsn#">
	SELECT PRIORITY FROM SETUP_PRIORITY WHERE PRIORITY_ID = #get_service_detail.priority_id#
</cfquery>
<cfquery name="GET_STATUS" datasource="#dsn#">
	SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID = #get_service_detail.service_status_id#
</cfquery>
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">

<table style="width:210mm">
	<tr>
		<td>
			<table style="width:100%">
				<tr class="row_border">
                    <td class="print-head"></td>
                    <td class="print_title"><cf_get_lang dictionary_id='58468.Call Center Başvuruları'></td>
                    <td style="text-align:right;">
                        <cfif len(check.asset_file_name2)>
                        <cfset attributes.type = 1>
                        <cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
                        </cfif>
                    </td>
                 </tr>
			</table>
		</td>
	</tr>
	<tr>
		<td>
			<table  style="width:100%;" align="center">
				<cfoutput>
					<tr>
						<td style="width:140px"><b><cf_get_lang dictionary_id='32417.Başvuru No'></b></td>
						<td style="width:170px">#get_service_detail.service_no#</td>
						<td style="width:140px"><b><cf_get_lang dictionary_id='29514.Başvuru Yapan'></b></td>
						<td style="width:170px">#get_service_detail.applicator_name#</td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='57485.Öncelik'></b></td>
						<td>#get_priority.priority#</td>
						<td><b><cf_get_lang dictionary_id='57482.Aşama'></b></td>
						<td>#get_status.stage#</td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='57486.Kategori'></b></td>
						<td>#get_service_appcat.servicecat#</td>
						<td><b><cf_get_lang dictionary_id='31061.Alt Kategori'></b></td>
						<td><cfif isdefined('GET_SERVICE_APPCAT_SUB')>
							<cfloop query="GET_SERVICE_APPCAT_SUB">
							<p>#GET_SERVICE_APPCAT_SUB.service_sub_cat#</p>
						</cfloop>
					</cfif>
						</td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='31362.Başvuru Tarihi'></b></td>
						<td>
							<cfset adate=date_add("H",session.ep.time_zone,get_service_detail.apply_date)>
							<cfset ahour=datepart("H",adate)>
							#dateformat(get_service_detail.apply_date,dateformat_style)# #TimeFormat(ahour,timeformat_style)#
						
						</td>
						<td><b><cf_get_lang dictionary_id='34926.Kabul Tarihi'></b></td>
						<td><cfif len(get_service_detail.start_date)>
							<cfset sdate=date_add("H",session.ep.time_zone,get_service_detail.start_date)>
							<cfset shour=datepart("H",sdate)>
							#dateformat(get_service_detail.start_date,dateformat_style)# #TimeFormat(shour,timeformat_style)#
						</cfif>
						</td>
					</tr>		
					<tr>
						<td><b><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></b></td>
						<td><cfif len(get_service_detail.finish_date)>
							<cfset fdate=date_add("H",session.ep.time_zone,get_service_detail.finish_date)>
							<cfset fhour=datepart("H",fdate)>
							#dateformat(get_service_detail.finish_date,dateformat_style)#  #TimeFormat(fhour,timeformat_style)#
						</cfif>
						</td>
						<td><b><cf_get_lang dictionary_id='58143.İletişim'></b></td>
						<td><cfif len(get_service_detail.commethod_id)>
							<cfquery name="GET_COM_METHOD" datasource="#dsn#">
								SELECT COMMETHOD FROM SETUP_COMMETHOD WHERE COMMETHOD_ID = #get_service_detail.commethod_id#
							</cfquery>
							#get_com_method.commethod#
						</cfif>
						</td>
					</tr>
					<tr rowspan="2"  class="row_border">
						<td><b><cf_get_lang dictionary_id='57480.Konu'></b></td>
						<td>#get_service_detail.service_head#</td>
						<td><b><cf_get_lang dictionary_id='57629.Açıklama'></b></td>
						<td>#get_service_detail.service_detail#</td>
					</tr>
					<tr></tr>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>
<br><br>
    <table>
	<tr class="fixed">
		<td style="font-size:9px!important;"><b>© Copyright</b> <cfoutput>#check.COMPANY_NAME#</cfoutput> dışında kullanılamaz, paylaşılamaz.</td>
	  </tr>
    </table>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
