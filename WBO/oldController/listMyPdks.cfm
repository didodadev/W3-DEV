<cf_xml_page_edit fuseact="hr.list_emp_pdks">
<cfset attributes.employee_id = session.ep.userid>
<cfset attributes.position_code = session.ep.position_code>
<cfset ay_list = "Ocak,Şubat,Mart,Nisan,Mayıs,Haziran,Temmuz,Ağustos,Eylül,Ekim,Kasım,Aralık">
<cfset puantaj_gun_ = daysinmonth(now())>
<cfset puantaj_start_ = CREATEODBCDATETIME(CREATEDATE(year(now()),month(now()),1))>
<cfset puantaj_finish_ = CREATEODBCDATETIME(date_add("d",1,CREATEDATE(year(now()),month(now()),puantaj_gun_)))>
<cfset gecen_ay_ = date_add("m",-1,puantaj_start_)>
<cfset gecen_ay_puantaj_gun_ = daysinmonth(gecen_ay_)>
<cfif isdefined("attributes.aktif_gun") and len(attributes.aktif_gun)>
	<script type="text/javascript">
		windowopen('<cfoutput>#request.self#?fuseaction=myhome.popup_edit_daily_in_mail&employee_id=#attributes.employee_id#&aktif_gun=#attributes.aktif_gun#</cfoutput>','small');
	</script>
</cfif>
<cfquery name="get_kart_no" datasource="#dsn#" maxrows="1">
	SELECT
		PDKS_NUMBER
	FROM
		EMPLOYEES_IN_OUT
	WHERE
		EMPLOYEE_ID = #attributes.employee_id#
	ORDER BY IN_OUT_ID DESC
</cfquery>
<cfquery name="get_in_outs" datasource="#dsn#">
	SELECT * FROM EMPLOYEE_DAILY_IN_OUT WHERE EMPLOYEE_ID = #attributes.employee_id# AND START_DATE BETWEEN #gecen_ay_# AND #puantaj_finish_# 
</cfquery>
<cfquery name="GET_TODAY_OFFTIMES" datasource="#DSN#">
	SELECT 
		OFFTIME.VALID, 
		OFFTIME.VALIDDATE,
		OFFTIME.EMPLOYEE_ID, 
		OFFTIME.OFFTIME_ID, 
		OFFTIME.VALID_EMPLOYEE_ID, 
		OFFTIME.STARTDATE, 
		OFFTIME.FINISHDATE, 
		OFFTIME.TOTAL_HOURS, 
		SETUP_OFFTIME.OFFTIMECAT
	FROM 
		OFFTIME,
		EMPLOYEES,
		SETUP_OFFTIME
	WHERE
		OFFTIME.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID AND
		OFFTIME.EMPLOYEE_ID = #attributes.employee_id# AND
		OFFTIME.OFFTIMECAT_ID = SETUP_OFFTIME.OFFTIMECAT_ID AND
		OFFTIME.EMPLOYEE_ID=EMPLOYEES.EMPLOYEE_ID
</cfquery>
<cfquery name="get_fees" datasource="#dsn#">
	SELECT * FROM EMPLOYEES_SSK_FEE WHERE EMPLOYEE_ID = #attributes.employee_id#
</cfquery>
<cfset colspan = "5">
<cfif isdefined("is_pdks_multirecord") and is_pdks_multirecord eq 1>
	<cfset colspan = colspan + 4>
</cfif>
<cfoutput>
    <cfset toplam_gun_ = puantaj_gun_+gecen_ay_puantaj_gun_>
    <cfif len(pdks_day_value) and toplam_gun_ gt pdks_day_value>
        <cfset toplam_gun_ = pdks_day_value>
        <cfset gecen_ay_ = date_add("d",-pdks_day_value,puantaj_finish_)>	
    </cfif>
    <cfset aktif_employee_id = attributes.employee_id>
</cfoutput>
<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.list_my_pdks';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/list_my_pdks.cfm';	
</cfscript>
