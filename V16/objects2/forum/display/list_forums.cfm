<cfparam name="attributes.keyword" default="">
<cfinclude template="../query/get_forumlist.cfm">
<!--- <cfinclude template="../query/get_forums.cfm"> --->
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<table cellspacing="1" cellpadding="2" align="center" style="width:100%">
	<tr class="color-header" style="height:22px;">
		<td class="form-title"><cf_get_lang_main no='9.Forum'></td>
		<td class="form-title" style="width:130px;"><cf_get_lang no='992.Yöneticiler'></td>
		<td class="form-title" style="width:40px;"><cf_get_lang_main no='68.Konu'></td>
		<td class="form-title" style="width:40px;"><cf_get_lang_main no='131.Mesaj'></td>
		<td class="form-title" style="width:100px;"><cf_get_lang no='993.Son Mesaj Tarihi'></td>
  	</tr>
  	<cfif forumlist.recordcount eq 0>
		<tr class="color-row" style="height:20px;">
	  		<td colspan="7"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
		</tr>
	<cfelse>
		<cfoutput query="forumlist">
	  		<cfset attributes.forumid = forumid>
			<tr onMouseOver="this.className='color-light';" onMouseOut="this.className='color-row';" class="color-row" style="height:20px;">
				<td style="vertical-align:top"><a href="#request.self#?fuseaction=objects2.view_topic&forumid=#Forumid#" class="tableyazi"><b><font size="2">#forumName#</font></b></a><br/>&nbsp;#description# </td>
				<td style="vertical-align:top">
					<cfif len(admin_pos)>				  
						<cfset attributes.employee_poss = admin_pos>
						<cfinclude template="../query/get_employees.cfm">
						<cfloop query="employees">					
							<a href="javascript://"  onclick="windowopen('#request.self#?fuseaction=objects2.popup_emp_det&emp_id=#encrypt(employee_id,"WORKCUBE","BLOWFISH","Hex")#&pos_id=#position_code#&department_id=#department_id#','medium');" class="tableyazi">#employee_username#,</a>
						</cfloop>
					</cfif> 
					<cfif len(admin_pars)>				
						<cfset attributes.partner_poss = admin_pars>
						<cfinclude template="../query/get_partners.cfm">
						<cfloop query="partners">					
							#company_partner_username#,
						</cfloop>
					</cfif> 
					<cfif len(admin_cons)>
						<cfset attributes.consumer_poss = admin_cons>
						<cfinclude template="../query/get_consumers.cfm">
						<cfloop query="consumers">					
							#consumer_username#,
						</cfloop>
					</cfif> 
				</td>
				<td style="vertical-align:top">#topic_count#</td>
				<td style="vertical-align:top">#reply_count#</td>
				<td style="vertical-align:top">
					<cfif len(last_msg_date)>
						#dateformat(date_add('h',session_base.time_zone,last_msg_date),'dd/mm/yyyy')# (#timeformat(date_add('h',session_base.time_zone,last_msg_date),'HH:MM')#)<br/>
					</cfif>
					<cfif len(last_msg_userkey)>
						<cfset attributes.userkey = last_msg_userkey>
						<cfinclude template="../query/get_username.cfm">
						#get_username.username#
					</cfif>
				</td>
			</tr>
		</cfoutput>
	</cfif>
</table>

