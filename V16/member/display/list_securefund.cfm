<cfquery name="get_company_securefund" datasource="#DSN#">
	SELECT 
		CS.*,
		OC.COMPANY_NAME,
		SS.SECUREFUND_CAT
	FROM 
		COMPANY_SECUREFUND CS,
		OUR_COMPANY OC,
		SETUP_SECUREFUND SS
	WHERE 
		<cfif isdefined("attributes.keyword")>
			SS.SECUREFUND_CAT LIKE '%#attributes.keyword#%' AND
		</cfif>
		<cfif isdefined("attributes.COMPANY_ID") and len(attributes.COMPANY_ID)>
			CS.COMPANY_ID = #ATTRIBUTES.COMPANY_ID# AND
		<cfelseif  isdefined("attributes.consumer_id") and len(attributes.consumer_id)>
			CS.CONSUMER_ID = #ATTRIBUTES.CONSUMER_ID# AND
		</cfif>
		CS.OUR_COMPANY_ID = OC.COMP_ID AND
		SS.SECUREFUND_CAT_ID = CS.SECUREFUND_CAT_ID
	ORDER BY 
		CS.FINISH_DATE DESC
</cfquery>

<cfquery name="get_money" datasource="#DSN#">
	SELECT MONEY FROM SETUP_MONEY WHERE PERIOD_ID = #SESSION.EP.PERIOD_ID# AND MONEY_STATUS = 1 ORDER BY MONEY_ID
</cfquery>

<cfoutput query="get_money">
	<cfset 'toplam_#money#' = 0>
