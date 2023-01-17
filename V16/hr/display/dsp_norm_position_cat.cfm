<cfquery name="get_position_cat_norm" datasource="#dsn#">
	SELECT
		B.BRANCH_NAME,
		D.DEPARTMENT_HEAD,
		D.DEPARTMENT_ID,
		SUM(EMPLOYEE_COUNT1) AS EMPLOYEE_COUNT1,
		SUM(EMPLOYEE_COUNT2) AS EMPLOYEE_COUNT2,
		SUM(EMPLOYEE_COUNT3) AS EMPLOYEE_COUNT3,
		SUM(EMPLOYEE_COUNT4) AS EMPLOYEE_COUNT4,
		SUM(EMPLOYEE_COUNT5) AS EMPLOYEE_COUNT5,
		SUM(EMPLOYEE_COUNT6) AS EMPLOYEE_COUNT6,
		SUM(EMPLOYEE_COUNT7) AS EMPLOYEE_COUNT7,
		SUM(EMPLOYEE_COUNT8) AS EMPLOYEE_COUNT8,
		SUM(EMPLOYEE_COUNT9) AS EMPLOYEE_COUNT9,
		SUM(EMPLOYEE_COUNT10) AS EMPLOYEE_COUNT10,
		SUM(EMPLOYEE_COUNT11) AS EMPLOYEE_COUNT11,
		SUM(EMPLOYEE_COUNT12) AS EMPLOYEE_COUNT12
	FROM
		EMPLOYEE_NORM_POSITIONS ENP,
		BRANCH B,
		DEPARTMENT D
	WHERE
		D.DEPARTMENT_ID=ENP.DEPARTMENT_ID AND
		B.BRANCH_ID = D.BRANCH_ID AND
		ENP.POSITION_CAT_ID = #attributes.position_cat_id#
	GROUP BY 
		D.DEPARTMENT_ID,D.DEPARTMENT_HEAD,B.BRANCH_NAME
	ORDER BY B.BRANCH_NAME
</cfquery>
<cfset department_id_list = valuelist(get_position_cat_norm.department_id)>

<cfquery name="get_all_depts" datasource="#dsn#">
	SELECT POSITION_CAT_ID,DEPARTMENT_ID,EMPLOYEE_ID FROM EMPLOYEE_POSITIONS WHERE POSITION_CAT_ID = #ATTRIBUTES.POSITION_CAT_ID# AND POSITION_STATUS = 1 <cfif listlen(department_id_list)>AND DEPARTMENT_ID IN (#department_id_list#)<cfelse>AND DEPARTMENT_ID IS NULL</cfif>
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box title="#getLang('hr',1578)#" scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
        <cf_grid_list>
            <thead>
                <tr>
                    <th width="150"><cf_get_lang dictionary_id='57453.Şube'></th>
                    <th width="100" class="text-center"><cf_get_lang dictionary_id='58497.Pozisyon'></th>
                    <th width="50" class="text-center"><cf_get_lang dictionary_id='55541.Dolu'></th>
                    <cfloop from="1" to="12" index="k">
                        <th width="50" class="text-center"><cfoutput>#listgetat(ay_list(),k)#</cfoutput></th>
                    </cfloop>
                </tr>
            </thead>
            <tbody>
                <cfoutput query="get_position_cat_norm">
                    <tr>
                        <td>#branch_name# - #DEPARTMENT_HEAD#</td>
                        <td class="txtbold" class="text-center">
                            <cfquery name="get_" dbtype="query">
                                SELECT COUNT(POSITION_CAT_ID) AS TOPLAM_ FROM get_all_depts WHERE DEPARTMENT_ID = #DEPARTMENT_ID#
                            </cfquery>
                            <cfif get_.recordcount and len(get_.TOPLAM_)>
                                #get_.toplam_#
                            <cfelse>
                                -
                            </cfif>
                        </td>
                        <td class="text-center" class="txtbold">
                            <cfquery name="get_2" dbtype="query">
                                SELECT COUNT(POSITION_CAT_ID) AS TOPLAM_2 FROM get_all_depts WHERE DEPARTMENT_ID = #DEPARTMENT_ID# AND (EMPLOYEE_ID IS NOT NULL AND EMPLOYEE_ID <> 0)
                            </cfquery>
                            <cfif get_2.recordcount and len(get_2.TOPLAM_2)>
                                #get_2.TOPLAM_2#
                            <cfelse>
                                -
                            </cfif>
                        </td>
                        <cfloop from="1" to="12" index="m"><td class="text-center"><cfif m eq month(now())><b></cfif>#evaluate("EMPLOYEE_COUNT#m#")#<cfif m eq month(now())><b></cfif></td></cfloop>
                    </tr>
                </cfoutput>
            </tbody>
        </cf_grid_list>
        <cfif get_position_cat_norm.recordcount eq 0>
            <div class="ui-info-bottom">
                <p><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</p>
            </div>
        </cfif>
    </cf_box>
</div>

