<!--- Standart Zimmet Tutanak --->
<link rel="stylesheet" href="/css/assets/template/catalyst/print.css" type="text/css">
<cfset attributes.ID =action_id>
<cfquery name="get_debt" datasource="#dsn#">
	SELECT
		*
	FROM
		EMPLOYEES_INVENT_ZIMMET EIZ,
		EMPLOYEES_INVENT_ZIMMET_ROWS EIZR
	WHERE
		EIZ.ZIMMET_ID = EIZR.ZIMMET_ID AND
		EIZ.ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
</cfquery>
<cfquery name="CHECK" datasource="#DSN#">
	SELECT 
	ASSET_FILE_NAME2,
	ASSET_FILE_NAME2_SERVER_ID,
	COMPANY_NAME
	FROM 
	  OUR_COMPANY 
	WHERE 
	  <cfif isdefined("attributes.our_company_id")>
		COMP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.our_company_id#">
	  <cfelse>
		<cfif isDefined("session.ep.company_id") and len(session.ep.company_id)>
		  COMP_ID = #session.ep.company_id#
		<cfelseif isDefined("session.pp.company_id") and len(session.pp.company_id)>	
		  COMP_ID = #session.pp.company_id#
		<cfelseif isDefined("session.ww.our_company_id")>
		  COMP_ID = #session.ww.our_company_id#
		<cfelseif isDefined("session.cp.our_company_id")>
		  COMP_ID = #session.cp.our_company_id#
		</cfif> 
	  </cfif>    
  </cfquery>
<cfquery name="get_department_id" datasource="#DSN#">
		SELECT 
		EP.DEPARTMENT_ID,
		EP.EMPLOYEE_ID
	FROM
		EMPLOYEES_INVENT_ZIMMET EIZ,
		EMPLOYEE_POSITIONS EP
	WHERE 
		EP.EMPLOYEE_ID = EIZ.EMPLOYEE_ID
		AND EIZ.ZIMMET_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.id#">
	 	AND EP.IS_MASTER= 1
</cfquery>
<cfset attributes.department_id =  get_department_id.DEPARTMENT_ID>
<table style="width:210mm">
    <tr>
      	<td>
			<table width="100%">
				<tr class="row_border">
					<td class="print-head">
						<table style="width:100%;">
							<tr>
								<td class="print_title"><cf_get_lang dictionary_id="33205.Zimmet Tutanağı"></td>
								<td style="text-align:right;">
									<cfif len(check.asset_file_name2)>
									<cfset attributes.type = 1>
										<cf_get_server_file output_file="/settings/#check.asset_file_name2#" output_server="#check.asset_file_name2_server_id#" output_type="5">
									</cfif>
								</td>
							</tr>
						</table>
					</td>
				</tr>
				<table>
					<tr>
						<td style="height:35px;"><b><cf_get_lang dictionary_id='57771. DETAY"'></b></td>
					</tr> 
				</table>

				<table class="print_border" style="width:140mm">
					<tr >
						<th><cf_get_lang_main no='1655.Varlık'></th>
						<th><cf_get_lang dictionary_id='30217.Varlık Tipi'></th>
					</tr>
					<cfoutput query="get_debt">
					<tr>
						<td align="left">#DEVICE_NAME#</td>
						<td align="left">#PROPERTY#</td>
					</tr>
					</cfoutput>
				</table>
				<br>
				<cfoutput>
					<table style="width:140mm">
							<tr>
								<td align="left" colspan="2">
									<cf_get_lang dictionary_id="62433.Yukarıda özellikleri belirtilen varlıklar kullanılması ve muhafaza edilmesi için"> 
									<b>#get_emp_info(get_department_id.EMPLOYEE_ID,0,0)#</b>&nbsp;<cf_get_lang dictionary_id="62434.kişisine"> <cf_get_lang dictionary_id="33301.teslim edilmiş ve zimmetlenmiştir">.<br/><br/><br/>
								</td>
							</tr>
						<tr>
							<td width="75%"><b><cf_get_lang dictionary_id="33199.Zimmet Alan"></b></td>
							<td width="25%"><b><cf_get_lang dictionary_id="33204.Zimmet Veren"></b></td>
						</tr>
						<tr>
							<td width="75%">#get_emp_info(get_debt.EMPLOYEE_ID,0,0)#</td>
							<td width="25%">#CHECK.company_name#</td>
						</tr>
					</table>
					<table>
						</br>
							<tr class="fixed">
								<td style="font-size:9px!important;"><b><cf_get_lang dictionary_id='61710.© Copyright'></b> <cfoutput>#check.COMPANY_NAME#</cfoutput> <cf_get_lang dictionary_id='61711.dışında kullanılamaz, paylaşılamaz.'></td>
							</tr>
						</br>
					</table>
				</cfoutput>
			</table>
		</td>
	</tr>
</table>


