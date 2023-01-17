<cfparam name="attributes.module_id_control" default="3,48">
<cfparam name="attributes.is_excel" default="0">
<cfparam name="attributes.page" default=1>
<cfinclude template="report_authority_control.cfm">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#"> 
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.send_type" default="1">
<cfparam name="attributes.attributes.branch_id" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="0">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfquery name="get_emp_branch" datasource="#DSN#">
	SELECT
		*
	FROM
		EMPLOYEE_POSITION_BRANCHES
	WHERE
		POSITION_CODE = #SESSION.EP.POSITION_CODE#
</cfquery>
<cfset emp_branch_list=valuelist(get_emp_branch.BRANCH_ID)>

<cfquery name="get_branches" datasource="#dsn#">
	SELECT * FROM BRANCH <cfif not session.ep.ehesap>WHERE BRANCH_ID IN (#emp_branch_list#)</cfif> ORDER BY BRANCH_NAME
</cfquery>
<cfsavecontent variable="header"><cf_get_lang dictionary_id ='40060.Puantaj Mail ve Görüntüleme Kontrol Raporu'> : <cfoutput>(#dateformat(now(),dateformat_style)# #timeformat(now(),timeformat_style)#)</cfoutput></cfsavecontent>
<cfform name="puantaj" method="post" action="#request.self#?fuseaction=report.puantaj_mail_kontrol">
    <cf_report_list_search title="#header#">
        <cf_report_list_search_area>
            <div class="row">
                <div class="col col-12 col-xs-12">
                    <div class="row formContent">
                        <div class="row" type="row">
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id='57453.Şube'></label>
                                        <select name="branch_id" id="branch_id">
                                        <option value=""><cf_get_lang dictionary_id='29495.Tüm Şubeler'></option>
                                        <cfoutput query="get_branches">
                                            <option value="#branch_id#" <cfif isdefined("attributes.branch_id") and attributes.branch_id eq branch_id>selected</cfif>>#branch_name#</option>
                                        </cfoutput>	
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id='58960.RaporT'></label>
                                        <select name="send_type" id="send_type">
                                        <option value="1" <cfif isdefined("attributes.send_type") and attributes.send_type eq 1>selected</cfif>><cf_get_lang dictionary_id ='39942.Şube Bazlı'></option>
                                        <option value="2" <cfif isdefined("attributes.send_type") and attributes.send_type eq 2>selected</cfif>><cf_get_lang dictionary_id ='39943.Kişi Bazlı'></option>
                                        </select>    
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">    
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id ='57428.Mail'></label>
                                        <select name="is_mail" id="is_mail">
                                        <option value=""><cf_get_lang dictionary_id ='57734.Mail'></option>
                                        <option value="1" <cfif isdefined("attributes.is_mail") and attributes.is_mail eq 1>selected</cfif>><cf_get_lang dictionary_id ='39944.Mail Gönderilen'></option>
                                        <option value="2" <cfif isdefined("attributes.is_mail") and attributes.is_mail eq 2>selected</cfif>><cf_get_lang dictionary_id ='39945.Mail Gönderilmeyen'></option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id ='40769.Onay Bilgisi'></label>
                                        <select name="is_approved" id="is_approved">
                                        <option value=""><cf_get_lang dictionary_id ='57734.Seç'></option>
                                        <option value="1" <cfif isdefined("attributes.is_approved") and attributes.is_approved eq 1>selected</cfif>><cf_get_lang dictionary_id ='58699.Onaylandı'></option>
                                        <option value="2" <cfif isdefined("attributes.is_approved") and attributes.is_approved eq 2>selected</cfif>><cf_get_lang dictionary_id ='40768.Onaylanmadı'></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id ='40769.Okundu Bilgisi'></label>
                                        <select name="is_read" id="is_read">
                                            <option value=""><cf_get_lang dictionary_id ='57734.Seç'></option>
                                            <option value="1" <cfif isdefined("attributes.is_read") and attributes.is_read eq 1>selected</cfif>><cf_get_lang dictionary_id ='39947.Okuyanlar'></option>
                                            <option value="2" <cfif isdefined("attributes.is_read") and attributes.is_read eq 2>selected</cfif>><cf_get_lang dictionary_id ='39948.Okumayanlar'></option>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id='47723.İçerik Tipi	'></label>	
                                        <select name="is_text" id="is_text">
                                            <option value="1" <cfif isdefined("attributes.is_text") and attributes.is_text eq 1>selected</cfif>><cf_get_lang dictionary_id ='39949.Metinler Gelsin'></option>
                                            <option value="2" <cfif isdefined("attributes.is_text") and attributes.is_text eq 2>selected</cfif>><cf_get_lang dictionary_id ='39950.Metinler Gelmesin'></option>
                                        </select>
                                    </div>
                                </div>
                            </div>
                            <div class="col col-3 col-md-4 col-sm-6 col-xs-12">
                                <div class="col col-12 col-md-12 col-xs-12">
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id ='58724.Ay'></label>
                                        <select name="sal_mon" id="sal_mon">
                                            <cfif session.ep.period_year lt dateformat(now(),'YYYY')>
                                                <cfloop from="1" to="12" index="i">
                                                    <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
                                                </cfloop>
                                            <cfelse>
                                                <cfloop from="1" to="#evaluate(dateformat(now(),'MM'))#" index="i">
                                                    <cfoutput><option value="#i#" <cfif attributes.sal_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
                                                </cfloop>
                                            </cfif>
                                        </select>
                                    </div>
                                    <div class="form-group">
                                        <label class="col col-12 col-md-12 col-xs-12 paddingNone"><cf_get_lang dictionary_id ='58455.Yıl'></label>
                                        <input name="sal_year" id="sal_year" type="text" value="<cfoutput>#attributes.sal_year#</cfoutput>" readonly style="width:50px;">
                                    </div>
                                </div>
                            </div>
                        </div>
                    </div>
                    <div class="row ReportContentBorder">
                        <div class="ReportContentFooter">
                            <label><input type="checkbox" name="is_excel" id="is_excel" value="1" <cfif attributes.is_excel eq 1>checked</cfif>><cf_get_lang dictionary_id='57858.Excel Getir'></label>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
							<cfif session.ep.our_company_info.is_maxrows_control_off eq 1>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" message="#message#" maxlength="3" style="width:25px;">
							<cfelse>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,250" message="#message#" maxlength="3" style="width:25px;">
							</cfif>
                            <input type="hidden" name="is_submit" id="is_submit" value="1">	
                            <cf_wrk_report_search_button button_type="1" is_excel='1' search_function="control()">
                            <cfif isdefined("attributes.send_type") and attributes.send_type eq 2>
                                <cfoutput>
                                    <cfsavecontent variable="title"><cf_get_lang dictionary_id='53276.Puantajı Mail Olarak Gönder'></cfsavecontent>
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.popup_send_puantaj_mails&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&branch_id=#attributes.branch_id#','small');"><img src="/images/mail.gif" border="0" title="<cfoutput>#title#</cfoutput>"></a>
                                </cfoutput>
                            </cfif>
                        </div>
                    </div>
                </div>
            </div> 
        </cf_report_list_search_area>
    </cf_report_list_search>
</cfform>
<cfif attributes.is_excel eq 1>
    <cfset type_ = 1>
    <cfset filename = "#createuuid()#">
    <cfheader name="Expires" value="#Now()#">
    <cfcontent type="application/vnd.msexcel;charset=utf-8">
    <cfheader name="Content-Disposition" value="attachment; filename=#filename#.xls">
    <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<cfelse>
    <cfset type_ = 0>
</cfif>
    
<cfif isdefined("attributes.is_submit")>
        <cfif attributes.send_type eq 1>
                <cfquery name="get_all_mails" datasource="#dsn#">
                    SELECT 
                        B.BRANCH_ID,
                        EP.SAL_MON,
                        EP.SAL_YEAR,
                        B.BRANCH_FULLNAME
                    FROM
                        EMPLOYEES_PUANTAJ EP,
                        BRANCH B
                    WHERE
                        EP.SAL_MON = #attributes.sal_mon# AND
                        EP.SAL_YEAR = #attributes.sal_year# AND
                        <cfif isdefined("attributes.branch_id") and len(attributes.branch_id)>
                                B.BRANCH_ID = #attributes.branch_id# AND
                            <cfelseif not session.ep.ehesap>
                                B.BRANCH_ID IN (#emp_branch_list#) AND
                            <cfelse>
                                B.BRANCH_ID IS NOT NULL AND
                        </cfif>
                        B.SSK_NO = EP.SSK_OFFICE_NO AND
                        B.SSK_OFFICE = EP.SSK_OFFICE
                    ORDER BY B.BRANCH_FULLNAME
                </cfquery>
                <cfif get_all_mails.recordcount>
                    <cfset branch_list = valuelist(get_all_mails.branch_id)>
                    <cfquery name="get_old_mails" datasource="#dsn#">
                        SELECT 
                            * 
                        FROM 
                            EMPLOYEES_PUANTAJ_MAILS 
                        WHERE 
                            BRANCH_ID IN (#branch_list#) AND 
                            SAL_MON = #attributes.sal_mon# AND 
                            SAL_YEAR = #attributes.sal_year# AND
                            EMPLOYEE_ID IS NULL
                        ORDER BY BRANCH_ID
                    </cfquery>
                    <cfset all_branch_list = listsort(listdeleteduplicates(valuelist(get_old_mails.BRANCH_ID,',')),'numeric','ASC',',')>
                </cfif>
            <cfelse>
                <cfquery name="get_all_mails" datasource="#dsn#">
                    SELECT 
                        E.EMPLOYEE_NAME,
                        E.EMPLOYEE_ID,
                        E.EMPLOYEE_SURNAME,
                        E.EMPLOYEE_EMAIL,
                        EP.SAL_MON,
                        EP.SAL_YEAR,
                        B.BRANCH_FULLNAME
                    FROM
                        EMPLOYEES E,
                        EMPLOYEES_PUANTAJ EP,
                        EMPLOYEES_PUANTAJ_ROWS EPR,
                        BRANCH B
                    WHERE
                        B.SSK_NO = EP.SSK_OFFICE_NO AND
                        B.SSK_OFFICE = EP.SSK_OFFICE AND
                        EP.SAL_MON = #attributes.sal_mon# AND
                        EP.SAL_YEAR = #attributes.sal_year# AND
                        EP.PUANTAJ_ID = EPR.PUANTAJ_ID AND
                        EPR.EMPLOYEE_ID = E.EMPLOYEE_ID AND
                        <cfif len(attributes.branch_id)>
                            B.BRANCH_ID = #attributes.branch_id# 
                        <cfelseif not session.ep.ehesap>
                            B.BRANCH_ID IN (#emp_branch_list#) 
                        <cfelse>
                            B.BRANCH_ID IS NOT NULL 
                        </cfif>
                    ORDER BY B.BRANCH_FULLNAME,E.EMPLOYEE_NAME,E.EMPLOYEE_SURNAME
                </cfquery>
                <cfif get_all_mails.recordcount>
                    <cfquery name="get_old_mails" datasource="#dsn#">
                        SELECT 
                            * 
                        FROM 
                            EMPLOYEES_PUANTAJ_MAILS 
                        WHERE 
                            <cfif len(attributes.branch_id)>
                                BRANCH_ID = #attributes.branch_id# AND
                            <cfelseif not session.ep.ehesap>
                                BRANCH_ID IN (#emp_branch_list#) AND
                            <cfelse>
                                BRANCH_ID IS NOT NULL AND
                            </cfif>
                            SAL_MON = #attributes.sal_mon# AND 
                            SAL_YEAR = #attributes.sal_year# AND
                            EMPLOYEE_ID IS NOT NULL
                        ORDER BY EMPLOYEE_ID
                    </cfquery>
                    <cfset all_employee_list = listsort(listdeleteduplicates(valuelist(get_old_mails.EMPLOYEE_ID,',')),'numeric','ASC',',')>
                    <cfset onaylayan_employee_list = "">
                    <cfquery name="get_onaylayanlar" datasource="#dsn#">
                        SELECT 
                            * 
                        FROM 
                            EMPLOYEES_PUANTAJ_MAILS 
                        WHERE 
                            <cfif len(attributes.branch_id)>
                            BRANCH_ID = #attributes.branch_id# AND
                            <cfelseif not session.ep.ehesap>
                            BRANCH_ID IN (#emp_branch_list#) AND
                            <cfelse>
                            BRANCH_ID IS NOT NULL AND
                            </cfif>
                            SAL_MON = #attributes.sal_mon# AND 
                            SAL_YEAR = #attributes.sal_year# AND
                            EMPLOYEE_ID IS NOT NULL AND
                            APPLY_DATE IS NOT NULL
                        ORDER BY EMPLOYEE_ID
                    </cfquery>
                    <cfif get_onaylayanlar.recordcount>
                        <cfset onaylayan_employee_list = listsort(listdeleteduplicates(valuelist(get_onaylayanlar.EMPLOYEE_ID,',')),'numeric','ASC',',')>
                    </cfif>
                    <cfset okuyan_employee_list = "">
                    <cfquery name="get_okuyanlar" datasource="#dsn#">
                        SELECT 
                            * 
                        FROM 
                            EMPLOYEES_PUANTAJ_MAILS 
                        WHERE 
                            <cfif len(attributes.branch_id)>
                            BRANCH_ID = #attributes.branch_id# AND
                            <cfelseif not session.ep.ehesap>
                            BRANCH_ID IN (#emp_branch_list#) AND
                            <cfelse>
                            BRANCH_ID IS NOT NULL AND
                            </cfif>
                            SAL_MON = #attributes.sal_mon# AND 
                            SAL_YEAR = #attributes.sal_year# AND
                            EMPLOYEE_ID IS NOT NULL AND
                            FIRST_READ_DATE IS NOT NULL
                        ORDER BY EMPLOYEE_ID
                    </cfquery>
                    <cfif get_okuyanlar.recordcount>
                        <cfset okuyan_employee_list = listsort(listdeleteduplicates(valuelist(get_okuyanlar.EMPLOYEE_ID,',')),'numeric','ASC',',')>
                    </cfif>
                </cfif>
                <cfquery name="get_protests" datasource="#dsn#">
                    SELECT
                        *
                    FROM
                        EMPLOYEES_PUANTAJ_PROTESTS
                    WHERE
                        SAL_MON = #attributes.sal_mon# AND 
                        SAL_YEAR = #attributes.sal_year# 
                    ORDER BY EMPLOYEE_ID
                </cfquery>
                <cfset main_employee_list = listsort(listdeleteduplicates(valuelist(get_protests.EMPLOYEE_ID,',')),'numeric','ASC',',')>
        </cfif>
        <cfif attributes.is_excel eq 1>
		    <cfset attributes.startrow=1>
            <cfset attributes.maxrows = get_all_mails.recordcount>
	    </cfif>
        <cfform action="" name="uyari_form" id="uyari_form" method="post">
        <cf_report_list>
            <thead>
                    <th width="30"><cf_get_lang dictionary_id ='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='58455.Yıl'></th>
                    <th><cf_get_lang dictionary_id='58724.Ay'></th>
                    <th><cf_get_lang dictionary_id ='57453.Şube'></th>
                    <th><cf_get_lang dictionary_id ='57756.Durum'></th>
                    <th><cf_get_lang dictionary_id ='39951.İlk Mail'></th>
                    <th><cf_get_lang dictionary_id ='55689.Son Mail'></th>
                    <cfif attributes.send_type eq 2>
                        <th><cf_get_lang dictionary_id ='39953.Uyarı Maili'></th>
                        <th><cf_get_lang dictionary_id ='57576.Çalışan'></th>
                        <th><cf_get_lang dictionary_id ='57428.Mail'></th>
                        <th><cf_get_lang dictionary_id ='40769.Onay Bilgisi'></th>
                        <th><cf_get_lang dictionary_id ='39954.İlk Okuma T'>.</th>
                        <th><cf_get_lang dictionary_id ='39955.Son Okuma T'>.</th>
                        <th><cf_get_lang dictionary_id ='39956.Uyarı Okuma T'>.</th>
                        <th><cf_get_lang dictionary_id ='39957.İtiraz'></th>
                        <cfif attributes.is_text eq 1><th width="75"><cf_get_lang dictionary_id ='39958.İtiraz Metni'></th></cfif>
                        <th><cf_get_lang dictionary_id='58654.Cevap'></th>
                        <cfif attributes.is_text eq 1><th width="80"><cf_get_lang dictionary_id ='39959.Cevap Metni'></th></cfif>
                        <th><cf_get_lang dictionary_id='58654.Cevap'></th>
                        <!-- sil --><th>&nbsp;</th>
                        <th class="header_icn_none"><a href="javascript://" onclick="uyari_gonder();"><img src="/images/messenger2.gif" border="0" title="<cf_get_lang dictionary_id ='40060.Puantajı Son Uyarı Olarak Gönder'>"></a><input type="checkbox" name="all_emp_list" id="all_emp_list" onclick="AllCheck();"></th>
                        <!-- sil -->
                    </cfif>
                </tr>
            </thead>
            <cfif get_all_mails.recordcount>
                <cfset the_state = false>
                    <tbody>
                        <cfoutput query="get_all_mails" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                            <cfset is_goster = 1>
                            <cfif attributes.send_type eq 1>
                                <cfif is_goster eq 1>
                                    <cfif isdefined("attributes.is_mail") and attributes.is_mail eq 1 and listlen(all_branch_list) and listfindnocase(all_branch_list,branch_id) and len(get_old_mails.first_mail_date[listfind(all_branch_list,branch_id,',')])>
                                        <cfset is_goster = 1>
                                    <cfelseif isdefined("attributes.is_mail") and attributes.is_mail eq 1>
                                        <cfset is_goster = 0>
                                    </cfif>
                                </cfif>
                                <cfif is_goster eq 1>
                                    <cfif isdefined("attributes.is_mail") and attributes.is_mail eq 2 and (not listlen(all_branch_list) or not listfindnocase(all_branch_list,branch_id))>
                                        <cfset is_goster = 1>
                                    <cfelseif isdefined("attributes.is_mail") and attributes.is_mail eq 2>
                                        <cfset is_goster = 0>
                                    </cfif>
                                </cfif>
                            <cfelseif attributes.send_type eq 2>
                                <cfif is_goster eq 1>
                                    <cfif isdefined("attributes.is_mail") and attributes.is_mail eq 1 and listlen(all_employee_list) and listfindnocase(all_employee_list,employee_id)>
                                        <cfset is_goster = 1>
                                    <cfelseif attributes.is_mail eq 1>
                                        <cfset is_goster = 0>
                                    </cfif>
                                </cfif>
                                <cfif is_goster eq 1>
                                    <cfif attributes.is_mail eq 2 and (not listlen(all_employee_list) or not listfindnocase(all_employee_list,employee_id))>
                                        <cfset is_goster = 1>
                                    <cfelseif attributes.is_mail eq 2>
                                        <cfset is_goster = 0>
                                    </cfif>
                                </cfif>
                                <cfif is_goster eq 1>
                                    <cfif attributes.is_approved eq 1 and listlen(onaylayan_employee_list) and listfindnocase(onaylayan_employee_list,employee_id)>
                                        <cfset is_goster = 1>
                                    <cfelseif attributes.is_approved eq 1>
                                        <cfset is_goster = 0>
                                    </cfif>
                                </cfif>
                                <cfif is_goster eq 1>
                                    <cfif attributes.is_approved eq 2 and (not listlen(onaylayan_employee_list) or not listfindnocase(onaylayan_employee_list,employee_id))>
                                        <cfset is_goster = 1>
                                    <cfelseif attributes.is_approved eq 2>
                                        <cfset is_goster = 0>
                                    </cfif>
                                </cfif>
                                <cfif is_goster eq 1>
                                    <cfif attributes.is_read eq 1 and listlen(okuyan_employee_list) and listfindnocase(okuyan_employee_list,employee_id)>
                                        <cfset is_goster = 1>
                                    <cfelseif attributes.is_read eq 1>
                                        <cfset is_goster = 0>
                                    </cfif>
                                </cfif>
                                <cfif is_goster eq 1>
                                    <cfif attributes.is_read eq 2 and (not listlen(okuyan_employee_list) or not listfindnocase(okuyan_employee_list,employee_id))>
                                        <cfset is_goster = 1>
                                    <cfelseif attributes.is_read eq 2>
                                        <cfset is_goster = 0>
                                    </cfif>
                                </cfif>
                            </cfif>
                            <cfif is_goster eq 1>
                                <cfset uyari_mail_ = 1>
                                <cfset the_state = true>
                                <tr>
                                    <td>#currentrow#</td>
                                    <td>#attributes.sal_year#</td>
                                    <td>#listgetat(ay_list(),attributes.sal_mon)#</td>
                                    <td>#BRANCH_FULLNAME#</td>
                                    <td><cf_get_lang dictionary_id ='39960.Hazırlandı'></td>
                                    <cfif attributes.send_type eq 1>
                                        <td><cfif listlen(all_branch_list) and listfindnocase(all_branch_list,branch_id) and len(get_old_mails.first_mail_date[listfind(all_branch_list,branch_id,',')])>#dateformat(get_old_mails.first_mail_date[listfind(all_branch_list,branch_id,',')],dateformat_style)#</cfif>&nbsp;</td>
                                        <td><cfif listlen(all_branch_list) and listfindnocase(all_branch_list,branch_id) and len(get_old_mails.last_mail_date[listfind(all_branch_list,branch_id,',')])>#dateformat(get_old_mails.last_mail_date[listfind(all_branch_list,branch_id,',')],dateformat_style)#</cfif>&nbsp;</td>
                                    <cfelse>
                                        <td><cfif listlen(all_employee_list) and listfindnocase(all_employee_list,employee_id) and len(get_old_mails.first_mail_date[listfind(all_employee_list,employee_id,',')])>#dateformat(get_old_mails.first_mail_date[listfind(all_employee_list,employee_id,',')],dateformat_style)#<cfset uyari_mail_ = 1></cfif>&nbsp;</td>
                                        <td><cfif listlen(all_employee_list) and listfindnocase(all_employee_list,employee_id) and len(get_old_mails.last_mail_date[listfind(all_employee_list,employee_id,',')])>#dateformat(get_old_mails.last_mail_date[listfind(all_employee_list,employee_id,',')],dateformat_style)#<cfset uyari_mail_ = 1></cfif>&nbsp;</td>
                                    </cfif>
                                    <cfif attributes.send_type eq 2>					
                                        <td><cfif listlen(all_employee_list) and listfindnocase(all_employee_list,employee_id) and len(get_old_mails.cau_mail_date[listfind(all_employee_list,employee_id,',')])>#dateformat(get_old_mails.cau_mail_date[listfind(all_employee_list,employee_id,',')],dateformat_style)#<cfset uyari_mail_ = 0></cfif>&nbsp;</td>
                                        <td>#employee_name# #employee_surname#</td>
                                        <td>#employee_email#&nbsp;</td>
                                        <td><cfif listlen(onaylayan_employee_list) and listfindnocase(onaylayan_employee_list,employee_id) and len(get_onaylayanlar.apply_date[listfind(onaylayan_employee_list,employee_id,',')])>#dateformat(get_old_mails.apply_date[listfind(all_employee_list,employee_id,',')],dateformat_style)#<!---<cfset uyari_mail_ = 0>---><cfelse><cf_get_lang dictionary_id='55467.Onaylamadı'></cfif></td>
                                        <td><cfif listlen(okuyan_employee_list) and listfindnocase(okuyan_employee_list,employee_id) and len(get_okuyanlar.first_read_date[listfind(okuyan_employee_list,employee_id,',')])>#dateformat(get_old_mails.first_read_date[listfind(all_employee_list,employee_id,',')],dateformat_style)#<cfset uyari_mail_ = 0><cfelse><cf_get_lang dictionary_id ='39961.Okumadı'></cfif></td>
                                        <td><cfif listlen(okuyan_employee_list) and listfindnocase(okuyan_employee_list,employee_id) and len(get_okuyanlar.last_read_date[listfind(okuyan_employee_list,employee_id,',')])>
                                                #dateformat(get_okuyanlar.last_read_date[listfind(okuyan_employee_list,employee_id,',')],dateformat_style)#<cfset uyari_mail_ = 0>
                                            <cfelse>
                                                <cf_get_lang dictionary_id ='39961.Okumadı'>
                                            </cfif>
                                        </td>
                                        <td>&nbsp;</td>
                                        <td><cfif listfindnocase(main_employee_list,employee_id)>#dateformat(get_protests.PROTEST_DATE[listfind(main_employee_list,employee_id,',')],dateformat_style)#&nbsp;<cfelse>&nbsp;</cfif></td>
                                        <cfif attributes.is_text eq 1><td><cfif listfindnocase(main_employee_list,employee_id)>#get_protests.PROTEST_DETAIL[listfind(main_employee_list,employee_id,',')]#&nbsp;<cfelse>&nbsp;</cfif></td></cfif>
                                        <td><cfif listfindnocase(main_employee_list,employee_id)>#dateformat(get_protests.ANSWER_DATE[listfind(main_employee_list,employee_id,',')],dateformat_style)#&nbsp;<cfelse>&nbsp;</cfif></td>
                                        <cfif attributes.is_text eq 1><td><cfif listfindnocase(main_employee_list,employee_id)>#get_protests.ANSWER_DETAIL[listfind(main_employee_list,employee_id,',')]#&nbsp;<cfelse>&nbsp;</cfif></td></cfif>
                                        <td><cfif listfindnocase(main_employee_list,employee_id) and len(get_protests.ANSWER_DETAIL[listfind(main_employee_list,employee_id,',')])><img src="/images/control.gif" border="0"><cfelse>&nbsp;</cfif></td>
                                        <!-- sil -->
                                        <td><a href="javascript://" onclick="windowopen('#request.self#?fuseaction=report.popup_send_puantaj_mails&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#&branch_id=#attributes.branch_id#&employee_id=#employee_id#','small');"><img src="/images/mail.gif" border="0" title="<cf_get_lang dictionary_id ='40063.Puantajı Mail Olarak Gönder'>"></a></td>
                                        <td><cfif uyari_mail_ eq 1><input type="checkbox" name="employee_id_list" id="employee_id_list" value="#employee_id#"><cfelse>&nbsp;</cfif></td>
                                        <!-- sil -->
                                    </cfif>
                                </tr>
                            </cfif>
                        </cfoutput>
                        <cfif the_state eq false>
                            <tr>
                                <td colspan="21"><cfif isdefined('attributes.is_submit')><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
                            </tr>
                        </cfif>
                    </tbody>
            <cfelse>
                <tbody>
                    <tr>
                        <td colspan="21"><cfif isdefined('attributes.is_submit')><cf_get_lang dictionary_id='57484.Kayıt Yok'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
                    </tr>
                </tbody>
		    </cfif>
            <cfset attributes.totalrecords=get_all_mails.recordcount>
        </cf_report_list>
        </cfform>
        <cfif attributes.totalrecords gt attributes.maxrows>
                <cfset url_str = "">
                <cfif isdefined("attributes.is_submit") and len(attributes.is_submit)>
                    <cfset url_str = "#url_str#&is_submit=#attributes.is_submit#">
                </cfif>
                    <cfset url_str = "#url_str#&branch_id=#attributes.branch_id#">
               
                <cfif isdefined("attributes.send_type") and len(attributes.send_type)>
                    <cfset url_str = "#url_str#&send_type=#attributes.send_type#">
                </cfif>
                    <cfset url_str = "#url_str#&is_mail=#attributes.is_mail#">
                    <cfset url_str = "#url_str#&is_approved=#attributes.is_approved#">
                    <cfset url_str = "#url_str#&is_read=#attributes.is_read#">
                <cfif isdefined("attributes.is_text") and len(attributes.is_text)>
                    <cfset url_str = "#url_str#&is_text=#attributes.is_text#">
                </cfif>
                <cfif len(attributes.sal_year)>
                    <cfset url_str = "#url_str#&sal_year=#attributes.sal_year#">
                </cfif>
                <cfif attributes.is_excel eq 0>
                    <cf_paging page="#attributes.page#"
                    maxrows="#attributes.maxrows#"
                    totalrecords="#attributes.totalrecords#"
                    startrow="#attributes.startrow#"
                    adres="#attributes.fuseaction#&#url_str#"> 
                </cfif>
        </cfif>
</cfif>
<script type="text/javascript">
    function control()	
	{
            if(document.puantaj.is_excel.checked==false)
            {
                document.puantaj.action="<cfoutput>#request.self#?fuseaction=#attributes.fuseaction#</cfoutput>"
                return true;
            }
            else
                document.puantaj.action="<cfoutput>#request.self#?fuseaction=#fusebox.circuit#.emptypopup_puantaj_mail_kontrol</cfoutput>"
    }
    
  
    function AllCheck(){
       
         $("table.report_list tbody input[name=employee_id_list]").each(function(){
            // console.log($(this).val());

            if($("input[name=all_emp_list]").is(":checked"))
            {
                if(!$(this).is(":checked"))
                {
                    $(this).prop("checked",true);       
                }
            }

            else
            {
                if($(this).is(":checked")){
                    $(this).prop("checked",false);
                }
            }

         });


    }

	function uyari_gonder()
	{
		windowopen('','small','uyari_window');
		uyari_form.action='<cfoutput>#request.self#?fuseaction=report.popup_send_puantaj_uyari_mails&sal_mon=#attributes.sal_mon#&sal_year=#attributes.sal_year#</cfoutput>';
		uyari_form.target='uyari_window';
		uyari_form.submit();
	}

</script>
