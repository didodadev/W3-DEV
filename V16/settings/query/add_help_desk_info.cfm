<cffunction name="temizle" returntype="string">
	<cfargument name="detay">
	<cfset yeni=detay>
	<cfset ara_flag=0>
	<cfloop condition="1">
		<cfif Find("http://foraep.workcube",yeni) or Find("http://ep.workcube",yeni)>
			<cfset yeni=Replace(yeni,"http://foraep.workcube","")>
			<cfset yeni=Replace(yeni,"http://ep.workcube","")>
		<cfelse>
			<cfreturn yeni>
		</cfif>	
	</cfloop>	
</cffunction>


<!--- belgenin kaydedileceði klasör --->
<cftry>
	<cffile action="upload" fileField="asset" destination="#upload_folder#" nameConflict="MakeUnique" mode="777">
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyaniz Upload Edilemedi Lütfen Konrol Ediniz '>!");
			history.back();
		</script>
		<cfabort>
	</cfcatch>  
</cftry>
<!--- XML DÖKÜMAN İSLEMLERİİİİ ---> 
<cffile action="read" file="#upload_folder##dir_seperator##cffile.serverfile#" variable="help_xml" charset="UTF-8">
<!--- 
<cfscript>
	help_xmlDoc = XmlParse(help_xml);
</cfscript>
--->
<cfset help_xmlDoc = XmlParse(help_xml)> 
<cfif help_xmlDoc.XmlRoot.XmlName EQ "help_desk_detail">
	<cfset help_desk_array = help_xmlDoc.help_desk_detail.XmlChildren>
	<cfset DiziBoyutu = ArrayLen(help_desk_array)>
	<!--- eski standartların yerine yenileri yazılıyor--->
<!--- 	 // 08/10/2003 xml help14 dosya bu nedenle bu islemi iptal ediyorum
	<cfquery datasource="#DSN#">
		DELETE 
		FROM
			HELP_DESK
		WHERE
			IS_STANDARD=1
	</cfquery>
 --->	
 	<cfscript>
		search_text="help_desk_detail/HELP_DESK/HELP_LANGUAGE/";
		selectedElements = XmlSearch(help_xmlDoc,search_text);
	</cfscript>
	<cfif arraylen(selectedElements)>
		<cfset str_lang_defined=1>
	<cfelse>
		<cfset str_lang_defined=0>
	</cfif>
	<cfloop index="i" from = "1" to = #DiziBoyutu#>
		<cfset str_topic = temizle(ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_TOPIC.XmlText)))>
		<cfquery name="get_help"  datasource="#DSN#">
			SELECT
				*
			FROM
				HELP_DESK
			WHERE 
			HELP_FUSEACTION='#ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_FUSEACTION.XmlText))#' AND
			HELP_CIRCUIT='#ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_CIRCUIT.XmlText))#' AND 
			HELP_HEAD='#Replace(HTMLEditFormat(ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_HEAD.XmlText))),","," ")#'
		</cfquery>
		<cfif not get_help.recordcount>
		 <cfquery  datasource="#DSN#">
			INSERT INTO
				HELP_DESK
				(
					HELP_ID,
					HELP_HEAD,                                                                                            
					HELP_TOPIC,                                                                                                                                                                                                                                                       
					HELP_CIRCUIT,              
					HELP_FUSEACTION,
					IS_STANDARD,
					HELP_LANGUAGE,
					RECORD_ID,
					RECORD_MEMBER
				)
				VALUES	
				(	
					#ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_ID.XmlText))#,
					<cfqueryparam cfsqltype="cf_sql_varchar" value='#Replace(HTMLEditFormat(ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_HEAD.XmlText))),","," ")#'>,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#str_topic#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_CIRCUIT.XmlText))#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_FUSEACTION.XmlText))#">
					,1
					<cfif str_lang_defined eq 1>,<cfqueryparam cfsqltype="cf_sql_varchar" value="#ToString(Trim(help_xmlDoc.help_desk_detail.help_desk[i].HELP_LANGUAGE.XmlText))#"><cfelse>,'TR'</cfif>
					,1
					,'E'
				)
		</cfquery> 
		</cfif>
	</cfloop>	 
	<cfset mesaj=0>
<cfelse>
	<cfset mesaj=1>	
</cfif>
<cffile action="delete" file="#upload_folder##dir_seperator##cffile.serverfile#">



<cfif mesaj>
	<script type="text/javascript">
		alert("<cf_get_lang no ='2512.Lütfen XML Dökümanınızı Kontrol Ediniz'>!");
	</script>
	<cfabort>
</cfif>

<cflocation url="#request.self#?fuseaction=settings.form_add_helpdesk_info" addtoken="no">
