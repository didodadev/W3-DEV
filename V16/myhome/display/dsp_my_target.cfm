<cfif fusebox.circuit eq 'myhome'>
    <cfset attributes.target_id = contentEncryptingandDecodingAES(isEncode:0,content:attributes.target_id,accountKey:session.ep.userid)>
    <cfset attributes.position_code = contentEncryptingandDecodingAES(isEncode:0,content:attributes.position_code,accountKey:session.ep.userid)>
</cfif>
<cfquery name="get_target" datasource="#dsn#">
   SELECT
     *
  FROM
	  TARGET 
	WHERE
	  TARGET_ID = #attributes.TARGET_ID#
</cfquery>
<cfsavecontent variable="message"><cf_get_lang dictionary_id="57951.Hedef"></cfsavecontent>
<cf_popup_box title="#message#: #session.ep.name# #session.ep.surname#">
	<table>
		<tr height="20">
			<td class="txtbold"><cf_get_lang dictionary_id='57486.Kategori'></td>
			<td>: 
				<cfinclude template="../query/get_target_cats.cfm">
					<cfoutput query="get_target_cats">
						<cfif get_target.targetcat_id eq targetcat_id>
							#targetcat_name#
						</cfif>
					</cfoutput> </td>
		</tr>
		<tr height="20">
			<td class="txtbold"><cf_get_lang dictionary_id='57951.Hedef'></td>
			<td>: <cfoutput>#get_target.target_head#</cfoutput></td>
		</tr>
		<tr height="20">
			<td class="txtbold"><cf_get_lang dictionary_id='57501.Başlangıç'>-<cf_get_lang dictionary_id='57502.Bitiş'></td>
			<td>: <cfoutput>#dateformat(get_target.startdate,dateformat_style)# - #dateformat(get_target.finishdate,dateformat_style)#</cfoutput> </td>
		</tr>
        <tr height="20">
        	<td class="txtbold"><cf_get_lang dictionary_id='31599.Hedef Ağırlığı'></td>
            <td>: <cfoutput>#get_target.target_weight#</cfoutput></td>
        </tr>
		<tr height="20">
			<td class="txtbold"><cf_get_lang dictionary_id='30968.Rakam'></td>
			<td>: <cfoutput>#TLFormat(get_target.target_number)#</cfoutput> &nbsp;
				<cfif len(get_target.CALCULATION_TYPE) and get_target.CALCULATION_TYPE eq 1>+ (<cf_get_lang dictionary_id='31142.Artış Hedefi'>)
					<cfelseif len(get_target.CALCULATION_TYPE) and get_target.CALCULATION_TYPE eq 2>- (<cf_get_lang dictionary_id='31143.Düşüş Hedefi'>)
					<cfelseif len(get_target.CALCULATION_TYPE) and get_target.CALCULATION_TYPE eq 3>+% (<cf_get_lang dictionary_id='31144.Yüzde Artış Hedefi'>)
					<cfelseif len(get_target.CALCULATION_TYPE) and get_target.CALCULATION_TYPE eq 4>-% (<cf_get_lang dictionary_id='31145.Yüzde Düşüş Hedefi'>)
					<cfelseif len(get_target.CALCULATION_TYPE) and get_target.CALCULATION_TYPE eq 5> = (<cf_get_lang dictionary_id='31146.Hedeflenen Rakam'>)
				</cfif></td>
		</tr>
		<tr height="20">
			<td class="txtbold"><cf_get_lang dictionary_id='31141.Ayrılan Bütçe'></td>
			<td>: <cfoutput>#TLFormat(get_target.SUGGESTED_BUDGET)#&nbsp;<cfif len(get_target.TARGET_MONEY)>#get_target.TARGET_MONEY#</cfif></cfoutput></td>
		</tr>
			<tr height="20">
			<td class="txtbold"><cf_get_lang dictionary_id='57629.Açıklama'></td>
			<td>: <cfoutput>#get_target.target_detail#</cfoutput></td>
		</tr>
	</table>
</cf_popup_box>