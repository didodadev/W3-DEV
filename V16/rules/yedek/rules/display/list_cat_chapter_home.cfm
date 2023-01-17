<!--- FBS 20140621 Kirilimlar duzenlendi, fazla queryler temizlendi, sorun olursa bilgi verin --->
<cfif isDefined('session.ep.userid')>
	<cfset lang_ = session.ep.language>
    <cfset comp_id_ = session.ep.company_id>
<cfelse>
	<cfset lang_ = session.pda.language>
    <cfset comp_id_ = session.pda.company_id>
</cfif>
<cfquery name="get_lit_names" datasource="#dsn#">
    SELECT 
        CC.CONTENTCAT, 
        CC.CONTENTCAT_ID 
    FROM 
        CONTENT_CAT CC
        RIGHT JOIN CONTENT_CAT_COMPANY CCC ON CCC.CONTENTCAT_ID = CC.CONTENTCAT_ID
    WHERE
		IS_RULE = 1 AND
        CC.LANGUAGE_ID = <cfqueryparam cfsqltype="cf_sql_varchar" value="#lang_#"> 
        AND CCC.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#comp_id_#"> 
    ORDER BY 
        CC.CONTENTCAT ASC
</cfquery>
<cfif isdefined("attributes.is_home") and not isdefined("attributes.contentcat_id")>
	<cfif get_lit_names.recordcount>
		<cfset attributes.contentcat_id = get_lit_names.contentcat_id>
	</cfif>
</cfif>
<cfquery name="get_chapter" datasource="#dsn#">
	SELECT CHAPTER_ID,CHAPTER,CONTENTCAT_ID,HIERARCHY FROM CONTENT_CHAPTER WHERE CONTENT_CHAPTER_STATUS = 1 <cfif get_lit_names.recordcount>AND CONTENTCAT_ID IN (#ValueList(get_lit_names.contentcat_id,',')#)</cfif>  ORDER BY HIERARCHY ASC
</cfquery>
<cfif isDefined('session.ep.userid')>
	<cfset f_category = "rule.view_category">
	<cfset f_chapter = "rule.view_chapter">
<cfelse>
	<cfset f_category = "#attributes.fuseaction#">
	<cfset f_chapter = "#attributes.fuseaction#">
</cfif>
<!-- 
<table align="left">
	<tr>
		<td>
		<cfoutput query="get_lit_names">
			<ul class="box_menus">
				<li>
					<a href="#request.self#?fuseaction=#f_category#&contentcat_id=#contentcat_id#"><b>#contentcat#</b></a>                
					
				</li>
			</ul>
		</cfoutput>
		</td>
	</tr>
</table>
<script src="../../design/SpryAssets/left_menus/jquery.treeview.js" type="text/javascript"></script>
-->