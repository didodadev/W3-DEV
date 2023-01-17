<cfparam name="attributes.ssk_office_" default="">
<cfparam name="attributes.sal_year" default="#year(now())#">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfinclude template="../query/get_branch.cfm">
<cfif isdefined("attributes.form_submitted")>
<cfquery name="GET_SSK_XML_EXPORTS" datasource="#DSN#">
    SELECT 
        EMPLOYEES_SSK_EXPORTS.SSK_OFFICE,
        EMPLOYEES_SSK_EXPORTS.SSK_OFFICE_NO,
        EMPLOYEES_SSK_EXPORTS.RECORD_DATE,
        EMPLOYEES_SSK_EXPORTS.IS_5073,
        EMPLOYEES_SSK_EXPORTS.IS_5084,
        EMPLOYEES_SSK_EXPORTS.IS_5615,
        EMPLOYEES_SSK_EXPORTS.IS_5510,
        EMPLOYEES_SSK_EXPORTS.IS_5921,
        EMPLOYEES_SSK_EXPORTS.IS_5746,
        EMPLOYEES_SSK_EXPORTS.IS_4691,
        EMPLOYEES_SSK_EXPORTS.IS_6111,
        EMPLOYEES_SSK_EXPORTS.IS_6486,
        EMPLOYEES_SSK_EXPORTS.IS_6322,
        EMPLOYEES_SSK_EXPORTS.IS_25510,
        EMPLOYEES_SSK_EXPORTS.IS_14857,
        EMPLOYEES_SSK_EXPORTS.IS_6645,
        EMPLOYEES_SSK_EXPORTS.IS_46486,
        EMPLOYEES_SSK_EXPORTS.IS_56486,
        EMPLOYEES_SSK_EXPORTS.IS_66486,
        EMPLOYEES_SSK_EXPORTS.IS_687,
        EMPLOYEES_SSK_EXPORTS.IS_17103,
        EMPLOYEES_SSK_EXPORTS.IS_27103,
        EMPLOYEES_SSK_EXPORTS.IS_37103,
        EMPLOYEES_SSK_EXPORTS.ESE_ID,
        EMPLOYEES_SSK_EXPORTS.FILE_NAME,
        EMPLOYEES_SSK_EXPORTS.SAL_MON,
        BRANCH.BRANCH_NAME,
        EMPLOYEES.EMPLOYEE_NAME,
        EMPLOYEES.EMPLOYEE_SURNAME
    FROM 
        EMPLOYEES_SSK_EXPORTS,
        EMPLOYEES,
        BRANCH
    WHERE
        BRANCH.BRANCH_ID = EMPLOYEES_SSK_EXPORTS.SSK_BRANCH_ID AND
        EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_SSK_EXPORTS.RECORD_EMP 
        <cfif not session.ep.ehesap>
        AND BRANCH.BRANCH_ID IN 
                    (
                    SELECT
                        BRANCH_ID
                    FROM
                        EMPLOYEE_POSITION_BRANCHES
                    WHERE
                        EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.position_code#">
                    )
        </cfif>
		<cfif len(attributes.sal_year)>
			AND EMPLOYEES_SSK_EXPORTS.SAL_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_year#">
		</cfif>
		<cfif len(attributes.sal_mon)>
			AND EMPLOYEES_SSK_EXPORTS.SAL_MON = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sal_mon#">
		</cfif>
		<cfif len(attributes.ssk_office_)>
			AND BRANCH.BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.ssk_office_#">
		</cfif>
    ORDER BY
        EMPLOYEES_SSK_EXPORTS.RECORD_DATE DESC
</cfquery>
<cfelse>
    <cfset get_ssk_xml_exports.recordcount = 0>
