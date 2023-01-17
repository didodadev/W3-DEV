<cfset languages_cmp = createObject("component","V16.settings.cfc.languages_deff")/>
		
<cfset get_languages = languages_cmp.getSetupLanguage()>
<cfset count_languages = languages_cmp.countSetupLanguage()>
<cfset count_tr = languages_cmp.countTR()>
<cfset count_eng = languages_cmp.countENG()>
<cfset count_de = languages_cmp.countDE()>
<cfset count_arb = languages_cmp.countARB()>
<cfset count_fr = languages_cmp.countFR()>
<cfset count_rus = languages_cmp.countRUS()>
<cfset count_it = languages_cmp.countIT()>


<cfif isDefined("attributes.reload") and attributes.reload eq 1>
	<cfif isDefined("attributes.repeating")>
		<cfparam name="attributes.page" default="1">
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >

		<cfif count_languages.recordcount>
			<cfparam name="attributes.totalrecords" default="#count_languages.recordCount#">
		<cfelse>
			<cfparam name="attributes.totalrecords" default="0">
		</cfif>
		
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th>ITEM</th>
					<th>COUNT</th>
					<th width="25"></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="count_languages" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>#count_languages.ITEM_TR#</td>
						<td>#count_languages.TOTAL_COUNT#</td>
						<td>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_list_lang_settings&keyword=#count_languages.ITEM_TR#&lang=tr&lang_2=eng&is_equal=1&form_submit=1')">
								<i class="catalyst-book-open" title="<cf_get_lang dictionary_id='57932.Sözlük'>"></i>
							</a>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_paging 
			name="body_div1_paging"
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			target="body_div1"
			isAjax="1"
			adres="settings.list_languages_deff&reload=1&repeating=1">
	<cfelseif isDefined("attributes.last_word")>
		<cfparam name="attributes.page" default="1">
		<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
		<cfset attributes.startrow = ((attributes.page-1)*attributes.maxrows) + 1 >
		
		<cfif get_languages.recordcount>
			<cfparam name="attributes.totalrecords" default="#get_languages.recordCount#">
		<cfelse>
			<cfparam name="attributes.totalrecords" default="0">
		</cfif>
		<cf_grid_list>
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='58577.Sıra'></th>
					<th>DICTIONARY_ID</th>
					<th>ITEM_TR</th>
					<th>ITEM_ENG</th>
					<th>ITEM_DE</th>
					<th>ITEM_ARB</th>
					<th>ITEM_FR</th>
					<th>ITEM_RUS</th>
					<th>ITEM_IT</th>
					<th><cf_get_lang dictionary_id='57627.Kayıt Tarihi'></th>
					<th><cf_get_lang dictionary_id='55055.Güncelleme Tarihi'></th>
					<th width="25"></th>
				</tr>
			</thead>
			<tbody>
				<cfoutput query="get_languages" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
					<tr>
						<td>#currentrow#</td>
						<td>#get_languages.DICTIONARY_ID#</td>
						<td>#get_languages.ITEM_TR#</td>
						<td>#get_languages.ITEM_ENG#</td>
						<td>#get_languages.ITEM_DE#</td>
						<td>#get_languages.ITEM_ARB#</td>
						<td>#get_languages.ITEM_FR#</td>
						<td>#get_languages.ITEM_RUS#</td>
						<td>#get_languages.ITEM_IT#</td>
						<td>#get_languages.RECORD_DATE#</td>
						<td>#get_languages.UPDATE_DATE#</td>
						<td>
							<a href="javascript://" onClick="openBoxDraggable('#request.self#?fuseaction=settings.popup_upd_lang_item&dictionary_id=#get_languages.DICTIONARY_ID#&lang=TR');">
								<i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i>
							</a>
						</td>
					</tr>
				</cfoutput>
			</tbody>
		</cf_grid_list>
		<cf_paging 
			name="body_div2_paging"
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#"
			startrow="#attributes.startrow#"
			target="body_div2"
			isAjax="1"
			adres="settings.list_languages_deff&reload=1&last_word=1">
	</cfif>
	<cfabort>
