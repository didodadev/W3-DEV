<cfsetting showdebugoutput="no">
<cfif len(attributes.card_no)>
<cfinclude template="../../add_options/query/add_online_pos_jokervada.cfm"><!--- sorgulama yapar --->
<cfif isdefined("approved_joker_info")>
	<cf_box title="Joker Vada" closable='0'>
	<table width="100%" height="100%" border="0" cellspacing="1" cellpadding="2">
		<tr height="100%">
			<cfif approved_joker_info eq 1><!--- Joker vada kontrolunden onay almışsa --->
				<td><cf_get_lang no ='1298.Joker Vada Seçenekleri'> : </td>
				<td>
				<cfoutput>
					<cfset code_sayisi = Arraylen(xml_response_node.posnetResponse.koiInfo.code)>
					<cfset message_sayisi = Arraylen(xml_response_node.posnetResponse.koiInfo.message)>
					<cfloop from="1" to="#code_sayisi#" index="i">
						<cfset vada_code = xml_response_node.posnetResponse.koiInfo.code[i].XmlText>
						<cfset vada_message = xml_response_node.posnetResponse.koiInfo.message[i].XmlText>
						<input type="radio" name="joker_options_value" id="joker_options_value" onClick="document.getElementById('joker_options_value').value=this.value;" value="#vada_code#">#vada_message#<br/>
					</cfloop>
				</cfoutput>
				</td>
			<cfelse>
				<td><cf_get_lang no ='1299.Joker Vada Sorgusu'> : </td>
				<td><cfoutput>#xml_response_node.posnetResponse.respText.XmlText#</cfoutput></td>
			</cfif>
		</tr>
	</table>
	</cf_box>
	<script type="text/javascript">
		document.getElementById('joker_vada_control').value = 1;//Buranın yeri değişmesin MER
	</script>
</cfif>
<cfelse>
	Kart No Giriniz!
</cfif>

