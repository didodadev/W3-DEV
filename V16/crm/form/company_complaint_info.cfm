<cfquery name="GET_SERVICE" datasource="#dsn#">
	SELECT
		SERVICE.SERVICE_DETAIL,
		SERVICE.SERVICE_NO,
		SERVICE.UPDATE_MEMBER,
		SERVICE.RECORD_MEMBER,
		SERVICE.APPLY_DATE,
		SERVICE.SERVICE_BRANCH_ID,
		SERVICE.SERVICE_ID,
		SERVICE_APPCAT.SERVICECAT,
		SP.PRIORITY,
		SP.COLOR,
		PROCESS_TYPE_ROWS.STAGE
	FROM
		 G_SERVICE SERVICE,
		 G_SERVICE_APPCAT SERVICE_APPCAT,
		SETUP_PRIORITY AS SP,
		PROCESS_TYPE_ROWS AS PROCESS_TYPE_ROWS
	WHERE 
		SERVICE.SERVICECAT_ID=SERVICE_APPCAT.SERVICECAT_ID AND
		SP.PRIORITY_ID = SERVICE.PRIORITY_ID AND
		SERVICE.SERVICE_COMPANY_ID = #ATTRIBUTES.CPID# AND
		SERVICE.SERVICE_STATUS_ID = PROCESS_TYPE_ROWS.PROCESS_ROW_ID
	ORDER BY
		SERVICE.RECORD_DATE DESC
</cfquery>
<cfquery name="GET_MANAGER_PARTNER" datasource="#dsn#">
	SELECT 
		COMPANY_PARTNER.PARTNER_ID 
	FROM
		COMPANY_PARTNER,
		COMPANY
	WHERE
		COMPANY.COMPANY_ID = #attributes.cpid# AND
		COMPANY.MANAGER_PARTNER_ID = COMPANY_PARTNER.PARTNER_ID
</cfquery>
<input type="hidden" name="frame_fuseaction" id="frame_fuseaction" value="<cfif isdefined("attributes.frame_fuseaction") and len(attributes.frame_fuseaction)><cfoutput>#attributes.frame_fuseaction#</cfoutput></cfif>">
<cfsavecontent variable="title"><cf_get_lang no='180.Şikayet Bilgileri'></cfsavecontent>
<cf_box title="#title#">
<cf_grid_list>
    <thead>
        <tr>
          <th width="50"></th>	
          <th width="100"><cf_get_lang_main no='330.Tarih'></th>
          <th width="110"><cf_get_lang_main no='41.Şube'></th>
          <th><cf_get_lang_main no='74.Kategori'></th>
          <th width="75"><cf_get_lang_main no='70.Aşama'></th>
          <th width="125"><cf_get_lang_main no='1174.İşlem Yapan'></th>
          <th><cf_get_lang_main no='217.Açıklama'></th>
          <th width="1%">
          <cfoutput>
              <a href="#request.self#?fuseaction=call.add_service&company_id=#attributes.cpid#&partner_id=#get_manager_partner.partner_id#" class="tableyazi" target="blank"><i class="fa fa-plus"></i></a>
          </cfoutput>
          </th> 
        </tr>
     </thead>
     <tbody>
        <cfoutput query="get_service">
           <tr>
              <td><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#" class="tableyazi" target="blank">#SERVICE_NO#</a></td>
              <td><cfif len(APPLY_DATE)>#dateformat(APPLY_DATE,dateformat_style)# (#timeformat(date_add('h',session.ep.time_zone,APPLY_DATE),timeformat_style)#)</cfif></td>
              <td><cfif len(SERVICE_BRANCH_ID)>
                    <cfset attributes.branch_id = SERVICE_BRANCH_ID>
                    <cfinclude template="../query/get_branch.cfm">
                    #GET_BRANCH.BRANCH_NAME#
                  </cfif>
              </td>
              <td>#serviceCAT#</td>
              <td>#stage#</td> 
              <td><cfif len(UPDATE_MEMBER)>#get_emp_info(UPDATE_MEMBER,0,0)#<cfelseif len(RECORD_MEMBER)>#get_emp_info(RECORD_MEMBER,0,0)#</cfif></td>    
              <td title="#service_detail#">#left(service_detail,25)#</td>
              <td><a href="#request.self#?fuseaction=call.list_service&event=upd&service_id=#service_id#" class="tableyazi" target="blank"><i class="fa fa-pencil"></i></a></td>
          </tr>
        </cfoutput>
     </tbody>
<cf_grid_list>
</cf_box>
