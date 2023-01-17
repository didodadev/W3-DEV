<cfquery name="get_" datasource="#dsn#">
	SELECT 
        EMPLOYEE_ID, 
        SAFEGUARD_FILE,
        RECORD_DATE, 
        RECORD_EMP, 
        RECORD_IP, 
        UPDATE_DATE, 
        UPDATE_EMP, 
        UPDATE_IP, 
        BRANCH_ID, 
        SAFEGUARD_FILE_SERVER_ID 
    FROM 
	    EMPLOYEES_SAFEGUARD 
    WHERE 
    	EMPLOYEE_ID = #attributes.employee_id#	
</cfquery>
<cfif not get_.recordcount>
	<cfquery name="add_" datasource="#dsn#">
		INSERT INTO
			EMPLOYEES_SAFEGUARD
		(
			EMPLOYEE_ID,
			RECORD_DATE,
			RECORD_IP,
			RECORD_EMP
		)
		VALUES
		(
			#attributes.employee_id#,
			#now()#,
			'#cgi.REMOTE_ADDR#',
			#session.ep.userid#
		)
	</cfquery>
</cfif>

<cfset upload_folder = "#upload_folder#hr#dir_seperator#">

<cfif isDefined("del_file")>
<!--- sadece varsa resmi sil --->
	<cfif len(attributes.old_safeguard_file)>
		<cf_del_server_file output_file="hr/#attributes.old_safeguard_file#" output_server="#attributes.old_safeguard_file_server_id#">
	</cfif>
	<cfset form.safeguard_file = "">
<cfelse>
	<cfif isDefined("form.safeguard_file") and len(form.safeguard_file)>
	<!--- eski varsa sil --->
		<cfif len(attributes.old_safeguard_file)>
			<cf_del_server_file output_file="hr/#attributes.old_safeguard_file#" output_server="#attributes.old_safeguard_file_server_id#">
		</cfif>
	<!--- yeni upload --->
		<cftry>
			<cffile action="UPLOAD" filefield="safeguard_file" destination="#upload_folder#" mode="777" nameconflict="MAKEUNIQUE">
			<cfcatch type="Any">
				<script type="text/javascript">
					alert("Dosyanız upload edilemedi ! Dosyanızı kontrol ediniz !");
					<cfif not isdefined("attributes.draggable")>history.back();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
				</script>
			</cfcatch>  
		</cftry>

		<cfset file_name = createUUID()>
		<cffile action="rename" source="#upload_folder##cffile.serverfile#" destination="#upload_folder##file_name#.#cffile.serverfileext#">
		<cfset form.safeguard_file = '#file_name#.#cffile.serverfileext#'>
		<!---Script dosyalarını engelle  02092010 FA,ND --->
			<cfset assetTypeName = listlast(cffile.serverfile,'.')>
			<cfset blackList = 'php,php2,php3,php4,php5,phtml,pwml,inc,asp,aspx,ascx,jsp,cfm,cfml,cfc,pl,bat,exe,com,dll,vbs,reg,cgi,htaccess,asis'>
			<cfif listfind(blackList,assetTypeName,',')>
				<cffile action="delete" file="#upload_folder##file_name#.#cffile.serverfileext#">
				<script type="text/javascript">
					alert("\'php\',\'jsp\',\'asp\',\'cfm\',\'cfml\' Formatlarında Dosya Girmeyiniz!!");
					<cfif not isdefined("attributes.draggable")>history.back();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
				</script>
				<cfabort>
			</cfif>	
	<cfelse>
	<!--- eski deðeri yerine yaz --->
		<cfset form.safeguard_file = attributes.old_safeguard_file>
	</cfif>
</cfif>
<cfquery name="upd_" datasource="#dsn#">
	UPDATE
		EMPLOYEES_SAFEGUARD
	SET
		<cfif len(form.safeguard_file)>
			SAFEGUARD_FILE = '#form.safeguard_file#',
			SAFEGUARD_FILE_SERVER_ID = #fusebox.server_machine#,
		<cfelse>
			SAFEGUARD_FILE = NULL, 
			SAFEGUARD_FILE_SERVER_ID = NULL,
		</cfif>
		BRANCH_ID = #attributes.branch_id#
		<cfif get_.recordcount neq 0>
			,UPDATE_EMP = #SESSION.EP.USERID#
			,UPDATE_DATE = #NOW()#
			,UPDATE_IP = '#CGI.REMOTE_ADDR#'
		</cfif>
	WHERE
		EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<script type="text/javascript">
	<cfif not isdefined("attributes.draggable")>window.close();<cfelseif isdefined("attributes.draggable")>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
</script>
