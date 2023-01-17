<cfinclude template="../../header.cfm">

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.keyword" default="">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif isDefined("attributes.form_submitted")>
    <cfset periodic_analysis_order = createObject("component","WBP/Recycle/files/sample_analysis/cfc/periodic_analysis_order") />
			
	<cfset getPeriodicAnalysisOrder = periodic_analysis_order.getPeriodicAnalysisOrder(
		keyword: attributes.keyword
    ) />

<cfelse>
	<cfset getPeriodicAnalysisOrder.recordcount=0>
</cfif>

<cfparam name="attributes.totalrecords" default=#getPeriodicAnalysisOrder.recordcount#>

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform name="analysis_operations" method="post" action="#request.self#?fuseaction=recycle.periodic_analysis_order">
			<cf_box_search>
				<input type="hidden" name="form_submitted" id="form_submitted" value="1">
				<div class="form-group">
					<cfinput type="text" name="keyword" style="width:100px;" value="#attributes.keyword#" maxlength="255" placeholder="#getLang("","",57460)#">
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
    <cf_box title="#getLang("","Periyodik Numune Analiz Emirleri",62959)#" uidrop="1" hide_table_column="1">
        <cf_flat_list>
            <thead>
                <tr>
                    <cfoutput>
                        <th><cf_get_lang dictionary_id='55657.Sıra No'></th>
                        <th><cf_get_lang dictionary_id='62100.Numune Alma Noktası Adı'></th>
                        <th><cf_get_lang dictionary_id='62098.İlk Numune Alma Zamanı'></th>
                        <th><cf_get_lang dictionary_id='62097.Numune Analiz Nedeni'></th>
                        <th width="20" class="header_icn_none text-center"><a href="<cfoutput>#request.self#</cfoutput>?fuseaction=recycle.periodic_analysis_order&event=add"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='57582.Ekle'>" alt="<cf_get_lang dictionary_id='57582.Ekle'>"></i></a></th>
                    </cfoutput>
                </tr>
            </thead>
            <tbody>
                <cfif getPeriodicAnalysisOrder.recordcount>
                    <cfoutput query="getPeriodicAnalysisOrder" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                        <tr>
                            <td>#currentrow#</td>
                            <td>#SAMPLING_POINTS_NAME#</td>
                            <td>#dateformat(SAMPLE_POINTS_DATE_ENTRY, dateformat_style)#</td>
                            <td>#SAMPLE_POINTS_REASON#</td>
                            <td style="text-align:center;"><a href="#request.self#?fuseaction=recycle.periodic_analysis_order&event=upd&sample_points_id=#SAMPLE_POINTS_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td>
                        </tr>
                    </cfoutput>
                <cfelse>
                    <tr>
                        <td colspan="5"><cfif isdefined("attributes.form_submitted")><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'></cfif></td>
					</tr>
				</cfif>
            </tbody>
        </cf_flat_list>

        <cfif attributes.totalrecords gt attributes.maxrows>
			<cfset url_str = "">
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
				adres="recycle.periodic_analysis_order#url_str#">
        </cfif>
    </cf_box>
</div>