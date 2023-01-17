<cf_xml_page_edit>
<cfset date1="01/01/#session.ep.period_year#">
<cfset date2="31/12/#session.ep.period_year#">
<cf_date tarih='date1'>
<cf_date tarih='date2'>
<cfquery name="get_member_accounts" datasource="#dsn#">
    SELECT *,0 AS ACC_TYPE_ID FROM EMPLOYEES WHERE EMPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfif isdefined('x_select_ch_type') and x_select_ch_type eq 0 and not isdefined("attributes.is_submitted")>
	<cfset attributes.employee_id = session.ep.userid>
	<cfset attributes.member_type = 'employee'>
	<cfset member_type = 'employee'>
	<cfset attributes.company = '#session.ep.name# #session.ep.surname#'>
	<cfset attributes.is_submitted = 1>
<cfelseif (isdefined('x_select_ch_type') and x_select_ch_type eq 1)>
	<cfset attributes.employee_id = session.ep.userid>
	<cfset attributes.member_type = 'employee'>
	<cfset member_type = 'employee'>
	<cfset attributes.company = '#session.ep.name# #session.ep.surname#'>
	<cfset attributes.is_submitted = 1>
    <cfquery name="get_member_accounts" datasource="#dsn#">
    	SELECT DISTINCT EA.ACC_TYPE_ID,SC.ACC_TYPE_NAME FROM EMPLOYEES_ACCOUNTS EA,SETUP_ACC_TYPE SC WHERE SC.ACC_TYPE_ID = EA.ACC_TYPE_ID AND EA.EMPLOYEE_ID = #session.ep.userid# AND EA.PERIOD_ID = #session.ep.period_id# ORDER BY EA.ACC_TYPE_ID DESC
    </cfquery>
</cfif>
<cfif isdefined("x_select_member") and x_select_member eq 1>
	<cfif isdefined('attributes.comp_name') and len(attributes.comp_name)>
		<cfset attributes.company = attributes.comp_name>
	</cfif>
</cfif>
<cfscript>
	all_borctoplam = 0;
	all_alacaktoplam = 0;
	attributes.acc_type_id = '';
	if(listlen(attributes.employee_id,'_') eq 2)
	{
		attributes.acc_type_id = listlast(attributes.employee_id,'_');
		attributes.employee_id = listfirst(attributes.employee_id,'_');
	}	
</cfscript>
<cfloop query="get_member_accounts">	
	<cfquery name="cari_rows" datasource="#dsn2#">
		SELECT
			CR.ACTION_DATE AS ACTION_DATE,
			CR.ACTION_NAME,
			CR.ACTION_DETAIL,
			0 AS BORC,
			CR.ACTION_VALUE ALACAK
		FROM
			CARI_ROWS CR
		WHERE
			<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
				FROM_CMP_ID = #attributes.COMPANY_ID# AND
			<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
				FROM_CONSUMER_ID = #attributes.consumer_id# AND
			<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
				FROM_EMPLOYEE_ID = #attributes.employee_id# AND
			</cfif>
			<cfif isdefined("get_member_accounts.acc_type_id") and get_member_accounts.acc_type_id neq 0>
				ACC_TYPE_ID = #get_member_accounts.acc_type_id# AND
			<cfelseif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0>
				ACC_TYPE_ID = #attributes.acc_type_id# AND
			</cfif>
			CR.ACTION_DATE >= #date1# AND 
			CR.ACTION_DATE <= #date2#
			AND
			(
				CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #session.ep.position_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#) OR
				CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #session.ep.position_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#)
			)
		UNION ALL
		SELECT
			CR.ACTION_DATE AS ACTION_DATE,
			CR.ACTION_NAME,
			CR.ACTION_DETAIL,
			CR.ACTION_VALUE AS BORC,
			0 AS ALACAK
		FROM
			CARI_ROWS CR
		WHERE
			<cfif (isdefined('attributes.company_id') and len(attributes.company_id) and len(attributes.company) and member_type is 'partner') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 1) or (isdefined("attributes.pos_code") and len(attributes.pos_code) and len(attributes.pos_code_text))>
				TO_CMP_ID = #attributes.COMPANY_ID# AND
			<cfelseif (isdefined('attributes.consumer_id') and  len(attributes.consumer_id) and len(attributes.company) and member_type is 'consumer') or (isdefined("attributes.member_cat_type") and len(attributes.member_cat_type) and listfirst(attributes.member_cat_type,'-') eq 2)>
				TO_CONSUMER_ID = #attributes.consumer_id# AND
			<cfelseif isdefined('attributes.employee_id') and  len(attributes.employee_id) and len(attributes.company) and member_type is 'employee'>
				TO_EMPLOYEE_ID = #attributes.employee_id# AND
			</cfif>
			<cfif isdefined("get_member_accounts.acc_type_id") and get_member_accounts.acc_type_id neq 0>
				ACC_TYPE_ID = #get_member_accounts.acc_type_id# AND
			<cfelseif isdefined("attributes.acc_type_id") and len(attributes.acc_type_id) and attributes.acc_type_id neq 0>
				ACC_TYPE_ID = #attributes.acc_type_id# AND
			</cfif>
			CR.ACTION_DATE >= #date1# AND 
			CR.ACTION_DATE <= #date2#
			AND
			(
				CR.TO_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #session.ep.position_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#) OR
				CR.FROM_CMP_ID IN (SELECT COMPANY_ID FROM #dsn_alias#.WORKGROUP_EMP_PAR WHERE POSITION_CODE = #session.ep.position_code# AND IS_MASTER=1 AND OUR_COMPANY_ID = #session.ep.company_id#)
			)
		ORDER BY 
			ACTION_DATE
	</cfquery>
	<cfset total = 0>
    <cfset borctoplam = 0>
    <cfset alacaktoplam = 0>
    <cfif cari_rows.recordcount>
        <cfoutput query="cari_rows">
            <cfset borctoplam = borctoplam + borc>
            <cfset alacaktoplam = alacaktoplam + alacak>
            <cfset all_borctoplam = all_borctoplam + borc>
            <cfset all_alacaktoplam = all_alacaktoplam + alacak>
            <cfset total = abs( borctoplam - alacaktoplam)>
        </cfoutput>	
	</cfif>
</cfloop>
<cfscript>
	WOStruct = StructNew();
	WOStruct['#attributes.fuseaction#'] = structNew();
	WOStruct['#attributes.fuseaction#']['default'] = 'list';
	if(not isdefined('attributes.event'))
	{
		attributes.event = WOStruct['#attributes.fuseaction#']['default'];
	}
	WOStruct['#attributes.fuseaction#']['list'] = structNew();
	WOStruct['#attributes.fuseaction#']['list']['window'] = 'normal';
	WOStruct['#attributes.fuseaction#']['list']['fuseaction'] = 'myhome.my_extre';
	WOStruct['#attributes.fuseaction#']['list']['filePath'] = 'myhome/display/my_extre.cfm';
</cfscript>
