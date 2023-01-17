<cfsetting showdebugoutput="no">
<cfset category_list = ''>
<cfquery name="GET_CONSUMER_CORRESPONDENCE" datasource="#dsn#">
   SELECT 
		C.ID,
		C.RECORD_EMP AS MAIL_FROM,
		C.MAIL_TO,
		C.SUBJECT,
		C.MAIL_CC,
		C.RECORD_DATE
	FROM 
		CORRESPONDENCE C
	WHERE
		C.TO_CONS LIKE '%,#attributes.cid#,%' OR
		C.CC_CONS LIKE '%,#attributes.cid#,%' OR
		C.BCC_CONS LIKE '%,#attributes.cid#,%' OR 
		C.RECORD_EMP = #attributes.cid#
</cfquery>
<cf_ajax_list>
	<thead>
		<tr>
			<th><cf_get_lang dictionary_id ='57480.Başlık'></th>
			<th><cf_get_lang dictionary_id ='31752.Gönderilenler'></th>
			<th><cf_get_lang dictionary_id ='31756.Bilgi Verilen'></th>
			<th><cf_get_lang dictionary_id ='31757.Gizli Gönderim'></th>
			<th><cf_get_lang dictionary_id ='31753.Gönderim Tarihi'></th>
			<th><cf_get_lang dictionary_id ='31754.Gönderen'></th>
		</tr>
	</thead>
    <tbody>
	<cfif get_consumer_correspondence.recordcount>
	<cfoutput query="get_consumer_correspondence">
		<tr>
			<td nowrap="nowrap">
            	<a href="#request.self#?fuseaction=correspondence.upd_correspondence&id=#id#">#subject#</a>
            </td>
			<td nowrap="nowrap">
			<cfif len(MAIL_TO)>
                <cfset sayac_comp = 0>
				<cfset sayac_con = 0>
				<cfset sayac_emp = 0>
					<cfloop list="#MAIL_TO#" index="cc">
						<cfquery name="get_info_comp" datasource="#dsn#">
							SELECT FULLNAME FROM COMPANY WHERE COMPANY_EMAIL = '#cc#'
						</cfquery>
						<cfif get_info_comp.recordcount>
							<cfif sayac_comp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31100.Kurumsal'></font></cfif>
							<cfset sayac_comp = 1>
							<li>#get_info_comp.FULLNAME#</li>
						<cfelse>
							<cfquery name="get_info_par" datasource="#dsn#">
								SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = '#CC#'
							</cfquery>
								<cfif get_info_par.recordcount>
									<cfif sayac_comp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31100.Kurumsal'></font></cfif>
									<cfset sayac_comp =1>
									<li>#get_info_par.COMPANY_PARTNER_NAME# #get_info_par.COMPANY_PARTNER_SURNAME#</li>
								<cfelse>
									<cfquery name="get_info_con" datasource="#dsn#">
										SELECT CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_EMAIL = '#cc#'
									</cfquery>
									<cfif get_info_con.recordcount>
										<cfif sayac_con eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31101.Bireysel'></font></cfif>
										<cfset sayac_con = 1>
										<li>#get_info_con.CONSUMER_NAME# #get_info_con.CONSUMER_SURNAME#</li>
									<cfelse>
										<cfquery name="get_info_emp" datasource="#dsn#">
											SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_EMAIL = '#cc#'
										</cfquery>
										<cfif get_info_emp.recordcount>
											<cfif sayac_emp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='57576.Çalışan'></font></cfif>
											<cfset sayac_emp = 1>
											<li>#get_info_emp.EMPLOYEE_NAME# #get_info_emp.EMPLOYEE_SURNAME#</li>
										<cfelse>
											---
										</cfif>
									</cfif>
									<br />
								</cfif>
						</cfif>
					</cfloop>
			<cfelse>
				---
			</cfif>
			</td>
			<td nowrap="nowrap">
			<cfif len(mail_cc)>
				<cfset sayac_comp = 0>
				<cfset sayac_con = 0>
				<cfset sayac_emp = 0>
					<cfloop list="#mail_cc#" index="cc">
						<cfquery name="get_info_comp" datasource="#dsn#">
							SELECT FULLNAME FROM COMPANY WHERE COMPANY_EMAIL = '#cc#'
						</cfquery>
						<cfif get_info_comp.recordcount>
							<cfif sayac_comp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31100.Kurumsal'></font></cfif>
							<cfset sayac_comp = 1>
							<li>#get_info_comp.FULLNAME#</li>
						<cfelse>
							<cfquery name="get_info_par" datasource="#dsn#">
								SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = '#CC#'
							</cfquery>
								<cfif get_info_par.recordcount>
									<cfif sayac_comp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31100.Kurumsal'></font></cfif>
									<cfset sayac_comp =1>
									<li>#get_info_par.COMPANY_PARTNER_NAME# #get_info_par.COMPANY_PARTNER_SURNAME#</li>
								<cfelse>
									<cfquery name="get_info_con" datasource="#dsn#">
										SELECT CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_EMAIL = '#cc#'
									</cfquery>
									<cfif get_info_con.recordcount>
										<cfif sayac_con eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31101.Bireysel'></font></cfif>
										<cfset sayac_con = 1>
										<li>#get_info_con.CONSUMER_NAME# #get_info_con.CONSUMER_SURNAME#</li>
									<cfelse>
										<cfquery name="get_info_emp" datasource="#dsn#">
											SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_EMAIL = '#cc#'
										</cfquery>
										<cfif get_info_emp.recordcount>
											<cfif sayac_emp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='57576.Çalışan'></font></cfif>
											<cfset sayac_emp = 1>
											<li>#get_info_emp.EMPLOYEE_NAME# #get_info_emp.EMPLOYEE_SURNAME#</li>
										<cfelse>
											---
										</cfif>
									</cfif>
									<br />
								</cfif>
						</cfif>
					</cfloop>
				<cfelse>
					---
				</cfif>
			</td>
			<td>---</td>
			<td>#dateformat(record_date,dateformat_style)#</td>
			<td><cfif len(mail_from)>#get_emp_info(mail_from,0,1)#<cfelse>#get_emp_info(session.ep.userid,0,1)#</cfif></td>
		</tr>
	</cfoutput>	
	<cfelse>
	<tr>
		<td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Yok'> !</td>
	</tr>
</cfif>
</tbody>
<cf_ajax_list>
