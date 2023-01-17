<cfif listfind(attributes.var_type,1,',')>
	<cfset attributes.period_id = Decrypt(attributes.period_id,session_base.userid,"CFMX_COMPAT","Hex")>
	<cfset url.period_id = Decrypt(url.period_id,session_base.userid,"CFMX_COMPAT","Hex")>
	<cfset attributes.period_id = Decrypt(attributes.period_id,session_base.userid,"CFMX_COMPAT","Hex")>
	<cfset url.period_id = Decrypt(url.period_id,session_base.userid,"CFMX_COMPAT","Hex")>
</cfif>

<cfif listfind(attributes.var_type,2,',')>
	<cfset attributes.cari_act_id = Decrypt(attributes.cari_act_id,session_base.userid,"CFMX_COMPAT","Hex")>
    <cfset url.cari_act_id= Decrypt(url.cari_act_id,session_base.userid,"CFMX_COMPAT","Hex")>
	<cfset attributes.cari_act_id = Decrypt(attributes.cari_act_id,session_base.userid,"CFMX_COMPAT","Hex")>
    <cfset url.cari_act_id= Decrypt(url.cari_act_id,session_base.userid,"CFMX_COMPAT","Hex")>
</cfif>

<cfif listfind(attributes.var_type,3,',')>
	<cfset attributes.id = Decrypt(attributes.id,session_base.userid,"CFMX_COMPAT","Hex")>
    <cfset url.id = Decrypt(url.id,session_base.userid,"CFMX_COMPAT","Hex")>
	<cfset attributes.id = Decrypt(attributes.id,session_base.userid,"CFMX_COMPAT","Hex")>
    <cfset url.id = Decrypt(url.id,session_base.userid,"CFMX_COMPAT","Hex")>
</cfif>

<cfif (isDefined('attributes.cari_act_id') and (not len(attributes.cari_act_id) or not isnumeric(attributes.cari_act_id))) or (isDefined('attributes.id') and (not len(attributes.id) or not isnumeric(attributes.id))) or (isDefined('attributes.period_id') and (not len(attributes.period_id) or not isnumeric(attributes.period_id)))>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1531.Boyle Bir Kayıt Bulunmamaktadir'>!");
		window.close(); 
	</script>
	<cfabort>
</cfif>
