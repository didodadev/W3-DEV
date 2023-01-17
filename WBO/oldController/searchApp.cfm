<cf_get_lang_set module_name="hr">
<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
    <cfinclude template="../hr/query/get_know_levels.cfm">
    <cfinclude template="../hr/query/get_moneys.cfm">
    <cfquery name="GET_CITY" datasource="#DSN#">
        SELECT CITY_ID, CITY_NAME FROM SETUP_CITY ORDER BY CITY_NAME
    </cfquery>
    <cfquery name="GET_EDU_LEVEL" datasource="#DSN#">
        SELECT EDU_LEVEL_ID,EDUCATION_NAME FROM SETUP_EDUCATION_LEVEL ORDER BY EDU_LEVEL_ID
    </cfquery>
    <cfquery name="GET_CV_STATUS" datasource="#DSN#">
        SELECT STATUS_ID,ICON_NAME,STATUS FROM SETUP_CV_STATUS
    </cfquery>
    <cfquery name="GET_COMPUTER_INFO" datasource="#DSN#">
        SELECT COMPUTER_INFO_ID,COMPUTER_INFO_NAME FROM SETUP_COMPUTER_INFO WHERE COMPUTER_INFO_STATUS = 1
    </cfquery>
    <cfquery name="GET_BRANCHES" datasource="#DSN#">
        SELECT BRANCHES_ID,BRANCHES_NAME FROM SETUP_APP_BRANCHES WHERE BRANCHES_STATUS = 1 ORDER BY BRANCHES_ROW_LINE 
    </cfquery>
    <cfquery name="GET_DRIVER_LIS" datasource="#DSN#">
        SELECT
            LICENCECAT_ID,
            LICENCECAT
        FROM
            SETUP_DRIVERLICENCE
        ORDER BY
            LICENCECAT
    </cfquery>    
    <cfquery name="get_language" datasource="#dsn#">
        SELECT LANGUAGE_ID, LANGUAGE_SET FROM SETUP_LANGUAGES ORDER BY LANGUAGE_SET
    </cfquery>
    <cfquery name="get_edu4_name" datasource="#dsn#">
        SELECT SCHOOL_ID,SCHOOL_NAME FROM SETUP_SCHOOL ORDER BY SCHOOL_NAME
    </cfquery>	
    <cfquery name="GET_EDU4" datasource="#DSN#">
        SELECT DISTINCT
            EDU_NAME
        FROM
            EMPLOYEES_APP_EDU_INFO
        WHERE
            EDU_NAME <> '' AND
            EDU_ID = -1 AND
            EDU_TYPE IN (4,5)
        ORDER BY EDU_NAME
    </cfquery>
    <cfquery name="GET_EDU4_PART" datasource="#DSN#">
        SELECT DISTINCT
            EDU_PART_NAME
        FROM
            EMPLOYEES_APP_EDU_INFO
        WHERE
            EDU_PART_NAME <> '' AND
            EDU_PART_ID = -1 AND
            EDU_TYPE IN (4,5)
        ORDER BY EDU_PART_NAME
    </cfquery>
	<cfoutput query="get_branches">
        <cfquery name="get_branches_rows" datasource="#dsn#">
            SELECT 
                BRANCHES_ROW_ID, 
                BRANCHES_ID, 
                BRANCHES_NAME_ROW, 
                BRANCHES_DETAIL_ROW, 
                BRANCHES_STATUS_ROW, 
                RECORD_DATE, 
                RECORD_EMP, 
                RECORD_IP, 
                UPDATE_DATE, 
                UPDATE_EMP, 
                UPDATE_IP 
            FROM 
                SETUP_APP_BRANCHES_ROWS 
            WHERE 
                BRANCHES_ID = #branches_id# AND BRANCHES_STATUS_ROW = 1
        </cfquery>
    </cfoutput>		
    <cfquery name="get_cv_unit" datasource="#DSN#">
        SELECT 
            UNIT_ID, 
            IS_VIEW, 
            UNIT_NAME, 
            UNIT_DETAIL, 
            RECORD_DATE, 
            RECORD_EMP, 
            RECORD_IP, 
            UPDATE_DATE, 
            UPDATE_EMP, 
            UPDATE_IP, 
            HIERARCHY, 
            IS_ACTIVE 
        FROM 
            SETUP_CV_UNIT
        WHERE
            IS_VIEW=1
    </cfquery>
    <cfquery name="get_position_cat" datasource="#dsn#">
        SELECT POSITION_CAT_ID,POSITION_CAT FROM SETUP_POSITION_CAT WHERE POSITION_CAT_UPPER_TYPE = 1 
    </cfquery>
    <cfquery name="get_branch" datasource="#dsn#">
        SELECT 
            BRANCH_ID,
            BRANCH_NAME,
            BRANCH_CITY
        FROM 
            BRANCH
        WHERE
            IS_INTERNET = 1
    </cfquery>
