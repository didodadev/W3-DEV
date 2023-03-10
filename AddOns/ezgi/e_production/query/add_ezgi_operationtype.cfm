<cfif len(attributes.asset)>
	<cfset upload_folder = "#upload_folder#operationtype#dir_seperator#">
	<cftry>
	<cfset file_name = createUUID()>
	<cffile action = "upload" fileField = "asset" destination = "#upload_folder#" nameConflict = "MakeUnique" mode="777">
	<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
	<cfset assetTypeName = listlast(cffile.serverfile,'.')>
	<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
	<cfif listfind(blackList,assetTypeName,',')>
		<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
		<script type="text/javascript">
			alert("<cf_get_lang_main no='3061.\''php\'',\''jsp\'',\''asp\'',\''cfm\'',\''cfml\'' Formatlarında Dosya Girmeyiniz!!'>");
			history.back();
		</script>
		<cfabort>
	</cfif>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang_main no ='43.Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz'> !");
			history.back();
		</script>
	</cfcatch>
	</cftry>
</cfif>
<cfquery name="GET_OPERATION_TYPE" datasource="#DSN3#">
	SELECT OPERATION_TYPE FROM OPERATION_TYPES WHERE OPERATION_TYPE LIKE '#attributes.OP_NAME#'
</cfquery>
<cfif get_operation_type.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang no ='621.İşlem Tipi Mevcut'> !");
		history.back();
	</script>
<cfelse>
	<cfquery name="operation_type" datasource="#dsn3#" result="MAX_ID">
		INSERT INTO
			OPERATION_TYPES 
		( 
			OPERATION_TYPE,
			O_MINUTE,
			COMMENT,
			COMMENT2,
			FILE_NAME,
			FILE_SERVER_ID,
			RECORD_DATE, 
			RECORD_EMP,
			OPERATION_COST,
			MONEY,
            OPERATION_CODE,
			OPERATION_STATUS,
            IS_VIRTUAL,
            EZGI_H_SURE,
            EZGI_FORMUL
		) 
		VALUES 
		( 
			'#attributes.OP_NAME#',
			<cfif len(attributes.MINUTES)>#attributes.MINUTES#<cfelse>NULL</cfif>,
			'#left(attributes.COMMENT,100)#',
			<cfif len(attributes.comment_2)>'#left(attributes.comment_2,100)#'<cfelse>NULL</cfif>,
			<cfif len(attributes.ASSET)>'#file_name#.#cffile.serverfileext#',<cfelse>NULL,</cfif>
			<cfif len(attributes.ASSET)>#fusebox.server_machine#,<cfelse>NULL,</cfif>
			#NOW()#, 
			#SESSION.EP.USERID#,
			#OPERATION_COST#,
			'#attributes.MONEY#',
            <cfif len(attributes.operation_code)>'#attributes.operation_code#'<cfelse>NULL</cfif>,
			<cfif isdefined("attributes.status")>1<cfelse>0</cfif>,
            <cfif isdefined("attributes.unit_type") and len(attributes.is_virtual)>#attributes.is_virtual#<cfelse>0</cfif>,
            <cfif isdefined("attributes.ezgi_h_sure") and len(attributes.ezgi_h_sure)>#attributes.ezgi_h_sure#<cfelse>0</cfif>,
            <cfif isdefined("attributes.ezgi_formul") and len(attributes.ezgi_formul)>'#attributes.ezgi_formul#'<cfelse>NULL</cfif>
		)
	</cfquery>
	<cflocation url="#request.self#?fuseaction=prod.upd_ezgi_operationtype&operation_type_id=#MAX_ID.IDENTITYCOL#" addtoken="no">
</cfif>
