<cfinclude template="../query/get_branch.cfm">
<cfoutput>
	<div class="col col-12 col-md-12 col-sm-12">
		<div>
			<label class="col col-3 col-md-3 col-sm-3 col-xs-3"><b><cf_get_lang dictionary_id='53266.Puantaj Listesi'></b></label>
			<label class="col col-9 col-md-9 col-sm-9 col-xs-9">: <cfoutput>#listgetat(ay_list(),attributes.sal_mon,',')# - #attributes.sal_year# <cfif isdefined("attributes.sal_year_end")>#listgetat(ay_list(),attributes.sal_mon_end,',')# - #attributes.sal_year_end#</cfif></cfoutput></label>
		</div>
		<cfif len(get_puantaj.stage_row_id)>
		<cfquery name="get_stage" datasource="#dsn#">
			SELECT STAGE FROM PROCESS_TYPE_ROWS WHERE PROCESS_ROW_ID =#get_puantaj.stage_row_id#
		</cfquery>
		<div>
			<label class="col col-3 col-md-3 col-sm-3 col-xs-3"><b><cf_get_lang dictionary_id='57482.Asama'></b></label>
			<label class="col col-9 col-md-9 col-sm-9 col-xs-9">: #get_stage.STAGE#</label>
		</div>
		</cfif>
		<div>
			<label class="col col-3 col-md-3 col-sm-3 col-xs-3"><b><cf_get_lang dictionary_id='57571.Ünvan'></b></label>
			<label class="col col-9 col-md-9 col-sm-9 col-xs-9">: #GET_BRANCH.BRANCH_FULLNAME#</label>
		</div>
		<div>
			<label class="col col-3 col-md-3 col-sm-3 col-xs-3"><b><cf_get_lang dictionary_id='58723.Adres'></b></label>
			<label class="col col-9 col-md-9 col-sm-9 col-xs-9">: #GET_BRANCH.BRANCH_ADDRESS# #GET_BRANCH.BRANCH_POSTCODE# #GET_BRANCH.BRANCH_COUNTY# #GET_BRANCH.BRANCH_CITY#</label>
		</div>
		<div>
			<label class="col col-3 col-md-3 col-sm-3 col-xs-3"><b><cf_get_lang dictionary_id='53591.SSK Ofis'> / <cf_get_lang dictionary_id='57487.No'></b></label>
			<label class="col col-9 col-md-9 col-sm-9 col-xs-9">: #GET_BRANCH.SSK_OFFICE# - #GET_BRANCH.SSK_M# #GET_BRANCH.SSK_JOB# #GET_BRANCH.SSK_BRANCH# #GET_BRANCH.SSK_BRANCH_OLD# #GET_BRANCH.SSK_NO# #GET_BRANCH.SSK_CITY# #GET_BRANCH.SSK_COUNTRY# #GET_BRANCH.SSK_CD#</label>
		</div>
		<div>
			<label class="col col-3 col-md-3 col-sm-3 col-xs-3"><b><cf_get_lang dictionary_id='58762.Vergi Dairesi'> / <cf_get_lang dictionary_id='57487.No'></b></label>
			<label class="col col-9 col-md-9 col-sm-9 col-xs-9"> 
				<cfif len(GET_BRANCH.BRANCH_TAX_NO)>
					: #GET_BRANCH.BRANCH_TAX_OFFICE# / #GET_BRANCH.BRANCH_TAX_NO#
				<cfelseif len(GET_BRANCH.TAX_NO)>
					: #GET_BRANCH.TAX_OFFICE# / #GET_BRANCH.TAX_NO#
				</cfif>
			</label>
		</div>
		<div>
			<cfquery name="GET_PLUS_LIST" datasource="#dsn#">
				SELECT 
					IN_OUT_ID,
					EMPLOYEE_ID,
					BASE_AMOUNT_7256,
					(SSK_ISVEREN_HISSESI_7256+SSK_ISCI_HISSESI_7256+ISSIZLIK_ISCI_HISSESI_7256+ISSIZLIK_ISVEREN_HISSESI_7256) AS TOTAL_LAW,
					(SSK_ISVEREN_HISSESI+SSK_ISCI_HISSESI+ISSIZLIK_ISCI_HISSESI+ISSIZLIK_ISVEREN_HISSESI) AS AVAILABLE
				FROM
					EMPLOYEES_PUANTAJ_ROWS
				WHERE
					PUANTAJ_ID = <cfqueryparam value = "#attributes.puantaj_id#" CFSQLType = "cf_sql_integer">
					AND ISNULL(BASE_AMOUNT_7256,0) > 0
					AND IS_7256_PLUS = 1
			</cfquery>
			<cfif GET_PLUS_LIST.recordcount gt 0>
				<label class="col col-3 col-md-3 col-sm-3 col-xs-3"><b><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=ehesap.popup_payroll_law&payroll_id=#attributes.puantaj_id#','list');"><cf_get_lang dictionary_id='61532.7256 Kanun Dağılımı'></a></b></label>
			</cfif>
		</div>
	</div>
</cfoutput>
