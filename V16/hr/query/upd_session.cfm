<cfscript>
VAR_ = attributes.var_;
for (i=1; i lte arraylen(SESSION.hr[VAR_]); i = i+1)
	{
	if (isdefined('form.COMMENT#i#')) SESSION.hr[VAR_][I][1] = EVALUATE('form.COMMENT#i#');
	if (isdefined('form.PERIOD#i#')) SESSION.hr[VAR_][I][2] = EVALUATE('form.PERIOD#i#');
	if (isdefined('form.METHOD#i#')) SESSION.hr[VAR_][I][3] = EVALUATE('form.METHOD#i#');
	if (isdefined('form.AMOUNT#i#')) SESSION.hr[VAR_][I][4] = EVALUATE('form.AMOUNT#i#');
	if (isdefined('form.SSK#i#')) SESSION.hr[VAR_][I][5] = EVALUATE('form.SSK#i#'); else SESSION.hr[VAR_][I][5] = 0;
	if (isdefined('form.TAX#i#')) SESSION.hr[VAR_][I][6] = EVALUATE('form.TAX#i#'); else SESSION.hr[VAR_][I][6] = 0;
	if (isdefined('form.show#i#')) SESSION.hr[VAR_][I][7] = EVALUATE('form.show#i#'); else SESSION.hr[VAR_][I][7] = 0;
	if (isdefined('form.start_sal_mon#i#')) SESSION.hr[VAR_][I][8] = EVALUATE('form.start_sal_mon#i#'); else SESSION.hr[VAR_][I][8] = 1;
	if (isdefined('form.end_sal_mon#i#')) SESSION.hr[VAR_][I][9] = EVALUATE('form.end_sal_mon#i#'); else SESSION.hr[VAR_][I][9] = 12;
	}
</cfscript>

<cfif attributes.var_ is "salary_pay_upd">
  <cflocation url="#request.self#?fuseaction=hr.popup_salaryparam_pay_iframe" addtoken="no">
<cfelseif attributes.var_ is "salary_get_upd">
  <cflocation url="#request.self#?fuseaction=hr.popup_salaryparam_get_iframe" addtoken="no">
</cfif>
