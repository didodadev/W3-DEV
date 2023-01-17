<cfset upload_folder = "#upload_folder#settings#dir_seperator#">
<cfquery name="DOSYALAR" datasource="#DSN#">
	SELECT 
		CONTENTCAT_IMAGE1, 
		CONTENTCAT_IMAGE2 ,
		CONTENTCAT_IMAGE_SERVER_ID1,
		CONTENTCAT_IMAGE_SERVER_ID2
	FROM 
		CONTENT_CAT 
	WHERE 
		CONTENTCAT_ID = #CONTENTCAT_ID#
</cfquery>

<cfif isDefined("DEL_IMAGE1")>
<!--- SADECE VARSA RESMI SIL --->
	<cfif len(DOSYALAR.CONTENTCAT_IMAGE1)>
		<CFTRY>
			<cf_del_server_file output_file="settings/#DOSYALAR.CONTENTCAT_IMAGE1#" output_server="#DOSYALAR.CONTENTCAT_IMAGE_SERVER_ID1#">
		<CFCATCH TYPE="ANY">
			<cfoutput><cf_get_lang no='637.Dosya Klasörde Bulunamadı ama veritabanından silindi!'></cfoutput>
		</CFCATCH>
		</CFTRY>
	</cfif>
	<cfset UPLOADED1 = "">
