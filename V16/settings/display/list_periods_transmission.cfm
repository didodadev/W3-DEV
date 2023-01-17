<cfsetting showdebugoutput="no">
<cfquery name="GET_POS_ID" datasource="#DSN#">
    SELECT POSITION_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
</cfquery>
<cfquery name="get_periods" datasource="#DSN#">
    SELECT
        PERIOD,PERIOD_ID
    FROM 
        SETUP_PERIOD
    WHERE
        OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.company_id#">
    ORDER BY
        PERIOD_YEAR DESC
</cfquery>
<option value=""><cf_get_lang dictionary_id='39035.Dönem Seçiniz'></option>
<cfoutput query="get_periods">
    <option value="#period_id#">#period#</option>
</cfoutput>
<script type="text/javascript">
    if( $("#hedef_period_1").val() != undefined && $("#hedef_period_1").val() != ''){
        var period_id =  $("#hedef_period_1").val();
        var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_periods&period_id="+period_id;
        AjaxPageLoad(send_address,'DEPARTMENT_PLACE_AJAX',1,'İlişkili Şubeler');
    }else if( $("#kaynak_period_1").val() != undefined && $("#kaynak_period_1").val() != ''){
        var period_id = $("#kaynak_period_1").val();
        var send_address = "<cfoutput>#request.self#</cfoutput>?fuseaction=myhome.popup_ajax_list_periods&period_id="+period_id;
        AjaxPageLoad(send_address,'DEPARTMENT_PLACE_AJAX',1,'İlişkili Şubeler');
    }
</script>

