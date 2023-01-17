<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.date1" default="#dateformat(Now(),dateformat_style)#">
<cfparam name="attributes.pos_req_type_id" default="">
<cfparam name="attributes.pos_req_type" default="">
<cf_date tarih='attributes.date1'>
<cfset url_str = "">
<cfif isdefined("attributes.list_type") and len(attributes.list_type)>
	<cfset url_str = "#url_str#&list_type=#attributes.list_type#">
</cfif>
<cfif isdefined("attributes.field_id") and len(attributes.field_id)>
	<cfset url_str = "#url_str#&field_id=#attributes.field_id#">
</cfif>
<cfif isdefined("attributes.field_name") and len(attributes.field_name)>
	<cfset url_str = "#url_str#&field_name=#attributes.field_name#">
</cfif>
<cfif len("attributes.keyword")>
	<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
</cfif>
<cfif len("attributes.date1")>
	<cfset url_str = "#url_str#&date1=#dateformat(attributes.date1,dateformat_style)#">
</cfif>
<cfif len("attributes.pos_req_type_id")>
	<cfset url_str = "#url_str#&pos_req_type_id=#attributes.pos_req_type_id#">
</cfif>
<cfif len("attributes.pos_req_type")>
	<cfset url_str = "#url_str#&pos_req_type=#attributes.pos_req_type#">
</cfif>

<cfquery name = "get_organizations" datasource = "#dsn#">
	SELECT
		O.ORGANIZATION_ID,
		O.ORGANIZATION_HEAD,
		O.START_DATE,
		O.FINISH_DATE
	FROM
		ORGANIZATION O
</cfquery>

<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_organizations.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.date1)><cfset attributes.date1 = dateformat(attributes.date1, dateformat_style)></cfif>
<cfsavecontent variable="message"><cf_get_lang dictionary_id='29912.Eğitimler'></cfsavecontent>
<cf_big_list_search title="#message#">
    <cfform action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.popup_list_organizations" method="post" name="search_form">
        <cfif isdefined("attributes.list_type")><input type="hidden" name="list_type" id="list_type" value="<cfoutput>#attributes.list_type#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_id")><input type="hidden" name="field_id" id="field_id" value="<cfoutput>#attributes.field_id#</cfoutput>"></cfif>
        <cfif isdefined("attributes.field_name")><input type="hidden" name="field_name" id="field_name" value="<cfoutput>#attributes.field_name#</cfoutput>"></cfif>
        <cf_big_list_search_area>
        	<div class="row form-inline">
                <div class="form-group" id="keyword">
					<div class="input-group x-12">
					<cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
					<cfinput type="text" name="keyword" placeholder="#message#" value="#attributes.keyword#" maxlength="255">
					</div>
				</div>	
                <div class="form-group">
					<div class="input-group x-12">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id='56283.Tarih Girmelisiniz'> !</cfsavecontent>
                        <cfinput name="date1" type="text" value="#dateformat(attributes.date1,dateformat_style)#" style="width:65px;" validate="#validate_style#" message="#message#" required="yes">
                        <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                    </div>
				</div>
                <div class="form-group x-3_5">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                        <cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                    </div>
                <div class="form-group">
					<cf_wrk_search_button>
					</div>          
                </div>
        </cf_big_list_search_area>
		<cf_big_list_search_detail_area>
			<div class="row">    
                <div class="col col-12 form-inline"> 
					<div class="form-group" id="pos_req_type">
						<div class="input-group x-16">
							<input type="hidden" name="pos_req_type_id" id="pos_req_type_id" value="<cfoutput>#attributes.pos_req_type_id#</cfoutput>">
							<input type="text" name="pos_req_type" id="pos_req_type" value="<cfoutput>#attributes.pos_req_type#</cfoutput>" style="width:200px">
							<span class="input-group-addon btnPointer icon-ellipsis" href="javascript://" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_req&field_id=search_form.pos_req_type_id&field_name=search_form.pos_req_type','list');"></span>
						</div>
					</div>
				</div>
			</div>
		</cf_big_list_search_detail_area>
	</cfform>
</cf_big_list_search>
<cf_medium_list>
	<thead>
        <tr>
            <th width="25"><cf_get_lang dictionary_id='57487.No'></th>
            <th width="200"><cf_get_lang dictionary_id='29465.Etkinlik'></th>
            <th width="250"><cf_get_lang dictionary_id='33081.Amaç'></th>
            <th width="100"><cf_get_lang dictionary_id='57742.Tarih'></th>
        </tr>
   </thead>
   <tbody>
		<cfif get_organizations.recordcount>
            <cfoutput query="get_organizations" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>
                    <td>#currentrow#</td>
                    <td>
                        <a href="javascript://" class="tableyazi"  onClick="add_organization('#ORGANIZATION_ID#','#ORGANIZATION_HEAD#')">#ORGANIZATION_HEAD#</a></td>
                    <td>
                    <td>#dateformat(start_date,dateformat_style)# - #dateformat(finish_date,dateformat_style)#</td>
                </tr>
            </cfoutput>
        <cfelse>
            <tr>
                <td colspan="4"><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!</td>
            </tr>
        </cfif>
	</tbody>
</cf_medium_list>
<cfif get_organizations.recordcount and (attributes.totalrecords gt attributes.maxrows)>
	<!-- sil -->
		<table cellpadding="0" cellspacing="0" border="0" width="98%" height="30" align="center">
			<tr> 
				<td>
					<cf_pages page="#attributes.page#" 
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="#listgetat(attributes.fuseaction,1,'.')#.popup_list_organizations#url_str#"> 
				</td>
				<!-- sil --><td style="text-align:right;"> <cfoutput> <cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
			</tr>
		</table>
	<!-- sil -->
</cfif>
<script type="text/javascript">
	function add_organization(organization_id,organization_head)
	{
		<cfif isdefined("attributes.field_id")>
		opener.<cfoutput>#field_id#</cfoutput>.value = organization_id;
		</cfif>
		<cfif isdefined("attributes.field_name")>
		opener.<cfoutput>#field_name#</cfoutput>.value = organization_head;
		</cfif>
		window.close();
	}
</script>
