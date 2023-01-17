<!--- servis teklif formu --->
<cfquery name="our_company" datasource="#dsn#">
	SELECT 
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		COMPANY_NAME,
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
	   COMP_ID = <cfif isDefined("SESSION.EP.COMPANY_ID")>#SESSION.EP.COMPANY_ID#<cfelseif isDefined("SESSION.PP.COMPANY")>#SESSION.PP.COMPANY#</cfif>
</cfquery>
<cfquery name="get_service" datasource="#dsn3#">
	SELECT * FROM SERVICE WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
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
	<cfquery name="get_county" datasource="#dsn#">
		SELECT COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_adres.county#">
	</cfquery>
</cfif>
<cfif len(get_adres.city)>
	<cfquery name="get_city" datasource="#dsn#">
		SELECT CITY_NAME FROM SETUP_CITY WHERE CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_adres.city#">
	</cfquery> 
</cfif>
<cfif len(get_service.subscription_id)>
	<cfquery name="get_subscription" datasource="#dsn3#">
		SELECT * FROM SUBSCRIPTION_CONTRACT WHERE SUBSCRIPTION_ID IS NOT NULL AND SUBSCRIPTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_service.subscription_id#">
	</cfquery>
</cfif>
<cfquery name="get_service_plus" datasource="#dsn3#">
	SELECT * FROM SERVICE_PLUS WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfquery name="get_service_operation" datasource="#dsn3#">
	SELECT TOTAL_PRICE SYSTEM_TOTAL_PRICE,AMOUNT,CURRENCY FROM SERVICE_OPERATION WHERE SERVICE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_id#">
</cfquery>
<cfset service_operation_total = 0>
<cfset service_operation_money = ''>
<cfset adam_gun = 0>
<cfif get_service_operation.recordcount>
	<cfoutput query="get_service_operation">
		<cfset service_operation_total = service_operation_total + SYSTEM_TOTAL_PRICE>
		<cfset adam_gun = adam_gun + amount>
		<cfset service_operation_money = currency>
	</cfoutput>
</cfif>
<br/><br/><br/>
<style>table,td{font-size:12px;}</style>
<table border="1" bordercolor="000000" cellpadding="2" cellspacing="0" style="width:175mm;" align="center">
	<tr height="16">
		<cfoutput query="our_company">
			<td align="left" width="50%">
            	<cfif len(our_company.ASSET_FILE_NAME3)>
            		<cf_get_server_file output_file="settings/#asset_file_name3#" output_server="#asset_file_name3_server_id#" output_type="5">
                </cfif>&nbsp;
            </td>
			<td align="left" width="50%">
			<table border="0" cellpadding="0" cellspacing="0">
				<tr style="height:5mm;">
					<td colspan="2"><b>#company_name#</b></td>
				</tr>
				<tr style="height:5mm;">
					<td colspan="2">#address#</td>
				</tr>
				<tr style="height:5mm;">
					<td><cf_get_lang_main no='87.Telefon'>: #tel_code# #tel#</td>
					<td><cf_get_lang_main no='76.Fax'>: #tel_code# #fax#</td>
				</tr>
				<tr style="height:5mm;">
					<td>#web#</td>
					<td>#email#</td>
				</tr>
			</table>
			</td>
		</cfoutput>
	</tr>  