</cfif>

<div class="col col-12">
	<cf_box title="#getLang('','Dil Gelişimi',65290)#">
		<div class="col col-2 col-sm-4 col-xs-5">
			<div class="col col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8 col-xs-8">
				<b><cf_get_lang dictionary_id='65291.Toplam Kelime'></b>
			</div>
			<label class="col col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 col-xs-4" id="total_words">
				<cfoutput>#tlformat(get_languages.recordCount,0,false)#</cfoutput>
			</label>
			<div class="col col-8 col-sm-8 col-md-8 col-lg-8 col-xl-8 col-xs-8">
				<b><cf_get_lang dictionary_id='65294.Tekrar Eden Kelime'></b>
			</div>
			<label class="col col-4 col-sm-4 col-md-4 col-lg-4 col-xl-4 col-xs-4" id="missing_words">
				<cfoutput>#tlformat(count_languages.recordCount,0,false)#</cfoutput>
			</label>
		</div>
		<div class="col col-10 col-sm-8 col-xs-7">
			<div class="col col-12 col-sm-12 col-md-12 col-lg-12 col-xl-12 col-xs-12">
				<b><cf_get_lang dictionary_id='65295.Eksik Kelime ve Cümleler'></b>
			</div>
			<div class="col col-1 col-sm-3 col-md-1 col-lg-1 col-xl-1 col-xs-4" style="margin:3px 0px 3px 0px;">
				<b>TR</b> : <cfoutput>#tlformat(count_tr.SUM_TR,0,false)#</cfoutput>
			</div>
			<div class="col col-1 col-sm-3 col-md-2 col-lg-2 col-xl-2 col-xs-4" style="margin:3px 0px 3px 0px;">
				<b>ENG</b> : <cfoutput>#tlformat(count_eng.SUM_ENG,0,false)#</cfoutput>
			</div>
			<div class="col col-1 col-sm-3 col-md-1 col-lg-1 col-xl-1 col-xs-4" style="margin:3px 0px 3px 0px;">
				<b>DE</b> : <cfoutput>#tlformat(count_de.SUM_DE,0,false)#</cfoutput>
			</div>
			<div class="col col-1 col-sm-3 col-md-2 col-lg-2 col-xl-2 col-xs-4" style="margin:3px 0px 3px 0px;">
				<b>ARB</b> : <cfoutput>#tlformat(count_arb.SUM_ARB,0,false)#</cfoutput>
			</div>
			<div class="col col-1 col-sm-3 col-md-2 col-lg-2 col-xl-2 col-xs-4" style="margin:3px 0px 3px 0px;">
				<b>FR</b> : <cfoutput>#tlformat(count_fr.SUM_FR,0,false)#</cfoutput>
			</div>
			<div class="col col-1 col-sm-3 col-md-2 col-lg-2 col-xl-2 col-xs-4" style="margin:3px 0px 3px 0px;">
				<b>RUS</b> : <cfoutput>#tlformat(count_rus.SUM_RUS,0,false)#</cfoutput>
			</div>
			<div class="col col-1 col-sm-3 col-md-1 col-lg-1 col-xl-1 col-xs-4" style="margin:3px 0px 3px 0px;">
				<b>IT</b> : <cfoutput>#tlformat(count_it.SUM_IT,0,false)#</cfoutput>
			</div>
		</div>
	</cf_box>
</div>
<div class="col col-6 col-xs-12" >
	<cf_box title="#getLang('','Tekrar Eden Kelime ve Cümleler',65292)#" box_page="#request.self#?fuseaction=settings.list_languages_deff&reload=1&repeating=1" id="div1"></cf_box>
</div>
<div class="col col-6 col-xs-12" >
	<cf_box title="#getLang('','Son Eklenenler',65293)#" box_page="#request.self#?fuseaction=settings.list_languages_deff&reload=1&last_word=1" id="div2"></cf_box>
</div>