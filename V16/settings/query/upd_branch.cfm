<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.branch_name=replacelist(attributes.branch_name,list,list2)>
<cfquery name="UPD_OUR_COMPANY" datasource="#DSN#">
	UPDATE 
	  	BRANCH 
	SET 
		IS_INTERNET = <cfif isdefined('attributes.is_internet')>1<cfelse>0</cfif>,
		IS_ORGANIZATION = <cfif isdefined('attributes.is_organization')>1<cfelse>0</cfif>,
		IS_PRODUCTION = <cfif isdefined('attributes.is_production')>1<cfelse>0</cfif>,
		ZONE_ID = <cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>#attributes.zone_id#<cfelse>NULL</cfif>, 
		ADMIN1_POSITION_CODE = <cfif isDefined('attributes.admin1_position_code') and len(attributes.admin1_position_code) and len(admin1_position)>#attributes.admin1_position_code#<cfelse>NULL</cfif>,
		ADMIN2_POSITION_CODE = <cfif isDefined('attributes.admin2_position_code') and len(attributes.admin2_position_code) and len(admin2_position)>#attributes.admin2_position_code#<cfelse>NULL</cfif>,
		BRANCH_STATUS = <cfif isdefined("attributes.branch_status")>1<cfelse>0</cfif>, 
		BRANCH_NAME = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_name#">, 
		BRANCH_FULLNAME = <cfif isdefined('attributes.branch_fullname') and len(attributes.branch_fullname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_fullname#"><cfelse>NULL</cfif>,
		BRANCH_EMAIL = <cfif isdefined('attributes.branch_email') and len(attributes.branch_email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_email#"><cfelse>NULL</cfif>,
		BRANCH_TELCODE = <cfif isdefined('attributes.branch_telcode') and len(attributes.branch_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_telcode#"><cfelse>NULL</cfif>, 
		BRANCH_TEL1 = <cfif isdefined('attributes.branch_tel1') and len(attributes.branch_tel1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_tel1#"><cfelse>NULL</cfif>,
		BRANCH_TEL2 = <cfif isdefined('attributes.branch_tel2') and len(attributes.branch_tel2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_tel2#"><cfelse>NULL</cfif>,
		BRANCH_TEL3 = <cfif isdefined('attributes.branch_tel3') and len(attributes.branch_tel3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_tel3#"><cfelse>NULL</cfif>,
		BRANCH_FAX = <cfif isdefined('attributes.branch_fax') and len(attributes.branch_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_fax#"><cfelse>NULL</cfif>,
		BRANCH_ADDRESS = <cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_address#">, 
		BRANCH_POSTCODE = <cfif isdefined('attributes.branch_postcode') and len(attributes.branch_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_postcode#"><cfelse>NULL</cfif>, 
		BRANCH_COUNTY = <cfif isdefined('attributes.branch_county') and len(attributes.branch_county)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_county#"><cfelse>NULL</cfif>, 
		BRANCH_CITY = <cfif isdefined('attributes.branch_city') and len(attributes.branch_city)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_city#"><cfelse>NULL</cfif>, 
		COORDINATE_1 = <cfif isdefined("attributes.coordinate_1") and len(attributes.coordinate_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coordinate_1#"><cfelse>NULL</cfif>,
		COORDINATE_2 = <cfif isdefined("attributes.coordinate_2") and len(attributes.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coordinate_2#"><cfelse>NULL</cfif>,
		BRANCH_COUNTRY = <cfif isdefined('attributes.branch_country') and len(attributes.branch_country)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_country#"><cfelse>NULL</cfif>,
		BRANCH_TAX_OFFICE = <cfif isdefined('tax_office') and len(tax_office)>'#tax_office#'<cfelse>NULL</cfif>,
		BRANCH_TAX_NO = <cfif isdefined('tax_no') and len(tax_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_no#"><cfelse>NULL</cfif>,
		COMPANY_ID = #attributes.company_id#,
		HIERARCHY = <cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy#"><cfelse>NULL</cfif>,
		HIERARCHY2 = <cfif isdefined("attributes.hierarchy2") and len(attributes.hierarchy2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.hierarchy2#"><cfelse>NULL</cfif>,
		RELATED_COMPANY = <cfif isdefined("attributes.related_company") and len(attributes.related_company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_company#"><cfelse>NULL</cfif>,
		RELATED_BRANCH_ID = <cfif isdefined("attributes.related_branch_id") and len(attributes.related_branch_id) and isdefined("attributes.related_branch_name") and len(attributes.related_branch_name)>#attributes.related_branch_id#<cfelse>NULL</cfif>,
		OZEL_KOD = <cfif isdefined("attributes.ozel_kod") and len(attributes.ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#"><cfelse>NULL</cfif>,
		BRANCH_CAT_ID = <cfif isdefined("attributes.branch_cat") and len(attributes.branch_cat)>#attributes.branch_cat#<cfelse>NULL</cfif>,
		UPDATE_EMP = #session.ep.userid#,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#		
	WHERE 
	   BRANCH_ID = #attributes.branch_id#
</cfquery>
<!--- History icin --->
<cfquery name="ADD_BRANCH_HISTORY" datasource="#DSN#">
	INSERT INTO
		BRANCH_HISTORY 
		(
			BRANCH_STATUS,ZONE_ID,COMPANY_ID,BRANCH_ID,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,BRANCH_NAME,BRANCH_FULLNAME,BRANCH_EMAIL,BRANCH_TELCODE,BRANCH_TEL1,BRANCH_TEL2,BRANCH_TEL3,BRANCH_FAX,BRANCH_ADDRESS,BRANCH_POSTCODE,BRANCH_COUNTY,BRANCH_CITY,BRANCH_COUNTRY,BRANCH_WORK,SSK_OFFICE,SSK_NO,SSK_M,SSK_JOB,SSK_BRANCH,SSK_BRANCH_OLD,SSK_CITY,SSK_COUNTRY,
			SSK_CD,SSK_AGENT,WORK_ZONE_M,WORK_ZONE_JOB,WORK_ZONE_FILE,WORK_ZONE_CITY,DANGER_DEGREE,DANGER_DEGREE_NO,FOUNDATION_DATE,ISKUR_BRANCH_NAME,ISKUR_BRANCH_NO,CAL_BOL_MUD_NAME,REAL_WORK,CAL_BOL_MUD_NO,IS_INTERNET,HIERARCHY,HIERARCHY2,KANUN_5084_ORAN,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_SAKAT_KONTROL,RELATED_COMPANY,OZEL_KOD,IS_ORGANIZATION,
			OPEN_DATE,TCKIMLIK_NO,USER_NAME,SYSTEM_PASSWORD,COMPANY_PASSWORD,SSK_EMPLOYEE_ID,SSK_POSITION_CODE,BRANCH_CAT_ID,IS_PRODUCTION
		) 
	SELECT BRANCH_STATUS,ZONE_ID,COMPANY_ID,BRANCH_ID,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,BRANCH_NAME,BRANCH_FULLNAME,BRANCH_EMAIL,BRANCH_TELCODE,BRANCH_TEL1,BRANCH_TEL2,BRANCH_TEL3,BRANCH_FAX,BRANCH_ADDRESS,BRANCH_POSTCODE,BRANCH_COUNTY,BRANCH_CITY,BRANCH_COUNTRY,BRANCH_WORK,SSK_OFFICE,SSK_NO,SSK_M,SSK_JOB,SSK_BRANCH,SSK_BRANCH_OLD,SSK_CITY,SSK_COUNTRY,SSK_CD,SSK_AGENT,WORK_ZONE_M,WORK_ZONE_JOB,WORK_ZONE_FILE,WORK_ZONE_CITY,DANGER_DEGREE,
	DANGER_DEGREE_NO,FOUNDATION_DATE,ISKUR_BRANCH_NAME,ISKUR_BRANCH_NO,CAL_BOL_MUD_NAME,REAL_WORK,CAL_BOL_MUD_NO,IS_INTERNET,HIERARCHY,HIERARCHY2,KANUN_5084_ORAN,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_SAKAT_KONTROL,RELATED_COMPANY,OZEL_KOD,IS_ORGANIZATION,OPEN_DATE,TCKIMLIK_NO,USER_NAME,SYSTEM_PASSWORD,COMPANY_PASSWORD,SSK_EMPLOYEE_ID,SSK_POSITION_CODE,BRANCH_CAT_ID,IS_PRODUCTION FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
</cfquery>
<cfquery name="GET_ASSETS" datasource="#DSN#">
	SELECT ASSET_FILE_NAME1,ASSET_FILE_NAME2,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2_SERVER_ID FROM BRANCH WHERE BRANCH_ID = #attributes.branch_id#
</cfquery>
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cfif isDefined("attributes.del_asset1") or (isdefined('attributes.asset1') and len(attributes.asset1))>
	<cfquery name="UPD_ASSET" datasource="#DSN#">
		UPDATE  
			BRANCH
		SET 
			ASSET_FILE_NAME1 = NULL,
			ASSET_FILE_NAME1_SERVER_ID = NULL
		WHERE 
			BRANCH_ID = #attributes.branch_id#
	</cfquery>
	<cf_del_server_file output_file="settings/#get_assets.asset_file_name1#" output_server="#get_assets.asset_file_name1_server_id#">  
</cfif>
<!--- DOSYA 2 SİLİNİYOR --->
<cfif isDefined("attributes.del_asset2") OR (isdefined('attributes.asset1') and LEN(attributes.asset2))>
	<cfquery name="DEL_OFFER_ASSET2" datasource="#DSN#">
		UPDATE  
			BRANCH
		SET 
			ASSET_FILE_NAME2 = NULL,
			ASSET_FILE_NAME2_SERVER_ID = NULL
		WHERE 
			 BRANCH_ID = #attributes.branch_id#
	</cfquery>
	<cf_del_server_file output_file="settings/#get_assets.asset_file_name2#" output_server="#get_assets.asset_file_name2_server_id#">
</cfif>
<!--- 1.asset bas--->
<cfif isdefined("attributes.asset1") and isdefined('attributes.asset1') and LEN(attributes.asset1)>
  	<cftry>
		<cffile action = "upload" 
			  filefield = "asset1" 
			  destination = "#upload_folder#" 
			  nameconflict = "MakeUnique" 
			  mode="777">
		<cfset file_name1 = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name1#.#cffile.serverfileext#">
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			UPDATE  
				BRANCH 
			SET 
				ASSET_FILE_NAME1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name1#.#cffile.serverfileext#">,
				ASSET_FILE_NAME1_SERVER_ID = #fusebox.server_machine# 
			WHERE 
				BRANCH_ID = #attributes.branch_id#
		</cfquery>
		<cfcatch type="Any">      
			<script type="text/javascript">
				alert("1.<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
    	</cfcatch>
  	</cftry>
</cfif>
<!--- 2.asset bas--->
<cfif isdefined("attributes.asset2") and isdefined('attributes.asset2') and LEN(attributes.asset2)>
  	<cftry>
		<cffile action = "upload" 
			filefield = "asset2" 
			destination = "#upload_folder#" 
			nameconflict = "MakeUnique" 
			mode="777">
		<cfset file_name2 = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name2#.#cffile.serverfileext#">
		<cfquery name="ADD_ASSET" datasource="#DSN#">
			UPDATE  
				BRANCH
			SET 
				ASSET_FILE_NAME2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name2#.#cffile.serverfileext#">,
				ASSET_FILE_NAME2_SERVER_ID = #fusebox.server_machine# 
			WHERE 
				BRANCH_ID = #attributes.branch_id#
		</cfquery>
		<cfcatch type="Any">      
      		<script type="text/javascript">
				alert("2.<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>
	</cftry>
</cfif>
<cfif not isdefined('attributes.fuseact')>
	<cf_add_log log_type="0" action_id="#attributes.branch_id#" action_name="#attributes.head#">
</cfif>
<script type="text/javascript">
	<cfif isdefined("attributes.callAjaxBranch") and attributes.callAjaxBranch eq 1><!--- Organizasyon Yönetimi sayfasıdan ajax ile çağırıldıysa 20190912ERU --->
        AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.list_branches&event=upd&type=3&id=#attributes.branch_id#&branch_id=#attributes.branch_id#&comp_id=#attributes.comp_id#</cfoutput>','ajax_right');
    <cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#</cfoutput>.list_branches&event=upd&id=<cfoutput>#attributes.branch_id#</cfoutput>';
	</cfif>
</script>