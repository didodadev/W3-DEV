
<!---
    File:V16\production_plan\display\list_production_team.cfm
    Author:Fatma Zehra Dere
    Date: 2021-10-13
    Description:Operatorlerde ekiplerin listelendiği sayfa 
--->
<cf_get_lang_set module_name="prod">
    <cfsetting showdebugoutput="no">
    <style>
        .ajax_list > thead tr th {
        border-bottom: 2px solid #51bbb4;
        font-size: 20px;
        color: #555;
        font-weight: bold;
        margin: 0;
        padding: 5px;
        outline: none!important;
        cursor: pointer!important;
        text-align: left;
        white-space: nowrap;
    }
    </style>
    <cfquery name="get_production_team"  datasource="#dsn#">
        SELECT
        *,
        CASE 
            WHEN EMPLOYEES.PHOTO IS NOT NULL AND LEN(EMPLOYEES.PHOTO) > 0 
                THEN '/documents/hr/'+EMPLOYEES.PHOTO 
            WHEN EMPLOYEES.PHOTO IS NULL AND EMPLOYEES_DETAIL.SEX = 0
                THEN  '/images/female.jpg'
        ELSE '/images/male.jpg' END AS PHOTOS
        FROM
        EMPLOYEE_POSITIONS
        INNER JOIN EMPLOYEES ON EMPLOYEES.EMPLOYEE_ID = EMPLOYEE_POSITIONS.EMPLOYEE_ID
        INNER JOIN EMPLOYEES_DETAIL ON EMPLOYEES_DETAIL.EMPLOYEE_ID = EMPLOYEES.EMPLOYEE_ID
        WHERE
        EMPLOYEE_POSITIONS.EMPLOYEE_ID <> 0
        AND
        (
            EMPLOYEE_POSITIONS.UPPER_POSITION_CODE = #session.ep.position_code#
            OR
            EMPLOYEE_POSITIONS.UPPER_POSITION_CODE2 = #session.ep.position_code#
        )
        AND EMPLOYEES.EMPLOYEE_STATUS = 1
        AND POSITION_STATUS = 1
        ORDER BY
        EMPLOYEE_POSITIONS.EMPLOYEE_NAME,
        EMPLOYEE_POSITIONS.EMPLOYEE_SURNAME
    </cfquery>
   
    <cfparam name='attributes.totalrecords' default="#get_production_team.recordcount#">
    <cfparam  name="attributes.page" default="1">
    <cfif not (isDefined('attributes.maxrows') and isNumeric(attributes.maxrows))>
        <cfset attributes.maxrows = 10 />
    </cfif>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    <cf_box title="#getLang('','Ekip',49364)#" box_style="maxi"  scroll="0" collapsable="0" settings="0" resize="0" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_flat_list>
            <thead>
                <tr>
                    <th width="40"><cf_get_lang dictionary_id='57487.No'></th>
                    <th><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
                </tr>
            </thead>
            <tbody>
                <cfif get_production_team.recordcount>
                    <cfoutput query="get_production_team"startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#EMPLOYEE_NAME# #EMPLOYEE_SURNAME#</td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr class="color-row" height="20">
                        <td colspan="15"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
                    </tr>
                </cfif>
            </tbody>
        </cf_flat_list>
        <cfset url_str = "">
        <cf_paging page="#attributes.page#" 
        maxrows="#attributes.maxrows#" 
        totalrecords="#attributes.totalrecords#" 
        startrow="#attributes.startrow#" 
        adres="production.list_production_team#url_str#"
        isAjax="#iif(isdefined("attributes.draggable"),1,0)#">
    </cf_box>
    <cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">
    