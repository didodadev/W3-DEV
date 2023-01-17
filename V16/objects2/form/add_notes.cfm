<table cellspacing="1" cellpadding="2" class="color-border" align="center" style="width:100%; height:100%">
	<tr class="color-list" style="height:35px;">
	  	<td class="headbold"><cf_get_lang_main no='55.Not'></td>
	</tr> 
	<tr class="color-row">
	  	<td style="vertical-align:top">
			<table>
			  	<cfform name="add_notes" action="#request.self#?fuseaction=objects2.emptypopup_add_notes_visited" method="post">
					<cfif isdefined('attributes.workgroup_id')>
						<input type="hidden" name="workgroup_id" id="workgroup_id" value="<cfoutput>#attributes.workgroup_id#</cfoutput>">
					</cfif>
			   		<tr>
				  		<td></td>
				  		<td><cf_get_lang no ='1289.Not Bırakan'> *</td>
				  		<td>
							<cfsavecontent variable="alert"><cf_get_lang no ='1290.Lütfen İsminizi Giriniz'></cfsavecontent>
							<cfif isdefined("session.ww.userid") and len(session.ww.userid)>
								<cfinput type="text" name="member" id="member" value="#session.ww.name# #session.ww.surname#" style="width:150;" maxlength="200" required="yes" message="#alert#">
				  			<cfelse>
								<cfinput type="text"name="member" id="member" value="" style="width:150;" maxlength="200" required="yes" message="#alert#">
				  			</cfif>
				  		</td>
					</tr>
					<tr>
				  		<td style="width:5px;"></td>
				  		<td><cf_get_lang_main no='87.Telefon'></td>
				  		<td><input type="text" name="tel" id="tel" style="width:150px;" maxlength="15"></td>
					</tr>
					<tr>
				  		<td></td>
				  		<td><cf_get_lang_main no='16.E-Posta'></td>
				  		<td><cfsavecontent variable="alert"><cf_get_lang_main no ='1072.Lütfen Geçerli Bir E-posta Adresi Giriniz!'></cfsavecontent>
							<cfinput type="text" name="email" id="email" style="width:150px;" validate="email">
						</td>
					</tr>
					<tr>
				  		<td></td>
						<cfoutput>
							<cfif isdefined("attributes.employee_id")>
							  	<td><cf_get_lang no ='1291.Not Bırakılan'></td>
							  	<td>
									<input type="hidden" name="member_visited_id" id="member_visited_id" value="#attributes.employee_id#">
									<input type="hidden" name="member_visited_type" id="member_visited_type" value="1">
									<cfinclude template="../query/get_employee.cfm">
									<input type="text" name="member_visited" id="member_visited" style="width:150;" readonly value="<cfoutput>#get_employee.employee_name# #get_employee.employee_surname#</cfoutput>">
							  	</td>
							<cfelseif isdefined("attributes.partner_id")>
								<td><cf_get_lang no ='1291.Not Bırakılan'></td>
							  	<td>
									<input type="hidden" name="member_visited_id" id="member_visited_id" value="#attributes.partner_id#">
									<input type="hidden" name="member_visited_type" id="member_visited_type" value="2">
									<cfinclude template="../query/get_partner.cfm">
									<input type="text" name="member_visited" id="member_visited" style="width:150;" readonly value="<cfoutput>#get_partner.company_partner_name# #get_partner.company_partner_surname#</cfoutput>">
								</td>
							</cfif>
						</cfoutput>
					</tr>
					<tr>
				  		<td></td>
				  		<td style="vertical-align:top"><cf_get_lang_main no ='217.Açıklama'> *</td>
				  		<td><textarea name="detail" id="detail" style="width:250;height:70px;"></textarea></td>
					</tr>
					<tr style="height:35px;">
				  		<td colspan="3" style="text-align:right;"><cf_workcube_buttons is_upd='0' add_function='kontrol()'></td>
					</tr>
			  	</cfform>
			</table>
	  	</td>
	</tr>
 </table>

<script type="text/javascript">
	function kontrol()
	{
		x = (1000 - document.getElementById('detail').value.length);
		if ( x < 0 )
		{ 
			alert ("<cf_get_lang_main no ='217.Açıklama'> "+ ((-1) * x) +"<cf_get_lang_main no ='1741.Karakter Uzun'>  !");
			return false;
		}
		if(document.getElementById('detail').value=="")
		{
			alert("<cf_get_lang no ='1292.Açıklama Girmelisiniz'> !");
			return false;
		}
		return true;
	}
</script>

