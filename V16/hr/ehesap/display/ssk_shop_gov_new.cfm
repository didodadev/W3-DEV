<cfinclude template="../query/get_ssk_offices.cfm">
<cfif not isDefined("attributes.print")>
	<table width="100%" border="0" cellspacing="0" cellpadding="0" align="center">
	<tr class="color-border">
	<td colspan="2">
		<table width="100%" border="0" cellspacing="1" cellpadding="2">
			<tr class="color-row">
			<td>
				<table>
				<cfform name="get_managers" action="" method="post">
				<tr>
					<td class="headbold"><cf_get_lang dictionary_id='52963.İşyeri Bildirgesi'></td>
					<td  style="text-align:right;">
					<select name="SSK_OFFICE" id="SSK_OFFICE">
						<cfoutput query="GET_SSK_OFFICES">
						<cfif len(SSK_OFFICE) and len(SSK_NO)>
							<option value="#SSK_OFFICE#-#SSK_NO#"<cfif isdefined("attributes.SSK_OFFICE") and (attributes.SSK_OFFICE is "#SSK_OFFICE#-#SSK_NO#")> selected</cfif>>#BRANCH_NAME#-#SSK_OFFICE#-#SSK_NO#</option>
						</cfif>
						</cfoutput>
					</select>
					<input type="text" name="hierarchy" id="hierarchy" maxlength="50" value="<cfif isdefined("attributes.hierarchy")><cfoutput>#attributes.hierarchy#</cfoutput></cfif>" style="width:100px;">
					</td>
					<td width="20"><cf_wrk_search_button></td>
				</tr>
				</cfform>
				</table>
			</td>
			<td width="44"  style="text-align:right;"> 
			<cfif isdefined("attributes.SSK_OFFICE")>
				<a href="javascript://" onClick="<cfoutput>windowopen('#request.self#?fuseaction=ehesap.popup_ssk_shop_gov&print=true#page_code#','page')</cfoutput>"><img src="/images/print.gif" title="<cf_get_lang dictionary_id='58743.Gönder'>" border="0"></a> 
			</cfif>  	
			<a href="javascript://" onClick="javascript: window.close();"><img src="/images/close.gif" title="Kapat" border="0"></a>
			</td>
			</tr>
		</table>
	</td>
	</tr>
	</table>
<cfelse>
	<script type="text/javascript">
		function waitfor()
			{
			window.close();
			}
		setTimeout("waitfor()",3000);
		window.opener.close();
		window.print();
	</script>
</cfif>
<cfif isdefined('attributes.SSK_OFFICE')>
	<cfinclude template="../query/get_branch.cfm">
	<cfset attributes.sal_mon = Month(now())>
	<cfset attributes.sal_year = session.ep.period_year>
	<cfset bu_ay_basi = CreateDate(attributes.sal_year,attributes.sal_moon,1)>
	<cfoutput>#bu_ay_basi#</cfoutput>
</cfif>
*******************************************************************************************
