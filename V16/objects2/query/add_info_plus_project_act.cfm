<cfquery name="get_asama" datasource="#dsn#" maxrows="1">
	SELECT 
		PROCESS_TYPE_ROWS.*,
		PROCESS_TYPE.IS_STAGE_BACK 
	FROM
		PROCESS_TYPE_ROWS,
		PROCESS_TYPE
	WHERE
		PROCESS_TYPE.PROCESS_ID = PROCESS_TYPE_ROWS.PROCESS_ID AND
		PROCESS_TYPE_ROWS.IS_PARTNER  = 1
</cfquery>
<cfif not get_asama.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1417.Proje Süreçleri Tanımlanmamış! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_oncelik" datasource="#DSN#" maxrows="1">
	SELECT 
		PRIORITY_ID,
		PRIORITY 
	FROM 
		SETUP_PRIORITY
	ORDER BY
		PRIORITY
</cfquery>
<cfif not get_oncelik.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1418.Proje Öncelikleri Tanımlanmamış! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfquery name="get_cat" datasource="#dsn#" maxrows="1">
	SELECT DISTINCT
		SPC.MAIN_PROCESS_CAT_ID,
		SPC.MAIN_PROCESS_CAT,
		SPC.MAIN_PROCESS_TYPE
	FROM
		SETUP_MAIN_PROCESS_CAT_ROWS AS SPCR,
		SETUP_MAIN_PROCESS_CAT_FUSENAME AS SPCF,
		SETUP_MAIN_PROCESS_CAT SPC
	WHERE
		SPC.MAIN_PROCESS_CAT_ID = SPCR.MAIN_PROCESS_CAT_ID AND
		SPC.MAIN_PROCESS_CAT_ID = SPCF.MAIN_PROCESS_CAT_ID AND
		SPC.MAIN_PROCESS_MODULE IN (1) AND
		SPCF.FUSE_NAME = 'project.addpro'
	ORDER BY 
		SPC.MAIN_PROCESS_CAT
</cfquery>
<cfif not get_asama.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='1420.Proje Kategorileri Tanımlanmamış! Lütfen Müşteri Temsilcinize Başvurunuz'>!");
		history.back();
	</script>
	<cfabort>
</cfif>

<cfset attributes.PRO_H_START = now()>
<cfset attributes.PRO_H_FINISH = date_add('d',7,now())>

<cflock name="#CREATEUUID()#" timeout="20">
	<cftransaction>
		<cfquery name="ADD_PROJECT" datasource="#dsn#">
			INSERT INTO 
				PRO_PROJECTS
			(
				COMPANY_ID,
				PARTNER_ID,
				PROJECT_HEAD,
				PROJECT_DETAIL,
				TARGET_START,
				TARGET_FINISH,
				PRO_CURRENCY_ID,
				PRO_PRIORITY_ID,
				RECORD_DATE,
				RECORD_EMP,
				RECORD_IP,
				PROJECT_STATUS,
				PROCESS_CAT
			)
			VALUES
			(
					#session.pp.COMPANY_ID#,
					#session.pp.userid#,
					'#FORM.project_head#',
					'#FORM.PROJECT_DETAIL#',
					#attributes.PRO_H_START#,
					#attributes.PRO_H_FINISH#,
					#get_asama.PROCESS_ROW_ID#,
					#get_oncelik.priority_id#,
					#NOW()#,
					#SESSION.pp.USERID#,
					'#CGI.REMOTE_ADDR#',
					1,
					#get_cat.MAIN_PROCESS_CAT_ID#
				)
		</cfquery>
		<!--- History tablosuna kayıt yapılacak--->
		<cfquery name="GET_LAST_PRO" datasource="#dsn#">
			SELECT MAX(PROJECT_ID) AS PRO_ID FROM PRO_PROJECTS
		</cfquery>
		<cfquery name="ADD_PROJECT_TO_HISTORY" datasource="#dsn#">
			INSERT INTO 
				PRO_HISTORY
				(
					COMPANY_ID,
					PARTNER_ID,
					PROJECT_ID,
					UPDATE_DATE,
					TARGET_START,
					TARGET_FINISH,
					PRO_CURRENCY_ID,
					PRO_PRIORITY_ID
				)
			VALUES
				(
					#session.pp.COMPANY_ID#,
					#session.pp.userid#,
					#get_last_pro.pro_id#,
					#now()#,
					#attributes.PRO_H_START#,
					#attributes.PRO_H_FINISH#,
					#get_asama.PROCESS_ROW_ID#,
					#get_oncelik.priority_id#
				)
		</cfquery>
	</cftransaction>
</cflock>
<cfscript>
STR_COLUMN="";
STR_VALUE="";

for (i=1; i lte 20; i=i+1)
	if (isDefined("attributes.PROPERTY#i#"))
		{
			STR_COLUMN = STR_COLUMN & " PROPERTY#i#,";
			STR_VALUE = STR_VALUE & "'"& evaluate("attributes.PROPERTY#i#")& "',";
		}
</cfscript>

<cfif len(STR_VALUE)>
	<cfquery name="ADD_INFO" datasource="#DSN#">
		INSERT INTO 
			PROJECT_INFO_PLUS
			(
				#PreserveSingleQuotes(STR_COLUMN)#
				PROJECT_ID,
				PARTNER_ID,
				COMPANY_ID,
				RECORD_IP,
				INFO_OWNER_TYPE
			)
				VALUES
			(
				#PreserveSingleQuotes(STR_VALUE)#
				#GET_LAST_PRO.PRO_ID#,
				#session.pp.userid#,
				#session.pp.COMPANY_ID#,
				'#cgi.remote_addr#',
				-10
			)
	</cfquery>
</cfif>
<script type="text/javascript">
	alert("<cf_get_lang no ='1419.Proje Kaydınız Başarıyla Alındı!İlgili Temsilci Sizinle İrtibata Geçecektir'>.");
	window.location.href = '<cfoutput>#request.self#?fuseaction=objects2.list_projects</cfoutput>';
</script>
