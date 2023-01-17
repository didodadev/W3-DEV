<cfform name="upd_opp" method="post" action="#request.self#?fuseaction=objects2.emptypopup_upd_opportunity" onsubmit="return (unformat_fields());">
	<table>
      	<input type="hidden" name="active_company" id="active_company" value="<cfoutput>#session.pp.company_id#</cfoutput>"> 
	  	<input type="hidden" name="opp_id" id="opp_id" value="<cfoutput>#opp_id#</cfoutput>">
	  	<tr>
        	<td colspan="4">&nbsp;&nbsp;<cf_get_lang_main no='68.Başlık'> *&nbsp;&nbsp;
				<cfsavecontent variable="message"><cf_get_lang_main no='647.Başlık Girmelisiniz'> !</cfsavecontent>
				<cfinput type="text" name="opp_head" id="opp_head" value="#get_opportunity.opp_head#" required="yes" message="#message#" style="width:450px;">
			</td>
        	<td><cf_get_lang_main no='75.No'></td>
       		<td>
				<input type="hidden" name="opp_id2" id="opp_id2" value="<cfoutput>#get_opportunity.opp_id#</cfoutput>" readonly>
            	<input type="text" name="opportunity_no" id="opportunity_no" style="width:60px;" value="<cfoutput>#get_opportunity.opp_no#</cfoutput>" readonly>
            	<input type="checkbox" name="opp_status" id="opp_status" value="1" <cfif get_opportunity.opp_status>checked</cfif>><cf_get_lang_main no='81.Aktif'>
        	</td>
      	</tr>
     	<tr>
     		<td colspan="4" rowspan="6">
				<!---<cfset tr_topic = htmleditformat(get_opportunity.opp_detail)>--->
				<cfset tr_topic = get_opportunity.opp_detail>
                <cfmodule
					template="/fckeditor/fckeditor.cfm"
					toolbarset="Basic"
					basepath="/fckeditor/"
					instancename="opp_detail"
					valign="top"
					value="#tr_topic#"
					width="500"
					height="200">
     		</td>
        	<td><cf_get_lang no='426.Başvuru'></td>
        	<td><cfsavecontent variable="message"><cf_get_lang_main no='1357.Basvuru Tarihi Girmelisiniz'></cfsavecontent>
            	<cfinput type="text" name="opp_date" id="opp_date" value="#dateformat(get_opportunity.opp_date,'dd/mm/yyyy')#" validate="eurodate" maxlength="10" message="#message#" style="width:60px;">
            	<cf_wrk_date_image date_field="opp_date">
        	</td>
     	</tr>
      	<tr>
        	<td style="width:80px;"><cf_get_lang_main no='74.Kategori'>*</td>
        	<td style="width:150px;">
          		<select name="opportunity_type_id" id="opportunity_type_id" style="width:160px;">
			  	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
			  	<cfoutput query="get_opportunity_type">
					<option value="#opportunity_type_id#" <cfif opportunity_type_id eq get_opportunity.opportunity_type_id>selected</cfif>>#opportunity_type#</option>
			  	</cfoutput>
			  	</select>
        	</td>		  
      	</tr>
      	<!---<tr>
			<td><cf_get_lang_main no='45.Müşteri'> *</td>
			<td>
				<cfif len(get_opportunity.partner_id)>
					<input type="hidden" name="consumer_id" id="member_type" value="">
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_opportunity.company_id#</cfoutput>" />
					<input type="hidden" name="partner_id" id="partner_id" value="<cfoutput>#get_opportunity.partner_id#</cfoutput>" />
					<input type="text"  name="member_name" id="member_name" value="<cfoutput>#get_par_info(get_opportunity.company_id,1,0,0)#-#get_par_info(get_opportunity.partner_id,0,-1,0)#</cfoutput>" style="width:170px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\',\'0\',\'\',\'\',\'2\',\'1\'','PARTNER_ID,COMPANY_ID,CONSUMER_ID','partner_id,company_id,consumer_id','upd_opp','3','250');" value="" autocomplete="off">
				<cfelseif len(get_opportunity.consumer_id)>				  
					<input type="hidden" name="company_id" id="company_id" value="">								  
					<input type="hidden" name="partner_id" id="member_id" value="">
					<input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_opportunity.consumer_id#</cfoutput>" />
					<input type="text"  name="member_name" id="member_name" value="<cfoutput>#get_cons_info(get_opportunity.consumer_id,0,0,0)#</cfoutput>" style="width:170px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\',\'0\',\'\',\'\',\'2\',\'1\'','PARTNER_ID,COMPANY_ID,CONSUMER_ID','partner_id,company_id,consumer_id','upd_opp','3','250');" value="" autocomplete="off">
				<cfelse>
					<input type="hidden" name="company_id" id="company_id" value="">								  
					<input type="hidden" name="consumer_id" id="member_type" value="">
					<input type="hidden" name="partner_id" id="member_id" value="">
					<input type="text"  name="member_name" id="member_name" value="" style="width:160px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\',\'0\',\'\',\'\',\'2\',\'1\'','PARTNER_ID,COMPANY_ID,CONSUMER_ID','partner_id,company_id,consumer_id','upd_opp','3','250');" value="" autocomplete="off">
				</cfif>
			</td>
      	</tr>--->
      	<tr>
			<td><cf_get_lang no='429.Satış Ortağı'></td>
			<td><select name="sales_partner_id" id="sales_partner_id" style="width:160px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_company_partners">
						<option value="#partner_id#" <cfif len(get_opportunity.sales_partner_id) and get_opportunity.sales_partner_id eq partner_id>selected</cfif>>#company_partner_name# #company_partner_surname#</option>
					</cfoutput>
				</select>
			</td>
	  	</tr>
      	<tr>
			<td><cf_get_lang no='430.Hareket'></td>
			<td>
			  	<select name="activity_time" id="activity_time" style="width:160px;">
					<option value="1" <cfif get_opportunity.activity_time eq 1>selected</cfif>><cf_get_lang no='436.Hemen'></option>
					<option value="7" <cfif get_opportunity.activity_time eq 7>selected</cfif>>1 Hafta</option>
					<option value="30" <cfif get_opportunity.activity_time eq 30>selected</cfif>>1 Ay</option>
					<option value="90" <cfif get_opportunity.activity_time eq 90>selected</cfif>>3 Ay</option>
					<option value="180" <cfif get_opportunity.activity_time eq 180>selected</cfif>>6 Ay</option>
					<option value="181" <cfif get_opportunity.activity_time eq 181>selected</cfif>>6 Aydan Fazla</option>
			  	</select>
			</td>
      	</tr>
      	<tr>
			<td><cf_get_lang_main no='731.İletişim'></td>
			<td>
			  	<select name="commethod_id" id="commethod_id" style="width:160px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				  	<cfoutput query="get_commethod_cats">
						<option value="#commethod_id#" <cfif commethod_id eq get_opportunity.commethod_id>selected</cfif>>#commethod#</option>
				  	</cfoutput>
			  	</select>
			</td>
      	</tr>
        <tr>
        	<td><cf_get_lang_main no='1240.Olasılık'></td>
			<td>
			  	<select name="probability" id="probability" style="width:160px;">
					<option value="0" <cfif get_opportunity.probability eq 0>selected</cfif>><cf_get_lang_main no='322.Seçiniz'></option>
					<option value="10" <cfif get_opportunity.probability eq 10>selected</cfif>>%10</option>
					<option value="20" <cfif get_opportunity.probability eq 20>selected</cfif>>%20</option>
					<option value="30" <cfif get_opportunity.probability eq 30>selected</cfif>>%30</option>
					<option value="40" <cfif get_opportunity.probability eq 40>selected</cfif>>%40</option>
					<option value="50" <cfif get_opportunity.probability eq 50>selected</cfif>>%50</option>
					<option value="60" <cfif get_opportunity.probability eq 60>selected</cfif>>%60</option>
					<option value="70" <cfif get_opportunity.probability eq 70>selected</cfif>>%70</option>
					<option value="80" <cfif get_opportunity.probability eq 80>selected</cfif>>%80</option>
					<option value="90" <cfif get_opportunity.probability eq 90>selected</cfif>>%90</option>
					<option value="100" <cfif get_opportunity.probability eq 100>selected</cfif>>%100</option>
			  	</select>
			</td>
        </tr>
     	<tr>
			<td>&nbsp;<cf_get_lang no='433.Tahmini Gelir'></td>
			<td>
				<cfinput type="text" name="income" id="income" class="moneybox" value="#TLFormat(get_opportunity.income)#" passthrough="onkeyup=""return(formatcurrency(this,event));""" style="width:84px;">
			  	<select name="money" id="money" style="width:42px;">
					<cfoutput query="get_moneys">
					  <option value="#money#" <cfif money is get_opportunity.money>selected</cfif>>#money#</option>
					</cfoutput>
			  	</select>
			</td>
			<td><cf_get_lang_main no= '4.Proje'></td>
			<td>
				<select name="project" id="project" style="width:130px;">
					<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
					<cfoutput query="get_project">
						<option value="#project_id#" <cfif len(get_opportunity.project_id) and (get_opportunity.project_id eq project_id)>selected</cfif>>#project_head#</option>
					</cfoutput>
				</select>
			</td>
        	<td><cf_get_lang_main no='70.Aşama'></td>
        	<td>
			  	<select name="opp_currency_id" id="opp_currency_id" style="width:160px;">
			  	<option value=""><cf_get_lang_main no='322.Seçiniz'></option>
			  	<cfoutput query="get_opp_currencies">
					<option value="#opp_currency_id#" <cfif opp_currency_id eq get_opportunity.opp_currency_id>selected</cfif>>#opp_currency#</option>
			  	</cfoutput>
			  	</select>
        	</td>
     	</tr>
     	<tr>
        	<td width="90">&nbsp;<cf_get_lang no='431.Tahmini Maliyet'></td>
        	<td>
				<cfinput type="text" name="cost" id="cost" class="moneybox" value="#TLFormat(get_opportunity.cost)#" passthrough="onkeyup=""return(formatcurrency(this,event));""" style="width:84px;">
          		<select name="money2" id="money2" style="width:42px;">
				<cfoutput query="get_moneys">
					<option value="#money#" <cfif money is get_opportunity.money>selected</cfif>>#money#</option>
				</cfoutput>
          		</select>
        	</td>
        	<td width="100"><cf_get_lang no='432.Özel Tanım'></td>
        	<td>
				<select name="sales_add_option" id="sales_add_option" style="width:130px;">
                <option value=""><cf_get_lang_main no='322.Seçiniz'></option>
				<cfoutput query="get_sale_add_option">
					<option value="#sales_add_option_id#" <cfif sales_add_option_id eq get_opportunity.sale_add_option_id>selected</cfif>>#sales_add_option_name#</option>
				</cfoutput>
            	</select>
        	</td>
			<td colspan="2">
                <cf_workcube_to_cc 
                    is_update="1" 
                    to_dsp_name="Müşteriler *" 
                    form_name="upd_opp" 
                    action_dsn="#DSN3#"
                    str_action_names="PARTNER_ID AS TO_PAR,CONSUMER_ID TO_CON"
                    action_table="OPPORTUNITIES"
                    action_id_name="OPP_ID"
                    action_id="#attributes.opp_id#"
                    str_list_param="10,11" 
                    data_type="1"> 	
				<!--- <cfif isdefined('attributes.company_id') and len(attributes.company_id)>
					<input type="hidden" name="consumer_id" id="consumer_id" value="" />
					<input type="hidden" name="company_id" id="company_id" value="<cfoutput>#attributes.company_id#</cfoutput>" />
					<input type="hidden" name="partner_id" id="partner_id" value="" />
					<input type="text" name="member_name" id="member_name" style="width:170px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\',\'0\',\'\',\'\',\'2\',\'1\'','PARTNER_ID,COMPANY_ID,CONSUMER_ID','partner_id,company_id,consumer_id','add_opp','3','250');" value="<cfoutput>#get_par_info(attributes.company_id,1,0,0)#</cfoutput>" autocomplete="off">
				<cfelse>
					<input type="hidden" name="consumer_id" id="consumer_id" value="" />
					<input type="hidden" name="company_id" id="company_id" value="" />
					<input type="hidden" name="partner_id" id="partner_id" value="" />
					<input type="text" name="member_name" id="member_name" style="width:170px;" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_relation_member_objects2','\'1,2\'','PARTNER_ID,COMPANY_ID,CONSUMER_ID','partner_id,company_id,consumer_id','add_opp','3','250');" value="" autocomplete="off">
				</cfif>--->
			</td>
      	</tr>
		<tr style="height:50px;">
			<td colspan="3">
				<cfoutput>
				<cf_get_lang_main no='71.Kayıt'> :
				<cfif len(get_opportunity.record_par)>
					#get_par_info(get_opportunity.record_par,0,-1,0)#
				<cfelseif len(get_opportunity.record_emp)>
					#get_emp_info(get_opportunity.record_emp,0,0)#
				</cfif>
				<cfif len(get_opportunity.record_date)> - #dateformat(date_add('h',session.pp.time_zone,get_opportunity.record_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_opportunity.record_date),'HH:MM')#</cfif>&nbsp;
				<cfif len(get_opportunity.update_emp) or len(get_opportunity.update_par)>
					<br/><cf_get_lang_main no='291.Son Güncelleme'> : 
					<cfif len(get_opportunity.update_emp)>
						#get_emp_info(get_opportunity.update_emp,0,0)#
					<cfelseif len(get_opportunity.update_par)>
						#get_par_info(get_opportunity.update_par,0,-1,0)#
					</cfif> - #dateformat(date_add('h',session.pp.time_zone,get_opportunity.update_date),'dd/mm/yyyy')# #timeformat(date_add('h',session.pp.time_zone,get_opportunity.update_date),'HH:MM')#
				</cfif>
				</cfoutput>
			</td>
			<td colspan="3" align="right" style="text-align:right;">
				<!---<cfif get_opportunity.is_processed eq 1>
					<cf_get_lang no='86.İşlendi'>
			  	<cfelse>
					<cfif get_opportunity.record_par eq session.pp.userid>
						<cf_workcube_buttons is_upd='1' delete_page_url='#request.self#?fuseaction=objects2.emptypopup_del_opportunity&opp_id=#attributes.opp_id#' add_function='kontrol()'>
					<cfelse>
						<cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
					</cfif>--->
                <cf_workcube_buttons is_upd='1' is_delete='0' add_function='kontrol()'>
			  	<!---</cfif>--->
			</td> 
      	</tr>
    </cfform>
</table>

