<cfquery name="get_values" datasource="#dsn3#">
	SELECT * FROM ORDER_INFO_PLUS WHERE ORDER_ID = #attributes.id#
</cfquery>
<cfquery name="get_labels" datasource="#dsn3#">
	SELECT * FROM SETUP_PRO_INFO_PLUS_NAMES WHERE OWNER_TYPE_ID = #attributes.type_id#
</cfquery>
<cfset attributes.order_id = attributes.id>
<cfif get_labels.recordcount>
	<table border="0" cellspacing="1" cellpadding="2" width="100%" height="100%" class="color-border">
		<tr height="35" class="color-list">
			<td class="headbold"><cf_get_lang dictionary_id="59816.Fatura Ek Bilgiler"></td>
		</tr>
		<tr>
			<td class="color-row" valign="top">
			<table>
			<cfif get_values.recordcount>
				<cfset send_par="upd_info_plus_act">
			<cfelse>
				<cfset send_par="add_info_plus_act">
			</cfif>
			<cfform action="#request.self#?fuseaction=sales.#send_par#" method="post">
				<input type="hidden" name="order_id" id="order_id" value="<cfoutput>#attributes.order_id#</cfoutput>">
				<cfloop index="i" from="1" to="7">
					<cfoutput>
					<tr>
						<td width="100">
							<cfif len(Evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
								#Evaluate("GET_LABELS.PROPERTY#i#_NAME")#
							</cfif>
						</td>
						<td width="175">
							<cfif len(Evaluate("GET_LABELS.PROPERTY#i#_NAME"))>
								<input type="text" name="PROPERTY#i#" id="PROPERTY#i#" <cfif get_values.recordcount>value="#Evaluate('GET_VALUES.PROPERTY#i#')#"</cfif> style="width:150px;">
							</cfif>
						</td>
						<td width="100">
							<cfset j=i+7>
							<cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME"))>
								#Evaluate("GET_LABELS.PROPERTY#j#_NAME")#
							</cfif>
						</td>
						<td>
							<cfif len(Evaluate("GET_LABELS.PROPERTY#j#_NAME"))>
								<input type="text" name="PROPERTY#j#" id="PROPERTY#j#" <cfif get_values.recordcount>value="#Evaluate('GET_VALUES.PROPERTY#j#')#"</cfif>  style="width:150px;">
							</cfif>
						</td>
					</tr>
					</cfoutput>
				</cfloop>
				 <cfloop index="i" from="0" to="4" step="2">
					<cfoutput>
					<tr>
						<td>
							<cfset st = i + 15>
							<cfif len(Evaluate('GET_LABELS.PROPERTY#st#_NAME'))>
								#Evaluate('GET_LABELS.PROPERTY#st#_NAME')#
							</cfif>
						</td>
						<td>
							<cfif len(Evaluate('GET_LABELS.PROPERTY#st#_NAME'))>
								<textarea name="PROPERTY#st#" id="PROPERTY#st#" style="width:150px;height:50px;"><cfif get_values.recordcount>#Evaluate('GET_VALUES.PROPERTY#st#')#</cfif></textarea>
							</cfif> 
						</td>
						<td>
							<cfset j = i + 15 + 1>
							<cfset j = st + 1>
							<cfif len(Evaluate('GET_LABELS.PROPERTY#j#_NAME'))>
								#Evaluate('GET_LABELS.PROPERTY#j#_NAME')#
							</cfif> 
						</td>
						<td>
							<cfif len(Evaluate('GET_LABELS.PROPERTY#j#_NAME'))> 
								<textarea name="PROPERTY#j#" id="PROPERTY#j#" style="width:150px;height:50px;"><cfif get_values.recordcount>#Evaluate('GET_VALUES.PROPERTY#j#')#</cfif></textarea>
							</cfif> 
						</td>
					</tr>
					</cfoutput>
				</cfloop>
				<tr>
					<td colspan="4" style="text-align:right;"><cf_workcube_buttons is_upd='0'></td>
				</tr>
				</cfform> 
			</table>
			</td>
		</tr>
	</table>
<cfelse>
	<table border="0" cellspacing="1" cellpadding="2" width="100%" height="100%" class="color-border">
		<tr height="35" class="color-list">
			<td class="headbold">&nbsp;<cf_get_lang dictionary_id="59816.Fatura Ek Bilgiler"></td>
		</tr>
		<tr>
			<td class="color-row" valign="top">
			<table>
				<tr>
					<td><cf_get_lang dictionary_id="29717.Ayarlar Modülünden Ek Bilgi Detaylarını Doldurunuz">.</td>
				</tr>
				<tr>
					<td><input type="button" value="<cf_get_lang dictionary_id='57553.Kapat'>" onClick="window.close();" style="width:65px;"></td>
				</tr>
			</table>
			</td>
		</tr>
	</table>
</cfif>