<cfelse>
	<cfif len(FORM.CONTENTCAT_IMAGE1)>
	<!--- ESKI VARSA SIL --->
		<cfif len(DOSYALAR.CONTENTCAT_IMAGE1)>
		<CFTRY>
			<cf_del_server_file output_file="settings/#DOSYALAR.CONTENTCAT_IMAGE1#" output_server="#DOSYALAR.CONTENTCAT_IMAGE_SERVER_ID1#">
			<CFCATCH TYPE="ANY">
				<cfoutput><cf_get_lang no='637.Dosya Klasörde Bulunamadı ama Veritabanından Silindi !'></cfoutput>
			</CFCATCH>
		</CFTRY>
		</cfif>
	<!--- YENI UPLOAD --->
		<CFTRY>
			<CFFILE  ACTION="UPLOAD" FILEFIELD="CONTENTCAT_IMAGE1" DESTINATION="#upload_folder#" MODE="777" NAMECONFLICT="MAKEUNIQUE" accept="image/jpeg, image/png, image/bmp, image/gif, image/pjpeg, image/x-png,image/jpg">
			<CFCATCH TYPE="ANY">
				<script type="text/javascript">
					alert("<cfoutput>#upload_folder#</cfoutput> - <cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
				<cfabort>
			</CFCATCH>  
		</CFTRY>
		<cfset file_name = createUUID()>
		<cffile action='rename' source='#upload_folder##cffile.serverfile#' destination='#upload_folder##file_name#.#cffile.serverfileext#'>
		<cfset UPLOADED1 = '#file_name#.#cffile.serverfileext#'>
	<cfelse>
	<!--- ESKI DEĞERI YERINE YAZ --->
		<cfset UPLOADED1 = DOSYALAR.CONTENTCAT_IMAGE1>
	</cfif>
</cfif>

<cfif isDefined("DEL_IMAGE2")>
<!--- SADECE VARSA RESMI SIL --->
	<cfif len(DOSYALAR.CONTENTCAT_IMAGE2)>
	<CFTRY>
		<cf_del_server_file output_file="settings/#DOSYALAR.CONTENTCAT_IMAGE2#" output_server="#DOSYALAR.CONTENTCAT_IMAGE_SERVER_ID2#">
		<CFCATCH TYPE="ANY">
			<cfoutput><cf_get_lang no='637.Dosya Klasörde Bulunamadı ama Veritabanından Silindi !'></cfoutput>
		</CFCATCH>
	</CFTRY>
	</cfif>
	<cfset UPLOADED2 = "">
<cfelse>
	<cfif len(FORM.CONTENTCAT_IMAGE2)>
	<!--- ESKI VARSA SIL --->
		<cfif len(DOSYALAR.CONTENTCAT_IMAGE2)>
		<CFTRY>
			<cf_del_server_file output_file="settings/#DOSYALAR.CONTENTCAT_IMAGE2#" output_server="#DOSYALAR.CONTENTCAT_IMAGE_SERVER_ID2#">
			<CFCATCH TYPE="ANY">
				<cfoutput><cf_get_lang no='637.Dosya Klasörde Bulunamadı ama Veritabanından Silindi !'></cfoutput>
			</CFCATCH>
		</CFTRY>
		</cfif>
	<!--- YENI UPLOAD --->
		<CFTRY>
			<CFFILE ACTION="UPLOAD" FILEFIELD="CONTENTCAT_IMAGE2" DESTINATION="#upload_folder#" MODE="777" NAMECONFLICT="MAKEUNIQUE" accept="image/jpeg, image/png, image/bmp, image/gif, image/pjpeg, image/x-png,image/jpg">
			<CFCATCH TYPE="ANY">
				<script type="text/javascript">
					alert("<cf_get_lang_main no='43.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz '>!");
					history.back();
				</script>
			</CFCATCH>  
		</CFTRY>
		<cfset file_name = createUUID()>
		<cffile action='rename' source='#upload_folder##cffile.serverfile#' destination='#upload_folder##file_name#.#cffile.serverfileext#'>
		<cfset UPLOADED2 = '#file_name#.#cffile.serverfileext#'>
	<cfelse>
	<!--- ESKI DEĞERI YERINE YAZ --->
		<cfset UPLOADED2 = DOSYALAR.CONTENTCAT_IMAGE2>
	</cfif>
</cfif>

<cfquery name="UPDCONTENTCAT" datasource="#dsn#">
	UPDATE 
		CONTENT_CAT 
	SET 
		IS_HOMEPAGE = <cfif isDefined("attributes.IS_HOMEPAGE")>1,<cfelse>0,</cfif>
		IS_RULE = <cfif isDefined("attributes.IS_RULE")>1,<cfelse>0,</cfif>		
		IS_TRAINING = <cfif isDefined("attributes.IS_TRAINING")>1,<cfelse>0,</cfif>		
		CONTENTCAT = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT#">,
		CONTENTCAT_IMAGE1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UPLOADED1#">,
		CONTENTCAT_IMAGE_SERVER_ID1 = #fusebox.server_machine#,
		FILE_TYPE1 = <cfif isDefined("attributes.FILE_TYPE1")>1,<cfelse>0,</cfif>
		FILE_TYPE2 = <cfif isDefined("attributes.FILE_TYPE2")>1,<cfelse>0,</cfif>
		CONTENTCAT_IMAGE2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#UPLOADED2#">,
		CONTENTCAT_IMAGE_SERVER_ID2 = #fusebox.server_machine#,
		CONTENTCAT_ALT1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_ALT1#">,
		CONTENTCAT_LINK1 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_LINK1#">,
		CONTENTCAT_ALT2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_ALT2#">,
		CONTENTCAT_LINK2 = <cfqueryparam cfsqltype="cf_sql_varchar" value="#CONTENTCAT_LINK2#">,
		LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#FORM.LANGUAGE_ID#">,
		UPDATE_IP = <cfqueryparam cfsqltype="cf_sql_varchar" value="#cgi.remote_addr#">,
		UPDATE_DATE = #now()#,
		UPDATE_EMP = #session.ep.userid#	 
	WHERE 
		CONTENTCAT_ID = #CONTENTCAT_ID#
</cfquery>
<cfquery name="delete_content_cat" datasource="#dsn#">
	DELETE FROM CONTENT_CAT_COMPANY WHERE CONTENTCAT_ID = #CONTENTCAT_ID#
</cfquery>
<cfquery name="add_company_content_cat" datasource="#dsn#">
    <cfloop list="#attributes.company_ID#" index="cc">
        INSERT INTO 
            CONTENT_CAT_COMPANY
            (
                CONTENTCAT_ID,
                COMPANY_ID
            )
           VALUES
            (
                #CONTENTCAT_ID#,
                #cc#
            ) 
     </cfloop>
</cfquery>
<cfif isDefined("attributes.IS_HOMEPAGE") AND attributes.IS_HOMEPAGE>
    <cfquery name="CHANGE" datasource="#DSN#">
        UPDATE
            CONTENT_CAT 
        SET 
            IS_HOMEPAGE = 0 
        WHERE 
            CONTENTCAT_ID <> #CONTENTCAT_ID# AND
            LANGUAGE_ID = '#attributes.language_id#'
    </cfquery>
</cfif>
<script>
	location.href = document.referrer;
</script>