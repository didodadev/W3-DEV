<!---E.A 17.07.2012 select ifadeleri düzenlendi--->
<cfparam name="attributes.rent_document" default="">
<cfif len(attributes.support_start_date)>
	<cf_date tarih='attributes.support_start_date'>
</cfif>
<cfif len(attributes.support_finish_date)>
	<cf_date tarih='attributes.support_finish_date'>
</cfif>
<cfquery name="ASSET_CARE_CONTRACTS_INFO" datasource="#DSN#">
	SELECT  USE_CERTIFICATE, USE_CERTIFICATE_SERVER_ID FROM ASSET_CARE_CONTRACT WHERE ASSET_ID = #attributes.assetp_id# and IS_RENT=1
</cfquery>
<cfif (ASSET_CARE_CONTRACTS_INFO.recordcount neq 0)>
	<cfif len(attributes.rent_document)>			
			<cftry>
			<cffile action = "upload" fileField = "rent_document" destination = "#upload_folder#assetcare#dir_seperator#" nameConflict = "MakeUnique" mode="777">
			<cfset file_name = createUUID() & '.' & #cffile.serverfileext#>
			<cffile action="rename" source="#upload_folder#assetcare#dir_seperator##cffile.serverfile#" destination="#upload_folder#assetcare#dir_seperator##file_name#">
			
			<!---Script dosyalarını engelle  02092010 ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder#assetcare#dir_seperator##file_name#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>	
			
			
			<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
				<cfcatch type="Any">
					<script type="text/javascript">
						alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
						history.back();
					</script>
					<cfabort>
				</cfcatch>  
			</cftry>	
			<!--- <cffile action="delete" file="#upload_folder#asset#dir_seperator##asset_care_contracts_info.use_certificate#"> --->
			<cf_del_server_file output_file="assetcare/#asset_care_contracts_info.use_certificate#" output_server="#asset_care_contracts_info.use_certificate_server_id#">
			
	</cfif>
	<cfquery name="UPD_ASSET_CARE_CONTRACTS_INFO" datasource="#DSN#">
		UPDATE 
			ASSET_CARE_CONTRACT 
		SET
			CONTRACT_HEAD = <cfif len(attributes.contract_head)>'#attributes.contract_head#'<cfelse>NULL</cfif>,
			SUPPORT_COMPANY_ID  = <cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
			SUPPORT_AUTHORIZED_ID = <cfif len(attributes.authorized_id)>#attributes.authorized_id#<cfelse>NULL</cfif>,
			SUPPORT_EMPLOYEE_ID = <cfif len(attributes.support_position_id)>#attributes.support_position_id#<cfelse>NULL</cfif>,
			SUPPORT_START_DATE = <cfif len(attributes.support_start_date)>#attributes.support_start_date#<cfelse>NULL</cfif>,
			SUPPORT_FINISH_DATE = <cfif len(attributes.support_finish_date)>#attributes.support_finish_date#<cfelse>NULL</cfif>,
			<cfif isdefined("file_name") and len(file_name)>USE_CERTIFICATE = '#file_name#',</cfif>		
			<cfif isdefined("file_name") and len(file_name)>USE_CERTIFICATE_SERVER_ID =#fusebox.server_machine#,</cfif>			
			DETAIL = <cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
			SUPPORT_CAT_ID = <cfif len(attributes.support_cat)>#attributes.support_cat#<cfelse>NULL</cfif>,
			RENT_PAYMENT_PERIOD =  <cfif len(attributes.rent_payment_period)>#attributes.rent_payment_period#<cfelse>NULL</cfif>,
			RENT_AMOUNT = <cfif len(attributes.rent_amount)>#attributes.rent_amount#<cfelse>NULL</cfif>,
 			RENT_AMOUNT_CURRENCY  = <cfif len(attributes.rent_amount_currency)>'#attributes.rent_amount_currency#'<cfelse>NULL</cfif>,
			FUEL_AMOUNT  = <cfif len(attributes.fuel_amount)>#attributes.fuel_amount#<cfelse>NULL</cfif>,
			FUEL_AMOUNT_CURRENCY  = <cfif len(attributes.fuel_amount_currency)>'#attributes.fuel_amount_currency#'<cfelse>NULL</cfif>,
			CARE_AMOUNT  = <cfif len(attributes.care_amount)>#attributes.care_amount#<cfelse>NULL</cfif>,
			CARE_AMOUNT_CURRENCY  = <cfif len(attributes.care_amount_currency)>'#attributes.care_amount_currency#'<cfelse>NULL</cfif>,
			CARE_EXPENSE  = <cfif isdefined("attributes.is_care_added")>#attributes.is_care_added#<cfelse>NULL</cfif>,
			FUEL_EXPENSE  = <cfif isdefined("attributes.is_fuel_added")>#attributes.is_fuel_added#<cfelse>NULL</cfif>,
			IS_RENT = 1,
			PROJECT_ID  = <cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
			UPDATE_DATE = #now()#,
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_IP = '#cgi.remote_addr#'
		WHERE
			ASSET_ID = #attributes.assetp_id#
	</cfquery>
