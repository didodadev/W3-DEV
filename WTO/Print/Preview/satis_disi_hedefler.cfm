<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT 
		T.*,
		EP.EMPLOYEE_NAME,
		EP.EMPLOYEE_SURNAME,
		EP.EMPLOYEE_ID,
		EP.POSITION_CODE 
	FROM 
		TARGET AS T,
		EMPLOYEE_POSITIONS AS EP
	WHERE 
		TARGET_ID = #attributes.ACTION_ID#
		AND T.POSITION_CODE = EP.POSITION_CODE
		<cfif isDefined("attributes.EMPLOYEE_ID") and len(attributes.EMPLOYEE_ID)>
		AND EP.EMPLOYEE_ID = #attributes.EMPLOYEE_ID#
		</cfif>
		<cfif isDefined("attributes.POSITION_CODE") and len(attributes.POSITION_CODE)>
		AND EP.POSITION_CODE = #attributes.POSITION_CODE#
		</cfif>
</cfquery>
<cfquery name="GET_TARGET_CATS" datasource="#dsn#">
	SELECT 
		*
	FROM	
		TARGET_CAT
</cfquery>

<cf_woc_header>
    <cf_woc_elements>
        <cf_wuxi id="t_startdate" data="#dateformat(get_target.startdate,dateformat_style)#" label="58053" type="cell">
        <cf_wuxi id="t_finishdate" data="#dateformat(get_target.finishdate,dateformat_style)#" label="57700" type="cell">
		<cfsavecontent variable="cat"><cfloop from="1" to="#GET_TARGET_CATS.recordcount#" index="i"> <cfif i eq get_target.targetcat_id><cfoutput>#GET_TARGET_CATS.TARGETCAT_NAME[i]#</cfoutput></cfif></cfloop></cfsavecontent>
        <cf_wuxi id="t_category" data="#cat#" label="57486" type="cell">
        <cfsavecontent variable="t_type"><cfif get_target.calculation_type eq 1>+ (<cf_get_lang dictionary_id='33534.Artış Hedefi'>)<cfelseif get_target.calculation_type eq 2>- (<cf_get_lang dictionary_id='33535.Düşüş Hedefi'>)<cfelseif get_target.calculation_type eq 3>+% (<cf_get_lang dictionary_id='33537.Yüzde Artış Hedefi'>)<cfelseif get_target.calculation_type eq 4>-% (<cf_get_lang dictionary_id='33536.Yüzde Düşüş Hedefi'>)<cfelseif get_target.calculation_type eq 5>= (<cf_get_lang dictionary_id='33541.Hedeflenen Rakam'>)</cfif></cfsavecontent>
        <cf_wuxi id="t_number" data="#TLFormat(get_target.target_number)# #t_type#" label="55486" type="cell">
        <cf_wuxi id="t_weight" data="#TLFormat(get_target.target_weight)#" label="29784" type="cell">
        <cf_wuxi id="t_budget" data="#TLFormat(get_target.suggested_budget)#" label="56006" type="cell">
        <cf_wuxi id="t_date1" data="#dateformat(get_target.other_date1,dateformat_style)#" label="33691" type="cell">
        <cf_wuxi id="t_date2" data="#dateformat(get_target.other_date2,dateformat_style)#" label="33692" type="cell">
        <cf_wuxi id="t_head" data="#get_target.target_head#" label="57951" type="cell">
        <cf_wuxi id="t_emp" data="#get_emp_info(get_target.target_emp,0,0)#" label="56298" type="cell">
        <cf_wuxi id="t_detail" data="#get_target.target_detail#" label="36199" type="cell">
    </cf_woc_elements>
<cf_woc_footer>