</cfoutput>
<cfset toplam_ = 0>
<cfset url_str = "">
<cfparam name="attributes.keyword" default="">
<cfif len(attributes.keyword)><cfset url_str = "#url_str#&keyword=#attributes.keyword#"></cfif>
<cfparam name="attributes.modal_id" default="">
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default="#get_company_securefund.recordcount#">
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box title="#getLang('','Teminatlar','57676')#" scroll="1" collapsable="1" closable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
		<cfform name="search" method="post" action="">
			<cfif isdefined("attributes.company_id")>
				<input type="hidden" value="<cfoutput>#attributes.company_id#</cfoutput>" name="company_id" id="company_id">
			<cfelseif  isdefined("attributes.consumer_id")>
				<input type="hidden" value="<cfoutput>#attributes.consumer_id#</cfoutput>" name="consumer_id" id="consumer_id">
			</cfif>
			<cf_box_search more="0">
				<div class="form-group">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" maxlength="255"  placeholder="#getLang('','Filtre','57460')#">
				</div>  
				<div class="form-group small">
					<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#getLang('','Sayi_Hatasi_Mesaj','57537')#" maxlength="3">
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4" search_function="#iif(isdefined("attributes.draggable"),DE("loadPopupBox('search' , #attributes.modal_id#)"),DE(""))#">
				</div>
			</cf_box_search>
		</cfform>
		<cf_grid_list>
			<thead>
				<tr> 
					<th width="100"><cf_get_lang dictionary_id='30451.Şirketimiz'></th>
					<th width="100"><cf_get_lang dictionary_id='57519.Cari Hesap'></th>
					<th width="60"><cf_get_lang dictionary_id='58176.Alış'> - <cf_get_lang dictionary_id='57448.Satış'></th>
					<th width="50"><cf_get_lang dictionary_id ='57756.Durum'></th>
					<th><cf_get_lang dictionary_id='58689.Teminat'></th>
					<th width="65"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></th>
					<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
					<th width="100" style="text-align:right;"><cf_get_lang dictionary_id='30635.Döviz Tutar'></th>
					<th width="15">
					<cfif isdefined("attributes.company_id")>
						<cfoutput><a target="_blank" href="#request.self#?fuseaction=finance.list_securefund&event=add&company_id=#attributes.company_id#"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></cfoutput>
					<cfelseif isdefined("attributes.consumer_id")>
						<cfoutput><a target="_blank" href="#request.self#?fuseaction=finance.list_securefund&event=add&consumer_id=#attributes.consumer_id#"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='57582.Ekle'>"></i></a></cfoutput>
					</cfif>
					</th>			  
				</tr>
				</thead>
				<cfif attributes.page neq 1>
					<cfoutput query="GET_COMPANY_SECUREFUND" startrow="1" maxrows="#attributes.startrow-1#">
						<cfif len(securefund_total)>
							<cfset 'toplam_#money_cat#' = evaluate('toplam_#money_cat#') + securefund_total>
						</cfif>
						<cfif len(action_value)>
							<cfset toplam_ = toplam_ + action_value>
						</cfif>
					</cfoutput>	
				</cfif>
				<cfif GET_COMPANY_SECUREFUND.recordcount>
				<cfif isdefined("company_id") and len(company_id)><cfset member_name =get_par_info(company_id,1,0,1)><cfelseif isdefined('consumer_id') and len(consumer_id)><cfset member_name =get_cons_info(consumer_id,0,1)></cfif>
					<tbody>
						<cfoutput query="GET_COMPANY_SECUREFUND" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
							<tr>
								<td>#COMPANY_NAME#</td>
								<td><cfif isdefined('member_name') and len(member_name)>#member_name#</cfif></td>
								<td><cfif GIVE_TAKE eq 0><cf_get_lang dictionary_id='58176.Alış'><cfelse><cf_get_lang dictionary_id='57448.Satış'></cfif></td>
								<td>
									<cfif len(get_company_securefund.return_process_cat)>İade <cfif get_company_securefund.GIVE_TAKE EQ 1><cf_get_lang dictionary_id="54412.Alındı"><cfelse><cf_get_lang dictionary_id="54418.Edildi"></cfif></cfif>
								</td>
								<td>#SECUREFUND_CAT#</td>
								<td>#DATEFORMAT(FINISH_DATE,dateformat_style)#</td>
								<td  style="text-align:right;">#tlformat(ACTION_VALUE)# #session.ep.money#</td>
								<cfif len(ACTION_VALUE)>
									<cfset toplam_ = toplam_ + ACTION_VALUE>
								</cfif>
								<td  style="text-align:right;">#tlformat(SECUREFUND_TOTAL)# #MONEY_CAT#</td>
								<cfif len(SECUREFUND_TOTAL)>
									<cfset 'toplam_#money_cat#' = evaluate('toplam_#money_cat#') + SECUREFUND_TOTAL>
								</cfif>
								<td><a target="_blank" href="#request.self#?fuseaction=finance.list_securefund&event=upd&securefund_id=#SECUREFUND_ID#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" border="0"></i></td>
							</tr>
						</cfoutput>
					</tbody>
					<tfoot>
						<tr>
							<td colspan="6" style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id='57680.Genel Toplam'></td>
							<td  style="text-align:right;">
								<cfif toplam_ gt 0>
									<cfoutput>#Tlformat(toplam_)# #session.ep.money#</cfoutput>
								</cfif>
							 <td  style="text-align:right;">
								<cfoutput query="get_money">
									<cfif evaluate('toplam_#money#') gt 0>
										#Tlformat(evaluate('toplam_#money#'))# #money#<br/>
									</cfif>
								</cfoutput>
							</td> 
							<td>&nbsp;</td>
						</tr>
					</tfoot>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="9"><cf_get_lang dictionary_id='57484.Kayıt Yok'>!</td>
						</tr>
					</tbody>
				</cfif>
		</cf_grid_list>
	</cf_box>
</div>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfif isdefined("attributes.company_id") and Len(attributes.company_id)><cfset url_str = "#url_str#&company_id=#attributes.company_id#"></cfif>
	<cfif isdefined("attributes.consumer_id") and Len(attributes.consumer_id)><cfset url_str = "#url_str#&consumer_id=#attributes.consumer_id#"></cfif>
	<table width="98%" align="center">
	  <tr> 
		<td>
		<cf_pages 
			page="#attributes.page#" 
			maxrows="#attributes.maxrows#" 
			totalrecords="#attributes.totalrecords#" 
			startrow="#attributes.startrow#" 
			adres="member.popup_list_securefund#url_str#"> 
		</td>
		<!-- sil --><td  style="text-align:right;"><cfoutput><cf_get_lang dictionary_id='57540.Toplam Kayıt'>:#attributes.totalrecords#&nbsp;-&nbsp;<cf_get_lang dictionary_id='57581.Sayfa'>:#attributes.page#/#lastpage#</cfoutput></td><!-- sil -->
	  </tr>
	</table>
</cfif>
