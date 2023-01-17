<cfscript>
VAR_ = attributes.var_;
for (i=1; i lte arraylen(session.hr[var_]); i = i+1)
	{
	if (isdefined('form.TAX_EXCEPTION#i#')) session.hr[var_][I][1] = EVALUATE('form.TAX_EXCEPTION#i#');
	if (isdefined('form.START_MONTH#i#')) session.hr[var_][I][2] = EVALUATE('form.START_MONTH#i#');
	if (isdefined('form.FINISH_MONTH#i#')) session.hr[var_][I][3] = EVALUATE('form.FINISH_MONTH#i#');
	if (isdefined('form.AMOUNT#i#')) session.hr[var_][I][4] = EVALUATE('form.AMOUNT#i#');
	}
</cfscript>

<cflocation url="#request.self#?fuseaction=hr.popup_salary_tax_exp_iframe" addtoken="no">
