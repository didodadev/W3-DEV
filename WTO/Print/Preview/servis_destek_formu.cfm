
<!--- servis destek formu --->
<cfif isdefined("attributes.action_id")>
    <cfset attributes.service_id = attributes.action_id>
<cfelse>
    <cfif isdefined("attributes.id")>
        <cfset attributes.service_id = attributes.id>
    <cfelse>
        <cfset attributes.service_id = listdeleteduplicates(attributes.iid)>
    </cfif>
</cfif>
<cfquery name="OUR_COMPANY" datasource="#DSN#">
	SELECT 
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		COMPANY_NAME,
		ASSET_FILE_NAME2,
		ASSET_FILE_NAME2_SERVER_ID,
		TEL_CODE,
		TEL,TEL2,
		TEL3,
		TEL4,
		FAX,
		TAX_OFFICE,
		TAX_NO,
		ADDRESS,
		WEB,
		EMAIL
	FROM 
	    OUR_COMPANY 
	WHERE 
	   <cfif isDefined("SESSION.EP.COMPANY_ID")>
		COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
		COMP_ID = #SESSION.PP.COMPANY#
	</cfif>
</cfquery>
<cfquery name="get_service" datasource="#dsn3#">
	SELECT * FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_SERVICE_TASK" datasource="#dsn#">
	SELECT 
		PW.PROJECT_EMP_ID,
		PW.OUTSRC_PARTNER_ID
	FROM
		PRO_WORKS PW,
		#dsn3_alias#.SERVICE S
	WHERE
		PW.SERVICE_ID = S.SERVICE_ID AND
		PW.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		S.SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
	GROUP BY
		PW.PROJECT_EMP_ID,
		PW.OUTSRC_PARTNER_ID
</cfquery>
<cfif len(get_service.service_company_id)>
	<cfquery name="get_adres" datasource="#dsn#">
		SELECT
			 COMPANY_ADDRESS AS ADRES,
			 SEMT AS SEMT,
			 COMPANY_TELCODE AS TELCODE,
			 COMPANY_TEL1 AS TEL,
			 TAXOFFICE AS TAX,
			 TAXNO AS TAXNO,
			 COUNTY AS COUNTY,
			 CITY AS CITY,
			 COUNTRY AS COUNTRY
		FROM  
			 COMPANY
		WHERE 
			 COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service.service_company_id#">
	</cfquery>
<cfelseif len(get_service.service_consumer_id)>
	<cfquery name="get_adres" datasource="#dsn#">
		SELECT
			 WORKADDRESS AS ADRES,
			 WORKSEMT AS SEMT,
			 CONSUMER_WORKTELCODE AS TELCODE,
			 CONSUMER_WORKTEL AS TEL,
			 TAX_OFFICE AS TAX,
			 TAX_NO AS TAXNO,
			 WORK_COUNTY_ID AS COUNTY,
			 WORK_CITY_ID AS CITY,
			 WORK_COUNTRY_ID AS COUNTRY
		FROM  
			 CONSUMER
		WHERE 
			 CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service.service_consumer_id#">
	</cfquery>
</cfif>
<cfif len(get_adres.county)>
    <cfquery name="GET_COUNTY" datasource="#dsn#">
        SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_adres.county#">
    </cfquery>
</cfif>
<cfif len(get_adres.city)>
    <cfquery name="GET_CITY" datasource="#dsn#">
        SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_adres.city#">
    </cfquery> 
</cfif>
<cfif len(get_service.subscription_id)>
	<cfquery name="GET_SUBSCRIPTION" datasource="#DSN3#">
		SELECT
			SC.*
		FROM
			SUBSCRIPTION_CONTRACT SC
		WHERE
			SUBSCRIPTION_ID IS NOT NULL AND 
			SC.SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service.subscription_id#">
	</cfquery>
</cfif>
<cfquery name="GET_SERVICE_PLUS" datasource="#DSN3#">
	SELECT
		*
	FROM
		SERVICE_PLUS
	WHERE
		SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfif len(get_service.project_id)>
    <cfquery name="get_project" datasource="#dsn#">
        SELECT 
            PROJECT_HEAD,PROJECT_ID 
        FROM 
            PRO_PROJECTS
        WHERE
            PROJECT_ID IS NOT NULL AND
            PROJECT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service.project_id#">
    </cfquery>
</cfif>
<cfquery name="get_priority" datasource="#dsn#">
SELECT
	PRIORITY
FROM
	SETUP_PRIORITY 
LEFT JOIN #dsn3#.SERVICE ON SERVICE.PRIORITY_ID = SETUP_PRIORITY.PRIORITY_ID
WHERE 
#dsn3#.SERVICE.SERVICE_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="GET_PROCESS_STAGE" datasource="#DSN#">
	SELECT
		PTR.STAGE,
		PTR.PROCESS_ROW_ID 
	FROM
		PROCESS_TYPE_ROWS PTR WITH (NOLOCK),
		PROCESS_TYPE_OUR_COMPANY PTO WITH (NOLOCK),
		PROCESS_TYPE PT WITH (NOLOCK)
	WHERE
		PT.IS_ACTIVE = 1 AND
		PT.PROCESS_ID = PTR.PROCESS_ID AND
		PT.PROCESS_ID = PTO.PROCESS_ID AND
		PTO.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#"> AND
		PT.FACTION LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%service.list_service%">
	ORDER BY 
		PTR.LINE_NUMBER
