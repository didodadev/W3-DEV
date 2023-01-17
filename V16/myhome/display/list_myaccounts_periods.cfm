<cfsetting showdebugoutput="no">
<cfif isdefined("attributes.period_id")>
	<cfif listlen(session.ep.user_location,'-') eq 3>
		<cfset control_ = ListDeleteAt(session.ep.user_location,3,'-')>
	<cfelse>
		<cfset control_ = session.ep.user_location>
	</cfif>
    <cfquery name="ALL_DEPARTMENTS_IC" datasource="#DSN#">
        SELECT DISTINCT
            DEPARTMENT.DEPARTMENT_ID, 
            DEPARTMENT.DEPARTMENT_HEAD, 
            BRANCH.BRANCH_NAME,
            BRANCH.BRANCH_ID 
        FROM 
            DEPARTMENT, 
            BRANCH,
            EMPLOYEE_POSITION_BRANCHES,
            SETUP_PERIOD SP
        WHERE 
            BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
            BRANCH.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND
            EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
            EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#"> AND
            BRANCH.COMPANY_ID = SP.OUR_COMPANY_ID AND
            SP.PERIOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.period_id#">
        ORDER BY 
            BRANCH.BRANCH_NAME,	
            DEPARTMENT.DEPARTMENT_HEAD
    </cfquery>
    <div class="form-group2">
        <select name="USER_LOCATION_AJAX" id="USER_LOCATION_AJAX" style="width:220px;" class="form-control">
            <cfoutput query="ALL_DEPARTMENTS_IC">
                <option value="#department_id#-#branch_id#" <cfif control_ is '#department_id#-#branch_id#'>selected</cfif>>#branch_name# / #department_head#</option>
            </cfoutput>
        </select>
    </div>
<cfelse>
	<cfquery name="GET_POS_ID" datasource="#DSN#">
		SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
	</cfquery>
	<cfquery name="get_periods" datasource="#DSN#">
		SELECT
			OUR_COMPANY_ID,SP.PERIOD,SP.PERIOD_ID,SP.PERIOD_YEAR
		FROM 
			SETUP_PERIOD SP, 
			EMPLOYEE_POSITION_PERIODS EP 
		WHERE 
			EP.PERIOD_ID = SP.PERIOD_ID AND 
			SP.OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#"> AND
			EP.POSITION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_pos_id.position_id#">
        GROUP BY   
            OUR_COMPANY_ID
            ,SP.PERIOD
            ,SP.PERIOD_ID
            ,SP.PERIOD_YEAR
		ORDER BY
			PERIOD_YEAR DESC
	</cfquery>
    <div class="form-group2">
        <select name="user_period_idMngPeriod" id="user_period_idMngPeriod" style="width:220px;" class="form-control" onChange="show_periods_departments(2)">
            <cfoutput query="get_periods">
                <option value="#period_id#" <cfif session.ep.period_id eq period_id>selected</cfif>>#period#</option>
            </cfoutput>
        </select>
    </div>
   <script type="text/javascript">
	   if(document.getElementById('user_period_idMngPeriod').value != '')
			{
				var period_id = document.getElementById('user_period_idMngPeriod').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_periods&period_id="+period_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE_AJAX',1,'İlişkili Şubeler');
			}
   </script>
</cfif>
