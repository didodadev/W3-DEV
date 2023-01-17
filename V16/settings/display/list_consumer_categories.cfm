<cfquery name="CONSUMERCATEGORIES" datasource="#DSN#">
	SELECT 
		#dsn#.Get_Dynamic_Language(CONSCAT_ID,'#session.ep.language#','CONSUMER_CAT','CONSCAT',NULL,NULL,CONSCAT) AS CONSCAT,
		CONSCAT_ID 
	FROM 
		CONSUMER_CAT 
	ORDER BY 
		CONSCAT
</cfquery>
<table>
	<cfif consumerCategories.recordcount>
		<cfoutput query="consumerCategories">
			<tr>
                <td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
				<td width="380"><a href="#request.self#?fuseaction=settings.form_upd_consumer_categories&ID=#consCat_id#" class="tableyazi">#consCat#</a></td>
			</tr>
		</cfoutput>
	<cfelse>
        <tr>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
            <td width="380"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
		</tr>
 	</cfif>
</table>
