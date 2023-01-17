<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfif not DirectoryExists("#upload_folder#settings")>
	<cfdirectory action="create" directory="#upload_folder#settings">
</cfif>
<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cfif len(FORM.CONTENTCAT_IMAGE1)>
	<cftry>
		<cffile 
			action="UPLOAD" 
			filefield="CONTENTCAT_IMAGE1" 
			destination="#upload_folder#" 
			mode="777" 
			nameconflict="MAKEUNIQUE" accept="image/jpeg, image/png, image/bmp, image/gif, image/pjpeg, image/x-png,image/jpg">
		<cfcatch type="any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
		</cfcatch>  
	</cftry>
	<cfset file_name = createUUID()>
	<cffile action='rename' source='#upload_folder##cffile.serverfile#' destination='#upload_folder##file_name#.#cffile.serverfileext#'>
	<cfset uploaded1 = '#file_name#.#cffile.serverfileext#'>
<cfelse>
	<cfset uploaded1 = "">
</cfif>

<cfif len(FORM.CONTENTCAT_IMAGE2)>
	<cftry>
		<CFFILE 
			ACTION="UPLOAD" 
			FILEFIELD="CONTENTCAT_IMAGE2"  
			DESTINATION="#upload_folder#" 
			MODE="777" 
			NAMECONFLICT="MAKEUNIQUE" accept="image/jpeg, image/png, image/bmp, image/gif, image/pjpeg, image/x-png">
		<CFCATCH TYPE="ANY">
			<script type="text/javascript">
				alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
				history.back();
			</script>
		</CFCATCH>  
	</CFTRY>
	<cfset file_name = createUUID()>
	<cffile action='rename' source='#upload_folder##cffile.serverfile#' destination='#upload_folder##file_name#.#cffile.serverfileext#'>
	<cfset uploaded2 = '#file_name#.#cffile.serverfileext#'>
<cfelse>
	<cfset uploaded2 = "">
</cfif>
<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="INSCONTENTCAT" datasource="#dsn#" result="MAX_ID">
            INSERT INTO 
                CONTENT_CAT
            (
                IS_HOMEPAGE,
                IS_RULE,
				IS_TRAINING,
                CONTENTCAT,
				CONTENTCAT_DICTIONARY_ID,
                CONTENTCAT_IMAGE1,
                CONTENTCAT_IMAGE_SERVER_ID1,
                FILE_TYPE1,
                FILE_TYPE2,
                CONTENTCAT_LINK1,
                CONTENTCAT_ALT1,
                CONTENTCAT_IMAGE2,
                CONTENTCAT_IMAGE_SERVER_ID2,
                CONTENTCAT_LINK2,
                CONTENTCAT_ALT2,
                LANGUAGE_ID,
                RECORD_IP,
                RECORD_DATE,
                RECORD_EMP
           ) 
            VALUES 
            (
                <cfif isDefined("attributes.IS_HOMEPAGE")>1,<cfelse>0,</cfif>
                <cfif isDefined("attributes.IS_RULE")>1,<cfelse>0,</cfif>
				<cfif isDefined("attributes.IS_TRAINING")>1,<cfelse>0,</cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT#">,
				<cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_DICTIONARY_ID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#UPLOADED1#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#fusebox.server_machine#">,
                <cfif isDefined("attributes.FILE_TYPE1")>1,<cfelse>0,</cfif>
                <cfif isDefined("attributes.FILE_TYPE2")>1,<cfelse>0,</cfif>
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_LINK1#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_ALT1#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#UPLOADED2#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#fusebox.server_machine#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_LINK2#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_ALT2#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#LANGUAGE_ID#">,
                <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
                #now()#,
                #session.ep.userid#
            )
           
		</cfquery>
        <cfquery name="add_company_content_cat" datasource="#dsn#">
        	<cfloop list="#attributes.company_id#" index="cc">
                INSERT INTO 
                    CONTENT_CAT_COMPANY
				(
					CONTENTCAT_ID,
					COMPANY_ID
				)
			   VALUES
				(
					#max_id.identitycol#,
					#cc#
				) 
             </cfloop>
        </cfquery>
	</CFTRANSACTION>
</CFLOCK>
<cfif isDefined("attributes.IS_HOMEPAGE") AND attributes.IS_HOMEPAGE>
	<cfquery name="CHANGE" datasource="#DSN#">
		UPDATE
			CONTENT_CAT 
		SET 
			IS_HOMEPAGE = 0 
		WHERE 
			CONTENTCAT_ID <> #max_id.identitycol# AND
			LANGUAGE_ID = '#attributes.LANGUAGE_ID#'
	</cfquery>
</cfif>
<script>
	location.href = document.referrer;
</script>
