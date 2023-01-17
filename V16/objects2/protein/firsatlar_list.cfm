<cfset opportunitiesCFC = createObject('component','V16.objects2.protein.data.opportunities_data')>
<cfset get_opportunities = opportunitiesCFC.GET_OPPORTUNITIES(keyword:attributes.keyword, opportunity_type_id:attributes.opportunity_type_id,process_stage:attributes.process_stage,sales_member_id:attributes.get_emp,sales_member_type:'partner',opp_status:attributes.opp_status,selected_company:iif(isdefined('attributes.selected_company') and len(attributes.selected_company),'attributes.selected_company',''))>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.totalrecords" default=#get_opportunities.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="protein-table" id="search-results"> 
  <div class="table-responsive">
    <table class="table table-hover">
        <thead class="main-bg-color">
          <tr>                  
            <th><cf_get_lang dictionary_id='58820.Başlık'></th>
            <th><cf_get_lang dictionary_id='57457.Müşteri'></th>
            <th><cf_get_lang dictionary_id='57486.Kategori'></th>
            <th><cf_get_lang dictionary_id='61837.Fırsatı Yöneten'></th>
            <th><cf_get_lang dictionary_id='61880.?'></th>
            <th><cf_get_lang dictionary_id='58652.Probability'></th>
            <th><cf_get_lang dictionary_id='58784.Referans'>-<cf_get_lang dictionary_id='57578.Yetkili'></th>
            <th colspan="2"><cf_get_lang dictionary_id='57482.Stage'></th>                
          </tr>
        </thead>
        <tbody>
          <cfif get_opportunities.recordcount>
            <cfoutput query="get_opportunities" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
                <tr>                
                  <td>#opp_head#</td>
                  <td><cfif len(partner_id)>
                    #FULLNAME# - #PARTNER_NAME_SURNAME#
                <cfelseif len(consumer_id)>
                    #CONSUMER_NAME#
                </cfif></td>
                  <td><cfif len(opportunity_type_id)>#OPPORTUNITY_TYPE#</cfif></td>
                  <td><cfif len(sales_emp_id)>#get_emp_info(sales_emp_id,0,0)#</cfif></td>
                  <td class="text-right">#TLFormat(income)# #money#</td>
                  <td><cfif len(probability)>#PROBABILITY_NAME#</cfif></td>
                  <td><cfif len(ref_company_id)>#get_par_info(ref_company_id,1,1,0)#</cfif> - <cfif len(ref_partner_id)>#get_par_info(ref_partner_id,0,-1,0)#</cfif></td>
                  <td><span class="badge pl-3 pr-3 py-2 span-color-<cfif line_number lt 8>#line_number#<cfelse>7</cfif>"><cfif len(opp_stage)>#STAGE#</cfif></span></td>
                  <td><a href="#site_language_path#/opportunitiesDetail?opp_id=#contentEncryptingandDecodingAES(isEncode:1,content:opp_id,accountKey:"wrk")#" class="none-decoration"><i class="fas fa-pencil-alt"></i></a></td>
                </tr>
          </cfoutput>
          <cfelse>
            <tr>
                <td colspan="6">
                    <cf_get_lang dictionary_id="57484.Kayıt yok">!
                </td>
            </tr>
          </cfif>      
        </tbody>
      </table>
      <cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
				<cfset url_string = '/opportunities?&is_submit=1'>
				<cfif len(attributes.keyword)>
					<cfset url_string = '#url_string#&keyword=#attributes.keyword#'>
				</cfif>
				<cfif len(attributes.process_stage)>
					<cfset url_string = '#url_string#&process_stage=#attributes.process_stage#'>
				</cfif>
				<cfif len(attributes.opportunity_type_id)>
					<cfset url_string = '#url_string#&opportunity_type_id=#attributes.opportunity_type_id#'>
				</cfif>
        <cfif len(attributes.get_emp)>
					<cfset url_string = '#url_string#&get_emp=#attributes.get_emp#'>
				</cfif>
        <cfif isdefined("attributes.opp_status")>
					<cfset url_string = '#url_string#&opp_status=#attributes.opp_status#'>
				</cfif>
        <table width="99%" cellpadding="0" cellspacing="0" border="0" align="center" height="35">
					<tr>
						<td>
						  <cf_pages page="#attributes.page#"
                maxrows="#attributes.maxrows#"
                totalrecords="#attributes.totalrecords#"
                startrow="#attributes.startrow#"
                adres="#url_string#">
						</td>
					  <td style="text-align:right"><cfoutput><cf_get_lang dictionary_id='57540.Total Record'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Page'>:#attributes.page#/#lastpage#</cfoutput> </td>
					</tr>
				</table>
      </cfif>
  </div>      
</div>
<script>  
$('.portHeadLightMenu ul li a').css("display", "none");

  $('#<cfoutput>protein_widget_#widget.id#</cfoutput> .portHeadLightMenu ul').append(  
    $('<li>').addClass('btn btn-color-5').attr({
      onclick :"openBoxDraggable('widgetloader?widget_load=addOpportunity&isbox=1&style=maxi&title=<cfoutput>#getLang('','',58489)#</cfoutput>')",
      title   :'<cf_get_lang dictionary_id='58489.Fırsat Ekle'>'}).text(" <cf_get_lang dictionary_id='58489.Fırsat Ekle'>").prepend($('<i>').addClass('far fa-plus-square'))
      ); 
</script>