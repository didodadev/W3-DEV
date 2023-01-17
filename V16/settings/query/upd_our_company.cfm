<cf_xml_page_edit fuseact="settings.form_upd_our_company" is_multi_page="1">
	<cf_date tarih="attributes.CONTRACT_DATE">
	<cf_date tarih="attributes.AUTHORITY_DOC_START">
	<cf_date tarih="attributes.AUTHORITY_DOC_FINISH">
	<cfquery name="UPD" datasource="#DSN#">
		UPDATE
			OUR_COMPANY
		SET
			IS_ORGANIZATION = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.IS_ORGANIZATION#">,
			COMPANY_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COMPANY_NAME#">,
			NICK_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.NICK_NAME#">,
			MANAGER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.MANAGER#">,
			MANAGER_POSITION_CODE = <cfif len(attributes.manager_pos_code) and len(attributes.manager_name)>#attributes.manager_pos_code#<cfelse>NULL</cfif>,
			MANAGER_POSITION_CODE2 = <cfif len(attributes.manager_pos_code2) and len(attributes.manager_name2)>#attributes.manager_pos_code2#<cfelse>NULL</cfif>,
			TAX_OFFICE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TAX_OFFICE#">,
			TAX_NO = <cfif isdefined("attributes.TAX_NO") and len(attributes.TAX_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TAX_NO#"><cfelse>NULL</cfif>,
			TEL_CODE = <cfif isdefined("attributes.TEL_CODE") and len(attributes.TEL_CODE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TEL_CODE#"><cfelse>NULL</cfif>,
			TEL = <cfif isdefined("attributes.TEL") and len(attributes.TEL)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TEL#"><cfelse>NULL</cfif>,
			TEL2 = <cfif isdefined("attributes.TEL2") and len(attributes.TEL2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TEL2#"><cfelse>NULL</cfif>,
			TEL3 = <cfif isdefined("attributes.TEL3") and len(attributes.TEL3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TEL3#"><cfelse>NULL</cfif>,
			TEL4 = <cfif isdefined("attributes.TEL4") and len(attributes.TEL4)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.TEL4#"><cfelse>NULL</cfif>,
			FAX = <cfif isdefined("attributes.FAX") and len(attributes.FAX)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FAX#"><cfelse>NULL</cfif>,
			FAX2 = <cfif isdefined("attributes.FAX2") and len(attributes.FAX2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.FAX2#"><cfelse>NULL</cfif>,
			COORDINATE_1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COORDINATE_1#">,
			COORDINATE_2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.COORDINATE_2#">,
			WEB = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.WEB#">,
			EMAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.EMAIL#">,
			ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ADDRESS#">,
			ADMIN_MAIL = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ADMIN_MAIL#">,
			T_NO = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.t_no#" null="#not len(attributes.t_no)#">,
			HIERARCHY = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HIERARCHY#">,
			HIERARCHY2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.HIERARCHY2#">,
			SERMAYE = <cfif isdefined("SERMAYE") and len(SERMAYE)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.SERMAYE#"><cfelse>NULL</cfif>,
			CHAMBER = <cfif LEN(attributes.CHAMBER)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CHAMBER#">,<cfelse>NULL,</cfif>
			CHAMBER_NO = <cfif LEN(attributes.CHAMBER_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CHAMBER_NO#"><cfelse>NULL</cfif>,
			CHAMBER2 = <cfif LEN(attributes.CHAMBER2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CHAMBER2#"><cfelse>NULL</cfif>,
			CHAMBER2_NO = <cfif LEN(attributes.CHAMBER2_NO)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CHAMBER2_NO#"><cfelse>NULL</cfif>,
			HEADQUARTERS_ID = <cfif LEN(attributes.HEAD_ID)>#attributes.HEAD_ID#<cfelse>NULL</cfif>,
			COMP_STATUS=<cfif isdefined('attributes.comp_status')>1<cfelse>0</cfif>,
			<cfif is_letter_authority eq 1>
				AUTHORITY_DOC_TYPE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AUTHORITY_DOC_TYPE#">,
				AUTHORITY_DOC_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.AUTHORITY_DOC_NUMBER#">,
				AUTHORITY_DOC_START = <cfif len(attributes.AUTHORITY_DOC_START)>#attributes.AUTHORITY_DOC_START#<cfelse>NULL</cfif>,
				AUTHORITY_DOC_FINISH = <cfif len(attributes.AUTHORITY_DOC_FINISH)>#attributes.AUTHORITY_DOC_FINISH#<cfelse>NULL</cfif>,
				AUTHORITY_DOC_WARNING = <cfif len(attributes.AUTHORITY_DOC_WARNING)>#attributes.AUTHORITY_DOC_WARNING#<cfelse>NULL</cfif>,
			</cfif>
			UPDATE_EMP = #session.ep.userid#,
			UPDATE_DATE = #now()#,
			UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
			COUNTRY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.country_id#" null="#not len(attributes.country_id)#">,
			POSTAL_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.postal_code#" null="#not len(attributes.postal_code)#">,
			CITY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.city_id#" null="#not len(attributes.city_id)#">,
			COUNTY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.county_id#" null="#not len(attributes.county_id)#">,
			CITY_SUBDIVISION_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.CITY_SUBDIVISION_NAME#" null="#not len(attributes.CITY_SUBDIVISION_NAME)#">,
			BUILDING_NUMBER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.BUILDING_NUMBER#" null="#not len(attributes.BUILDING_NUMBER)#">,
			STREET_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.STREET_NAME#" null="#not len(attributes.STREET_NAME)#">,
			DISTRICT_NAME  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.DISTRICT_NAME#" null="#not len(attributes.DISTRICT_NAME)#">,
			MERSIS_NO  = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.mersis_no#" null="#not len(attributes.mersis_no)#">,
			<!---Nace kodu Alanı için ekleme --->
			NACE_CODE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.NACE_CODE#" null="#not len(attributes.NACE_CODE)#">,
			KEP_ADRESS = <cfif len(attributes.KEP_ADRESS)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.KEP_ADRESS#"><cfelse>NULL</cfif>,
			ACCOUNTER_KEY = <cfif len(attributes.ACCOUNTER_KEY)><cfqueryparam cfsqltype="cf_sql_nvarchar" value="#attributes.ACCOUNTER_KEY#"><cfelse>NULL</cfif>
		 WHERE
			COMP_ID = #attributes.COMP_ID#
	</cfquery>
	
	<!--- 1.asset baş--->
	<cfquery name="GET_ASSET" datasource="#DSN#">
		SELECT 
			ASSET_FILE_NAME1,
			ASSET_FILE_NAME1_SERVER_ID
		FROM 
			OUR_COMPANY
		WHERE
			COMP_ID = #attributes.COMP_ID#
	</cfquery>
	<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
	<cfif isdefined("attributes.asset1") and len(attributes.asset1)>
		<cftry>
			<cffile action = "upload" 
					filefield = "asset1" 
					destination = "#upload_folder#" 
					nameconflict = "MakeUnique"
					mode="777">
			<cfcatch type="Any">
			<cfset error=1>
				<script type="text/javascript">
					alert("1.<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>
		<cfset file_name = createUUID()>
		<cffile action="rename" 
				source="#upload_folder##cffile.serverfile#" 
				destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
			<cfquery name="ADD_ASSET" datasource="#DSN#">
				UPDATE 
					OUR_COMPANY
				SET
					ASSET_FILE_NAME1=<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
					ASSET_FILE_NAME1_SERVER_ID=#fusebox.server_machine# 
			   WHERE
					COMP_ID = #attributes.COMP_ID#
			</cfquery>
		</cfif>
		<cfif len(get_asset.ASSET_FILE_NAME1)>
			<cf_del_server_file output_file="settings/#get_asset.asset_file_name1#" output_server="#get_asset.asset_file_name1_server_id#">
		</cfif>
	<cfelse>
		<!--- Logo sil checbox u seciliyse --->
		<cfif isdefined("attributes.del_logo1")>
			<cf_del_server_file output_file="settings/#get_asset.asset_file_name1#" output_server="#get_asset.asset_file_name1_server_id#">
			<cfquery name="DEL_ASSET" datasource="#DSN#">
				UPDATE 
					OUR_COMPANY
				SET
					ASSET_FILE_NAME1=NULL,
					ASSET_FILE_NAME1_SERVER_ID=NULL
			   WHERE
					COMP_ID = #attributes.COMP_ID#
			</cfquery>
		</cfif>
	</cfif>
	<!--- 1.asset son --->
	<!--- 2.asset --->
	<cfquery name="GET_ASSET" datasource="#DSN#">
		SELECT 
			ASSET_FILE_NAME2,
			ASSET_FILE_NAME2_SERVER_ID
		FROM 
			OUR_COMPANY 
		WHERE
			COMP_ID = #attributes.COMP_ID#
	</cfquery>
	<cfif isdefined("attributes.asset2") and len(attributes.asset2)>
		<cftry>
			<cffile action = "upload" 
					filefield = "asset2" 
					destination = "#upload_folder#" 
					nameconflict = "MakeUnique" 
					mode="777">
			<cfcatch type="Any">
				<cfset error=2>
				<script type="text/javascript">
					alert("2.<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>
		<cfset file_name = createUUID()>
		<cffile action="rename" 
				source="#upload_folder##cffile.serverfile#" 
				destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
			<cfquery name="ADD_ASSET" datasource="#DSN#">
				UPDATE 
					OUR_COMPANY
				SET
					ASSET_FILE_NAME2=<cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
					ASSET_FILE_NAME2_SERVER_ID=#fusebox.server_machine# 
				WHERE
					COMP_ID = #attributes.COMP_ID#
			</cfquery>
		</cfif>
		<cfif len(get_asset.ASSET_FILE_NAME2)>
			<cf_del_server_file output_file="settings/#get_asset.asset_file_name2#" output_server="#get_asset.asset_file_name2_server_id#">
		</cfif>
	<cfelse>
		<!--- Logo sil checbox u seciliyse --->
		<cfif isdefined("attributes.del_logo2")>
			<cf_del_server_file output_file="settings/#get_asset.asset_file_name2#" output_server="#get_asset.asset_file_name2_server_id#">
			<cfquery name="DEL_ASSET" datasource="#DSN#">
				UPDATE 
					OUR_COMPANY
				SET
					ASSET_FILE_NAME2=NULL,
					ASSET_FILE_NAME2_SERVER_ID=NULL
			   WHERE
					COMP_ID = #attributes.COMP_ID#
			</cfquery>
		</cfif>
	</cfif>
	<!--- 2.asset son --->
	<!--- 3.asset --->
	<cfquery name="GET_ASSET" datasource="#DSN#">
		SELECT 
			ASSET_FILE_NAME3 ,
			ASSET_FILE_NAME3_SERVER_ID
		FROM 
			OUR_COMPANY 
		WHERE
			COMP_ID = #attributes.COMP_ID#
	</cfquery>
	<cfif isdefined("attributes.asset3") and len(attributes.asset3)>
		<cftry>
			<cffile action = "upload" 
					filefield = "asset3" 
					destination = "#upload_folder#" 
					nameconflict = "MakeUnique" 
					mode="777">
			<cfcatch type="Any">
				<cfset error=3>
				<script type="text/javascript">
					alert("3. <cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</cfcatch>  
		</cftry>
		<cfset file_name = createUUID()>
		<cffile action="rename" 
				source="#upload_folder##cffile.serverfile#" 
				destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfif not isdefined("error")>
			<cfquery name="ADD_ASSET" datasource="#DSN#">
				UPDATE OUR_COMPANY
					SET
						ASSET_FILE_NAME3 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
						ASSET_FILE_NAME3_SERVER_ID=#fusebox.server_machine#
					WHERE
						COMP_ID = #attributes.COMP_ID#
			</cfquery>
			</cfif>
			<cfif len(get_asset.ASSET_FILE_NAME3)>
				<cf_del_server_file output_file="settings/#get_asset.asset_file_name3#" output_server="#get_asset.asset_file_name3_server_id#">
			</cfif>
	<cfelse>
		<!--- Logo sil checbox u seciliyse --->
		<cfif isdefined("attributes.del_logo3")>
			<cf_del_server_file output_file="settings/#get_asset.asset_file_name3#" output_server="#get_asset.asset_file_name3_server_id#">
			<cfquery name="DEL_ASSET" datasource="#DSN#">
				UPDATE 
					OUR_COMPANY
				SET
					ASSET_FILE_NAME3=NULL,
					ASSET_FILE_NAME3_SERVER_ID=NULL
			   WHERE
					COMP_ID = #attributes.COMP_ID#
			</cfquery>
		</cfif>
	</cfif>
	<cf_add_log  log_type="0" action_id="#attributes.COMP_ID#" action_name="#attributes.company_name# ">
	<cf_wrk_get_history  datasource='#DSN#' source_table= 'OUR_COMPANY' target_table= 'OUR_COMPANY_HISTORY' record_id= '#attributes.COMP_ID#' record_name='COMP_ID'>
	<!--- 3.asset son --->
	
	<script type="text/javascript">
		<cfif isdefined("attributes.callAjaxComp") and attributes.callAjaxComp eq 1><!--- Organizasyon Yönetimi sayfasından geldiyse 20190912ERU --->
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=settings.form_upd_our_company&type=1&ourcompany_id=#attributes.comp_id#</cfoutput>','ajax_right');
		   // $('#headQuarters_Comp_Branch<cfoutput>#attributes.COMP_ID#</cfoutput>').show();
			//return false;
		<cfelse>
	
			<cfoutput>
				window.location = "<cfoutput>#http_referer#</cfoutput>";
			</cfoutput>
	
		</cfif>
	</script>
		
	
	
	
	