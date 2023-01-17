<!--- bu sayfada unicodelar icin sql_unicode fonksiyonu kullanildi --->
<cfif len(form.image1)>
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
		
<cfquery name="CHAPTER_CONTROL" datasource="#DSN#">
	SELECT 
		CONTENTCAT_ID 
	FROM 
		CONTENT_CHAPTER
	WHERE 
		CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.contentcat_id#"> AND 
		CHAPTER = <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.chapter_name#">
</cfquery>

<cfif chapter_control.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no='85.Girdiğiniz Bölüm Adı Şu An Kullanılıyor !'>");
		history.back();
	</script>
	<cfabort>
</cfif>
	
<cfif len(form.contentcat_id) and len(form.hierarchy)>
	<cfquery name="GET_CHAPTER" datasource="#DSN#">
		SELECT 
			HIERARCHY 
		FROM 
			CONTENT_CHAPTER
		WHERE 
			HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hierarchy#%"> AND 
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
<cfelseif len(form.contentcat_id) and not len(form.hierarchy)>
	<cfquery name="GET_CHAPTER_" datasource="#DSN#" maxrows="1">
		SELECT 
			HIERARCHY
		FROM 
			CONTENT_CHAPTER
		WHERE 
			HIERARCHY LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="#form.hierarchy#%"> AND
			CONTENTCAT_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#form.contentcat_id#">
		ORDER BY
			RECORD_DATE DESC,
			HIERARCHY DESC
	</cfquery>
	<cfif get_chapter_.recordcount>
		<cfset end_hierarchy = form.contentcat_id & ","& '#listgetat(get_chapter_.hierarchy,2,',')+1#'>
	<cfelse>
		<cfset end_hierarchy = form.contentcat_id & ","& 1>
	</cfif>
</cfif>

<cfquery name="INSERT_CHAPTER" datasource="#DSN#">
	INSERT INTO
		CONTENT_CHAPTER
	(
		CONTENT_CHAPTER_STATUS, 
		HIERARCHY, 
		CHAPTER,
		CHAPTER_DICTIONARY_ID, 
		RECORD_DATE, 
		RECORD_MEMBER, 
		RECORD_IP, 
		CONTENTCAT_ID
		<cfif len(form.image1)>
			,CHAPTER_IMAGE1
		</cfif>
		<cfif len(form.image2)>
			,CHAPTER_IMAGE2
		</cfif>
		<cfif len(form.image1)>
			,SERVER_ID1
		</cfif>
		<cfif len(form.image2)>
			,SERVER_ID2
		</cfif>
	)
	VALUES
	(
		<cfif isDefined("attributes.status")>0<cfelse>1</cfif>, 					 
		'#end_hierarchy#',
		#sql_unicode()#'#form.chapter_name#', 
		#sql_unicode()#'#form.chapter_dictionary_id#', 
		#now()#, 
		#session.ep.userid#, 
		'#REMOTE_ADDR#',
		#form.contentcat_id#
		<cfif len(form.image1)>,'#file_name#'</cfif>
		<cfif len(form.image2)>,'#file_name2#'</cfif>
		<cfif len(form.image1)>,#fusebox.server_machine#</cfif>
		<cfif len(form.image2)>,'#fusebox.server_machine#'</cfif>
	)
</cfquery>
<cflocation url="#request.self#?fuseaction=content.list_chapters" addtoken="no">
