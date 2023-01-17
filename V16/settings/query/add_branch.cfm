<cfset list="',""">
<cfset list2=" , ">
<cfset attributes.branch_name=replacelist(attributes.branch_name,list,list2)>
<cfif isdefined("FOUNDATION_DATE")><cf_date tarih = "FOUNDATION_DATE"></cfif>
<cfif isDefined("FORM.BRANCH_STATUS")><cfset FORM.BRANCH_STATUS = 0></cfif>

<cflock name="CreateUUID()" timeout="20">
	<cftransaction>
		<cfquery name="ADD_OUR_COMPANY" datasource="#DSN#" result="MAX_ID">
			INSERT INTO
				BRANCH 
			( 
				IS_ORGANIZATION,
				IS_INTERNET,
				IS_PRODUCTION,
				ZONE_ID, 
				ADMIN1_POSITION_CODE,
				ADMIN2_POSITION_CODE,
				BRANCH_STATUS, 
				BRANCH_FULLNAME,
				BRANCH_NAME, 
				BRANCH_EMAIL,
				BRANCH_TELCODE, 
				BRANCH_TEL1,
				BRANCH_TEL2, 
				BRANCH_TEL3,
				BRANCH_FAX, 
				BRANCH_ADDRESS, 
				BRANCH_POSTCODE, 
				BRANCH_COUNTY, 
				BRANCH_CITY,
				COORDINATE_1,
				COORDINATE_2,
				BRANCH_COUNTRY,
				BRANCH_TAX_OFFICE,
				BRANCH_TAX_NO,
				HIERARCHY,
				HIERARCHY2,
				COMPANY_ID,
				RELATED_COMPANY,
				RELATED_BRANCH_ID,
				BRANCH_CAT_ID,
				OZEL_KOD,				
				RECORD_EMP,
				RECORD_DATE,
				RECORD_IP
			) 
			VALUES
			( 
				<cfif isdefined('attributes.is_organization')>1<cfelse>0</cfif>, 
				<cfif isdefined('attributes.is_internet')>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.is_production')>1<cfelse>0</cfif>,
				<cfif isdefined('attributes.zone_id') and len(attributes.zone_id)>#attributes.zone_id#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.admin1_position_code') and len(attributes.admin1_position_code)>#attributes.admin1_position_code#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.admin2_position_code') and len(attributes.admin2_position_code)>#attributes.admin2_position_code#<cfelse>NULL</cfif>,
				<cfif isDefined('attributes.branch_status')>1<cfelse>0</cfif>, 
				<cfif isDefined('attributes.branch_fullname') and len(attributes.branch_fullname)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_fullname#"><cfelse>NULL</cfif>,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_name#">, 
				<cfif isDefined('attributes.branch_email') and len(attributes.branch_email)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_email#"><cfelse>NULL</cfif>, 
				<cfif isDefined('attributes.branch_telcode') and len(attributes.branch_telcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_telcode#"><cfelse>NULL</cfif>,
				<cfif isDefined('attributes.branch_tel1') and len(attributes.branch_tel1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_tel1#"><cfelse>NULL</cfif>,
				<cfif isDefined('attributes.branch_tel2') and len(attributes.branch_tel2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_tel2#"><cfelse>NULL</cfif>,
				<cfif isDefined('attributes.branch_tel3') and len(attributes.branch_tel3)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_tel3#"><cfelse>NULL</cfif>,  
				<cfif isDefined('attributes.branch_fax') and len(attributes.branch_fax)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_fax#"><cfelse>NULL</cfif>,
				<cfif isDefined('attributes.branch_address') and len(attributes.branch_address)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_address#"><cfelse>NULL</cfif>, 
				<cfif isDefined('attributes.branch_postcode') and len(attributes.branch_postcode)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_postcode#"><cfelse>NULL</cfif>, 
				<cfif isDefined('attributes.branch_county') and len(attributes.branch_county)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_county#"><cfelse>NULL</cfif>, 
				<cfif isDefined('attributes.branch_city') and len(attributes.branch_city)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_city#"><cfelse>NULL</cfif>, 
				<cfif isdefined("attributes.coordinate_1") and len(attributes.coordinate_1)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coordinate_1#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.coordinate_2") and len(attributes.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.coordinate_2#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.coordinate_2") and len(attributes.coordinate_2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.branch_country#"><cfelse>NULL</cfif>, 
				<cfif isdefined("tax_office") and len(tax_office)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_office#"><cfelse>NULL</cfif>,
				<cfif isdefined("tax_no") and len(tax_no)><cfqueryparam cfsqltype="cf_sql_varchar" value="#tax_no#"><cfelse>NULL</cfif>,
				<cfif isdefined("form.hierarch") and len(form.hierarchy)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hierarchy#"><cfelse>NULL</cfif>,
				<cfif isdefined("form.hierarchy2") and len(form.hierarchy2)><cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hierarchy2#"><cfelse>NULL</cfif>,
				#attributes.company_id#,
				<cfif isdefined("attributes.related_company") and len(attributes.related_company)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.related_company#"><cfelse>NULL</cfif>,
				<cfif isdefined("attributes.related_branch_id") and len(attributes.related_branch_id) and isdefined("attributes.related_branch_name") and len(attributes.related_branch_name)>#attributes.related_branch_id#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.branch_cat') and len(attributes.branch_cat)>#attributes.branch_cat#<cfelse>NULL</cfif>,
				<cfif isdefined('attributes.ozel_kod') and len(attributes.ozel_kod)><cfqueryparam cfsqltype="cf_sql_varchar" value="#attributes.ozel_kod#"><cfelse>NULL</cfif>,
				#session.ep.userid#,
				#now()#,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">					
			)
		</cfquery>
	</cftransaction>
</cflock>

<!--- genius için erk 20040427 --->
<cfquery name="ADD_LAST_NUMBER" datasource="#DSN#">
	INSERT INTO 
		SETUP_BRANCH_PRICE_CHANGE_NO
	(
		BRANCH_ID,
		SON_BELGE_NO
	)
	VALUES
	(
		#MAX_ID.IDENTITYCOL#, 
		'1'
	)
</cfquery>

<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cfif isdefined("attributes.asset1") and len(attributes.asset1)>
	<cftry>
		<cffile 
			action = "upload" 
			filefield = "asset1" 
			destination = "#upload_folder#" 
			nameconflict = "MakeUnique" 
			mode="777">
		<cfset file_name = createUUID()>
		<cffile 
			action="rename" 
			source="#upload_folder##cffile.serverfile#" 
			destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfquery name="UPD_ASSET" datasource="#DSN#">
			UPDATE  
				BRANCH 
			SET 
				ASSET_FILE_NAME1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
				ASSET_FILE_NAME1_SERVER_ID = #fusebox.server_machine#
			WHERE 
				BRANCH_ID = #MAX_ID.IDENTITYCOL#
		</cfquery>
		<cfcatch type="Any">      
	  		<cfset error=1>
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
    	</cfcatch>
  	</cftry>
</cfif>
<cfif isdefined("attributes.asset2") and len(attributes.asset2)>
  	<cftry>
		<cffile 
			action = "upload" 
			filefield = "asset2" 
			destination = "#upload_folder#" 
			nameconflict = "MakeUnique" 
			mode="777">
	    <cfset file_name = createUUID()>
    	<cffile 
			action="rename" 
			source="#upload_folder##cffile.serverfile#" 
			destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfquery name="UPD_ASSET" datasource="#DSN#">
			UPDATE  
				BRANCH 
			SET 
				ASSET_FILE_NAME2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#file_name#.#cffile.serverfileext#">,
				ASSET_FILE_NAME2_SERVER_ID = #fusebox.server_machine#
			WHERE 
				BRANCH_ID = #MAX_ID.IDENTITYCOL#
		</cfquery>
    	<cfcatch type="Any">
	    	<cfset error=1>
	     	<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
			<cfabort>
	    </cfcatch>
  	</cftry>
</cfif>

<!--- history icin --->
<cfquery name="ADD_BRANCH_HISTORY" datasource="#DSN#">
	INSERT INTO
		BRANCH_HISTORY 
	(
		BRANCH_STATUS,ZONE_ID,COMPANY_ID,BRANCH_ID,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,BRANCH_NAME,BRANCH_FULLNAME,BRANCH_EMAIL,BRANCH_TELCODE,BRANCH_TEL1,BRANCH_TEL2,BRANCH_TEL3,BRANCH_FAX,BRANCH_ADDRESS,BRANCH_POSTCODE,BRANCH_COUNTY,BRANCH_CITY,BRANCH_COUNTRY,BRANCH_WORK,SSK_OFFICE,SSK_NO,SSK_M,SSK_JOB,SSK_BRANCH,SSK_BRANCH_OLD,SSK_CITY,SSK_COUNTRY,
		SSK_CD,SSK_AGENT,WORK_ZONE_M,WORK_ZONE_JOB,WORK_ZONE_FILE,WORK_ZONE_CITY,DANGER_DEGREE,DANGER_DEGREE_NO,ASSET_FILE_NAME1,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2,ASSET_FILE_NAME2_SERVER_ID,FOUNDATION_DATE,ISKUR_BRANCH_NAME,ISKUR_BRANCH_NO,CAL_BOL_MUD_NAME,REAL_WORK,CAL_BOL_MUD_NO,IS_INTERNET,HIERARCHY,HIERARCHY2,KANUN_5084_ORAN,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_SAKAT_KONTROL,RELATED_COMPANY,OZEL_KOD,IS_ORGANIZATION,RELATED_BRANCH_ID,BRANCH_CAT_ID,IS_PRODUCTION
	) 
		SELECT BRANCH_STATUS,ZONE_ID,COMPANY_ID,BRANCH_ID,ADMIN1_POSITION_CODE,ADMIN2_POSITION_CODE,BRANCH_NAME,BRANCH_FULLNAME,BRANCH_EMAIL,BRANCH_TELCODE,BRANCH_TEL1,BRANCH_TEL2,BRANCH_TEL3,BRANCH_FAX,BRANCH_ADDRESS,BRANCH_POSTCODE,BRANCH_COUNTY,BRANCH_CITY,BRANCH_COUNTRY,BRANCH_WORK,SSK_OFFICE,SSK_NO,SSK_M,SSK_JOB,SSK_BRANCH,SSK_BRANCH_OLD,SSK_CITY,SSK_COUNTRY,SSK_CD,SSK_AGENT,WORK_ZONE_M,WORK_ZONE_JOB,WORK_ZONE_FILE,WORK_ZONE_CITY,DANGER_DEGREE,DANGER_DEGREE_NO,ASSET_FILE_NAME1,ASSET_FILE_NAME1_SERVER_ID,ASSET_FILE_NAME2,ASSET_FILE_NAME2_SERVER_ID,FOUNDATION_DATE,ISKUR_BRANCH_NAME,ISKUR_BRANCH_NO,CAL_BOL_MUD_NAME,REAL_WORK,CAL_BOL_MUD_NO,IS_INTERNET,HIERARCHY,HIERARCHY2,KANUN_5084_ORAN,RECORD_DATE,RECORD_EMP,RECORD_IP,UPDATE_DATE,UPDATE_EMP,UPDATE_IP,IS_SAKAT_KONTROL,RELATED_COMPANY,OZEL_KOD,IS_ORGANIZATION,RELATED_BRANCH_ID,BRANCH_CAT_ID,IS_PRODUCTION FROM BRANCH WHERE BRANCH_ID = #MAX_ID.IDENTITYCOL#
</cfquery>
<script type="text/javascript">
	<cfif isdefined("attributes.callAjaxBranch") and attributes.callAjaxBranch eq 1><!--- Organizasyon Planlama sayfasından ajax ile çağırıldıysa 20190912ERU --->
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.list_branches&event=upd&id=#MAX_ID.IDENTITYCOL#&type=2&comp_id=#attributes.company_id#</cfoutput>','ajax_right');
		AjaxPageLoad('<cfoutput>#request.self#?fuseaction=hr.organization_management&event=ajaxSub&type=2&comp_id=#attributes.company_id#</cfoutput>','getCompanyBranches<cfoutput>#attributes.company_id#</cfoutput>');
        $('#headQuarters_Comp_Branch<cfoutput>#attributes.company_id#</cfoutput>').show();
	<cfelse>
		window.location.href = '<cfoutput>#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_branches&event=upd&id=#MAX_ID.IDENTITYCOL#</cfoutput>';
	</cfif>
</script>