</table>
<br/><br/>
<cfoutput query="get_service">
	<table cellpadding="3" cellspacing="0" border="1" bordercolor="000000" style="width:175mm;" align="center">
		<tr>
			<td width="35%" bgcolor="000000"><font color="FFFFFF" size="+2" face="Arial, Helvetica, sans-serif"><cf_get_lang no="933.Servis Teklif Formu"></font></td>
			<td width="32%"><b><cf_get_lang no='956.Form'><cf_get_lang_main no='75.No'> :</b>&nbsp;&nbsp;#service_no#</td>
			<td width="32%"><b><cf_get_lang_main no='330.Tarih'> :</b>&nbsp;&nbsp;#dateformat(APPLY_date,dateformat_style)#</td>
		</tr>
	</table>
	<br/><br/>
	<table border="0" cellpadding="3" cellspacing="0" style="width:175mm;" align="center">
		<tr height="23">
			<td width="80"><b><cf_get_lang_main no='45.Müşteri'></b></td>
			<td align="left"><b>:</b> 
				<cfif len(service_consumer_id)>#get_cons_info(service_consumer_id,0,0)#</cfif>
				<cfif len(service_company_id)>#get_par_info(service_company_id,1,1,0)#</cfif>
			</td>
		</tr>
		<tr height="23">
			<td><b><cf_get_lang_main no='166.Yetkili'></b></td>
			<td><b>:</b> #get_service.applicator_name#</td>
		</tr>
		<tr height="23">
			<td><b><cf_get_lang_main no='1311.Adres'></b></td>
			<td><b>:</b> #get_adres.adres# <cfif len(get_adres.county)>#get_county.county_name#</cfif><cfif len(get_adres.city)>&nbsp;#get_city.city_name#</cfif></td>
		</tr>
		<tr height="23">
			<td><b><cf_get_lang_main no='87.Telefon'></b></td>
			<td><b>:</b> #get_adres.telcode# - #get_adres.tel#</td>
		</tr>
		<tr height="23">
		  <td><b><cf_get_lang_main no='1350.Vergi Dairesi'></b></td>
		  <td><b>:</b> #get_adres.tax#</td>
		</tr>
		<tr height="23">
			<td><b><cf_get_lang_main no='340.Vergi No'></b></td>
			<td colspan="2"><b>:</b> #get_adres.taxno#</td>
		</tr>
	</table>
	<hr color="000000" style="width:175mm;">
	<table border="0" cellpadding="3" cellspacing="0" style="width:175mm;" align="center">
		<tr style="height:25mm;" valign="top">
			<td><b><cf_get_lang_main no='68.Konu'> : </b> #service_head#<br/>
				<cfset new_detail = replace(service_detail,'#chr(13)#','<br/>','all')>
				#new_detail#
			</td>
		</tr>
	</table>
</cfoutput>
<table cellpadding="3" cellspacing="0" border="1" bordercolor="000000" style="width:175mm;height:35mm;" align="center">
	<tr>
		<td colspan="2">
			<table>
				<tr>
					<td>&nbsp;</td>
					<td><font style="font-size:12px;">
							<strong>
							<cf_get_lang no="934.Yukarıdaki düzenlemeyi yapabilmek için firmamız"> <cfoutput>#adam_gun# <cf_get_lang no="935.Adam Gün karşılığında"> #TLFormat(service_operation_total)# #service_operation_money#</cfoutput>+ <cf_get_lang no="938.KDV talep etmektedir">. <br/>
							<cf_get_lang no="937.Bu tutarı onaylıyorsanız lütfen bildiriniz">.
							</strong>
						</font>
					</td>
				</tr>
			</table>
		</td>
	</tr>
</table>
<br/><br/>
<table border="0" cellpadding="3" cellspacing="0" style="width:175mm;" align="center">
	<tr valign="top" height="30">
		<td width="60%"><b><cf_get_lang_main no='45.Müşteri'><cf_get_lang_main no='88.Onay'> :</b></td>
		<td width="40%"><b><cf_get_lang_main no='55.Not'> :</b></td>
	</tr>
	<tr valign="top" height="30">
		<td><b><cf_get_lang_main no='45.Müşteri'><cf_get_lang_main no='166.Yetkili'> :</b></td>
		<td>&nbsp;</td>
	</tr>
	<tr valign="top" height="30">
		<td><b><cf_get_lang_main no='330.Tarih'> :</b></td>
		<td>&nbsp;</td>
	</tr>
</table>
