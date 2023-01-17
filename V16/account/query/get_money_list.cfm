<cfif not isdefined('attributes.money')>
	<cfset attributes.money=session.ep.money>
	<cfset attributes.rate=1>
</cfif>
<cfinclude template="../query/get_moneys.cfm">
<div class="form-group medium" id="money">
    <input type="hidden" name="old_money" id="old_money" value="<cfoutput>#attributes.money#</cfoutput>">
    <input name="rate" id="rate" type="text" value="<cfoutput>#wrk_round(attributes.rate,'#session.ep.our_company_info.rate_round_num#')#</cfoutput>">
</div>
<div class="form-group small" id="money">
    <select name="money" id="money" onChange="change_fintab_money(this.value);" >
        <cfoutput query="GET_MONEYS">
            <option value="#MONEY#"<cfif attributes.money eq MONEY>Selected</cfif>>#MONEY#</option>
        </cfoutput>
    </select> 
</div>
<script type="text/javascript">
function change_fintab_money(xxx)
{
	<cfoutput query="GET_MONEYS">
		if('#GET_MONEYS.MONEY#' == xxx)
		{
			document.getElementById('rate').value=commaSplit('#GET_MONEYS.RATE2#','#session.ep.our_company_info.rate_round_num#');
		}
	</cfoutput>
}
</script>
