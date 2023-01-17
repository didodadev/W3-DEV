<cfif attributes.relation_type_info eq 1><!--- kurumsal üyeler --->
	<cfquery name="GET_RELATION" datasource="#dsn#">
		SELECT
			PARTNER_RELATION_ID RELATION_ID,
			PARTNER_RELATION RELATION_NAME,
			DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			UPDATE_DATE,
			UPDATE_EMP
		FROM
			SETUP_PARTNER_RELATION
		ORDER BY
			PARTNER_RELATION
	</cfquery>
<cfelseif attributes.relation_type_info eq 2><!--- bireysel üyeler --->
	<cfquery name="GET_RELATION" datasource="#dsn#">
		SELECT
			CONSUMER_RELATION_ID RELATION_ID,
			CONSUMER_RELATION RELATION_NAME,
			CONSUMER_RELATION_DETAIL DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			UPDATE_DATE,
			UPDATE_EMP
		FROM
			SETUP_CONSUMER_RELATION
		ORDER BY
			CONSUMER_RELATION
	</cfquery>
<cfelseif attributes.relation_type_info eq 3><!--- sistemler --->
	<cfquery name="GET_RELATION" datasource="#dsn#">
		SELECT
			SUBSCRIPTION_RELATION_ID RELATION_ID,
			SUBSCRIPTION_RELATION RELATION_NAME,
			DETAIL,
			RECORD_DATE,
			RECORD_EMP,
			UPDATE_DATE,
			UPDATE_EMP
		FROM
			SETUP_SUBSCRIPTION_RELATION
		ORDER BY 
			SUBSCRIPTION_RELATION
	</cfquery>
</cfif>
<table width="200" border="0" cellpadding="0" cellspacing="0">
  <tr>
    <td class="txtbold" height="20" colspan="2">&nbsp;&nbsp;<cfif attributes.relation_type_info eq 1><cf_get_lang no='684.Kurumsal Üye İlişkileri'><cfelseif attributes.relation_type_info eq 2><cf_get_lang no='145.Bireysel Üye İlişkileri'><cfelseif attributes.relation_type_info eq 3><cf_get_lang no ='2146.Sistem İlişkileri'></cfif></td>
  </tr>
  <cfif GET_RELATION.recordcount>
    <cfoutput query="GET_RELATION">
      <tr>
        <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13" align="absmiddle"></td>
      <td width="180"><a href="#request.self#?fuseaction=settings.form_upd_partner_relation&partner_relation_id=#RELATION_ID#&relation_type_info=#attributes.relation_type_info#" class="tableyazi">#RELATION_NAME#</a></td>

	  </tr>
    </cfoutput>
    <cfelse>
    <tr>
      <td width="20" align="right" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
      <td width="180"><font class="tableyazi"><cf_get_lang_main no='72.Kayıt Bulunamadı'>!</font></td>
    </tr>
  </cfif>
</table>