</cfif> 

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_ssk_xml_exports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="search" action="#request.self#?fuseaction=ehesap.list_ssk_xml_export" method="post">
            <cf_box_search more="0">
                <input type="hidden" name="form_submitted" id="form_submitted" value="1">
                <div class="form-group">
                    <select name="ssk_office_" id="ssk_office_">
                        <option value=""><cf_get_lang dictionary_id ='53806.İşyeri'></option>
                        <cfoutput query="get_branch">
                            <cfif len("#ssk_office##ssk_no#")>
                                <option value="#BRANCH_ID#"<cfif attributes.ssk_office_ is '#ssk_office#-#ssk_no#'> selected</cfif>>#branch_name#-#ssk_office#-#ssk_no#</option>
                            </cfif>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group">
                    <select name="sal_mon" id="sal_mon">
                        <cfloop from="1" to="12" index="i">
                            <cfset ay_bu=ListGetAt(ay_list(),i)>
                            <cfoutput><option value="#i#" <cfif attributes.sal_mon eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="sal_year" id="sal_year">
                        <option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
                        <cfloop from="-5" to="5" index="i">
                            <cfoutput><option value="#session.ep.period_year + i#"<cfif attributes.sal_year eq (session.ep.period_year + i)> selected</cfif>>#session.ep.period_year + i#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" onKeyUp="isNumber(this)" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53805.SGK Aylık E-Bildirge XML Dosya Listesi"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id ='53806.İşyeri'></th>
                    <th><cf_get_lang dictionary_id ='53807.SSK Şube Adı SSK Şube İşyeri No'></th>
                    <th><cf_get_lang dictionary_id ='53808.Yıl  Ay'></th>
                    <th><cf_get_lang dictionary_id='57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
                    <th>5073</th>
                    <th>5084</th>
                    <th>5615</th>
                    <th>5763</th>
                    <th>5921</th>
                    <th>5746</th>
                    <th>4691</th>
                    <th>6111</th>
                    <th>6486</th>
                    <th>6322</th>
                    <th>25510</th>
                    <th>14857</th>
                    <th>6645</th>
                    <th>46486</th>
                    <th>56486</th>
                    <th>66486</th>
                    <th>00687</th>
                    <th>17103</th>
                    <th>27103</th>
                    <th>37103</th>
                    <!-- sil -->
                    <th width="20" class="header_icn_none text-center">
                        <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_form_export_ssk_xml','','ui-draggable-box-medium');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='53812.E-Bildirge Ekle'>" alt="<cf_get_lang dictionary_id ='53812.E-Bildirge Ekle'>"></i></a>
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
            <cfif get_ssk_xml_exports.recordcount>
                <cfoutput query="get_ssk_xml_exports" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td width="35">#currentrow#</td>
                        <td>#branch_name#</td>
                        <td>#ssk_office# / #ssk_office_no#</td>
                        <td>#sal_year# / #ListGetAt(ay_list(),get_ssk_xml_exports.sal_mon)#</td>
                        <td>#employee_name# #employee_surname#</td>
                        <td>#dateformat(record_date,dateformat_style)# (#timeformat(date_add("h",session.ep.time_zone,record_date),timeformat_style)#)</td>
                        <td align="center"><cfif is_5073 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_5084 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_5615 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_5510 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_5921 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_5746 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_4691 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_6111 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_6486 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_6322 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_25510 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_14857 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_6645 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_46486 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_56486 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_66486 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_687 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_17103 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_27103 eq 1>+<cfelse>-</cfif></td>
                        <td align="center"><cfif is_37103 eq 1>+<cfelse>-</cfif></td>
                        <!-- sil -->
                        <td align="center" nowrap="nowrap">
                            <!---<cfif session.ep.ehesap>--->
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53809.Kayıtlı E-Bildirgeyi Siliyorsunuz  Emin misiniz'></cfsavecontent>
                                <a href="javascript://" onClick="if (confirm('#message#')) windowopen('#request.self#?fuseaction=ehesap.emptypopup_del_export_ssk_xml&ese_id=#ese_id#','medium');"><img src="/images/delete_list.gif" title="<cf_get_lang dictionary_id ='53810.E-Bildirge Sil'> !" border="0"></a>
                            <!---</cfif>--->
                            <a href="#file_web_path#hr#dir_seperator#ebildirge#dir_seperator##file_name#"><img src="/images/download.gif" title="<cf_get_lang dictionary_id ='53811.E-Bildirge XML Dosyası '>!"></a>
                        </td>
                        <!-- sil -->
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="27"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
                    </tr>
                </cfif>
            </tbody>
        </cf_grid_list>

        <cfset adres=attributes.fuseaction>
        <cfif isdefined ("attributes.sal_year")>
            <cfset adres = "#adres#&sal_year=#attributes.sal_year#">
        </cfif>
        <cfif isdefined ("attributes.sal_mon")>
            <cfset adres = "#adres#&sal_mon=#attributes.sal_mon#">
        </cfif>
        <cfif isdefined("attributes.ssk_office")>
            <cfset adres = "#adres#&ssk_office=#attributes.ssk_office#">
        </cfif>
        <cfif isdefined("attributes.form_submitted")>
            <cfset adres = "#adres#&form_submitted=#attributes.form_submitted#">
        </cfif>
        <cf_paging
            page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="#adres#">
    </cf_box>
</div>