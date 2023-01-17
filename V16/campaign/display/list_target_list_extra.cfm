<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.RECORD_EMP" default="">
<cfparam name="attributes.RECORD_IP" default="">
<cfparam name="attributes.UPDATE_DATE" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.UPDATE_IP" default="">
<cfparam name="get_target_name.recordcount" default="0">
<cfparam name="attributes.call_status" default="1">
<cfparam name="attributes.is_record" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdefined("attributes.form_varmi_check")>
    <cfquery name="is_search" datasource="#dsn3#">
        UPDATE TARGET_AUDIENCE_RECORD SET CALL_STATUS = 0 WHERE TARGET_RECORD_ID in (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.selected_list#" list="yes"> )
    </cfquery>
    <cfquery name="is_search" datasource="#dsn3#">
        UPDATE TARGET_AUDIENCE_RECORD SET CALL_STATUS = 1 WHERE TARGET_RECORD_ID in (<cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.is_record#" list="yes">)
    </cfquery>
</cfif>
<cfquery name="get_target" datasource="#dsn3#">
	SELECT
    	TMARKET_NAME,
        TMARKET_NO,
        TMARKET_ID
    FROM
    	TARGET_MARKETS
    WHERE
		<cfif isDefined("attributes.tmarket_id") and len(attributes.tmarket_id)>
            TMARKET_ID IN (<cfqueryparam cfsqltype="cf_sql_integer" list="yes" value="#attributes.tmarket_id#">)
        <cfelseif isdefined("attributes.keyword") and len(attributes.keyword)>
            (TMARKET_NAME LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%"> OR
            TMARKET_NO LIKE <cfqueryparam cfsqltype="cf_sql_varchar" value="%#attributes.keyword#%">)
        </cfif>
</cfquery>
<cfquery name="get_target_name" datasource="#dsn3#">
    WITH CTE3 AS (
    SELECT DISTINCT
        1 TYPE,
        TAR.TARGET_RECORD_ID,
        TAR.TMARKET_ID,
        TAR.COMPANY_ID,
        TAR.PARTNER_ID,
        TAR.CONSUMER_ID,
        TAR.IS_TARGET_RECORD,
        TAR.OTHER_RECORD,
        TAR.CALL_STATUS,
        CS.CONSUMER_NAME MEMBER_NAME,
        CS.CONSUMER_SURNAME MEMBER_SURNAME,
        '' COMPANY_NAME,
        CS.MISSION MEMBER_MISSION,
        CS.WORKADDRESS MEMBER_ADDRESS,
        CS.WORKPOSTCODE MEMBER_POSTCODE,
        CS.WORKSEMT MEMBER_SEMT,
        CS.WORK_COUNTY_ID MEMBER_COUNTY,
        CS.WORK_CITY_ID MEMBER_CITY,
        CS.CONSUMER_EMAIL USER_EMAIL,
        CS.CONSUMER_WORKTEL TEL_NO,
        CS.CONSUMER_WORKTELCODE TELCODE,
        CS.DEPARTMENT MEMBER_DEPARTMENT,
        CS.CONSUMER_NAME + ' ' + CS.CONSUMER_SURNAME AS FULL_NAME
    FROM
        TARGET_AUDIENCE_RECORD TAR  JOIN  
        #DSN_ALIAS#.CONSUMER CS ON TAR.CONSUMER_ID = CS.CONSUMER_ID
    WHERE
        TAR.TMARKET_ID = #ATTRIBUTES.TMARKET_ID#
        <cfif isdefined("attributes.CALL_STATUS") and attributes.CALL_STATUS  eq 0>
           AND TAR.CALL_STATUS = 0
        <cfelseif isdefined("attributes.CALL_STATUS") and attributes.CALL_STATUS  eq 1>
           AND TAR.CALL_STATUS = 1
        </cfif>
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>AND( CS.CONSUMER_NAME LIKE '%#attributes.keyword#%' OR CS.CONSUMER_SURNAME LIKE '%#attributes.keyword#%')</cfif>
UNION ALL 
    SELECT DISTINCT
        2 TYPE,
        TAR.TARGET_RECORD_ID,
        TAR.TMARKET_ID,
        TAR.COMPANY_ID,
        TAR.PARTNER_ID,
        TAR.CONSUMER_ID,
        TAR.IS_TARGET_RECORD,
        TAR.OTHER_RECORD,
        TAR.CALL_STATUS,
        CP.COMPANY_PARTNER_NAME MEMBER_NAME,
        CP.COMPANY_PARTNER_SURNAME MEMBER_SURNAME,
        C.NICKNAME COMPANY_NAME,
        CP.MISSION MEMBER_MISSION,
        CP.COMPANY_PARTNER_ADDRESS MEMBER_ADDRESS,
        CP.COMPANY_PARTNER_POSTCODE MEMBER_POSTCODE,
        CP.SEMT MEMBER_SEMT,
        CP.COUNTY MEMBER_COUNTY,
        CP.CITY MEMBER_CITY,
        CP.COMPANY_PARTNER_EMAIL USER_EMAIL,
        CP.MOBILTEL TEL_NO,
        CP.MOBIL_CODE TELCODE,
        CP.DEPARTMENT MEMBER_DEPARTMENT,
        C.FULLNAME FULL_NAME
    FROM
        TARGET_AUDIENCE_RECORD TAR  JOIN  
        #DSN_ALIAS#.COMPANY C ON TAR.COMPANY_ID = C.COMPANY_ID  
        JOIN #DSN_ALIAS#.COMPANY_PARTNER CP ON TAR.PARTNER_ID = CP.PARTNER_ID
    WHERE
        TAR.TMARKET_ID = #ATTRIBUTES.TMARKET_ID#
        <cfif isdefined("attributes.CALL_STATUS") and attributes.CALL_STATUS  eq 0>
            AND TAR.CALL_STATUS = 0
        <cfelseif isdefined("attributes.CALL_STATUS") and attributes.CALL_STATUS  eq 1>
            AND TAR.CALL_STATUS = 1
        </cfif>
        <cfif isDefined("attributes.keyword") and len(attributes.keyword)>AND( CP.COMPANY_PARTNER_NAME LIKE '%#attributes.keyword#%' OR CP.COMPANY_PARTNER_SURNAME LIKE '%#attributes.keyword#%')</cfif>
         ),
    CTE4 AS (
                SELECT
                    CTE3.*,
                    ROW_NUMBER() OVER (	ORDER BY TARGET_RECORD_ID , CALL_STATUS  asc
                                    ) AS RowNum,(SELECT COUNT(*) FROM CTE3) AS QUERY_COUNT
                FROM
                    CTE3
            )
            SELECT
                CTE4.*
            FROM
                CTE4
            WHERE
                RowNum BETWEEN #attributes.startrow# and #attributes.startrow#+(#attributes.maxrows#-1)
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_target_name.query_count#">   
<cfset county_list=''>
<cfset city_list=''>
<cfset department_list=''>
<cfset position_list=''>
<cfif get_target_name.recordcount>
    <cfoutput query="get_target_name">
        <cfif len(member_county) and not listfind(county_list,member_county)>
            <cfset county_list=listappend(county_list,member_county)>
        </cfif>
        <cfif len(member_city) and not listfind(city_list,member_city)>
            <cfset city_list=listappend(city_list,member_city)>
        </cfif>
        <cfif len(member_department) and not listfind(department_list,member_department)>
            <cfset department_list=listappend(department_list,member_department)>
        </cfif>
        <cfif len(member_mission) and not listfind(position_list,member_mission)>
            <cfset position_list=listappend(position_list,member_mission)>
        </cfif>
    </cfoutput>
    <cfif len(county_list)>
        <cfquery name="get_counties" datasource="#dsn#">
            SELECT COUNTY_ID, COUNTY_NAME FROM SETUP_COUNTY WHERE COUNTY_ID IN (#county_list#) ORDER BY COUNTY_ID
        </cfquery>
        <cfset county_list = listsort(listdeleteduplicates(valuelist(get_counties.county_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(city_list)>
        <cfquery name="get_cities" datasource="#dsn#">
            SELECT CITY_ID,CITY_NAME FROM SETUP_CITY WHERE CITY_ID IN (#city_list#) ORDER BY CITY_ID
        </cfquery>
        <cfset city_list = listsort(listdeleteduplicates(valuelist(get_cities.city_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(department_list)>
        <cfquery name="get_departments" datasource="#dsn#">
            SELECT PARTNER_DEPARTMENT_ID, PARTNER_DEPARTMENT FROM SETUP_PARTNER_DEPARTMENT WHERE PARTNER_DEPARTMENT_ID IN (#department_list#) ORDER BY PARTNER_DEPARTMENT_ID
        </cfquery>
        <cfset department_list = listsort(listdeleteduplicates(valuelist(get_departments.partner_department_id,',')),'numeric','ASC',',')>
    </cfif>
    <cfif len(position_list)>
        <cfquery name="get_positions" datasource="#dsn#">
            SELECT PARTNER_POSITION_ID, PARTNER_POSITION FROM SETUP_PARTNER_POSITION WHERE PARTNER_POSITION_ID IN (#position_list#) ORDER BY PARTNER_POSITION_ID
        </cfquery>
        <cfset position_list = listsort(listdeleteduplicates(valuelist(get_positions.partner_position_id,',')),'numeric','ASC',',')>
    </cfif>
</cfif>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="list_target_list_" method="post" action="#request.self#?fuseaction=campaign.list_target_list_extra">
            <input type="hidden" name="tmarket_id" id="tmarket_id" value="<cfoutput>#attributes.TMARKET_ID#</cfoutput>" />
            <cf_box_search>
                <cfinput type="hidden" name="is_form" value="1">
                <div class="form-group" id="item-keyword">
                    <cfinput type="text" name="keyword" placeholder="#getLang('','','57460')#" maxlength="100" value="#attributes.keyword#">
                </div>
                <div class="form-group" id="item-call_status">
                    <select name="call_status" id="call_status">
                        <option value="1" <cfif isdefined("attributes.call_status") and attributes.call_status eq 1>selected</cfif>><cf_get_lang dictionary_id='54711.To call'></option>
                        <option value="0" <cfif isdefined("attributes.call_status") and attributes.call_status eq 0>selected</cfif>><cf_get_lang dictionary_id='62783.Aranmayacak'></option>
                        <option value="2" <cfif isdefined("attributes.call_status") and attributes.call_status eq 2>selected</cfif>><cf_get_lang dictionary_id='57708.Tümü'></option>
                    </select>
                </div>
                <div class="form-group small" id="item-maxrow">
                    <cfinput type="text" name="maxrows" value="#attributes.maxrows#" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button is_excel="1" button_type="4">
                </div>
                <div class="form-group" id="item-add-button">
                    <cfif isDefined("attributes.tmarket_id")>
                        <a href="javascript://" class="ui-btn ui-btn-gray" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_form_add_worker&tmarket_id=#attributes.tmarket_id#&</cfoutput>','','ui-draggable-box-small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                        <cfelse>
                        <a href="javascript://" class="ui-btn ui-btn-gray" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_form_add_worker&tmarket_id=#attributes.tmarket_id#</cfoutput>','','ui-draggable-box-small');"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a>
                    </cfif>
                </div>
            </cf_box_search>
        </cfform>
    </cf_box>
</div>
    <cfsavecontent  variable="message"><cf_get_lang dictionary_id='49363.Hedef Kitle'> :<cfoutput> #get_target.tmarket_name#</cfoutput>
    </cfsavecontent>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#message#">
        <cfform  name="list_target_list_1" method="post" action="#request.self#?fuseaction=campaign.list_target_list_extra">
            <input type="hidden" name="tmarket_id" id="tmarket_id" value="<cfoutput>#attributes.tmarket_id#</cfoutput>" /> 
            <input type="hidden" name="page" id="page" value="<cfoutput>#attributes.page#</cfoutput>" /> 
            <input type="hidden" value="<cfoutput>#valuelist(get_target_name.TARGET_RECORD_ID)#</cfoutput>" name="selected_list" id="selected_list">
            <input type="hidden" name="form_varmi_check" id="form_varmi_check" value="1" />
            <cf_grid_list>
                <thead>
                    <cfoutput query="get_target_name">
                        <cfif get_target_name.type[1] eq 1 and currentrow eq 1>
                        <tr> 
                            <th  colspan="9"><cf_get_lang dictionary_id='29406.Bireysel Üyeler'></th>
                        </tr>
                        <cfelseif get_target_name.type[1] eq 2 and currentrow eq 1>
                            <tr> 
                                <th  colspan="9"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></th>
                            </tr>
                        </cfif>
                        <cfif (get_target_name.type[currentrow] neq get_target_name.type[currentrow-1] and currentrow neq 1) and get_target_name.type[currentrow] eq 2>
                            <tr> 
                                <th  colspan="9"><cf_get_lang dictionary_id='29408.Kurumsal Üyeler'></th>
                            </tr>
                        </cfif>	
                    </cfoutput>	
                    <tr>
                        <th width="15"><cfoutput>#getLang('','sıra','58577')#</cfoutput></th>
                        <th><cfoutput>#getLang('','ad','57570')#</cfoutput></th>
                        <th><cfoutput>#getLang('','pozisyon','57573')#</cfoutput></th>
                        <th><cfoutput>#getLang('','departman','57572')#</cfoutput></th>
                        <th><cfoutput>#getLang('','şirket','57574')#</cfoutput></th>
                        <th><cfoutput>#getLang('','adres','58723')#</cfoutput></th>
                        <th><cfoutput>#getLang('','e-posta','57428')#</cfoutput></th>
                        <th><cfoutput>#getLang('','Telefon','57499')#</cfoutput></th>
                        <th width="15"><cf_get_lang dictionary_id="54711.Aranacak"></th>
                    </tr>
                </thead>
                <cfif isdefined("get_target_name") and get_target_name.recordcount>
                    <tbody>
                        <cfoutput query="get_target_name">
                            <tr>
                                <td>#rownum#</td>
                                <td>
                                    <cfif TYPE eq 1>
                                        <a href="#request.self#?fuseaction=member.consumer_list&event=det&cid=#consumer_id#" class="tableyazi">#member_name# #member_surname#</a>
                                    <cfelseif TYPE eq 2>
                                        <a href="#request.self#?fuseaction=member.list_contact&event=upd&pid=#partner_id#" class="tableyazi">#member_name# #member_surname# / #company_name#</a>
                                    <cfelse>
                                        #member_name# #member_surname#
                                    </cfif>
                                </td>
                                <td><cfif len(member_mission)>#get_positions.partner_position[listfind(position_list,member_mission,',')]#</cfif></td>
                                <td><cfif len(member_department)>#get_departments.partner_department[listfind(department_list,member_department,',')]#</cfif></td>
                                <td>#company_name#</td>
                                <td>#member_address# #member_postcode# #member_semt# <cfif isdefined('get_counties')>#get_counties.county_name[listfind(county_list,member_county,',')]# /</cfif> <cfif isdefined('get_cities')>#get_cities.city_name[listfind(city_list,member_city,',')]#</cfif></td>
                                <td><cfif len(user_email)>#get_target_name.user_email#</cfif></td>
                                <td nowrap><cfif len(tel_no)>(#telcode#) #tel_no#</cfif></td>
                                <td>
                                    <input type="checkbox" name="is_record" id="is_record" value="#TARGET_RECORD_ID#" <cfif CALL_STATUS eq 1>checked title="Aranacak" <cfelse>title="Aranmayacak"</cfif>/>
                                </td>
                            </tr>
                        </cfoutput>
                    </tbody>	
                <cfelse>
                    <tbody>
                        <tr>
                            <td colspan="9"><cfoutput>#getLang('','',72)#</cfoutput></td>
                        </tr>
                    </tbody>
                </cfif>
            </cf_grid_list>
            <cf_box_footer> 
                <div class="col col-6 col-md-6 col-sm-6 col-xs-12"><cf_get_lang dictionary_id='62728.Bu Hedef Kitle Kaydedilmiştir'></div>
                    <cfif get_target_name.recordcount>
                        <div class="col col-6 col-md-6 col-sm-6 col-xs-12" align="right">
                            <a href="<cfoutput>#request.self#?fuseaction=campaign.list_target_list_extra&tmarket_id=#attributes.tmarket_id#</cfoutput>"><input type="submit" name="Kaydet" value="Kaydet" /></a>
                        </div>
                    </cfif>
            </cf_box_footer>
        </cfform>
        <cfset url_str = "">
        <cfif get_target_name.recordcount and (attributes.totalrecords gt attributes.maxrows)>
        
            <cfif len(attributes.keyword)>
                <cfset url_str = "#url_str#&keyword=#attributes.keyword#">
            </cfif>
            <cf_paging page="#attributes.page#" 
                maxrows="#attributes.maxrows#" 
                totalrecords="#attributes.totalrecords#" 
                startrow="#attributes.startrow#" 
                adres="campaign.list_target_list_extra&tmarket_id=#attributes.TMARKET_ID#">
            
        </cfif>
    </cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
</script>