<cfelse>
	<cfif len(attributes.rent_document)>			
		<cftry>
			<cffile action = "upload" fileField = "rent_document" destination = "#upload_folder#assetcare#dir_seperator#" nameConflict = "MakeUnique" mode="777">
			<cfset file_name = createUUID() & '.' & #cffile.serverfileext#>
			<cffile action="rename" source="#upload_folder#assetcare#dir_seperator##cffile.serverfile#" destination="#upload_folder#assetcare#dir_seperator##file_name#">
			<!---Script dosyalarını engelle  02092010 ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder#assetcare#dir_seperator##file_name#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					history.back();
				</script>
				<cfabort>
			</cfif>			
			<cfset form.photo = '#file_name#.#cffile.serverfileext#'>
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>
	</cfif>
	
	<cfquery name="ADD_ASSET_CARE_CONTRACTS_INFO" datasource="#DSN#">
		INSERT INTO
		ASSET_CARE_CONTRACT 
			(
				ASSET_ID,
				CONTRACT_HEAD ,
				SUPPORT_COMPANY_ID,
				SUPPORT_AUTHORIZED_ID,
				SUPPORT_EMPLOYEE_ID,
				SUPPORT_START_DATE,
				SUPPORT_FINISH_DATE,
				USE_CERTIFICATE,
				USE_CERTIFICATE_SERVER_ID,
				DETAIL,
				SUPPORT_CAT_ID,
				RENT_PAYMENT_PERIOD,
				RENT_AMOUNT,
				RENT_AMOUNT_CURRENCY,
				FUEL_AMOUNT,
				FUEL_AMOUNT_CURRENCY,  
				CARE_AMOUNT,
				CARE_AMOUNT_CURRENCY,
				CARE_EXPENSE,
				FUEL_EXPENSE,
				IS_RENT,
				PROJECT_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP
			) 
		VALUES 
			(
				#attributes.assetp_id#,
				<cfif len(attributes.contract_head)>'#attributes.contract_head#'<cfelse>NULL</cfif>,
				<cfif len(attributes.company_id)>#attributes.company_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.authorized_id)>#attributes.authorized_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.support_position_id)>#attributes.support_position_id#<cfelse>NULL</cfif>,
				<cfif len(attributes.support_start_date)>#attributes.support_start_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.support_finish_date)>#attributes.support_finish_date#<cfelse>NULL</cfif>,
				<cfif len(attributes.rent_document)>'#file_name#'<cfelse>NULL</cfif>,
				<cfif len(attributes.rent_document)>#fusebox.server_machine#<cfelse>NULL</cfif>,
				<cfif len(attributes.detail)>'#attributes.detail#'<cfelse>NULL</cfif>,
				<cfif len(attributes.support_cat)>#attributes.support_cat#<cfelse>NULL</cfif>,
				<cfif len(attributes.rent_payment_period)>#attributes.rent_payment_period#<cfelse>NULL</cfif>,
				<cfif len(attributes.rent_amount)>#attributes.rent_amount#<cfelse>NULL</cfif>,
	 			<cfif len(attributes.rent_amount_currency)>'#attributes.rent_amount_currency#'<cfelse>NULL</cfif>,
				<cfif len(attributes.fuel_amount)>#attributes.fuel_amount#<cfelse>NULL</cfif>,
				<cfif len(attributes.fuel_amount_currency)>'#attributes.fuel_amount_currency#'<cfelse>NULL</cfif>,
				<cfif len(attributes.care_amount)>#attributes.care_amount#<cfelse>NULL</cfif>,
				<cfif len(attributes.care_amount_currency)>'#attributes.care_amount_currency#'<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_care_added")>#attributes.is_care_added#<cfelse>NULL</cfif>,
				<cfif isdefined("attributes.is_fuel_added")>#attributes.is_fuel_added#<cfelse>NULL</cfif>,
				1,
				<cfif isdefined("attributes.project_id") and len(attributes.project_id)>#attributes.project_id#<cfelse>NULL</cfif>,
				#now()#,
				#session.ep.userid#,
				'#cgi.remote_addr#'
			)
	</cfquery>
</cfif>

<script type="text/javascript">
	 window.location.href='<cfoutput>#request.self#?fuseaction=assetcare.list_vehicles&event=rent&assetp_id=#attributes.assetp_id#</cfoutput>';
</script>