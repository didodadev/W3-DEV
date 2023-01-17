<cf_get_lang_set module_name="myhome">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event") or (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfscript>
        get_demands = createObject("component","myhome.cfc.get_travel_demands");
        get_demands.dsn = dsn;
        get_travel_demand = get_demands.travel_demands
                        (
                            employee_id : session.ep.userid
                        );
    </cfscript>	
<cfif (isdefined("attributes.event") and attributes.event is 'upd')>
	<cfscript>
		get_comp_ = createObject("component","hr.cfc.get_our_company");
		get_comp_.dsn = dsn;
		get_our_company = get_comp_.get_company();
	</cfscript>
</cfif>    
<cfelseif (isdefined("attributes.event") and attributes.event is 'add')>
		<cfscript>
            get_comp_ = createObject("component","hr.cfc.get_our_company");
            get_comp_.dsn = dsn;
            get_our_company = get_comp_.get_company();
        </cfscript>
     <cfquery name="get_position_detail" datasource="#dsn#">
        SELECT UPPER_POSITION_CODE,UPPER_POSITION_CODE2 FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_POSITIONS.EMPLOYEE_ID =  <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.employee_id#"> AND IS_MASTER = 1
    </cfquery>  
    
    <cfquery name="get_department" datasource="#dsn#">
        SELECT
            D.DEPARTMENT_ID,
            D.DEPARTMENT_HEAD,
            B.BRANCH_NAME,
            OC.NICK_NAME
        FROM 
            EMPLOYEE_POSITIONS EP INNER JOIN DEPARTMENT D ON EP.DEPARTMENT_ID = D.DEPARTMENT_ID 
            INNER JOIN BRANCH B ON D.BRANCH_ID = B.BRANCH_ID
            INNER JOIN OUR_COMPANY OC ON B.COMPANY_ID = OC.COMP_ID
       WHERE
            EP.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
    </cfquery> 
    
</cfif>

<script type="text/javascript">
//Event : add
<cfif (isdefined("attributes.event") and attributes.event is 'add')>
	function check()
		{
			if(document.getElementById('company').value == "")
			{
				alert("<cf_get_lang_main no='162.Şirket'>");
				return false;	
			}
			if(!$(':radio[name="departure_time"]:checked').length)
			{
				alert("Gidiş Tarihi");
				return false;
			}
			if(!$(':radio[name="departure_of_time"]:checked').length)
			{
				alert("Dönüş Tarihi");
				return false;
			}
			if(document.getElementById('place').value == '')
			{
				alert("Göreve Gideceği Yer");
				return false;	
			}
			return process_cat_control();
		}	
</cfif>
<cfif (isdefined("attributes.event") and attributes.event is 'upd')>
	function check()
	{
		return process_cat_control();
	}
</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_travel_demands';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_travel_demands.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'myhome.popup_form_add_travel_demand';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'myhome/form/form_add_travel_demand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'myhome/query/add_travel_demand.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'myhome.list_travel_demands&event=upd';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'myhome.popup_form_upd_travel_demand';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'myhome/form/form_upd_travel_demand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'myhome/query/upd_travel_demand.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'myhome.list_travel_demands&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'travel_demand_id=##attributes.travel_demand_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.travel_demand_id##';
	
</cfscript>
