<!---
File: list_muhtasar_xml_export.cfm
Author: Team Yazılım - Yunus Özay <yunusozay@gmail.com>
Edit: Workcube - Esma Uysal <esmauysal@workcube.com>
Controller: MuhtasarXMLExportController.cfm
--->
<cfset drc_name_ = "#dateformat(now(),'yyyymmdd')#">
<cfset file_name = "2018_all_20181016144808.xls">

<cfset is_control = 2>

<cfparam name="attributes.ssk_office_" default="">
<cfparam name="attributes.sal_year" default="#session.ep.period_year#">
<cfparam name="attributes.sal_mon" default="#dateformat(date_add('m',-1,now()),'MM')#">
<cfinclude template="../query/get_branch.cfm">
<cfif isdefined("attributes.form_submitted")>

<cfquery name="GET_SSK_XML_EXPORTS" datasource="#DSN#">
    SELECT 
        EMPLOYEES_MUHTASAR_EXPORTS.SSK_OFFICE,
        EMPLOYEES_MUHTASAR_EXPORTS.SSK_OFFICE_NO,
        EMPLOYEES_MUHTASAR_EXPORTS.RECORD_DATE,
        EMPLOYEES_MUHTASAR_EXPORTS.EME_ID,
        EMPLOYEES_MUHTASAR_EXPORTS.EXCEL_FILE_NAME,
		EMPLOYEES_MUHTASAR_EXPORTS.FILE_NAME,
		EMPLOYEES_MUHTASAR_EXPORTS.FILE_NAME_7103,
        EMPLOYEES_MUHTASAR_EXPORTS.SAL_MON,
		EMPLOYEES_MUHTASAR_EXPORTS.SAL_YEAR,
		EMPLOYEES_MUHTASAR_EXPORTS.EXPORT_REASON,
		EMPLOYEES_MUHTASAR_EXPORTS.EXPORT_TYPE,
		EMPLOYEES_MUHTASAR_EXPORTS.SSK_BRANCH_ID,
		EMPLOYEES_MUHTASAR_EXPORTS.COMPANY_ID,
        BRANCH.BRANCH_NAME,
		OUR_COMPANY.COMPANY_NAME,
        EMPLOYEES.EMPLOYEE_NAME,
        EMPLOYEES.EMPLOYEE_SURNAME,
        EMPLOYEES_MUHTASAR_EXPORTS.EXCEL_XLS_FILE_NAME,
        EMPLOYEES_MUHTASAR_EXPORTS.TOTAL_FILE_NAME,
        FILE_NAME_5746
    FROM 
        EMPLOYEES_MUHTASAR_EXPORTS
			LEFT JOIN BRANCH ON (BRANCH.BRANCH_ID = EMPLOYEES_MUHTASAR_EXPORTS.SSK_BRANCH_ID)
			LEFT JOIN OUR_COMPANY ON (OUR_COMPANY.COMP_ID = EMPLOYEES_MUHTASAR_EXPORTS.COMPANY_ID)
		,
        EMPLOYEES
    WHERE
        EMPLOYEES.EMPLOYEE_ID = EMPLOYEES_MUHTASAR_EXPORTS.RECORD_EMP 
		<cfif len(attributes.sal_year)>
			AND EMPLOYEES_MUHTASAR_EXPORTS.SAL_YEAR = #attributes.sal_year#
		</cfif>
		<cfif len(attributes.sal_mon)>
			AND EMPLOYEES_MUHTASAR_EXPORTS.SAL_MON = #attributes.sal_mon#
		</cfif>
		<cfif len(attributes.ssk_office_)>
			AND BRANCH.BRANCH_ID = #attributes.ssk_office_#
        </cfif>
        <cfif not session.ep.ehesap>
            AND 
            (
                (
                    BRANCH.BRANCH_ID IN 
                    (
                        SELECT
                            BRANCH_ID
                        FROM
                            EMPLOYEE_POSITION_BRANCHES
                        WHERE
                            EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#
                    )
                )
                OR
                (
                    EMPLOYEES_MUHTASAR_EXPORTS.RECORD_EMP = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.userid#">
                )
            )
        </cfif>
    ORDER BY
        EMPLOYEES_MUHTASAR_EXPORTS.RECORD_DATE DESC
</cfquery>
<cfelse>
    <cfset get_ssk_xml_exports.recordcount = 0>
