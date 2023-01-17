<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfquery name="CHAPTER_CONTROL" datasource="#DSN#">
	SELECT 
		CONTENTCAT_ID 
	FROM 
		CONTENT_CHAPTER
	WHERE 
		CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.old_contentcat_id#"> AND 
		CHAPTER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.chapter_name#"> AND
		CHAPTER_ID <> <cfqueryparam cfsqltype="cf_sql_integer" value="#form.chapter_id#"> 
</cfquery>

<cfif chapter_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='85.Girdiğiniz Bölüm Adı Şu An Kullanılıyor !'>");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfif len(form.image1)>	
	<cfif len(form.image1_old)>
		<!---<cf file action="DELETE" file="#upload_folder#content#dir_seperator#chapter#dir_seperator##form.image1_old#"> --->
		<cf_del_server_file output_file="content/chapter/#form.image1_old#" output_server="#form.image1_old_server_id#">
	</cfif>
	<cftry>
		<cffile action="UPLOAD" 
			nameconflict="OVERWRITE" 
			filefield="image1" 
			destination="#upload_folder#content#dir_seperator#chapter#dir_seperator#" accept="image/*">			
			<cfset file_name = "#createUUID()#.#cffile.serverfileext#">
			<cffile action="rename" source="#upload_folder#content#dir_seperator#chapter#dir_seperator##cffile.serverfile#" destination="#upload_folder#content#dir_seperator#chapter#dir_seperator##file_name#">
				
		<cfcatch type="any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>	
	</cftry>
</cfif>

<cfif len(form.image2)>	
	<cfif len(form.image2_old)>
		<cf_del_server_file output_file="content/chapter/#form.image2_old#" output_server="#form.image2_old_server_id#">
	</cfif>
	<cftry>
		<cffile action="UPLOAD" 
			nameconflict="OVERWRITE" 
			filefield="image2" 
			destination="#upload_folder#content#dir_seperator#chapter#dir_seperator#" accept="image/*">			
			<cfset file_name2 = "#createUUID()#.#cffile.serverfileext#">
			<cffile action="rename" source="#upload_folder#content#dir_seperator#chapter#dir_seperator##cffile.serverfile#" destination="#upload_folder#content#dir_seperator#chapter#dir_seperator##file_name2#">
					
		<cfcatch type="any">
			<script type="text/javascript">
				alert("<cf_get_lang_main no ='43.Dosyanız Upload Edilemedi ! Dosyanizi Kontrol Ediniz'>!");
				history.back();
			</script>
			<cfabort>
		</cfcatch>	
	</cftry>
</cfif>


<cfif len(form.contentcat_id) AND len(form.hierarchy)>
	<cfquery name="GET_CHAPTER" datasource="#DSN#">
		SELECT 
			HIERARCHY 
		FROM 
			CONTENT_CHAPTER
		WHERE 
			HIERARCHY LIKE  <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hierarchy#%"> AND 
			HIERARCHY <> <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hierarchy#"> AND  
			CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.contentcat_id#">
	</cfquery>
	
	<cfif get_chapter.recordcount eq 0>
		<cfset end_hierarchy = form.hierarchy & ",1000">
	<cfelse>
		<cfset boy = listlen(form.hierarchy,",") + 1>
		<cfset ch_val = 0>
		<cfoutput query="get_chapter">
			<cfif listlen(hierarchy,","	) is boy>
				<cfif listgetat(hierarchy,boy,",") gt ch_val>
					<cfset ch_val = listgetat(hierarchy,boy,",")>
				</cfif>
			</cfif>
		</cfoutput>		
		<cfset art = ch_val + 1>
		<cfset end_hierarchy = form.hierarchy & ","& art>		
	</cfif>
	<cfoutput>
		#get_chapter.recordcount# -- #form.hierarchy#--<strong>#end_hierarchy#</strong>
	</cfoutput>	
	<cfset end_contentcat_id = form.contentcat_id>
	
<cfelseif len(form.contentcat_id) AND not len(form.hierarchy)>
	<cfquery name="GET_CHAPTER" datasource="#DSN#">
		SELECT 
			HIERARCHY
		FROM 
			CONTENT_CHAPTER
		WHERE 
			CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.contentcat_id#">
	</cfquery>
	
	<cfset ch_val = 0>
	<cfoutput query="get_chapter">
		<cfif listlen(hierarchy,",") is 2>
			<cfif listgetat(hierarchy,2,",") gt ch_val>
				<cfset ch_val = listgetat(hierarchy,2,",")>
			</cfif>
		</cfif>
	</cfoutput>
	<cfset art = ch_val + 1>
	<cfset end_hierarchy = 0 & ","& art>	
	<cfset end_contentcat_id = form.contentcat_id>
<cfelse>
	<cfset end_hierarchy = form.old_hierarchy>	
	<cfset end_contentcat_id = form.old_contentcat_id>
</cfif>

<cfquery name="INSERT_CHAPTER" datasource="#DSN#">
	UPDATE
		CONTENT_CHAPTER
	SET 
		CONTENT_CHAPTER_STATUS = <cfif isDefined("attributes.content_chapter_status")>0<cfelse>1</cfif>,
		HIERARCHY = '#end_hierarchy#',
		CHAPTER = #sql_unicode()#'#form.chapter_name#',
		<cfif len(form.image1)>CHAPTER_IMAGE1 = '#file_name#',</cfif>
		<cfif len(form.image1)>SERVER_ID1 = #fusebox.server_machine#,</cfif>
		<cfif len(form.image2)>CHAPTER_IMAGE2 = '#file_name2#',</cfif>
		<cfif len(form.image2)>SERVER_ID2 = #fusebox.server_machine#,</cfif>
		CONTENTCAT_ID = #end_contentcat_id#,
		UPDATE_EMP = #session.ep.userid#, 
		UPDATE_IP = '#cgi.REMOTE_ADDR#',
		UPDATE_DATE = #now()#
	WHERE
		CHAPTER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.chapter_id#">						
</cfquery>

<cflocation url="#request.self#?fuseaction=content.upd_chapter&chapter_id=#form.chapter_id#" addtoken="no">
