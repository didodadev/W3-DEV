<cfsetting showdebugoutput="no">
<cfquery name="get_related_survey" datasource="#dsn#">
	SELECT 
		S.SURVEY_MAIN_ID,
		S.SURVEY_MAIN_HEAD,
		C.RELATION_TYPE,
		C.RELATION_CAT,
		C.RELATED_ALL
	FROM	
		SURVEY_MAIN S,
		CONTENT_RELATION C
	WHERE
		S.SURVEY_MAIN_ID = C.SURVEY_MAIN_ID 
	<!--- sadece firsat detayindan kaydedilen sonuclar --->
	<cfif attributes.action_type eq 'OPPORTUNITY'>
		AND RELATION_TYPE = 1
		AND C.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
	<!--- sadece ürün detayindan kaydedilen sonuclar --->
	<cfelseif attributes.action_type eq 'PRODUCT'>
		AND RELATION_TYPE = 2
		AND C.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
	<!--- sadece içerik detayindan kaydedilen sonuclar --->
	<cfelseif attributes.action_type eq 'CONTENT'>
		AND RELATION_TYPE = 3
		AND C.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
	<!--- sadece project detayindan kaydedilen sonuclar --->
	<cfelseif attributes.action_type eq 'PROJECT'>
		AND RELATION_TYPE = 4
		AND C.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
	</cfif>
	AND C.RELATION_CAT IS NULL
UNION
	SELECT 
		S.SURVEY_MAIN_ID,
		S.SURVEY_MAIN_HEAD,
		C.RELATION_TYPE,
		C.RELATION_CAT,
		C.RELATED_ALL
	FROM	
		SURVEY_MAIN S,
		CONTENT_RELATION C
	WHERE
		S.SURVEY_MAIN_ID = C.SURVEY_MAIN_ID 
	<!--- sadece firsat detayindan kaydedilen sonuclar --->
	<cfif attributes.action_type eq 'OPPORTUNITY'>
		AND RELATION_TYPE = 1
		AND C.RELATED_ALL = 1
	<!--- sadece ürün detayindan kaydedilen sonuclar --->
	<cfelseif attributes.action_type eq 'PRODUCT'>
		AND RELATION_TYPE = 2
		AND C.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#">
	<!--- sadece içerik detayindan kaydedilen sonuclar --->
	<cfelseif attributes.action_type eq 'CONTENT'>
		AND RELATION_TYPE = 3
		AND C.RELATION_CAT = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.action_type_id#"> 
	<!--- sadece project detayindan kaydedilen sonuclar --->
	<cfelseif attributes.action_type eq 'PROJECT'>
		AND RELATION_TYPE = 4
		AND C.RELATED_ALL = 1
	</cfif>
</cfquery>
<div id="cont" style="height:100px;z-index:1;overflow:auto;">
	<cfform name="list_survey" method="post">
	<table width="100%">
		<cfif get_related_survey.recordcount>
			<cfloop query="get_related_survey">
				<cfquery name="get_upd_info" datasource="#dsn#">
					SELECT SURVEY_MAIN_RESULT_ID FROM SURVEY_MAIN_RESULT WHERE SURVEY_MAIN_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#survey_main_id#">  AND ACTION_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#action_type_id#">
				</cfquery>
				<tr height="20" class="color-row">
					<td><cfif get_upd_info.recordcount>
							<a href="javascript://" class="tableyazi" onClick="windowopen('<cfoutput>#request.self#?<!--- test olmayınca hata veriyor,"objects.popup_form_upd_survey_main_result" fonksiyonu çalıştırılamıyor --->fuseaction=test.popup_form_upd_survey_main_result&survey_id=#survey_main_id#&action_type=#action_type#&action_type_id=#action_type_id#&result_id=#get_upd_info.survey_main_result_id#&is_popup=1</cfoutput>','list');"><cfoutput>#survey_main_head#</cfoutput></a>
						<cfelse>
							<a href="javascript://" class="tableyazi" onClick="windowopen('<cfoutput>#request.self#?fuseaction=test.popup_form_add_survey_main_result&survey_id=#survey_main_id#&action_type=#action_type#&action_type_id=#action_type_id#&is_popup=1</cfoutput>','list');"><cfoutput>#survey_main_head#</cfoutput></a>
						</cfif>
					</td>
					<td width="40" style="text-align:right;">
						<cfif get_upd_info.recordcount>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=test.popup_form_upd_survey_main_result&survey_id=#survey_main_id#&action_type=#action_type#&action_type_id=#action_type_id#&result_id=#get_upd_info.survey_main_result_id#&is_popup=1</cfoutput>','list');"><img src="/images/update_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0" align="absmiddle"></a>
						<cfelse>
							<a href="javascript://" onClick="windowopen('<cfoutput>#request.self#?fuseaction=test.popup_form_add_survey_main_result&survey_id=#survey_main_id#&action_type=#action_type#&action_type_id=#action_type_id#&is_popup=1</cfoutput>','list');"><img src="/images/plus_list.gif" title="<cf_get_lang dictionary_id='57582.Ekle'>" border="0" align="absmiddle"></a>
						</cfif>
					</td>
				</tr>
			</cfloop>
		<cfelse>
			<tr>
				<td><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
			</tr>
		</cfif>
	</table>
	</cfform>
</div>

