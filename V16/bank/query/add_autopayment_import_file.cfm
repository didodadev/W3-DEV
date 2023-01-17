<cf_date tarih="form.process_date">
<!--- islem tarihine ait e-defter varsa belge eklenmesi engelleniyor --->
<cfif session.ep.our_company_info.is_edefter eq 1>
	<cfstoredproc procedure="GET_NETBOOK" datasource="#dsn2#">
    	<cfprocparam cfsqltype="cf_sql_timestamp" value="#form.process_date#">
		<cfprocparam cfsqltype="cf_sql_timestamp" value="#form.process_date#">
		<cfprocparam cfsqltype="cf_sql_varchar" value="">
		<cfprocresult name="getNetbook">
	</cfstoredproc>
	
	<cfif getNetbook.recordcount>
		<script language="javascript">
			alert("<cf_get_lang dictionary_id='52606.İşlemi yapamazsınız'>. <cf_get_lang dictionary_id='51859.İşlem tarihine ait e-defter bulunmaktadır'>.");
			history.back();
		</script>
		<cfabort>
	</cfif>
	
	
</cfif>

<cftry>
	<cffile action="read" file="#uploaded_file#" variable="dosya">
	<cfset file_name = "T_#CreateUUID()#_#month(now())##day(now())#.txt">
	<cflock name="#CreateUUID()#" timeout="60">
		<cftransaction>
			<cfquery name="ADD_FILE" datasource="#DSN2#">
				INSERT INTO
					FILE_IMPORTS
				(	
					PROCESS_TYPE,
					STARTDATE,
					FILE_NAME,
					FILE_SERVER_ID,
					FILE_CONTENT,
					IMPORTED,
					SOURCE_SYSTEM,
					RECORD_DATE,
					RECORD_IP,
					RECORD_EMP,
					IS_DBS
				)
				VALUES
				(
					-12,
					#form.process_date#,
					'#file_name#',
					#fusebox.server_machine#,
                    <cfif isdefined(attributes.key_type) and len(attributes.key_type)>'#Encrypt(dosya,attributes.key_type,"CFMX_COMPAT","Hex")#',<cfelse>'#dosya#',</cfif>
					0,
					<cfif isdefined("attributes.source") and attributes.source eq 2>#attributes.bank#<cfelse>#attributes.bank_type#</cfif>,
					#now()#,		
					'#cgi.remote_addr#',
					#session.ep.userid#,
					<cfif isdefined("attributes.source") and attributes.source eq 2>1<cfelse>0</cfif>
				)
			</cfquery>
		</cftransaction>
	</cflock>
	<cfcatch type="Any">
		<script type="text/javascript">
			alert("<cf_get_lang dictionary_id='57455.Dosyanız Upload Edilemedi ! Dosyanızı Kontrol Ediniz'>!");
				<cfif not isdefined("attributes.draggable")>window.close();<cfelse>closeBoxDraggable( '<cfoutput>#attributes.modal_id#</cfoutput>' );</cfif>
		</script>
		<cfabort>
	</cfcatch>
</cftry>
<script type="text/javascript">
	alert("<cf_get_lang dictionary_id='52455.Dosyanız Upload Edildi'> !");
		history.back();
</script>
