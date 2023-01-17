<cfquery name="GET_GROUP_REQ_TYPE" datasource="#dsn#">
	SELECT REQ_TYPE FROM POSITION_REQ_TYPE WHERE IS_GROUP=1 ORDER BY REQ_TYPE
</cfquery>
<cfquery name="get_pos_dep" datasource="#dsn#">
	SELECT POSITION_CODE,DEPARTMENT_ID FROM EMPLOYEE_POSITIONS WHERE EMPLOYEE_ID=#session.ep.userid#
</cfquery>
<cfif get_pos_dep.recordcount>
	<cfset pos_list=valuelist(get_pos_dep.POSITION_CODE,',')>
	<cfset dept_list=valuelist(get_pos_dep.DEPARTMENT_ID,',')>
<cfelse>
	<cfset pos_list=session.ep.position_code>
	<cfset dept_list=0>
</cfif>
<cfquery name="get_department_all" datasource="#dsn#">
	SELECT DISTINCT 
		D.DEPARTMENT_HEAD,
		D.ADMIN1_POSITION_CODE,
		D.ADMIN2_POSITION_CODE,
		D.DEPARTMENT_ID,
		OC.COMP_ID
	FROM 
		DEPARTMENT D,
		BRANCH B,
		OUR_COMPANY OC
	WHERE 
		(D.ADMIN1_POSITION_CODE IN (#pos_list#) OR D.ADMIN2_POSITION_CODE IN (#pos_list#) OR D.DEPARTMENT_ID IN (#dept_list#))
		AND D.BRANCH_ID=B.BRANCH_ID
		AND B.COMPANY_ID=OC.COMP_ID 
</cfquery>
<cfif get_department_all.recordcount>
	<cfset list_comp_id=valuelist(get_department_all.COMP_ID,',')>
	<cfset list_all_dep_id=valuelist(get_department_all.DEPARTMENT_ID,',')>
<cfelse>
	<cfset list_comp_id="">
	<cfset list_all_dep_id=0>
</cfif>
<!---departmanlar bilgileri için--->
	<cfquery name="GET_DEP_REQ_ALL" datasource="#dsn#">
		SELECT 
			RELATION_ID,
			RELATION_ACTION,
			RELATION_ACTION_ID,
			RELATION_YEAR,
			POSITION_REQ_TYPE.REQ_TYPE,
			POSITION_REQ_TYPE.REQ_TYPE_ID
		FROM 
			RELATION_SEGMENT,
			POSITION_REQ_TYPE
		WHERE
			POSITION_REQ_TYPE.REQ_TYPE_ID=RELATION_SEGMENT.RELATION_FIELD_ID AND
			RELATION_SEGMENT.RELATION_TABLE='POSITION_REQ_TYPE' AND
			RELATION_ACTION=2 AND
			RELATION_SEGMENT.RELATION_ACTION_ID IN(#list_all_dep_id#)
			AND (POSITION_REQ_TYPE.IS_GROUP IS NULL OR POSITION_REQ_TYPE.IS_GROUP=0)
	</cfquery>
	<cfquery name="GET_DEP_REQ_GRUP_ALL" datasource="#dsn#">
		SELECT 
			RELATION_ID,
			RELATION_ACTION,
			RELATION_ACTION_ID,
			RELATION_YEAR,
			POSITION_REQ_TYPE.REQ_TYPE,
			POSITION_REQ_TYPE.REQ_TYPE_ID
		FROM 
			RELATION_SEGMENT,
			POSITION_REQ_TYPE
		WHERE
			POSITION_REQ_TYPE.REQ_TYPE_ID=RELATION_SEGMENT.RELATION_FIELD_ID AND
			RELATION_SEGMENT.RELATION_TABLE='POSITION_REQ_TYPE' AND
			RELATION_ACTION=2 AND
			RELATION_SEGMENT.RELATION_ACTION_ID IN (#list_all_dep_id#)
			AND POSITION_REQ_TYPE.IS_GROUP=1
	</cfquery>
	<cfquery name="GET_DEP_TARGET_ALL" datasource="#dsn#">
		SELECT
			TARGET_ID,
			DEPARTMENT_ID,
			TARGETCAT_ID,
			STARTDATE,
			FINISHDATE,
			TARGET_HEAD,
			TARGET_NUMBER,
			TARGET_DETAIL,
			TARGET_EMP
		FROM 
			TARGET
		WHERE
			DEPARTMENT_ID  IN (#list_all_dep_id#)
	</cfquery>

<cfquery name="get_company" datasource="#dsn#">
	SELECT 
		COMPANY_NAME,
		COMP_ID,
		NICK_NAME,
		MANAGER_POSITION_CODE,
		MANAGER_POSITION_CODE2
	FROM 
		OUR_COMPANY 
	WHERE 
		MANAGER_POSITION_CODE IN (#pos_list#) OR MANAGER_POSITION_CODE2 IN (#pos_list#)
		<cfif listlen(list_comp_id,',')>OR COMP_ID IN(#list_comp_id#)</cfif>
</cfquery>
<table class="dph">
    <tr>
        <td class="dpht"><cf_get_lang dictionary_id='31348.Hedef ve Yetkinlik Belirleme'></td>
    </tr>
</table>
<cf_medium_list>
	<thead>
        <tr>
            <th>&nbsp;<cf_get_lang dictionary_id='31349.Grup Ana Yetkinlikleri'></th>
        </tr>
    </thead>
    <tbody>
		<cfoutput query="GET_GROUP_REQ_TYPE">
            <tr>
                <td>#currentrow# - #GET_GROUP_REQ_TYPE.REQ_TYPE#</td>
            </tr>
        </cfoutput>
    </tbody>
</cf_medium_list>
<!--- Şirket ---->
<cfoutput query="get_company">
	<cfquery name="GET_COMP_REQ" datasource="#dsn#">
		SELECT 
			RELATION_ID,
			RELATION_ACTION,
			RELATION_ACTION_ID,
			RELATION_YEAR,
			POSITION_REQ_TYPE.REQ_TYPE,
			POSITION_REQ_TYPE.REQ_TYPE_ID
		FROM 
			RELATION_SEGMENT,
			POSITION_REQ_TYPE
		WHERE
			POSITION_REQ_TYPE.REQ_TYPE_ID=RELATION_SEGMENT.RELATION_FIELD_ID AND
			RELATION_SEGMENT.RELATION_TABLE='POSITION_REQ_TYPE' AND
			RELATION_ACTION=1 AND
			RELATION_SEGMENT.RELATION_ACTION_ID=#get_company.COMP_ID#
			AND (POSITION_REQ_TYPE.IS_GROUP IS NULL OR POSITION_REQ_TYPE.IS_GROUP=0)
	</cfquery>
	
	<cfquery name="GET_COMP_TARGET" datasource="#dsn#">
		SELECT
			TARGET_ID,
			OUR_COMPANY_ID,
			TARGETCAT_ID,
			STARTDATE,
			FINISHDATE,
			TARGET_HEAD,
			TARGET_NUMBER,
			TARGET_DETAIL,
			TARGET_EMP
		FROM 
			TARGET
		WHERE
			OUR_COMPANY_ID=#get_company.COMP_ID#
	</cfquery>
    <cf_medium_list>
            <thead>
                <tr>
                    <th>&nbsp;#get_company.COMPANY_NAME#</th>
                    <th style="text-align:right;">
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_comp_vizyon&company_id=#get_company.COMP_ID#','small');"><img src="../images/branch_plus.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='57758.Şirket Vizyonu'>"></a>
                        <cfif listfind(pos_list,get_company.MANAGER_POSITION_CODE,',') or listfind(pos_list,get_company.MANAGER_POSITION_CODE2,',')>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_add_perfection&company_id=#get_company.COMP_ID#','list');"><img src="../images/magic.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='31421.Yetkinlik Ekle'>"></a>
                        <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_add_target&company_id=#get_company.COMP_ID#','list');"><img src="../images/target.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='31422.Hedef Ekle'>"></a>
                        </cfif>
                    </th>
                </tr>
            </thead>
            <tbody>
                <tr class="nohover">
                    <td valign="top">
                        <table width="100%">
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id='31350.Şirket Ana Yetkinlikleri'></th>
                                </tr>
                            </thead>
                            <tbody>
                                <cfloop query="GET_COMP_REQ">
                                    <tr>
                                        <td>#GET_COMP_REQ.currentrow# #GET_COMP_REQ.REQ_TYPE#</td>
                                    </tr>
                                </cfloop>
                            </tbody>
                        </table>
                    </td>
                    <td valign="top">
                        <table width="100%">
                            <thead>
                                <tr>
                                    <th><cf_get_lang dictionary_id='57964.Hedefler'></th>
                                </tr>
                            </thead>
                            <tbody>
                            <cfloop query="GET_COMP_TARGET">
                                <tr>
                                    <td>
                                        <cfif listfind(pos_list,get_company.MANAGER_POSITION_CODE[get_company.currentrow],',') or listfind(pos_list,get_company.MANAGER_POSITION_CODE2[get_company.currentrow],',')>
                                        #GET_COMP_TARGET.currentrow#. <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_upd_target&target_id=#GET_COMP_TARGET.TARGET_ID#','list');">#GET_COMP_TARGET.TARGET_HEAD#</a>
                                        <cfelse>
                                        #GET_COMP_TARGET.currentrow# #GET_COMP_TARGET.TARGET_HEAD#
                                        </cfif>
                                    </td>
                                </tr>
                            </cfloop>
                            </tbody>
                        </table>
                    </td>
                </tr>
            </tbody>
    </cf_medium_list>
	<!--- Departman ---->
	<cfquery name="get_department_req" dbtype="query">
		SELECT 
			*
		FROM 
			get_department_all
		WHERE 
			COMP_ID=#get_company.COMP_ID#
	</cfquery>
	<cfif get_department_req.recordcount>
	<cfloop query="get_department_req">
		<cfquery name="GET_DEP_REQ" dbtype="query">
			SELECT 
				*
			FROM 
				GET_DEP_REQ_ALL
			WHERE
				RELATION_ACTION_ID=#get_department_req.department_id#
		</cfquery>
		<cfquery name="GET_DEP_REQ_GRUP" dbtype="query">
			SELECT 
				*
			FROM 
				GET_DEP_REQ_GRUP_ALL
			WHERE
				RELATION_ACTION_ID=#get_department_req.department_id#
		</cfquery>
		
		<cfquery name="GET_DEP_TARGET" dbtype="query">
			SELECT
				*
			FROM 
				GET_DEP_TARGET_ALL
			WHERE
				DEPARTMENT_ID=#get_department_req.DEPARTMENT_ID#
		</cfquery>
	<cf_medium_list>
    	<thead>
            <tr>
                <th>&nbsp;#get_department_req.department_head#</th>
                <th style="text-align:right;">
                    <cfif listfind(pos_list,get_department_req.ADMIN1_POSITION_CODE,',') or listfind(pos_list,get_department_req.ADMIN2_POSITION_CODE,',')>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_add_perfection&dept_id=#get_department_req.department_id#&type=1','list');"><img src="../images/magic.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='31421.Yetkinlik Ekle'>"></a>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_add_perfection&dept_id=#get_department_req.department_id#&is_group=1','list');"><img src="../images/magic.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='31423.Grup Yetkinliklerinden Ekle'>"></a>
                    <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_add_target&dept_id=#get_department_req.department_id#','list');"><img src="../images/target.gif" border="0" align="absmiddle" title="<cf_get_lang dictionary_id='31422.Hedef Ekle'>"></a>
                    </cfif>
                </th>
            </tr>
       </thead>
       <tbody>
       	<tr class="nohover">
        	<td>
            	<table width="100%">
                	<thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='31352.Seçilen Grup Ana Yetkinlikleri'></th>
                            <th><cf_get_lang dictionary_id='31353.Seçilen Şirket Ana Yetkinlikleri'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <table>
                                    <cfloop query="GET_DEP_REQ_GRUP">
                                        <tr>
                                            <td>#GET_DEP_REQ_GRUP.currentrow# #GET_DEP_REQ_GRUP.REQ_TYPE#</td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </td>
                            <td>
                                <table>
                                    <cfloop query="GET_DEP_REQ">
                                        <tr>
                                            <td>#GET_DEP_REQ.currentrow# #GET_DEP_REQ.REQ_TYPE#</td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                 </table>
            </td>
			<td>
                <table width="100%">
                	<thead>
                        <tr>
                            <th><cf_get_lang dictionary_id='57964.Hedefler'></th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td>
                                <table>
                                    <cfloop query="GET_DEP_TARGET">
                                        <tr>
                                            <td>
                                                <cfif listfind(pos_list,get_department_req.ADMIN1_POSITION_CODE[get_department_req.currentrow],',') or listfind(pos_list,get_department_req.ADMIN2_POSITION_CODE[get_department_req.currentrow],',')>
                                                    #GET_DEP_TARGET.currentrow#. <a class="tableyazi" href="javascript://" onClick="windowopen('#request.self#?fuseaction=myhome.popup_upd_target&target_id=#GET_DEP_TARGET.TARGET_ID#','list');">#GET_DEP_TARGET.TARGET_HEAD#</a>
                                                <cfelse>
                                                    #GET_DEP_TARGET.currentrow# #GET_DEP_TARGET.TARGET_HEAD#
                                            </cfif>
                                            </td>
                                        </tr>
                                    </cfloop>
                                </table>
                            </td>
                        </tr>
                    </tbody>
                </table>
            </td>
		 </tr>
	   </tbody>
	</cf_medium_list>
	</cfloop>
	</cfif>
</cfoutput>
