<cfquery name="OFFTIMECATEGORIES" datasource="#DSN#">
	SELECT 
		OFFTIMECAT_ID,
		#dsn#.Get_Dynamic_Language(OFFTIMECAT_ID,'#session.ep.language#','SETUP_OFFTIME','OFFTIMECAT',NULL,NULL,OFFTIMECAT) AS OFFTIMECAT,
		CASE 
			WHEN ISNULL(UPPER_OFFTIMECAT_ID,0) <> 0 THEN UPPER_OFFTIMECAT_ID
			WHEN ISNULL(UPPER_OFFTIMECAT_ID,0) = 0 THEN OFFTIMECAT_ID
        END AS NEW_CAT_ID,
		UPPER_OFFTIMECAT_ID 
	FROM 
		SETUP_OFFTIME 
	ORDER BY 
		NEW_CAT_ID,
		OFFTIMECAT_ID
</cfquery>
<table width="200" cellpadding="0" cellspacing="0" border="0">

<cfif offTimeCategories.recordcount>
	<cfoutput query="offTimeCategories">
  	<tr>
		<cfif UPPER_OFFTIMECAT_ID neq 0>
			<td width="20" align="right" valign="baseline" style="text-align:right;"></td>
			<td width="170"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i>&nbsp;<a href="#request.self#?fuseaction=settings.form_upd_offtime&ID=#offTimeCat_ID#">#offTimeCat#</a></td>
		<cfelse>
			<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
			<td width="170">&nbsp;<a href="#request.self#?fuseaction=settings.form_upd_offtime&ID=#offTimeCat_ID#">#offTimeCat#</a></td>
		</cfif>
  	</tr>
  </cfoutput>
<cfelse>
 	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><i class="fa fa-cube" style="font-size:12px;color:##FF9800;"></i></td>
    	<td width="380"><font class="tableyazi"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</font></td>
  	</tr>
</cfif>
</table>
