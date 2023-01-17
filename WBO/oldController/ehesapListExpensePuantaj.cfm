<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
	<cfscript>
		bu_ay_basi = CreateDate(year(now()),month(now()),1);
		bu_ay_sonu = DaysInMonth(bu_ay_basi);
	</cfscript>
	<cfparam name="attributes.startdate" default="#date_add("m",-1,bu_ay_basi)#">
	<cfparam name="attributes.finishdate" default="#Createdate(year(bu_ay_basi),month(bu_ay_basi),bu_ay_sonu)#">
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfif isdefined("attributes.form_submitted")>
		<cf_date tarih="attributes.startdate">
		<cf_date tarih="attributes.finishdate">
		<cfquery name="get_puantaj" datasource="#dsn#">
			SELECT
				EPR.*,
				E.EMPLOYEE_NAME,
				E.EMPLOYEE_SURNAME,
				EI.TC_IDENTY_NO
			FROM
				EMPLOYEES E,
				EMPLOYEES_IDENTY EI,
				EMPLOYEES_EXPENSE_PUANTAJ EPR
			WHERE
				EPR.EMPLOYEE_ID = E.EMPLOYEE_ID
				AND EI.EMPLOYEE_ID = E.EMPLOYEE_ID
				<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
					<cfif database_type is "MSSQL">
						AND ((E.EMPLOYEE_NAME + ' ' + E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%' OR EI.TC_IDENTY_NO = '#attributes.keyword#' OR E.EMPLOYEE_NO LIKE '%#attributes.keyword#%')
					<cfelse>
						AND ((E.EMPLOYEE_NAME || ' ' || E.EMPLOYEE_SURNAME) LIKE '%#attributes.keyword#%' OR EI.TC_IDENTY_NO = '#attributes.keyword#' OR E.EMPLOYEE_NO LIKE '%#attributes.keyword#%')
					</cfif>
				</cfif>
				<cfif len(attributes.startdate)>
					AND EPR.EXPENSE_DATE >= #attributes.startdate# 
				</cfif>
				<cfif len(attributes.finishdate)>
					AND EPR.EXPENSE_DATE <= #attributes.finishdate# 
				</cfif>
			ORDER BY
				EPR.EXPENSE_DATE DESC
		</cfquery>
	<cfelse>
		<cfset get_puantaj.recordcount = 0>
	</cfif>
	<cfparam name="attributes.totalrecords" default='#get_puantaj.recordcount#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset adres=attributes.fuseaction>
	<cfset adres = "#adres#&keyword=#attributes.keyword#&form_submitted=1">
	<cfif isdefined("attributes.startdate") and isdate(attributes.startdate)>
		<cfset adres = "#adres#&startdate=#dateformat(attributes.startdate,'dd/mm/yyyy')#">
	</cfif>
	<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
		<cfset adres = "#adres#&finishdate=#dateformat(attributes.finishdate,'dd/mm/yyyy')#">
	</cfif>
<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
	<cfif isdefined("attributes.expense_puantaj_id")>
		<cfquery name="get_puantaj" datasource="#dsn#">
			SELECT * FROM EMPLOYEES_EXPENSE_PUANTAJ WHERE EXPENSE_PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.expense_puantaj_id#">
		</cfquery>
	</cfif>
	<cfif isdefined("attributes.expense_puantaj_id")>
		<cfquery name="get_puantaj_kontrol" datasource="#dsn#">
			SELECT
				EPR.PUANTAJ_ID
			FROM
				EMPLOYEES_PUANTAJ EP,
				EMPLOYEES_PUANTAJ_ROWS EPR
			WHERE
				EP.PUANTAJ_ID = EPR.PUANTAJ_ID
				AND EPR.IN_OUT_ID = #get_puantaj.in_out_id#
				AND EP.SAL_MON > = #month(get_puantaj.expense_date)#
				AND EP.SAL_YEAR > = #year(get_puantaj.expense_date)#
		</cfquery>
		<cfquery name="get_expense_puantaj" datasource="#dsn#">
			SELECT
				EXPENSE_PUANTAJ_ID
			FROM
				EMPLOYEES_EXPENSE_PUANTAJ
			WHERE
				IN_OUT_ID = #get_puantaj.in_out_id#
				AND EXPENSE_DATE >= #createodbcdatetime(get_puantaj.expense_date)#
				AND EXPENSE_PUANTAJ_ID <> #attributes.expense_puantaj_id#
		</cfquery>
	</cfif>
</cfif>

<script type="text/javascript">
	<cfif (isdefined("attributes.event") and attributes.event is 'list') or not isdefined("attributes.event")>
		$(document).ready(function() {
			$('#keyword').focus();
		});
	<cfelseif isdefined("attributes.event") and attributes.event is 'add'>
		function check()
		{
			<cfif isdefined("attributes.expense_puantaj_id")>
				employee_puantaj_id = "<cfoutput>#attributes.expense_puantaj_id#</cfoutput>";
			<cfelse>
				employee_puantaj_id = 0;
				if(document.add_expense_puantaj.employee_name.value == '' || document.add_expense_puantaj.employee_id.value == '')
				{
					alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='164.Çalışan'> !");
					return false;
				}
			</cfif>
			if(document.add_expense_puantaj.expense_day.value == '' || document.add_expense_puantaj.expense_day.value == 0)
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='78.Gün'> !");
				return false;
			}
			if(document.add_expense_puantaj.expense_date.value == '')
			{
				alert("<cf_get_lang_main no='59.Eksik Veri'> : <cf_get_lang_main no='330.Tarih'> !");
				return false;
			}
			expense_date = js_date(document.add_expense_puantaj.expense_date.value.toString());
			var listParam = document.add_expense_puantaj.in_out_id.value + "*" + expense_date + "*" + employee_puantaj_id;
			get_puantaj_ = wrk_safe_query("hr_control_expense_puantaj",'dsn',0,listParam);
			if(get_puantaj_.recordcount > 0)
			{
				alert("<cf_get_lang dictionary_id='54591.Çalışan İçin Aynı veya Yeni Tarihli Harcırah Kaydı Mevcut. Lütfen Bilgileri Kontrol Ediniz!'>");
				return false;
			}
			return true;
		}
	</cfif>
</script>

<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'ehesap.list_expense_puantaj';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'hr/ehesap/display/list_expense_puantaj.cfm';
	
	WOStruct['#attributes.fuseaction#']['add'] = structNew();
	WOStruct['#attributes.fuseaction#']['add']['window'] = 'popup';
	WOStruct['#attributes.fuseaction#']['add']['fuseaction'] = 'ehesap.popup_add_expense_puantaj';
	WOStruct['#attributes.fuseaction#']['add']['filePath'] = 'hr/ehesap/form/add_expense_puantaj.cfm';
	WOStruct['#attributes.fuseaction#']['add']['queryPath'] = 'hr/ehesap/query/add_expense_puantaj.cfm';
	WOStruct['#attributes.fuseaction#']['add']['nextEvent'] = 'ehesap.list_expense_puantaj&event=upd';
</cfscript>
