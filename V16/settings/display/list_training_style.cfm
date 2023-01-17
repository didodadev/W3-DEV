<cfquery name="GET_TRAIN_ALL" datasource="#DSN#">
	SELECT 
		* 
	FROM 
		SETUP_TRAINING_STYLE
</cfquery>
<table cellpadding="0" cellspacing="0" border="0">
	<tr> 
		<td class="txtbold" height="20" colspan="2">&nbsp;&nbsp; <cf_get_lang no='1464.Eğitim Şekli Bilgisi'></td>
	</tr>
<cfif get_train_all.recordcount>
	<cfoutput query="get_train_all">
  	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="115">
			<cfif listfirst(url.fuseaction,'.') is 'training_management'>
				<a href="#request.self#?fuseaction=settings.form_upd_training_style&training_sytle_id=#TRAINING_STYLE_ID#" class="tableyazi">#TRAINING_STYLE#</a>
			<cfelse>
				<a href="#request.self#?fuseaction=settings.form_upd_training_style&training_sytle_id=#TRAINING_STYLE_ID#" class="tableyazi">#TRAINING_STYLE#</a>
			</cfif>
		</td>
  </tr>
  </cfoutput>
<cfelse>
	<tr>
		<td width="20" align="right" valign="baseline" style="text-align:right;"><img src="/images/tree_1.gif" width="13"></td>
		<td width="115"><font class="tableyazi"><cf_get_lang_main no='1124.Kayıt Bulunamadı'>!</font></td>
	</tr>
 </cfif>
</table>