</cfquery>
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<table style="width:210mm">
    <tr>
        <td>
            <table style="width:100%">
                <tr class="row_border">
                    <td class="print-head"></td>
                    <td class="print_title"><cf_get_lang dictionary_id='33332.Servis Destek Formu'></td>
                    <td style="text-align:right;">
                        <cfif len(our_company.asset_file_name2)>
                        <cfset attributes.type = 1>
                        <cf_get_server_file output_file="/settings/#our_company.asset_file_name2#" output_server="#our_company.asset_file_name2_server_id#" output_type="5">
                        </cfif>
                    </td>
                </tr>
            </table>
        </td>
    </tr>
	<tr>
		<td>
			<table style="width:100%">
				<cfoutput query="get_service">
					<tr>
						<td style="width:140px"><b><cf_get_lang dictionary_id='29764.Form'><cf_get_lang dictionary_id='57487.No'></b></<td>
						<td style="width:170px">#service_no#</<td>
						<td style="width:140px"><b><cf_get_lang dictionary_id='57480.Konu'></b></<td>
						<td style="width:170px">#service_head#</<td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='57457.Müşteri'></b></td>
						<td><cfif len(service_consumer_id)>
								#get_cons_info(service_consumer_id,0,0)#</cfif>
									<cfif len(service_company_id)>
										#get_par_info(service_company_id,1,1,0)#</cfif>
						</td>
						<td><b><cf_get_lang dictionary_id='33336.Servis İstek Tarihi'></b></td>
						<td>#dateformat(apply_date,dateformat_style)#<td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='57578.Yetkili'></b></td>
						<td>#get_service.applicator_name#</td>
						<td><b><cf_get_lang dictionary_id='57491.Saat'></b></td>
						<td><cfif len(apply_date)>
							<cfset applydate = date_add("H",session.ep.TIME_ZONE,apply_date)>
							</cfif>
							<cfif len(apply_date)>#timeformat(applydate,'HH:MM:SS')#</cfif>
						</td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='58783.Workcube'><cf_get_lang dictionary_id='57637.Seri No'></b></td>
						<td><cfif len(get_service.subscription_id)>
								&nbsp;#get_subscription.subscription_no#
									<cfelse>
										&nbsp;
							</cfif>
						</td>
						<td><b><cf_get_lang dictionary_id='57416.Proje'></b></td>
						<td><cfif len(get_service.project_id)>
							#get_project.project_head#
						<cfelse>
							&nbsp;
						</cfif>
						</td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='58762.Vergi Dairesi'></b></td>
						<td>#get_adres.tax#</td>
						<td><b><cf_get_lang dictionary_id='57752.Vergi No'></b></td>
						<td>#get_adres.taxno#<td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='51263.Telefon No'></b></td>
						<td>#get_adres.telcode#&nbsp#get_adres.tel#</td>
						<td><b><cf_get_lang dictionary_id='57485.Öncelik'></b></td>
						<td>#get_priority.PRIORITY#</td>
					</tr>
					<tr>
						<td><b><cf_get_lang dictionary_id='57629.Açıklama'></b></td>
						<td  colspan="3"><cfset new_detail = replace(service_detail,'#chr(13)#','<br/>','all')>
							#new_detail#</td>
						<td></td>
						<td></td>
					</tr>
					<tr  class="row_border">
						<td><b><cf_get_lang dictionary_id='58723.Adres'></b></td>
						<td colspan="3">#get_adres.adres#
							<cfif len(get_adres.county)>
								&nbsp#get_county.county_name#
							</cfif>
							<cfif len(get_adres.city)>
								&nbsp#get_city.city_name#
							</cfif></td>
						<td></td>
						<td></td>	
					</tr>
				</cfoutput>
			</table>
		</td>	
	</tr>
	<tr>
		<td>
			<table style="width:100%">
				<cfoutput>
					<tr><td style="height:5mm;">&nbsp;</td></tr>
					<tr>
						<td style="width:140px"><b><cf_get_lang dictionary_id='57655.Başlama Tarihi'></b></td>
						<td style="width:170px"><cfset startdate=date_add("H",session.ep.TIME_ZONE,get_service.start_date)>
							<cfif len(get_service.finish_date)>
								<cfset finishdate=date_add("H",session.ep.TIME_ZONE,get_service.finish_date)>
							</cfif>
							#timeformat(startdate,'HH:MM:SS')#&nbsp;&nbsp;#dateformat(get_service.start_date,dateformat_style)#</td>
						<td style="width:140px"><b><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></b></td>
						<td><cfif len(get_service.finish_date)>#timeformat(finishdate,'HH:MM:SS')#</cfif>&nbsp;&nbsp;#dateformat(get_service.finish_date,dateformat_style)#</td>
					</tr>
					<tr class="row_border">
						<cfif len(startdate) and len(get_service.finish_date)>
							<cfset d3=DATEDIFF('h',startdate,finishdate)>
							<cfset minute_=DATEDIFF('N',startdate,finishdate) mod 60>
						</cfif>
							<td><b><cf_get_lang dictionary_id='33352.Toplam Çalışma Saat'></b></td>
							<td colspan="3"><cfif len(startdate) and len(get_service.finish_date)>#d3# <cf_get_lang dictionary_id='57491.Saat'> #minute_# <cf_get_lang dictionary_id='58127.Dakika'></cfif></td>
							<td></td>
							<td></td>	
					</tr>
				</cfoutput>
			</table> 
		</td>
	</tr>	
</table>

<table width="100%">
	<tr><td style="height:10mm;">&nbsp;</td></tr>
	<tr valign="top">
		<td colspan="2"><b><cf_get_lang dictionary_id='57457.Müşteri'><cf_get_lang dictionary_id='57500.Onay'></b></td>
		<td><b><cf_get_lang dictionary_id='57457.Müşteri'><cf_get_lang dictionary_id='57578.Yetkili'></b></td>		
	</tr>
	<tr><td style="height:10mm;">&nbsp;</td></tr>	
</table>

<table>
	<tr class="fixed">
		<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#our_company.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
	</tr>
</table>