<cfquery name="get_req" datasource="#DSN#">
    SELECT * FROM SETUP_REQ_TYPE 
  </cfquery>
  <cfquery name="get_company_member_req" datasource="#dsn#"> 
      SELECT REQ_ID FROM MEMBER_REQ_TYPE WHERE COMPANY_ID = #attributes.cpid#
  </cfquery>
  <cfset liste = valuelist(get_company_member_req.req_id)>
  <div class="col col-12 col-md-12 col-sm-12 col-xs-12">
      <cf_box title="#getLang('','Yetkinlikler','58709')#" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
          <cfform action="#request.self#?fuseaction=member.emptypopup_company_partner_req_type_upd&cpid=#attributes.cpid#" method="post" name="req">
              <cf_flat_list>
                  <thead>
                      <tr>
                          <th><cf_get_lang dictionary_id='57907.Yetkinlik'></th>
                          <th><cf_get_lang dictionary_id='58693.Seç'></th>
                      </tr>
                  </thead>
                  <tbody>
                      <cfoutput query="get_req">
                          <tr>
                              <td>#get_req.REQ_NAME#</td>
                              <td width="20">
                                  <input type="checkbox" name="REQ" id="REQ" value="#get_req.REQ_ID#"<cfif liste contains REQ_ID>checked</cfif>>
                              </td>
                          </tr>
                      </cfoutput>
                  </tbody>
              </cf_flat_list>
              <cf_box_footer>
                  <cf_workcube_buttons is_upd='0'>
              </cf_box_footer>
          </cfform>
      </cf_box>
  </div>
  