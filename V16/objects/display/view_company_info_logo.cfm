<cfquery name="CHECK" datasource="#DSN#">
	SELECT
	    COMPANY_NAME,
		TEL_CODE,
		TEL,
		TEL2,
		TEL3,
		TEL4,
		FAX,
		ADDRESS,
		WEB,
		EMAIL,
		ASSET_FILE_NAME3,
		ASSET_FILE_NAME3_SERVER_ID,
		TAX_OFFICE,
		TAX_NO
	FROM
	   OUR_COMPANY
	WHERE
	<cfif isDefined("SESSION.EP.COMPANY_ID")>
	    COMP_ID = #SESSION.EP.COMPANY_ID#
	<cfelseif isDefined("SESSION.PP.COMPANY")>	
	    COMP_ID = #session.pp.company_id#
	</cfif> 
</cfquery>
<table width="650" border="0" cellspacing="0" cellpadding="0">
	<tr> 
		<td valign="top">
			<cfoutput QUERY="CHECK">
				<font class="headbold">#company_name#</font><br/>
				<b><cf_get_lang dictionary_id='57499.Telefon'>: </b> (#tel_code#) - #tel#  #tel2#  #tel3# #tel4# <br/>
				<b><cf_get_lang dictionary_id='57488.Fax'>: </b> #fax# <br/>
				#address#<br/>
				<b><cf_get_lang dictionary_id='58762.Vergi Dairesi'> - <cf_get_lang dictionary_id='57487.No'>:</b> #TAX_OFFICE# - #TAX_NO#<br/>
				#web# - #email#
			</cfoutput>
		</td>
		<cfif len(check.asset_file_name3)>
			<td style="text-align:right;">
				<cfoutput>
					<cf_get_server_file output_file="settings/#check.asset_file_name3#" output_server="#CHECK.asset_file_name3_server_id#" output_type="5">
				</cfoutput>
			</td>
		</cfif>
	</tr>
	<tr>
		<td colspan="2"><hr></td>
	</tr>
</table>

