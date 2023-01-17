<cfscript>
sub_datasource_list='';
sub_list ='';
sub_related_columns_list='';
for(inx=1;inx lte attributes.record_num;inx=inx+1)
{
	pre_dsn = evaluate("attributes.sub_table_dsn_#inx#");
	sub_datasource_list= listappend(sub_datasource_list,evaluate('#pre_dsn#'),',');
	sub_list= listappend(sub_list,evaluate('attributes.sub_table_#inx#'),',');
	sub_related_columns_list= listappend(sub_related_columns_list,evaluate("attributes.sub_table_related_columns_#inx#"),',');
}
	xml_doc = wrk_xml(
						main_table : attributes.main_table,
						main_table_datasource : evaluate("#attributes.table_dsn#"),
						query_where : attributes.where_text,
						query_order : attributes.order_text,
						main_table_related_columns : attributes.main_table_related_columns,
						sub_table_list : sub_list,
						sub_table_datasource_list : sub_datasource_list,
						sub_table_related_columns_list : sub_related_columns_list
						//sub_table_query_table_list : 
						//sub_table_query_list:
					);
</cfscript>	

<!--- 
<cfdump var="#xml_doc#"> 
<cffile action="write" file="#upload_folder#ship.xml" output="#toString(xml_doc)#" charset="utf-8">
--->
<!--- <cfset upload_folder = "#upload_folder##dir_seperator#">
<cfset file_name = "#CreateUUID()#.xml">
<cfoutput>#CreateUUID()#.xml</cfoutput>
<cffile action="write" file="#upload_folder##file_name#" output="#toString(xml_doc)#" charset="utf-8"> --->
<cffile action="write" file="#upload_folder#invoice.xml" output="#toString(xml_doc)#" charset="utf-8">
<script type="text/javascript">
location.href = document.referrer;
</script>