</cfif>
<script type="text/javascript">
$( document ).ready(function() {
	branches_name.style.display='none';
	formation_type.style.display = 'none';
});
function kontrol()
{
	if ( (employe_detail.search_app.checked != 1) && (employe_detail.search_app_pos.checked != 1) )
	{
		alert("<cf_get_lang no ='1441.Arama Yapılması İçin Özgeçmiş veya Başvuruları Seçmelisiniz'>!");
		return false;
	}
	employe_detail.salary_wanted1.value = filterNum(employe_detail.salary_wanted1.value);
	employe_detail.salary_wanted2.value = filterNum(employe_detail.salary_wanted2.value);
	return true;
}
function get_county(city_id)
{
	document.employe_detail.home_county.options.length = 0;
	var home_county_id = document.employe_detail.homecity.options.length;	
	var home_county = '';
	for(i=0;i<home_county_id;i++)
	{
		if(document.employe_detail.homecity.options[i].selected && home_county.length==0)
			home_county = home_county + document.employe_detail.homecity.options[i].value;
		else if(document.employe_detail.homecity.options[i].selected)
			home_county = home_county + ',' + document.employe_detail.homecity.options[i].value;
	}
	var get_ilce = wrk_safe_query('hr_get_ilce','dsn',0,home_county);
	document.employe_detail.home_county.options[0]=new Option('İlçe','0')
	for(var xx=0;xx<get_ilce.recordcount;xx++)
	{
		document.employe_detail.home_county.options[xx+1]=new Option(get_ilce.COUNTY_NAME[xx]);
		document.employe_detail.home_county.options[xx+1].value=get_ilce.COUNTY_ID[xx];
	}
}
function goster_opy()
{
	var get_branches = wrk_safe_query('hr_get_branches','dsn');
	if(document.employe_detail.branches_id.value=="")
	{
		branches_name.style.display='none';
		for(var xx=0;xx<get_branches.recordcount;xx++)
			eval('diger_'+get_branches.BRANCHES_ID[xx]).style.display='none';
	}
	else
	{
		eval('diger_'+document.employe_detail.branches_id.value).style.display='';
		branches_name.style.display='';
		for(var xx=0;xx<get_branches.recordcount;xx++)
			if(get_branches.BRANCHES_ID[xx] != document.employe_detail.branches_id.value)
			 eval('diger_'+get_branches.BRANCHES_ID[xx]).style.display='none';
	}
}
function goster_()
{
	if(document.employe_detail.is_formation.options[1].selected == true)
	{
		formation_type.style.display = '';
	}
	if(document.employe_detail.is_formation.options[2].selected == true)
	{
		formation_type.style.display = 'none';
		document.employe_detail.formation_typee.value = '';
	}
}
</script>
<cfscript>

	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
	attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'hr.search_app';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/search_app.cfm';

</cfscript>

