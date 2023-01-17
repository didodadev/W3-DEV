<cfquery name="GET_LIT" DATASOURCE="#DSN#" maxrows="5">
	SELECT
		CONT_HEAD,
		CONTENT_ID
	FROM
		CONTENT
	WHERE
		EMPLOYEE_VIEW = 1 AND
		IS_VIEWED = 1 AND
		VIEW_DATE_START <= #now()# AND
		VIEW_DATE_FINISH >= #now()# AND
		STAGE_ID = -2
</cfquery> 
<cfoutput query="get_lit">
    <div class="ListContent">
        <i class="wrk-keyboard-right-arrow"></i>
        <a href="#request.self#?fuseaction=rule.dsp_rule&cntid=#get_lit.content_id#">#get_lit.cont_head#</a>
    </div>
</cfoutput>