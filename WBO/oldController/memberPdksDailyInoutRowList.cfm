<cfset is_member = 1>
<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
    <cf_get_lang_set module_name="hr">
    <cfinclude template="../hr/query/get_emp_codes.cfm">
    <cfparam name="attributes.keyword" default="">
    <cfparam name="attributes.order_type" default="1">
    <cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
        <cf_date tarih = "attributes.startdate">
    <cfelse>
        <cfset attributes.startdate = now()>
    </cfif>
    <cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
        <cf_date tarih = "attributes.finishdate">
    <cfelse>
        <cfset attributes.finishdate = attributes.startdate>
    </cfif>
    <cfif isdefined("attributes.form_submit")> 
        <cfquery name="get_daily_in_out" datasource="#dsn#">
			SELECT
				C.PARTNER_ID,
				C.COMPANY_PARTNER_NAME,
				C.COMPANY_PARTNER_SURNAME,
				C.PDKS_NUMBER,
				ED.IN_OUT_ID,
				ED.DETAIL,
				ED.ROW_ID,
				ED.FILE_ID,
				ED.IS_WEEK_REST_DAY,
				ED.BRANCH_ID,
				ED.START_DATE,
				ED.FINISH_DATE
			FROM
				EMPLOYEE_DAILY_IN_OUT ED,
				COMPANY_PARTNER C
			WHERE
				ED.PARTNER_ID = C.PARTNER_ID 
				<cfif len(attributes.keyword)>
					<cfif database_type is "MSSQL">
						AND ((C.COMPANY_PARTNER_NAME + ' ' + C.COMPANY_PARTNER_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'  OR C.PDKS_NUMBER LIKE '#attributes.keyword#%')
					<cfelse>
						AND ((C.COMPANY_PARTNER_NAME || ' ' || C.COMPANY_PARTNER_SURNAME) LIKE '<cfif len(attributes.keyword) gt 2>%</cfif>#attributes.keyword#%'  OR C.PDKS_NUMBER LIKE '#attributes.keyword#%')
					</cfif>
				</cfif>
				<cfif len(attributes.startdate)>
					AND
					((ED.START_DATE >= #attributes.startdate# AND ED.START_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.START_DATE IS NULL)
					AND
					((ED.FINISH_DATE >= #attributes.startdate# AND ED.FINISH_DATE < #DATEADD("d",1,attributes.finishdate)#) OR ED.FINISH_DATE IS NULL)
				</cfif>		
			ORDER BY
				<cfif attributes.order_type eq 1>
					ED.FILE_ID,
					C.COMPANY_PARTNER_NAME,
					C.COMPANY_PARTNER_SURNAME
				<cfelseif attributes.order_type eq 2>
					C.COMPANY_PARTNER_NAME,
					C.COMPANY_PARTNER_SURNAME,
					ED.FILE_ID
				</cfif>
		</cfquery>
    <cfelse>
        <cfset get_daily_in_out.recordcount=0>
    </cfif>
    <cfparam name="attributes.branch_id" default="">
    <cfparam name="attributes.page" default=1>
    <cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
    <cfparam name="attributes.totalrecords" default='#get_daily_in_out.recordcount#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfset url_string = ''>
	<cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
        <cfset url_string = '#url_string#&branch_id=#attributes.branch_id#'>
    </cfif>
    <cfif isdefined("attributes.startdate") and len(attributes.startdate)>
        <cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#'>
    </cfif>
    <cfif isdefined("attributes.finishdate") and len(attributes.finishdate)>
        <cfset url_string = '#url_string#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#'>
    </cfif>
    <cfif isdefined("attributes.form_submit") and len(attributes.form_submit)>
        <cfset url_string = '#url_string#&form_submit=1'>
    </cfif>
    <cfif isdefined("attributes.hierarchy") and len(attributes.hierarchy)>
        <cfset url_string = '#url_string#&hierarchy=#attributes.hierarchy#'>
    </cfif>
    <cfif isdefined("attributes.keyword") and len(attributes.keyword)>
        <cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
    </cfif>
    <cfif isdefined("attributes.order_type") and len(attributes.order_type)>
        <cfset url_string = '#url_string#&order_type=#attributes.order_type#'>
    </cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'upd'>
    <cfquery name="get_emp_daily_in_out" datasource="#dsn#">
		SELECT 
			ED.*,
			C.COMPANY_PARTNER_NAME,
			C.COMPANY_PARTNER_SURNAME 
		FROM 
			EMPLOYEE_DAILY_IN_OUT ED,
			COMPANY_PARTNER C
		WHERE 
			ED.PARTNER_ID = C.PARTNER_ID AND
			ROW_ID = #attributes.row_id#
	</cfquery>
</cfif>

<script type="text/javascript">
	<cfif not isdefined("attributes.event") or isdefined("attributes.event") and attributes.event is 'list'>
		$( document ).ready(function() {
			document.getElementById('keyword').focus();
		});	
	<cfelseif isdefined('attributes.event') and listfind('add,upd',attributes.event,',')>
		function kontrol()
		{	
			if (document.getElementById('emp_name').value == "" && document.getElementById('partner_name').value == "")
			{
				alert("<cf_get_lang_main no='1701.Çalışan Girmelisinz'>!");
				return false;
			}
			if (document.getElementById('startdate').value == "")
			{
				alert("<cf_get_lang_main no ='326.Başlangıç Tarihi Girmelisiniz'>!");
				return false;
			}
			if (document.getElementById('finishdate').value == "")
			{
				alert("<cf_get_lang_main no ='327.Bitiş Tarihi Girmelisiniz'>!");
				return false;
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	// Switch //
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
		
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'member.list_emp_daily_in_out_row';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/display/list_emp_daily_in_out_row.cfm';

	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'member.list_emp_daily_in_out_row&event=add';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/form/add_emp_daily_in_out.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/query/add_emp_daily_in_out.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'member.list_emp_daily_in_out_row';
	
	WOStruct['#attributes.fuseaction#']['upd'] = structNew();
	WOStruct['#attributes.fuseaction#']['upd']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['upd']['fuseaction'] = 'member.list_emp_daily_in_out_row';
	WOStruct['#attributes.fuseaction#']['upd']['filePath'] = 'hr/form/upd_emp_daily_in_out.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['queryPath'] = 'hr/query/upd_emp_daily_in_out.cfm';
	WOStruct['#attributes.fuseaction#']['upd']['nextEvent'] = 'member.list_emp_daily_in_out_row&event=upd';
	WOStruct['#attributes.fuseaction#']['upd']['parameters'] = 'row_id=##attributes.row_id##';
	WOStruct['#attributes.fuseaction#']['upd']['Identity'] = '##attributes.row_id##';
	
	if(isdefined("attributes.event") and attributes.event is 'upd')
	{
		WOStruct['#attributes.fuseaction#']['del'] = structNew();
		WOStruct['#attributes.fuseaction#']['del']['window'] = 'emptypopup';
		WOStruct['#attributes.fuseaction#']['del']['fuseaction'] = 'member.del_emp_daily_in_out&row_id=#attributes.row_id#';
		WOStruct['#attributes.fuseaction#']['del']['filePath'] = 'hr/query/del_emp_daily_in_out.cfm';
		WOStruct['#attributes.fuseaction#']['del']['queryPath'] = 'hr/query/del_emp_daily_in_out.cfm';
		WOStruct['#attributes.fuseaction#']['del']['nextEvent'] = 'member.list_emp_daily_in_out_row';
	}
	
	WOStruct['#attributes.fuseaction#']['extendedForm'] = structNew();
	WOStruct['#attributes.fuseaction#']['extendedForm']['controllerFileName'] = 'pdksDailyInoutRowList';
	WOStruct['#attributes.fuseaction#']['extendedForm']['eventList'] = 'add,upd';
	WOStruct['#attributes.fuseaction#']['extendedForm']['tableName'] = 'EMPLOYEE_DAILY_IN_OUT';
	WOStruct['#attributes.fuseaction#']['extendedForm']['dataSourceName'] = 'main';
	WOStruct['#attributes.fuseaction#']['extendedForm']['settings'] = "['item-emp_name','item-startdate','item-finishdate']"; // Bu atama yapılmazsa sayfada her alan değiştirilebilir olur.
</cfscript>
