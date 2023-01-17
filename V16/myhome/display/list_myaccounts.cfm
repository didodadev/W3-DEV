<cfsetting showdebugoutput="no">

<cfif listlen(session.ep.user_location,'-') eq 3>
	<cfset control_ =  ListDeleteAt(session.ep.user_location,3,'-')>
<cfelse>
	<cfset control_ =  session.ep.user_location>
</cfif>
<cfquery name="ALL_DEPARTMENTS" datasource="#DSN#">
	SELECT DISTINCT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID 
	FROM 
		DEPARTMENT, 
		BRANCH,
		EMPLOYEE_POSITION_BRANCHES
	WHERE 
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		BRANCH.BRANCH_ID = EMPLOYEE_POSITION_BRANCHES.BRANCH_ID AND
		EMPLOYEE_POSITION_BRANCHES.DEPARTMENT_ID = DEPARTMENT.DEPARTMENT_ID AND
		EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# AND
		BRANCH.COMPANY_ID = #session.ep.company_id# AND
		BRANCH.BRANCH_STATUS = 1 AND
		DEPARTMENT.DEPARTMENT_STATUS = 1
	ORDER BY 
		BRANCH.BRANCH_NAME,	
		DEPARTMENT.DEPARTMENT_HEAD
</cfquery>
<cfquery name="get_active_department" datasource="#dsn#">
	SELECT 
		DEPARTMENT.DEPARTMENT_ID, 
		DEPARTMENT.DEPARTMENT_HEAD, 
		BRANCH.BRANCH_NAME,
		BRANCH.BRANCH_ID,
		OUR_COMPANY.NICK_NAME
	FROM 
		DEPARTMENT, 
		BRANCH,
		OUR_COMPANY
	WHERE
		BRANCH.COMPANY_ID = OUR_COMPANY.COMP_ID AND
		BRANCH.BRANCH_ID = DEPARTMENT.BRANCH_ID AND
		DEPARTMENT.DEPARTMENT_ID = #listfirst(control_,'-')#
</cfquery>
<cfinclude template="../query/my_sett.cfm">
<cfsavecontent variable="text">
<cfform action="#request.self#?fuseaction=myhome.emptypopup_settings_process&id=acc_period" method="post" name="mng_period">
	<div class="ui-form-list ui-form-block">
		<input type="hidden" name="employee_idMngPeriod" id="employee_idMngPeriod" value="<cfoutput>#session.ep.userid#</cfoutput>">
    <cfquery name="GET_POS_ID" datasource="#DSN#">
        SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = #session.ep.position_code#
    </cfquery>
    <input type="hidden" name="position_idMngPeriod" id="position_idMngPeriod" value="<cfoutput>#get_pos_id.position_id#</cfoutput>">
    <div class="form-group"> 
        <cfquery name="get_companies" datasource="#DSN#">
            SELECT DISTINCT
                COMP_ID,
                COMPANY_NAME
            FROM 
                SETUP_PERIOD SP, 
                EMPLOYEE_POSITION_PERIODS EP ,
                OUR_COMPANY O
            WHERE 
                EP.PERIOD_ID = SP.PERIOD_ID AND 
                EP.POSITION_ID = #GET_POS_ID.POSITION_ID# AND
                SP.OUR_COMPANY_ID = O.COMP_ID
            ORDER BY
                COMPANY_NAME
        </cfquery>
        <select name="company_idMngPeriod" id="company_idMngPeriod" class="form-control" onchange="show_periods_departments(1)">
            <cfoutput query="get_companies">
                <option value="#comp_id#" <cfif session.ep.company_id eq comp_id>selected</cfif>>#COMPANY_NAME#</option>
            </cfoutput>
        </select>
    </div>
    <div class="form-group" id="periods_td"> 
        <div id="PERIOD_PLACE"></div>
    </div>
    <div class="form-group" id="departments_td"> 
        <div id="DEPARTMENT_PLACE_AJAX">
            <select name="USER_LOCATION_AJAX" id="USER_LOCATION_AJAX" class="form-control">
                <cfoutput query="all_departments">
                    <option value="#department_id#-#branch_id#" <cfif control_ is '#department_id#-#branch_id#'>selected</cfif>>#branch_name# / #department_head#</option>
                </cfoutput>
            </select>
        </div>
	</div>
	<div class="form-group">
		<label><cf_get_lang dictionary_id='53710.Para Formatı'></label>
		<select name="moneyFormat" id="moneyFormat" class="form-control">
			<option value="0" <cfif MY_SETT.moneyformat_style eq 0>selected="selected"</cfif>><cf_get_lang dictionary_id='31503.Avrupa Formatı'> (3.123,56)</option> 
			<option value="1" <cfif MY_SETT.moneyformat_style eq 1>selected="selected"</cfif>><cf_get_lang dictionary_id='31512.Amerikan Formatı'> (3,123.56)</option>
		</select>
	</div>
	</div>
	<div class="ui-form-list-btn">
		<div>
			<a href="javascript://" class="ui-btn ui-btn-success" onClick="AjaxFormSubmit('mng_period','SHOW_INFO',1,'Güncelleniyor','Güncellendi','<cfoutput>#request.self#?fuseaction=myhome.emptypopup_show_session_info&show_type=1</cfoutput>','mysettings_period');"><cf_get_lang dictionary_id='57464.Güncelle'></a>
		</div>
	</div>
	<div id="SHOW_INFO"></div>
</cfform>
</cfsavecontent>
<cfif fusebox.fuseaction is 'popup_list_myaccounts'>
	<cfsavecontent variable="txt"><cfoutput>#session.ep.name# #session.ep.surname# : <cf_get_lang dictionary_id='30773.Çalışma Dönemi'></cfoutput></cfsavecontent>
	<cf_popup_box title="#txt#">
    <cfoutput>#text#</cfoutput>
    </cf_popup_box>
<cfelse>
	<cfoutput>#text#</cfoutput>
</cfif>
<script type="text/javascript">	
	$(document).ready(function(){
			var company_id = document.getElementById('company_idMngPeriod').value;
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_periods&company_id="+company_id;
			AjaxPageLoad(send_address,'PERIOD_PLACE',1,'Dönemler');
		}
	)
	function showDepartmentAjax(branch_id)	
	{
		var x= document.mng_period.user_period_idMngPeriod.selectedIndex;
		var period_id_ = document.mng_period.user_period_idMngPeriod.value;
		if(period_id_ != "")
		{
			var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_departments&period_id="+period_id_;
			AjaxPageLoad(send_address,'DEPARTMENT_PLACE_AJAX',1,'İlişkili Şubeler');
		}
	}
	function kontrolUserLocation()
	{
		if(document.getElementById('USER_LOCATION_AJAX').value == '')
		{
			alert('<cf_get_lang dictionary_id="57997.sube yetkiniz uygun degil ">');
			return false;
		}
	}
	function show_periods_departments(number)
	{
		if(number == 1)
		{
			if(document.getElementById('company_idMngPeriod').value != '')
			{
				var company_id = document.getElementById('company_idMngPeriod').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_periods&company_id="+company_id;
				AjaxPageLoad(send_address,'PERIOD_PLACE',1,'Dönemler');
			}
		}
		else
		{
			if(document.getElementById('user_period_idMngPeriod').value != '')
			{
				var period_id = document.getElementById('user_period_idMngPeriod').value;
				var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_periods&period_id="+period_id;
				AjaxPageLoad(send_address,'DEPARTMENT_PLACE_AJAX',1,'İlişkili Şubeler');
			}
		}
	}
</script>
