<cfif isdefined('attributes.emp_id') and len(attributes.emp_id)>
<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_EMP_DT">
	SELECT
		TCADT.ATTENDANCE_MAIN,
		TCADT.IS_EXCUSE_MAIN,
		TCADT.EXCUSE_MAIN,
		TCADT.EMP_ID,
		TCA.START_DATE
	FROM
		TRAINING_CLASS_ATTENDANCE TCA,
		TRAINING_CLASS_ATTENDANCE_DT TCADT
	WHERE
		TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> 
		AND TCADT.EMP_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.emp_id#">
		AND TCADT.IS_TRAINER = 0
		AND TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
</cfquery>
<cfquery name="emp_adsoyad" datasource="#DSN#">
	SELECT
		EMPLOYEE_NAME,
		EMPLOYEE_SURNAME
	FROM
		EMPLOYEES
	WHERE
		EMPLOYEE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_train_class_emp_dt.emp_id#">
</cfquery>
<cfelseif isdefined('attributes.par_id') and len(attributes.par_id)>
<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_PAR_DT">
	SELECT
		TCADT.ATTENDANCE_MAIN,
		TCADT.IS_EXCUSE_MAIN,
		TCADT.EXCUSE_MAIN,
		TCADT.PAR_ID,
		TCA.START_DATE
	FROM
		TRAINING_CLASS_ATTENDANCE TCA,
		TRAINING_CLASS_ATTENDANCE_DT TCADT
	WHERE
		TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> 
		AND TCADT.PAR_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.par_id#">
		AND TCADT.IS_TRAINER = 0
		AND TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
</cfquery>
<cfquery name="campany_adsoyad" datasource="#DSN#">
	SELECT
		COMPANY_PARTNER_NAME,
		COMPANY_PARTNER_SURNAME
	FROM
		COMPANY_PARTNER
	WHERE
		PARTNER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_train_class_par_dt.par_id#">
</cfquery>
<cfelseif isdefined('attributes.con_id') and  len(attributes.con_id)>
<cfquery datasource="#dsn#" name="GET_TRAIN_CLASS_CON_DT">
	SELECT
		TCADT.ATTENDANCE_MAIN,
		TCADT.IS_EXCUSE_MAIN,
		TCADT.EXCUSE_MAIN,
		TCADT.CON_ID,
		TCA.START_DATE
	FROM
		TRAINING_CLASS_ATTENDANCE TCA,
		TRAINING_CLASS_ATTENDANCE_DT TCADT
	WHERE
		TCA.CLASS_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.class_id#"> 
		AND TCADT.CON_ID=<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.con_id#">
		AND TCADT.IS_TRAINER = 0
		AND TCA.CLASS_ATTENDANCE_ID=TCADT.CLASS_ATTENDANCE_ID
</cfquery>
<cfquery name="consumer_adsoyad" datasource="#DSN#">
	SELECT
		CONSUMER_NAME,
		CONSUMER_SURNAME
	FROM
		CONSUMER
	WHERE
		CONSUMER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_train_class_con_dt.con_id#">
</cfquery>
</cfif>
<table cellspacing="0" cellpadding="0" border="0" height="100%" width="100%">
  <tr class="color-border">
    <td valign="middle">
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold" width="150">Yoklama Detay</td>
              </tr>
			  <tr>
					<cfif isdefined('attributes.emp_id') and len(attributes.emp_id)>
						<cfoutput query="emp_adsoyad">
							<td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</TD>
						</cfoutput>
					<cfelseif isdefined('attributes.par_id') and len(attributes.par_id)>
						<cfoutput query="campany_adsoyad">
							<td>#COMPANY_PARTNER_NAME# #COMPANY_PARTNER_SURNAME#</TD>
						</cfoutput>
					<cfelseif isdefined('attributes.con_id') and len(attributes.con_id)>
						<cfoutput query="consumer_adsoyad">
							<td>#CONSUMER_NAME# #CONSUMER_SURNAME#</TD>
						</cfoutput>
					</cfif>
			  </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2">
                  <table border="0">
				  	<tr>
						<td>Yoklama Tarihi</td>
						<td>Devam Durumu</td>
						<td>Mazeret</td>
					</tr>
                   
						<cfif isdefined('attributes.emp_id') and len(attributes.emp_id)>
						<cfoutput query="GET_TRAIN_CLASS_EMP_DT">
							<tr>
								<td width="100">#DateFormat(START_DATE,dateformat_style)#</td>
								<td width="100" align="center"><cfif IsNumeric(ATTENDANCE_MAIN) AND ATTENDANCE_MAIN>%#ATTENDANCE_MAIN#<cfelseif IS_EXCUSE_MAIN IS 1>&nbsp;</cfif> </td>
								<td><cfif IS_EXCUSE_MAIN IS 1><img src="/images/control.gif"><cfelse>&nbsp;</cfif></td>
							</tr>
						</cfoutput>
						<cfelseif isdefined('attributes.par_id') and len(attributes.par_id)>
						<cfoutput query="GET_TRAIN_CLASS_PAR_DT">
							<tr>
								<td width="100">#DateFormat(START_DATE,dateformat_style)#</td>
								<td width="100" align="center"><cfif IsNumeric(ATTENDANCE_MAIN) AND ATTENDANCE_MAIN>%#ATTENDANCE_MAIN#<cfelseif IS_EXCUSE_MAIN IS 1>&nbsp;</cfif> </td>
								<td><cfif IS_EXCUSE_MAIN IS 1><img src="/images/control.gif"><cfelse>&nbsp;</cfif></td>
							</tr>
						</cfoutput>
						<cfelseif isdefined('attributes.con_id') and  len(attributes.con_id)>
						<cfoutput query="GET_TRAIN_CLASS_CON_DT">
							<tr>
								<td width="100">#DateFormat(START_DATE,dateformat_style)#</td>
								<td width="100" align="center"><cfif IsNumeric(ATTENDANCE_MAIN) AND ATTENDANCE_MAIN>%#ATTENDANCE_MAIN#<cfelseif IS_EXCUSE_MAIN IS 1>&nbsp;</cfif> </td>
								<td><cfif IS_EXCUSE_MAIN IS 1><img src="/images/control.gif"><cfelse>&nbsp;</cfif></td>
							</tr>
						</cfoutput>
						</cfif>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

