<cfsetting showdebugoutput="no">
<cfquery name="GET_OPPORTUNITY_PLUSES" datasource="#DSN3#">
	SELECT 
		COMMETHOD_ID,
		EMPLOYEE_ID, 
		MAIL_CC, 
		MAIL_SENDER,OPP_ID, 
		OPP_PLUS_ID, 
		OPP_ZONE,
		PARTNER_ID, 
		PLUS_CONTENT, 
		PLUS_DATE, 
		PLUS_SUBJECT, 
		RECORD_DATE, 
		RECORD_EMP, 
		RECORD_IP, 
		RECORD_PAR, 
		UPDATE_DATE, 
		UPDATE_IP, 
		UPDATE_EMP,
		UPDATE_PAR FROM 
		OPPORTUNITIES_PLUS 
	WHERE 
		OPP_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#listgetat(attributes.opp_id,1,',')#"> ORDER BY RECORD_DATE DESC
</cfquery>
<table cellspacing="1" cellpadding="2" border="0" style="width:98%;">
    <tr>
		<td><a onclick="gizle_goster(my_add_plus);" style="cursor:pointer;"><img src="/images/pod_add.gif" border="0"></a>
			<b><cf_get_lang no='1617.Yeni takip notu eklemek için tıklayınız'>...<b>
		</td>
	</tr>
	<tr style="display:none;" id="my_add_plus" class="color-row">
		<td><cfinclude template="add_opp_plus.cfm"></td>
	</tr>
  	<cfoutput query="get_opportunity_pluses">
	  	<tr class="color-row">
			<td>
		  		<cfif len(plus_date)><b><cf_get_lang_main no='71.Kayit'></b> #dateformat(plus_date,'dd/mm/yyyy')#</cfif> -
		  		<cfif len(record_emp)>#get_emp_info(record_emp,0,0)#<cfelse>#get_par_info(record_par,0,0,0)#</cfif>
		  		<cfif len(commethod_id)>&nbsp; -
					<cfset attributes.commethod_id = commethod_id>
					<cfquery name="GET_COMMETHOD" datasource="#DSN#">
						SELECT 
							COMMETHOD 
						FROM
							SETUP_COMMETHOD
						<cfif isDefined("attributes.commethod_id")>
							WHERE
								COMMETHOD_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.commethod_id#">
						</cfif>
					</cfquery>
					#get_commethod.commethod#<br/>
		  		</cfif>
		  		<br/>
		  		<cfif mail_sender neq ''><b><cf_get_lang no='1564.Mail Gönderilenler'></b> : #mail_sender#<br/></cfif>
		  		<br/>
				<cfif record_par eq session.pp.userid>
					<a onclick="gizle_goster(my_upd_plus#currentrow#);" style="cursor:pointer;"><img src="/images/pod_edit.gif" border="0"></a>
				</cfif>
		 	 	#plus_content#
          		<hr />
			</td>
	  	</tr>
	  	<tr style="display:none;" id="my_upd_plus#currentrow#" class="color-row">
			<td><cfinclude template="upd_opp_plus.cfm"></td>
	  	</tr>
  	</cfoutput>
</table>

