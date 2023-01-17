<cfif fusebox.use_period eq true>
	<cfset dsn_spf = dsn3>
<cfelse>
	<cfset dsn_spf = dsn>
</cfif>
<cfparam name="attributes.form_type" default="-1">
<cfparam name="attributes.style" default="-1">
<cfif (attributes.form_type neq -1 and not(isdefined("get_templates.recordcount"))) or (attributes.fuseaction eq 'ehesap.list_icmal' and not(isdefined("get_templates.recordcount")))>
	<cfquery name="get_templates" datasource="#dsn_spf#">
		SELECT 
			SPF.IS_XML,
			SPF.TEMPLATE_FILE,
			SPF.FORM_ID,
			SPF.IS_DEFAULT,
			SPF.NAME,
			SPF.PROCESS_TYPE,
			SPF.MODULE_ID,
			SPFC.PRINT_NAME
		FROM 
			SETUP_PRINT_FILES SPF,
			#dsn_alias#.SETUP_PRINT_FILES_CATS SPFC,
			#dsn_alias#.MODULES MOD
		WHERE
			SPF.ACTIVE = 1 AND
			SPF.MODULE_ID = MOD.MODULE_ID AND
			SPFC.PRINT_TYPE = SPF.PROCESS_TYPE AND 
			SPFC.PRINT_TYPE = 180 AND
			SPF.IS_DEFAULT = 1
		ORDER BY
			SPF.IS_XML,
			SPF.NAME
	</cfquery>
<cfelse>
	
</cfif>
<cfparam name="attributes.convert" default="">
<cfif not isdefined("get_puantaj_personal") and isdefined("get_puantaj_rows")>
	<cfset get_puantaj_personal = get_puantaj_rows>
</cfif> 
<cfif attributes.convert EQ "pdf">
	<cfdocument format="pdf" pagetype="A4" orientation="portrait" fontEmbed="true" unit="cm" localUrl="true" saveAsName="test" marginLeft="0.5" margintop="0.5" marginright="0.5" marginbottom="0">
		<cfif get_templates.recordcount>
			<cfif findNoCase("WTO/", get_templates.template_file) gt 0>
				<cfinclude template="/#get_templates.template_file#">
			<cfelse>
				<cfinclude template="#file_web_path#settings/#get_templates.template_file#">
			</cfif>
		<cfelse>
			<cfif get_puantaj_personal.STATUE_TYPE eq 1 and get_puantaj_personal.STATUE eq 2>
				<cfinclude template="view_officer_salary.cfm">
			<cfelseif (get_puantaj_personal.STATUE_TYPE eq 3 or get_puantaj_personal.STATUE_TYPE eq 4) and get_puantaj_personal.STATUE eq 2>
				<cfinclude template="view_officer_additional_courses.cfm">
			<cfelse>
				<cfinclude template="view_icmal_inner.cfm">
			</cfif>
		</cfif>
	</cfdocument>
<cfelse>
	<cfif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'default-1'>
		<cfinclude template="view_order_payment.cfm">
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'default-2'>
		<cfinclude template="view_personnel_form.cfm">
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'default-3'>
		<cfinclude template="view_monthly_payroll.cfm">	
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'default-4'>
		<cfinclude template="view_payroll_statement.cfm">
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'default-5'>
		<cfinclude template="view_promotion_information.cfm">
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'default-6'> <!--- 5434 --->
		<cfinclude template="view_detail_information_5434.cfm">
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'default-8'> <!--- 5510 --->
		<cfinclude template="view_detail_information.cfm">
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'default-7'>
		<cfinclude template="view_bes_detail.cfm">
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'interruption'>
		<cfset interruption_name = attributes.general_paper_tempate.Split("-")>
		<cfif interruption_name[2] eq 2 or interruption_name[2] eq 3 or interruption_name[2] eq 4>
			<cfinclude template="view_interruption_alimony.cfm">
		<cfelse>
			<cfinclude template="view_interruption.cfm">
		</cfif>
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'offtime'>
		<cfset offtime_name = attributes.general_paper_tempate.Split("-")>
		<cfif offtime_name[2] eq 1>
			<cfinclude template="view_offtime_payroll.cfm">
		</cfif>
	<cfelseif isDefined("attributes.general_paper_tempate") and len(attributes.general_paper_tempate) and attributes.general_paper_tempate contains 'exception'>
		<cfset interruption_name = attributes.general_paper_tempate.Split("-")>
		<cfinclude template="view_interruption.cfm">
	<cfelseif (attributes.style neq 'all' and isDefined('get_templates') And get_templates.recordcount and isdefined("attributes.form_type") and attributes.form_type neq -1 and attributes.form_type neq -2) or (attributes.style eq 'all' and len(attributes.form_type)) >
		<cfif findNoCase("WTO/", get_templates.template_file) gt 0>
            <cfinclude template="/#get_templates.template_file#">
        <cfelse> 
            <cfinclude template="#file_web_path#settings/#get_templates.template_file#">
        </cfif>
	<cfelse>
		<cfif isdefined("get_puantaj_personal.STATUE_TYPE") and (get_puantaj_personal.STATUE_TYPE eq 1 or get_puantaj_personal.STATUE_TYPE eq 5 or get_puantaj_personal.STATUE_TYPE eq 8) and get_puantaj_personal.STATUE eq 2>
			<cfinclude template="view_officer_salary.cfm">
		<cfelseif isdefined("get_puantaj_personal.STATUE_TYPE") and (get_puantaj_personal.STATUE_TYPE eq 6 or get_puantaj_personal.STATUE_TYPE eq 7 or get_puantaj_personal.STATUE_TYPE eq 9 or get_puantaj_personal.STATUE_TYPE eq 10) and get_puantaj_personal.STATUE eq 2>
			<cfinclude template="view_officer_jury.cfm">
		<cfelseif isdefined("get_puantaj_personal.STATUE_TYPE") and (get_puantaj_personal.STATUE_TYPE eq 3 or get_puantaj_personal.STATUE_TYPE eq 4) and get_puantaj_personal.STATUE eq 2>
			<cfinclude template="view_officer_additional_courses.cfm">
		<cfelseif isdefined("get_puantaj_personal.STATUE_TYPE") and get_puantaj_personal.STATUE_TYPE eq 11>
			<cfinclude template="view_officer_debits.cfm">
		<cfelse>
			<cfinclude template="view_icmal_inner.cfm">
		</cfif>
	</cfif>
</cfif>
