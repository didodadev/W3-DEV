<cfset target_date=dateformat(now(),"dd/mm/yyyy")>
<cfset pos_code_list= "">
<cfset record_emp_list= "">

<cfquery name="GET_TARGET" datasource="#dsn#">
	SELECT
		TARGET_HEAD,
		TARGET_ID,
		POSITION_CODE,
		RECORD_EMP
	FROM
		TARGET
	WHERE
		FINISHDATE =  #CreateODBCDateTime(DATEADD("d",1,target_date))# 
</cfquery>
<cfset pos_code_list= ListDeleteDuplicates(valuelist(GET_TARGET.POSITION_CODE))>
<cfset record_emp_list= ListDeleteDuplicates(valuelist(GET_TARGET.RECORD_EMP))>

<cfif listlen(pos_code_list) or listlen(record_emp_list)>
	<cfquery name="get_all_mails" datasource="#dsn#">
		SELECT 
			EP.EMPLOYEE_EMAIL,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.EMPLOYEE_ID,
			EP.POSITION_CODE 
		FROM
			EMPLOYEE_POSITIONS EP
		WHERE 
			EP.EMPLOYEE_EMAIL IS NOT NULL 
			AND
			(
				<cfif len(pos_code_list)>
			 	EP.POSITION_CODE IN (#pos_code_list#)
				<cfelse>
				EP.POSITION_CODE IS NOT NULL
				</cfif>
				OR
				<cfif len(record_emp_list)>
				EP.EMPLOYEE_ID IN (#record_emp_list#)
				<cfelse>
				EP.EMPLOYEE_ID IS NOT NULL
				</cfif>
			)
	</cfquery>
</cfif>
<cfif GET_TARGET.recordcount>
	<cfoutput query="GET_TARGET">
		<cfif get_all_mails.recordcount>
			<cfquery name="get_employee_mail" dbtype="query">
				SELECT
					EMPLOYEE_EMAIL,
					POSITION_CODE 
				FROM
					get_all_mails
				WHERE
					POSITION_CODE=#GET_TARGET.POSITION_CODE#
			</cfquery>
			<cfquery name="get_record_mail" dbtype="query">
				SELECT
					EMPLOYEE_EMAIL,
					EMPLOYEE_ID
				FROM
					get_all_mails
				WHERE
					EMPLOYEE_ID=#GET_TARGET.RECORD_EMP#
			</cfquery>
			<cfmail from="#ListFirst(Server_Detail)#" to="#get_employee_mail.EMPLOYEE_EMAIL#" cc="#get_record_mail.EMPLOYEE_EMAIL#" subject="Hedef Bildirimi" type="html">
				<table cellspacing="0" cellpadding="0" width="500" border="0" align="center">
				 <tr bgcolor="##000000">
					<td>
					  <table cellspacing="1" cellpadding="2" width="100%" border="0">
						<tr bgcolor="##FFFFFF">
						  <td></td>
						</tr>
						<tr bgcolor="##FFFFFF">
						  <td>
						  <table align="left">
							<tr>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;">??yi ??al????malar. Ad??n??za Kay??tl?? #GET_TARGET.TARGET_HEAD# Hedef Kayd??n??n Yar??n Son G??n??d??r...??lgili Hedef Bilgilerine A??a????daki Linki T??klayarak Ula??abilirsiniz!</td>
							</tr>
							</tr>
								<td style="font-size:11px;font-family: Geneva,  tahoma, arial,Helvetica, sans-serif;"><br/><b><a href="http://ep.workcube/index.cfm?fuseaction=myhome.my_targets" class="tableyazi">??lgili Hedef Kayd??</b></a></td>
							<tr>
								<td>&nbsp;</td>
							</tr>
						  </table>
						  </td>
						</tr>
					  </table>
					</td>
				  </tr>
				</table>
			</cfmail>
		</cfif>
	</cfoutput>
</cfif>
