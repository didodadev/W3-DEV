<cfscript>
function replace_(field_,id1,id2)
{
	temp = "";
	SetVariable("temp", evaluate("#field_#[#id1#]")); 
	SetVariable("#field_#[#id1#]", evaluate("#field_#[#id2#]")); 
	SetVariable("#field_#[#id2#]", temp); 
}
function replace_array_row(id1,id2)   
{
	replace_("session.report.bracket", id1, id2);
	replace_("session.report.compare_", id1, id2);
	replace_("session.report.condition", id1, id2);
	replace_("session.report.cond_type", id1, id2);
	replace_("session.report.field_id_1", id1, id2);
	replace_("session.report.field_name_1", id1, id2);
	replace_("session.report.field_column_1", id1, id2);
	replace_("session.report.field_id_2", id1, id2);
	replace_("session.report.field_name_2", id1, id2);
	replace_("session.report.field_column_2", id1, id2);
}

replace_array_row(attributes.row_id, attributes.row_id - 1);
</cfscript>

<cflocation url="#cgi.HTTP_REFERER#" addtoken="no">
