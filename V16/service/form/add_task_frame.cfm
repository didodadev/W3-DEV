<cfinclude template="../query/get_service_task.cfm">
<table cellspacing="1" cellpadding="2" border="0" class="color-border" style="width:98%">
        <tr class="color-header" height="22">
          <td>
            <table width="100%" cellpadding="0" cellspacing="0" border="0">
              <tr>
                <td class="form-title" width="65"><cf_get_lang no='62.Görevler'></td>
                <td align="right" style="text-align:right;">
				<a href="<cfoutput>#request.self#?fuseaction=project.works&event=add&work_fuse=service.list_service&event=upd&service_id=#attributes.service_id#</cfoutput>"><img src="/images/plus_square.gif" border="0" ></a>
				</td>
			  </tr>
            </table>
          </td>
        </tr>
		<cfoutput query="get_service_task">
			<tr clasS="color-row">
				<td>
					<table border="0">
					  <tr>
						<td class="txtboldblue" width="50"><cf_get_lang_main no='157.Görevli'></td>
						<td width="100%">
						<cfif len(get_service_task.PROJECT_EMP_ID)>
							#get_emp_info(get_service_task.PROJECT_EMP_ID,0,0)#
						<cfelseif len(get_service_task.outsrc_partner_id)>
							#get_par_info(get_service_task.outsrc_partner_id,0,0,0)#
						</cfif></td>
						<td><a href="#request.self#?fuseaction=project.works&event=det&id=#"><img src="/images/update_list.gif" border="0" ></a></td>
					  </tr>
					  <tr>
						<td class="txtboldblue" valign="top"><cf_get_lang_main no='330.Tarih'> </td>
						<td colspan="2">#dateformat(get_service_task.TARGET_START,dateformat_style)#-#dateformat(get_service_task.TARGET_FINISH,dateformat_style)#</td>
					  </tr>
					  <tr>
						<td class="txtboldblue" valign="top"><cf_get_lang_main no='217.Açıklama'></td>
						<td colspan="2">#get_service_task.WORK_DETAIL# </td>
					  </tr>
					</table>
					</td>
			</tr>
		</cfoutput>
      </table>