</cfif> 
<cfset ay_list_ = ay_list()>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default='#get_ssk_xml_exports.recordcount#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-xs-12">
    <cf_box>
        <cfform name="search" action="#request.self#?fuseaction=ehesap.list_muhtasar_xml_export" method="post">
            <input type="hidden" name="form_submitted" id="form_submitted" value="1">
            <cf_box_search>
                <div class="form-group">
                    <select name="ssk_office_" id="ssk_office_">
                        <option value=""><cf_get_lang dictionary_id ='53807.SSK Şube Adı SSK Şube İşyeri No'></option>
                        <cfoutput query="get_branch">
                            <cfif len("#ssk_office##ssk_no#")>
                                <option value="#BRANCH_ID#"<cfif attributes.ssk_office_ is '#ssk_office#-#ssk_no#'> selected</cfif>>#branch_name#-#ssk_office#-#ssk_no#</option>
                            </cfif>
                        </cfoutput>
                    </select>
                </div>
                <div class="form-group"><select name="sal_mon" id="sal_mon">
                        <cfloop from="1" to="12" index="i">
                            <cfset ay_bu=ListGetAt(ay_list_,i)>
                            <cfoutput><option value="#i#" <cfif attributes.sal_mon eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group">
                    <select name="sal_year" id="sal_year">
                        <option value=""><cf_get_lang dictionary_id='58455.Yıl'></option>
                        <cfloop from="-5" to="5" index="i">
                            <cfoutput><option value="#session.ep.period_year + i#"<cfif session.ep.period_year eq (session.ep.period_year + i)> selected</cfif>>#session.ep.period_year + i#</option></cfoutput>
                        </cfloop>
                    </select>
                </div>
                <div class="form-group small">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Kayıt Sayısı Hatalı',57537)#" maxlength="3">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
    <cf_box title="#getLang(dictionary_id : 47453)#" uidrop="1" hide_table_column="1">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="35"><cf_get_lang dictionary_id='58577.Sıra'></th>
                    <th><cf_get_lang dictionary_id = '53806.İşyeri'></th>
                    <th><cf_get_lang dictionary_id = '53807.SSK Şube Adı SSK Şube İşyeri No'></th>
                    <th><cf_get_lang dictionary_id = '53808.Yıl  Ay'></th>
                    <th><cf_get_lang dictionary_id = '53846.Mahiyet'></th>
                    <th><cf_get_lang dictionary_id = '62279.Tahakkuk Nedeni'></th>
                    <th><cf_get_lang dictionary_id = '57899.Kaydeden'></th>
                    <th><cf_get_lang dictionary_id = '57627.Kayıt Tarihi'></th>
                    <!-- sil -->
                    <th width="35">
                        <a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_muhtasar_xml_export&event=add','','ui-draggable-box-small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='53812.E-Bildirge Ekle'>"></i></a>
                    </th>
                    <!-- sil -->
                </tr>
            </thead>
            <tbody>
            <cfif get_ssk_xml_exports.recordcount>
                <cfoutput query="get_ssk_xml_exports" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td width="35">#currentrow#</td>
                        <td><cfif not len(SSK_BRANCH_ID) and not len(COMPANY_ID)><cf_get_lang dictionary_id='43266.Tüm Şirketler'><cfelseif len(COMPANY_ID)>#COMPANY_NAME#</cfif></td>
                        <td><cfif len(SSK_BRANCH_ID)>#branch_name# - (#ssk_office# / #ssk_office_no#)<cfelse><cf_get_lang dictionary_id='29495.Tüm Şubeler'></cfif></td>
                        <td>#sal_year# / #ListGetAt(ay_list(),get_ssk_xml_exports.sal_mon)#</td>
                        <td><cfif EXPORT_REASON is 'A'><cf_get_lang dictionary_id='56015.Asıl'><cfelseif EXPORT_REASON is 'E'><cf_get_lang dictionary_id='53841.Ek'><cfelseif EXPORT_REASON is 'I'><cf_get_lang dictionary_id='58506.İptal'></cfif></td>
                        <td>#EXPORT_TYPE#</td>
                        <td>#employee_name# #employee_surname#</td>
                        <td>#dateformat(record_date,'dd/mm/yyyy')# (#timeformat(date_add("h",session.ep.time_zone,record_date),"HH:MM")#)</td>
                        <!-- sil -->
                        <td align="center" nowrap="nowrap">
                            <ul class="ui-icon-list">
                                <li><a href="javascript://" onClick="if (confirm('#getLang('','Kayıtlı E-Muhtasarı Siliyorsunuz! Emin misiniz?',64651)#')) windowopen('#request.self#?fuseaction=ehesap.list_muhtasar_xml_export&event=del&eme_id=#eme_id#','medium');"><i class="fa fa-minus" title="<cf_get_lang dictionary_id ='53810.E-Bildirge Sil'> !"></i></a></li>
                                <li><a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##file_name#"><i class="fa fa-clipboard" title="<cf_get_lang dictionary_id ='53811.E-Bildirge XML Dosyası '>!"></i></a></li>
                                <li><a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##FILE_NAME_7103#"><i class="fa fa-file-text-o" title="<cf_get_lang dictionary_id ='53811.E-Bildirge XML Dosyası '>7103!"></i></a></li>
                                <li><a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##excel_file_name#"><i class="fa fa-file-excel-o" title="<cf_get_lang dictionary_id='61587.E-bildirge CSV Dosyası'>"></i></a></li>
                                <li><a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##excel_xls_file_name#"><i class="fa fa-file-text" title="<cf_get_lang dictionary_id='61588.E-bildirge CSV Dosyası'>"></i></a></li>
                                <li><a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##total_file_name#"><i class="fa fa-file" title="<cf_get_lang dictionary_id='65209.Vergi Bildirimi'>"></i></a></li>
                                <li><a href="#file_web_path#hr#dir_seperator#emuhtasar#dir_seperator##FILE_NAME_5746#"><i class="fa fa-file-zip-o" title="<cf_get_lang dictionary_id='37091.Ar-Ge Muhtasar'>"></i></a></li>
                            </ul>
                        </td>
                        <!-- sil -->
                    </tr>
                </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'> !<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz '> !</cfif></td>
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