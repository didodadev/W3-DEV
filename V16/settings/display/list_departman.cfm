<cfquery name="DEPARTMANS" datasource="#dsn#">
	SELECT * FROM DEPARTMAN
</cfquery>		
<cfif departmans.recordcount>
	<cfoutput query="departmans">
		<a href="#request.self#?fuseaction=settings.form_upd_departman&ID=#dep_ID#">#dep_Head#</a><br/>
	</cfoutput>
<cfelse>
	<font class="ikaz"><cf_get_lang no='156.Kayıtlı Departman yok'></font>
</cfif>

