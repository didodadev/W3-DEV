<!---Select ifadeleri düzenlendi e.a 24.072012--->
<!--- Alt Tree Kategorilerin Gonderi Listesini Goruntuler FBS 20081114 --->
<cfset position_code_list = "">
<cfset position_cat_list = "">
<cfquery name="get_status_pos_code_cat" datasource="#dsn#">
	SELECT
		SERVICE_SUB_STATUS_ID,
		POSITION_CAT_ID,
		POSITION_CODE
	FROM 
		G_SERVICE_APPCAT_SUB_STATUS_POST 
	WHERE 
		SERVICE_SUB_STATUS_ID = #service_sub_status_id#
</cfquery>
<cfoutput query="get_status_pos_code_cat">				
	<cfif len(position_code) and not listfind(position_code_list,position_code)>
		<cfset position_code_list=listappend(position_code_list,position_code)>
	</cfif>
	<cfif len(position_cat_id) and not listfind(position_cat_list,position_cat_id)>
		<cfset position_cat_list=listappend(position_cat_list,position_cat_id)>
	</cfif>
</cfoutput>
<cfif len(position_code_list)>
	<cfset position_code_list = listsort(position_code_list,'numeric','ASC',',')>
	<cfquery name="get_position_code" datasource="#dsn#">
		SELECT
			EP.POSITION_CODE,
			EP.EMPLOYEE_EMAIL,
			EP.POSITION_NAME,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS EP,
			DEPARTMENT D
		WHERE 
			EP.POSITION_CODE IN (#position_code_list#) AND
			EP.EMPLOYEE_EMAIL IS NOT NULL AND
			EP.DEPARTMENT_ID = D.DEPARTMENT_ID
	</cfquery>
	<cfset position_code_list = listsort(listdeleteduplicates(valuelist(get_position_code.position_code,',')),'numeric','ASC',',')>
</cfif>
<cfif len(position_cat_list)>
	<cfset position_cat_list = listsort(position_cat_list,'numeric','ASC',',')>
	<cfquery name="get_position_cat" datasource="#dsn#">
		SELECT
			EP.POSITION_CODE,
			EP.EMPLOYEE_NAME,
			EP.EMPLOYEE_SURNAME,
			EP.POSITION_NAME,
			EP.EMPLOYEE_EMAIL,
			SPC.POSITION_CAT_ID,
			SPC.POSITION_CAT
		FROM
			EMPLOYEE_POSITIONS EP,
			SETUP_POSITION_CAT SPC
		WHERE
			EP.EMPLOYEE_NAME IS NOT NULL AND
			EP.EMPLOYEE_EMAIL IS NOT NULL AND
			EP.POSITION_CAT_ID = SPC.POSITION_CAT_ID AND
			SPC.POSITION_CAT_ID IN (#position_cat_list#)
		ORDER BY
			SPC.POSITION_CAT_ID
	</cfquery>
	<cfset position_cat_list = listsort(listdeleteduplicates(valuelist(get_position_cat.position_cat_id,',')),'numeric','ASC',',')>
</cfif>

<cfset position_code_info_list = "">
<cfquery name="get_status_pos_code_info" datasource="#dsn#">
	SELECT 
    	SERVICE_SUB_STATUS_ID, 
        POSITION_CODE_INFO 
    FROM 
    	G_SERVICE_APPCAT_SUB_STATUS_INFO 
    WHERE 
	    SERVICE_SUB_STATUS_ID = #service_sub_status_id#
</cfquery>
<cfoutput query="get_status_pos_code_info">				
	<cfif len(position_code_info) and not listfind(position_code_info_list,position_code_info)>
		<cfset position_code_info_list=listappend(position_code_info_list,position_code_info)>
	</cfif>
</cfoutput>
<cfif len(position_code_info_list)>
	<cfset position_code_info_list = listsort(position_code_info_list,'numeric','ASC',',')>
	<cfquery name="get_position_code_info" datasource="#dsn#">
		SELECT
			POSITION_CODE,
			EMPLOYEE_EMAIL,
			POSITION_NAME,
			EMPLOYEE_NAME,
			EMPLOYEE_SURNAME
		FROM
			EMPLOYEE_POSITIONS
		WHERE
			EMPLOYEE_EMAIL IS NOT NULL AND
			POSITION_CODE IN (#position_code_info_list#)
		ORDER BY
			POSITION_CODE
	</cfquery>
	<cfset position_code_info_list = listsort(listdeleteduplicates(valuelist(get_position_code_info.position_code,',')),'numeric','ASC',',')>
</cfif>
<cf_popup_box title="#getLang('call',51)#">
		<table>
			<tr>
				<td class="formbold" height="30"><cf_get_lang_main no='1592.Pozisyon Tipi'></td>
			</tr>
			<tr>
				<td><cfif len(position_cat_list)>
						<cfoutput query="get_position_cat" group="position_cat_id">
							<em><u>#position_cat#</u></em><br/>
							<cfoutput>
								&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#employee_name# #employee_surname# (#employee_email#)<br/>
							</cfoutput><br/>
						</cfoutput>
					<cfelse>
						<cf_get_lang_main no='72.Kayıt Yok'>!
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="formbold" height="30"><cf_get_lang no='99.Pozisyonlar'></td>
			</tr>
			<tr>
				<td><cfif len(position_code_list)>
						<cfoutput query="get_position_code">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#employee_name# #employee_surname# (#employee_email#) - #position_name#<br/>
						</cfoutput>
					<cfelse>
						<cf_get_lang_main no='72.Kayıt Yok'>!
					</cfif>
				</td>
			</tr>
			<tr>
				<td class="formbold" height="30"><cf_get_lang_main no='1361.Bilgi Verilecekler'></td>
			</tr>
			<tr>
				<td><cfif len(position_code_info_list)>
						<cfoutput query="get_position_code_info">
							&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#employee_name# #employee_surname# (#employee_email#) - #position_name#<br/>
						</cfoutput>
					<cfelse>
						<cf_get_lang_main no='72.Kayıt Yok'>!
					</cfif>
				</td>
			</tr>
		</table>
</cf_popup_box>
