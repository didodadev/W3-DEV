 <cfif len(attributes.employee_id)>
    <cfset attributes.employee_id = listFirst(attributes.employee_id,'_')>
    <cfquery name="get_travel" datasource="#dsn#">
        SELECT * FROM EMPLOYEES_TRAVEL_DEMAND WHERE EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND MANAGER1_VALID = 1 ORDER BY PAPER_NO
    </cfquery>
</cfif>
<select name="EXPENSE_HR_ALLOWANCE" id="EXPENSE_HR_ALLOWANCE" >
    <option value=""><cf_get_lang dictionary_id = "57734.Seçiniz"></option>
    <cfif len(attributes.employee_id)>
        <cfoutput query="get_travel">
            <option value="#travel_demand_id#" <cfif isdefined('attributes.travel_demand_id') and len(attributes.travel_demand_id)><cfif travel_demand_id eq attributes.travel_demand_id>selected</cfif></cfif>>#paper_no#</option>
        </cfoutput>
    </cfif>
</select>
<script type="text/javascript">
    $("#EXPENSE_HR_ALLOWANCE").change(function(){
        var travel_id ='SELECT TRAVEL_DEMAND_ID,DEPARTURE_DATE,DEPARTURE_OF_DATE,TRAVEL_TYPE FROM EMPLOYEES_TRAVEL_DEMAND  WHERE TRAVEL_DEMAND_ID ='+ $('#EXPENSE_HR_ALLOWANCE').val();
        var get_travel = wrk_query(travel_id,"dsn");
        var departure_date  = date_format(get_travel.DEPARTURE_DATE);
        $('#travel_start_date').val(departure_date);
        var departure_of_date  = date_format(get_travel.DEPARTURE_OF_DATE);
        $('#travel_finish_date').val(departure_of_date);
        var travel_type  = get_travel.TRAVEL_TYPE;
        if(travel_type == 1)
            $('#travel_type').val('<cf_get_lang dictionary_id="60477.Görev Seyahatleri">');
        else if (travel_type == 2)
            $('#travel_type').val('<cf_get_lang dictionary_id="60478.Uzun Süreli Seyahatler">');
        else if(travel_type == 3)
            $('#travel_type').val('<cf_get_lang dictionary_id="60479.Eğitim Seyahatleri">');
    });
</script>