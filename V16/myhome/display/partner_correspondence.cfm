<cfsetting showdebugoutput="no"> 
<cfif isdefined('attributes.list_partner') and ListLen(attributes.list_partner,',')>
<cfif listlen(list_partner)><!--- Firmanın partner'ı varsa --->
	<!---<cfquery name="get_partner_correspondence" datasource="#dsn#">
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
            C.TO_PARS LIKE '%,#attributes.cpid#,%' OR
            <cfif len(list_partner)>
            	<cfloop list="#list_partner#" index="cc">
            	C.TO_PARS LIKE '%,#cc#,%' OR  
              	</cfloop>
            </cfif>
            C.CC_PARS LIKE '%,#attributes.cpid#,%' OR
            C.BCC_PARS LIKE '%,#attributes.cpid#,%' OR 
            C.RECORD_EMP = #attributes.cpid#
    </cfquery> --->
	<cfquery name="GET_PARTNER_CORRESPONDENCE" datasource="#DSN#">
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
       	','+C.TO_COMP+',' LIKE '%,#attributes.cpid#,%' 
       	 <cfif len(list_partner)>		
			<cfif len(list_partner)>
			OR
			(
        		<cfloop list="#list_partner#" index="cc">
			(
        	        (','+C.TO_PARS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#cc#,%">) OR                
        	        (','+C.TO_PARS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#cc#,%">) OR  
        	        (','+C.CC_PARS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#cc#,%">) OR
        	        (','+C.BCC_PARS+',' LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%,#cc#,%">) OR 
        	        (C.RECORD_PAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#cc#">)
			)
			<cfif cc neq listlast(list_partner,',')>OR</cfif>
			
        		</cfloop>
			)
</cfif>
        	</cfif>
	</cfquery>
<cfelse>
	<cfset get_partner_correspondence.recordcount=0>
</cfif>	
<cf_ajax_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id ='57480.Konu'></th>
            <th><cf_get_lang dictionary_id ='31752.Gönderilenler'></th>
            <th><cf_get_lang dictionary_id ='31756.Bilgi Verilen'></th>
            <th><cf_get_lang dictionary_id ='31757.Gizli Gönderim'></th>
            <th><cf_get_lang dictionary_id ='31753.Gönderim Tarihi'></th>
            <th><cf_get_lang dictionary_id ='31754.Gönderen'></th>
        </tr>
    </thead>
    <tbody>
    <cfif get_partner_correspondence.recordcount>
    <cfoutput query="get_partner_correspondence">
        <tr>
            <td nowrap="nowrap"><a href="#request.self#?fuseaction=correspondence.upd_correspondence&id=#id#">
                #SUBJECT#</a>
            </td>
            <td nowrap="nowrap">&nbsp;
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
                        <li>#get_info_comp.FULLNAME#<br />
                    <cfelse>
                        <cfquery name="get_info_par" datasource="#dsn#">
                            SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = '#CC#'
                        </cfquery>
                        <cfif get_info_par.recordcount>
                            <cfif sayac_comp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31100.Kurumsal'></font></cfif>
                            <cfset sayac_comp = 1>
                            <li>#get_info_par.COMPANY_PARTNER_NAME# #get_info_par.COMPANY_PARTNER_SURNAME# <br />
                        <cfelse>
                            <cfquery name="get_info_con" datasource="#dsn#">
                                SELECT CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_EMAIL = '#cc#'
                            </cfquery>
                            <cfif get_info_con.recordcount>
                                <cfif sayac_con eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31101.Bireysel'></font></cfif>
                                <cfset sayac_con = 1>
                                <li>#get_info_con.CONSUMER_NAME# #get_info_con.CONSUMER_SURNAME# 
                            <cfelse>
                                <cfquery name="get_info_emp" datasource="#dsn#">
                                    SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_EMAIL = '#cc#'
                                </cfquery>
                                <cfif get_info_emp.recordcount>
                                    <cfif sayac_emp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='57576.Çalışan'></font></cfif>
                                    <cfset sayac_emp = 1>
                                    <li>#get_info_emp.EMPLOYEE_NAME# #get_info_emp.EMPLOYEE_SURNAME# 
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
                        <li>#get_info_comp.FULLNAME#<br />
                    <cfelse>
                        <cfquery name="get_info_par" datasource="#dsn#">
                            SELECT COMPANY_PARTNER_NAME,COMPANY_PARTNER_SURNAME FROM COMPANY_PARTNER WHERE COMPANY_PARTNER_EMAIL = '#CC#'
                        </cfquery>
                        <cfif get_info_par.recordcount>
                            <cfif sayac_comp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31100.Kurumsal'></font></cfif>
                            <cfset sayac_comp = 1>
                            <li>#get_info_par.COMPANY_PARTNER_NAME# #get_info_par.COMPANY_PARTNER_SURNAME# <br />
                        <cfelse>
                            <cfquery name="get_info_con" datasource="#dsn#">
                                SELECT CONSUMER_NAME, CONSUMER_SURNAME FROM CONSUMER WHERE CONSUMER_EMAIL = '#cc#'
                            </cfquery>
                            <cfif get_info_con.recordcount>
                                <cfif sayac_con eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='31101.Bireysel'></font></cfif>
                                <cfset sayac_con = 1>
                                <li>#get_info_con.CONSUMER_NAME# #get_info_con.CONSUMER_SURNAME# 
                            <cfelse>
                                <cfquery name="get_info_emp" datasource="#dsn#">
                                    SELECT EMPLOYEE_NAME, EMPLOYEE_SURNAME FROM EMPLOYEES WHERE EMPLOYEE_EMAIL = '#cc#'
                                </cfquery>
                                <cfif get_info_emp.recordcount>
                                    <cfif sayac_emp eq 0><font color="FFF0000" style="font-style:normal"><cf_get_lang dictionary_id='57576.Çalışan'></font></cfif>
                                    <cfset sayac_emp = 1>
                                    <li>#get_info_emp.EMPLOYEE_NAME# #get_info_emp.EMPLOYEE_SURNAME# 
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
            <td nowrap="nowrap">---</td>
            <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
            <td><cfif len(mail_from)>#get_emp_info(mail_from,0,1)#<cfelse>#get_emp_info(session.ep.userid,0,1)#</cfif></td>
        </tr>
        </cfoutput>	
        <cfelse>
            <tr>
                <td colspan="6"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !</td>
            </tr>
        </cfif>
    </tbody>
</cf_ajax_list>
</cfif>
