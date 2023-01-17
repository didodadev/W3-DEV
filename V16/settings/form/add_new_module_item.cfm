<cfquery name="get_new_item" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_LANGUAGE
</cfquery>
<!--- LANGUAGE_SHORT --->
      <table cellspacing="1" cellpadding="2" border="0" width="100%" height="100%" class="color-border" align="center">
        <tr class="color-list" valign="middle">
          <td height="35">
            <table width="98%" align="center">
              <tr>
                <td valign="bottom" class="headbold"><cf_get_lang_main no='1729.Add Word/Kelime Ekle'></td>
              </tr>
            </table>
          </td>
        </tr>
        <tr class="color-row" valign="top">
          <td>
            <table align="center" width="98%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td colspan="2"> <br/>
                  <table>
                   <cfform action="#request.self#?fuseaction=settings.emptypopup_add_module_new_item_act" method="post" name="add_sub_name">
					   <input type="hidden" name="module_name" id="module_name" value="<cfoutput>#attributes.strmodule#</cfoutput>">
					   <cfloop from="1" to="#get_new_item.recordcount#" index="i">
							<cfset NEW_DB_NAME="SETUP_LANGUAGE_#UCASE(get_new_item.LANGUAGE_SHORT[i])#">
							<cfif DATABASE_TYPE IS "MSSQL">
								<cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
									SELECT * FROM 	sysobjects 
									WHERE id = object_id(N'[#NEW_DB_NAME#]') and OBJECTPROPERTY(id, N'IsUserTable') = 1
								</cfquery>
							<cfelseif DATABASE_TYPE IS "DB2">
								<cfquery name="GET_LANGUAGE_DB" datasource="#DSN#">
									SELECT TBNAME FROM SYSIBM.SYSCOLUMNS WHERE TBNAME='#NEW_DB_NAME#'
								</cfquery>
							</cfif>					   
							<cfif GET_LANGUAGE_DB.recordcount >
								<tr>
								<td>
									<cfoutput>#get_new_item.LANGUAGE_SET[i]#</cfoutput>
									<input  type="hidden"  name="db_isimleri" id="db_isimleri"  value="<cfoutput>#UCASE(get_new_item.LANGUAGE_SHORT[i])#</cfoutput>">
								</td>
								<td>
								<cfsavecontent variable="message"><cf_get_lang no='724.Kelime Ekle girmelisiniz'></cfsavecontent>
								<cfinput TYPE="text"  required="yes" NAME="item_name_#get_new_item.LANGUAGE_SHORT[i]#" message="#message#" STYLE="width:305px;"  MAXLENGTH="500"></td>
								</tr>
							</cfif>
					   </cfloop>
                      <tr align="center">
                        <td height="35" colspan="2" align="right" style="text-align:right;">
							<cf_workcube_buttons is_upd='0'>
                        </td>
                      </tr>
                    </cfform>
                  </table>
                </td>
              </tr>
            </table>
          </td>
        </tr>
      </table>
    </td>
  </tr>
</table>

