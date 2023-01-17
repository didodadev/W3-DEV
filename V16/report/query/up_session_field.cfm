<cfscript>
function replace_(list_, id1, id2, delimiter)
{
	temp1 = listgetat(evaluate(list_), id1, delimiter);
	temp2 = listgetat(evaluate(list_), id2, delimiter);
	SetVariable(list_, listsetat(evaluate(list_), id1, temp2, delimiter)); 
	SetVariable(list_, listsetat(evaluate(list_), id2, temp1, delimiter)); 
}
function replace_array_row(id1,id2)   
{
	replace_("session.report.my_fields", id1, id2, ",");
	replace_("session.report.my_field_ids", id1, id2, ",");
	replace_("session.report.my_field_funcs", id1, id2, ",");
	replace_("session.report.my_field_columns", id1, id2, ",");
	replace_("session.report.my_field_formats", id1, id2, ";");
	replace_("session.report.my_field_format_styles", id1, id2, ";");
}

replace_array_row(attributes.row_id, attributes.row_id - 1);
</cfscript>

<cflocation url="#cgi.HTTP_REFERER#" addtoken="no">
