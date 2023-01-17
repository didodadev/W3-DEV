<cfquery name="category" datasource="#dsn#">
	SELECT 
		* 
	FROM 
		WORK_GROUP 
	WHERE 
		WORKGROUP_ID=#attributes.workgroup_ID#
</cfquery>
<cfquery name="get_empS" datasource="#DSN#">
	SELECT 
		EMPLOYEE_POSITIONS.EMPLOYEE_ID,
		EMPLOYEE_POSITIONS.POSITION_CODE,
		EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
		EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEE_POSITIONS,
		WORKGROUP_EMP_PAR
	WHERE 
		EMPLOYEE_POSITIONS.POSITION_STATUS = 1
		AND
		EMPLOYEE_POSITIONS.POSITION_CODE = WORKGROUP_EMP_PAR.POSITION_CODE
		AND
		WORKGROUP_EMP_PAR.WORKGROUP_ID=#attributes.workgroup_ID#
</cfquery> 
<cfquery name="get_employees" datasource="#DSN#">
	SELECT 
		EMPLOYEES.EMPLOYEE_ID,
		EMPLOYEES.EMPLOYEE_NAME,
		EMPLOYEES.EMPLOYEE_SURNAME
	FROM 
		EMPLOYEES,
		WORKGROUP_EMP_PAR
	WHERE 
		EMPLOYEES.EMPLOYEE_ID= WORKGROUP_EMP_PAR.EMPLOYEE_ID
		AND
		WORKGROUP_EMP_PAR.WORKGROUP_ID=#attributes.workgroup_ID#
</cfquery> 
<cfquery name="get_PARS" datasource="#DSN#">
	SELECT 
		COMPANY_PARTNER.COMPANY_PARTNER_NAME,
		COMPANY_PARTNER.COMPANY_PARTNER_SURNAME,
		COMPANY_PARTNER.COMPANY_ID,
		COMPANY_PARTNER.PARTNER_ID,
		COMPANY.FULLNAME
	FROM 
		COMPANY_PARTNER,
		COMPANY,
		WORKGROUP_EMP_PAR
	WHERE 
		COMPANY_PARTNER.PARTNER_ID = WORKGROUP_EMP_PAR.PARTNER_ID
		AND
		COMPANY.COMPANY_ID = COMPANY_PARTNER.COMPANY_ID
		AND
		WORKGROUP_EMP_PAR.WORKGROUP_ID=#attributes.workgroup_ID#
</cfquery> 
<cfsavecontent variable="message"><cf_get_lang dictionary_id='58140.İş Grubu'></cfsavecontent>
<cf_box title="#category.workgroup_name# #message#">
	<cfform>
		<div class="form-group">
			<label><cf_get_lang dictionary_id='32559.Grup Amacı'></label>
			<div>
				<cfoutput>#category.goal#</cfoutput>
			</div>
		</div>
		<div>
			<label><cf_get_lang dictionary_id='32560.Grup Çalışanları'></label>
			<div id="emp_par_table" class="form-group">
				<cf_box_elements>
					<cfoutput query="GET_EMPS">
						<div  class="form-group  col col-4 col-md-4 col-sm-4 col-xs-12">
							<label>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</label>
						</div>
					</cfoutput>
						<cfoutput query="GET_EMPLOYEES">
							<div  class="form-group  col col-4 col-md-4 col-sm-4 col-xs-12">
								<label><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=objects.popup_emp_det&emp_id=#get_employees.EMPLOYEE_ID#','list');" > #EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</a></label>
							</div>
						</cfoutput>
					<cfoutput query="get_PARS">
							<div  class="form-group  col col-4 col-md-4 col-sm-4 col-xs-12">
								<label>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME# - #FULLNAME#</label>
							</div>
					</cfoutput>
				</cf_box_elements>
			</div>
		</div>				  
	</cfform>
</cf_box>
