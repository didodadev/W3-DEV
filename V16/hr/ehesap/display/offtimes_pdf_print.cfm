<cf_get_lang_set module_name="ehesap">
<cfquery name="GET_DET_FORM" datasource="#dsn3#" maxrows="1">
  	SELECT 
		SPF.TEMPLATE_FILE,
		SPF.FORM_ID,
		SPF.IS_DEFAULT,
		SPF.NAME,
		SPF.PROCESS_TYPE,
		SPF.IS_STANDART,
		SPF.MODULE_ID,
		SPFC.PRINT_NAME
	FROM 
		SETUP_PRINT_FILES SPF,
		#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC,
		#dsn_alias#.MODULES MOD
	WHERE
		SPF.ACTIVE = 1 AND
		SPF.MODULE_ID = MOD.MODULE_ID AND
		SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
		SPFC.PRINT_TYPE = 175 AND
		SPF.IS_DEFAULT = 1
	ORDER BY
		SPF.NAME
</cfquery>
<cfif not GET_DET_FORM.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang dictionary_id='46457.İzin Talep Yazdırma Formu Bulunamadı! Lütfen Form Tanımlayınız.'>");
		window.close();
	</script>
	<cfabort>
</cfif>

<cfif isdate(attributes.startdate)>
	<cf_date tarih="attributes.startdate">
</cfif>
<cfif isdate(attributes.finishdate)>
	<cf_date tarih="attributes.finishdate">
</cfif>

<cfinclude template="../../query/get_emp_codes.cfm">
<cfquery name="get_my_branches" datasource="#dsn#">
	SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfset branch_id_list = valuelist(get_my_branches.BRANCH_ID)>
<cfinclude template="../query/get_offtimes.cfm">

<cfif GET_OFFTIMES.recordcount>
	<cfdocument permissions="allowprinting" format="pdf" orientation="portrait" pagetype="a4" encryption="128-bit">
		<link rel='stylesheet' href='css/win_ie_1.css' type='text/css'>
		<cfoutput query="GET_OFFTIMES">
			<cfif currentrow eq 1 or (currentrow gt 1 and GET_OFFTIMES.employee_id[currentrow] neq GET_OFFTIMES.employee_id[currentrow-1])>
			<table height="100%">
				<tr>
					<td height="100%" valign="top">
			</cfif>
			<cfset attributes.iid = GET_OFFTIMES.offtime_id>
			<cfif GET_DET_FORM.is_standart eq 1>
				<cfinclude template="/#get_det_form.template_file#">
			<cfelse>		
				<cfinclude template="/documents/settings/#get_det_form.template_file#">
			</cfif>
								
			<cfif currentrow neq GET_OFFTIMES.recordcount and GET_OFFTIMES.employee_id[currentrow] eq GET_OFFTIMES.employee_id[currentrow+1]>
				<cfif currentrow neq 1 and GET_OFFTIMES.employee_id[currentrow] eq GET_OFFTIMES.employee_id[currentrow-1]>
					</td></tr></table>
					<table height="100%">
					<tr>
					<td height="100%" valign="top">
				<cfelse>
					</td></tr>
					<tr><td height="100%" valign="top">
				</cfif>				
			</cfif>
			
			<cfif (currentrow eq GET_OFFTIMES.recordcount or GET_OFFTIMES.employee_id[currentrow] neq GET_OFFTIMES.employee_id[currentrow+1])>
				</td></tr></table>
			</cfif>
		</cfoutput>
	</cfdocument>
<cfelse>
	 <script type="text/javascript">
		alert("<cf_get_lang dictionary_id='46448.Uygun İzin Kaydı Bulunamadı'>!");
		window.close();
	</script>
	<cfabort>
</cfif>
<cf_get_lang_set module_name="#fusebox.circuit#">
