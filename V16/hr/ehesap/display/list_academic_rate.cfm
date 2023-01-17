<!---
    File: V16\hr\ehesap\display\list_academic_rate.cfm
    Author: Esma R. Uysal <esmauysal@workcube.com>
    Date: 2021-10-11
    Description: Memur Akademik teşvik oranları
        
    History:
        
    To Do:

--->
<cfset get_component = createObject("component","V16.hr.ehesap.cfc.academic_personnel_rate") />
<cfset get_course_info = get_component.GET_SETUP_ACADEMIC_PERSONNEL() />
<cf_grid_list>
    <thead>
        <tr>
            <th><cf_get_lang dictionary_id='58820.Başlık'></th>
            <th><cf_get_lang dictionary_id='62933.Geçerli Tarih'></th>
            <th style="width:10px;" class="header_icn_none"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.personal_payment&event=addAcademicRate','listCourses_box','ui-draggable-box-small');" title="<cf_get_lang dictionary_id='44630.Ekle'>"><i class="fa fa-plus"></i></a></th>
        </tr>
    </thead>
    <tbody>
        <cfoutput query="get_course_info">
            <tr>
                <td>#title#</td>
                <td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
                <td style="text-align:center;"><a href="javascript://" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.personal_payment&event=updAcademicRate&setup_academic_personnel_id=#setup_academic_personnel_id#','listCourses_box','ui-draggable-box-small');"title="<cf_get_lang dictionary_id='58718.Düzenle'>" ><i class="fa fa-pencil"></i></a></td>
            </tr>
        </cfoutput>
    </tbody>
</cf_grid_list>