
<cfinclude template="../../header.cfm">

<cfif isdefined("attributes.form_submitted")>
	<cfquery name="GET_TEST_ALL" datasource="#DSN#">
		SELECT
			REFINERY_TEST_ID,
			#dsn#.Get_Dynamic_Language(REFINERY_TEST_ID,'#session.ep.language#','REFINERY_TEST','TEST_NAME',NULL,NULL,TEST_NAME) AS TEST_NAME,
			TEST_COMMENT
		FROM
			REFINERY_TEST
		WHERE 1 = 1 AND OUR_COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
			<cfif isDefined("REFINERY_TEST_ID") and len(REFINERY_TEST_ID)>
				AND REFINERY_TEST_ID = <cfqueryparam cfsqltype="cf_sql_nvarchar" value="#REFINERY_TEST_ID#">
			</cfif>
			<cfif isDefined("attributes.keyword") and len(attributes.keyword)>
				AND 
					(
						TEST_NAME LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
						OR TEST_COMMENT LIKE <cfqueryparam cfsqltype="cf_sql_nvarchar" value="%#attributes.keyword#%">
					)
			</cfif>
	</cfquery>
<cfelse>
	<cfset get_test_all.recordcount=0>
</cfif>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_test_all.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="search_target" method="post" action="#request.self#?fuseaction=recycle.analysis_template">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfsavecontent variable="place"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#place#">
				</div>
				<div class="form-group small">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Kayıt Sayısı Hatalı'>!</cfsavecontent>
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>
	<cfsavecontent variable="head"><cf_get_lang dictionary_id='62769.Analiz Şablonları'></cfsavecontent>
	<cf_box title="#head#" uidrop="1" hide_table_column="1">
		<cf_flat_list>
			<thead>
				<tr>
					<cfoutput>
					<th><cf_get_lang dictionary_id='55657.Sıra No'></th>
					<th><cf_get_lang dictionary_id='62141.Test Adı'></th>
					<th><cf_get_lang dictionary_id='36199.Açıklama'></th>
					<th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.analysis_template&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
					</cfoutput>
				</tr>
			</thead>
			<tbody>
				<cfif GET_TEST_ALL.recordcount>
					<cfoutput query="GET_TEST_ALL" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td>#currentrow#</td>
							<td>#TEST_NAME#</td>
							<td>#TEST_COMMENT#</td>
							<td width="20" style="text-align:center;">
								<a href="#request.self#?fuseaction=recycle.analysis_template&event=upd&refinery_test_id=#REFINERY_TEST_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
							</td>
						</tr>
					</cfoutput>
				<cfelse>
					<tr>
						<td colspan="4"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
			</tbody>
		</cf_flat_list>

		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfif len(attributes.keyword)>
				<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
			</cfif>
			<cfif len(attributes.form_submitted)>
				<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="recycle.analysis_template#url_str#">
		</cfif>
	</cf_box>
</div>

