<cfquery name="CONTROL" datasource="#DSN#">
	SELECT 
		TOPICID 
	FROM 
		FORUM_TOPIC
	WHERE 
		FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#forumid#"> AND 
		TITLE = <cfqueryparam cfsqltype="cf_sql_varchar" value="#title#">
</cfquery>

<cfif control.recordcount>
	<cfoutput>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1497.Bu Başlık Kullanılıyor Lütfen geri dönüp kontrol ediniz'>..");
		history.back();
	</script>
	</cfoutput>
</cfif>

<cfif not isDefined("locked")>
	<cfset locked = 0>
</cfif>

<cfif not isDefined("status")>
	<cfset status = 0>
</cfif>

<cfinclude template="get_badwords.cfm">
<cfif len(badword_list)>
	<cfset topic = replacenocase(topic, badword_list, star_list)>
</cfif>

<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>
	<cftry>
		<cffile action="UPLOAD" nameconflict="MAKEUNIQUE" filefield="attach_topic_file" destination="#upload_folder#forum#dir_seperator#">
		<cfset file_name = "#createUUID()#.#cffile.serverfileext#">	
		<cffile action="rename" source="#upload_folder#forum#dir_seperator##cffile.serverfile#" destination="#upload_folder#forum\#file_name#">
		<!---Script dosyalarını engelle  02092010 FA-ND --->
		<cfset assetTypeName = listlast(cffile.serverfile,'.')>
		<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
		<cfif listfind(blackList,assetTypeName,',')>
			<cffile action="delete" file="#upload_folder#forum\#file_name#">
			<script type="text/javascript">
				alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
				history.back();
			</script>
			<cfabort>
		</cfif>
	<cfcatch type="any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'>!");
			history.back();
		</script>
	</cfcatch>
	</cftry>
</cfif>

<cfquery name="ADD_TOPIC" datasource="#DSN#">
	INSERT INTO 
		FORUM_TOPIC 
		(
			USERKEY,
			IMAGEID,
			TITLE,
			TOPIC,
			VERIFIED,
			LOCKED,
			FORUMID,
			<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>FORUM_TOPIC_FILE,</cfif>
			<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>FORUM_TOPIC_FILE_SERVER_ID,</cfif>
				RECORD_DATE,
			<cfif isdefined("SESSION.PP.USERID")>
				RECORD_PAR,
			<cfelse>
				RECORD_CON,
			</cfif>		
				RECORD_IP,
				UPDATE_DATE,
			<cfif isdefined("SESSION.PP.USERID")>
				UPDATE_PAR,
			<cfelse>
				UPDATE_CON,
			</cfif>		
			UPDATE_IP
		)
		VALUES
		(
			<cfif isdefined('session.pp.userkey')>'#session.pp.userkey#'<cfelse>'#session.ww.userkey#'</cfif>,
			#imageid#,
			'#title#',
			'#topic#',
			1,
			#locked#,
			#forum_subject#,
			<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>'#file_name#',</cfif>
			<cfif isdefined("attributes.attach_topic_file") and len(attributes.attach_topic_file)>#fusebox.server_machine#,</cfif>
			#now()#,
			<cfif isdefined("session.pp.userid")>
				#session.pp.userid#,
			<cfelse>
				#session.ww.userid#,
			</cfif>
			'#cgi.remote_addr#',
			#now()#,
			<cfif isdefined("session.pp.userid")>
				#session.pp.userid#,
			<cfelse>
				#session.ww.userid#,
			</cfif>
			'#cgi.remote_addr#'
		)						
</cfquery>

<cfquery name="UPD_FORUM_LAST_MSG_DATE" datasource="#DSN#">
	UPDATE
		FORUM_MAIN
	SET
		LAST_MSG_DATE = #now()#,
		LAST_MSG_USERKEY = <cfif isdefined('session.pp.userkey')>'#session.pp.userkey#'<cfelse>'#session.ww.userkey#'</cfif>,
		TOPIC_COUNT = TOPIC_COUNT+1
	WHERE
		FORUMID = <cfqueryparam cfsqltype="cf_sql_integer" value="#forum_subject#">
</cfquery>
<cflocation url="#request.self#?fuseaction=objects2.view_topic&forumid=#forumid#" addtoken="No">
