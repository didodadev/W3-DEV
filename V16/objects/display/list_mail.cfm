<cfif isDefined("attributes.names")><cfset name_list = attributes.names></cfif>
<cfset mail_list = attributes.mails>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='32440.Mail Listesi'></cfsavecontent>
<cf_popup_box title="#message#">
	<table>
		<tr>
			<td class="txtbold" style="width:200px;"><cf_get_lang dictionary_id='57570.Ad Soyad'></th>
			<td class="txtbold"><cf_get_lang dictionary_id='57428.Mail'></th>
		</tr>
		<cfloop from="1" to="#ListLen(mail_list)#" index="i"> 				  
			<tr>
				<cfoutput>				  
				<cfif isDefined("attributes.names")><td>#ListGetAt(name_list,i)#</td></cfif>
				<td>#ListGetAt(mail_list,i)#</td>
				</cfoutput>
			</tr>
		</cfloop>
	</table> 
</cf_popup_box>
