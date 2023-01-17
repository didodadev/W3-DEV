<cf_get_lang_set module_name="worknet">
<cf_xml_page_edit fuseact="worknet.list_demand">
﻿<div style="position:absolute; margin:35px; left:200px; z-index:99;" id="showCategory"></div>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.sector" default="">
<cfparam name="attributes.demand_type" default="">
<cfparam name="attributes.company_name" default="">
<cfparam name="attributes.company_id" default="">
<cfparam name="attributes.is_status" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.demand_stage" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfparam name="attributes.project_id" default="">
<cfparam name="attributes.project_head" default="">

<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>

<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
<cfset getProcess = createObject("component","V16.worknet.query.worknet_process").getProcess(fuseaction:attributes.fuseaction)/>

<cfif isdefined('attributes.form_submitted')>
	<cfset getDemand = cmp.getDemand(
			keyword:attributes.keyword,
			sector:attributes.sector,
			demand_type:attributes.demand_type,
			demand_stage:attributes.demand_stage,
			is_status:attributes.is_status,
			company_name:attributes.company_name,
			company_id:attributes.company_id,
			product_catid:attributes.product_catid,
			product_cat:attributes.product_cat,
			start_date:attributes.start_date,
			finish_date:attributes.finish_date,
			project_id:attributes.project_id,
			project_head:attributes.project_head
		) 
	/>
<cfelse>
	<cfset getDemand.recordcount = 0>
</cfif>
<cfparam name="attributes.totalrecords" default="#getDemand.recordcount#">

<cfform name="search_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_demand" method="post">
    <cf_big_list_search title="#getLang('main',115)#"> 
    <cf_big_list_search_area>
    	<div class="row" type="row">
    		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
	            <div class="form-group" id="item-keyword">
	            	<label class="col col-12"><cf_get_lang_main no='48.Filtre'></label>
	                <div class="col col-12">
	                	<div class="input-group">
	                    	<input type="hidden" name="form_submitted" id="form_submitted" value="1">
	                    	<cfinput type="text" name="keyword" id="keyword" value="#attributes.keyword#" style="width:120px;">
	                    </div>
	                </div>
	            </div> 
				<div class="form-group" id="item-date">
					<label class="col col-12"><cf_get_lang no='84.Yayın Tarihi'></label>
						<div class="col col-4 col-sm-12">
							<div class="input-group">
								<input type="text" name="start_date" id="start_date" value="<cfif len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:65px;" placeholder="Başlangıç Tarihi">
								<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
			                </div>
			            </div>
			            <div class="col col-4 col-sm-12">  
			            	<div class="input-group">                      
			                	<input type="text" name="finish_date" id="finish_date" value="<cfif len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:65px;" placeholder="Bitiş Tarihi">
								<span class="input-group-addon"><cf_wrk_date_image date_field="finish_date"></span>
			                </div>
			            </div> 
			    </div>
	            <div class="form-group" id="item-is_status">
	            	<label class="col col-12"><cf_get_lang_main no ='344.Durum'></label>
	                <div class="col col-12">
	                	<div class="input-group">
			                <select name="is_status" id="is_status" style="width:90px;">
			                    <option value=""><cf_get_lang_main no ='344.Durum'></option>
			                      <option value="1" <cfif attributes.is_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
			                    <option value="0" <cfif attributes.is_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
			                </select>
	                    </div>
	                </div>
	            </div> 
	            <div class="form-group" id="item-demand_stage">
	            	<label class="col col-12"><cf_get_lang_main no='70.Aşama'></label>
	                <div class="col col-12">
	                	<div class="input-group">
			                <select name="demand_stage" id="demand_stage" style="width:90px;">
			                    <option value=""><cf_get_lang_main no='70.Aşama'></option>
			                    <cfoutput query="getProcess">
			                        <option value="#process_row_id#" <cfif attributes.demand_stage eq process_row_id>selected</cfif>>#stage#</option>
			                    </cfoutput>
			                 </select>
	                    </div>
	                </div>
	            </div>	            	            	               			
    		</div>
    		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
	            <div class="form-group" id="item-company_id">
	            	<label class="col col-12"><cf_get_lang_main no ='246.Üye'></label>
	                <div class="col col-12">
	                	<div class="input-group">
			                <input type="hidden" name="company_id" id="company_id" value="<cfif len(attributes.company_id)><cfoutput>#attributes.company_id#</cfoutput></cfif>">
			                <input type="text" name="company_name" id="company_name" style="width:120px;" onFocus="AutoComplete_Create('company_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2,3\',\'<cfif fusebox.circuit is 'store'>1<cfelse>0</cfif>\',\'0\',\'0\',\'2\',\'0\',\'0\',\'1\'','COMPANY_ID,CONSUMER_ID,EMPLOYEE_ID,MEMBER_TYPE','company_id,consumer_id,employee_id,member_type','form','3','250');" value="<cfif len(attributes.company_name)><cfoutput>#attributes.company_name#</cfoutput></cfif>" autocomplete="off">
			                <span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&field_comp_id=search_demand.company_id&field_comp_name=search_demand.company_name&select_list=2</cfoutput>&keyword='+encodeURIComponent(search_demand.company_name.value),'list','popup_list_pars');"></span>
	                    </div>
	                </div>
	            </div>
	            <div class="form-group" id="item-product_catid">
	            	<label class="col col-12"><cf_get_lang_main no='155.Ürün Kategorileri'></label>
	                <div class="col col-12">
	                	<div class="input-group">
			                <input type="hidden" name="product_catid" id="product_catid" value="<cfif isdefined('attributes.product_catid') and len(attributes.product_catid)><cfoutput>#attributes.product_catid#</cfoutput></cfif>" />
			                <input type="text" name="product_cat" id="product_cat" style="width:130px;" value="<cfif isdefined('attributes.product_cat') and len(attributes.product_cat)><cfoutput>#attributes.product_cat#</cfoutput><cfelse><cf_get_lang_main no='155.Ürün Kategorileri'></cfif>"/> <!---onfocus="goster(showCategory);openProductCat();"--->
			                <span class="input-group-addon icon-ellipsis btnPointer" onClick="goster(showCategory);openProductCat();"></span>
	                    </div>
	                </div>
	            </div>
	            <div class="form-group" id="item-demand_type">
	            	<label class="col col-12"><cf_get_lang no ='81.Talep Turu'></label>
	                <div class="col col-12">
	                	<div class="input-group">
			                <select name="demand_type" id="demand_type" style="width:85px;">
			                    <option value=""><cf_get_lang no ='81.Talep Turu'></option>
			                    <option value="1" <cfif attributes.demand_type eq 1>selected</cfif>><cf_get_lang no ='79.Alım'></option>
			                    <option value="2" <cfif attributes.demand_type eq 2>selected</cfif>><cf_get_lang no ='80.Satım'></option>
			                </select>
	                    </div>
	                </div>
	            </div>
	            <div class="form-group" id="item-sector_cat_id">
	            	<label class="col col-12"><cf_get_lang_main no='167.Sektör'></label>
	                <div class="col col-12">
	                	<div class="input-group">
			                <cfsavecontent variable="text"><cf_get_lang_main no='167.Sektör'></cfsavecontent>
			                <cfif isdefined("attributes.sector") and len(attributes.sector)><cfset attributes.sector = attributes.sector><cfelse><cfset attributes.sector = ''></cfif>
			                <cf_wrk_selectlang 
			                    name="sector"
			                    option_name="sector_cat"
			                    option_value="sector_cat_id"
			                    width="100"
			                    table_name="SETUP_SECTOR_CATS"
			                    option_text="#text#" value="#attributes.sector#" >
	                    </div>
	                </div>
	            </div> 	             	             	             	                 			
    		</div>
    		<div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
	            <div class="form-group" id="item-project_id">
	            	<label class="col col-12"><cfoutput>#getLang('main',4)#</cfoutput></label>
	                <div class="col col-12">
	                	<div class="input-group">
			                 <input type="hidden" name="project_id" id="project_id" value="<cfif isdefined("attributes.project_id") and len (attributes.project_head)><cfoutput>#attributes.project_id#</cfoutput></cfif>">
			                 <input type="text" name="project_head"  id="project_head" style="width:120px;" placeholder="<cfoutput>#getLang('main',4)#</cfoutput>" value="<cfif Len(attributes.project_head)><cfoutput>#get_project_name(attributes.project_id)#</cfoutput></cfif>" onfocus="AutoComplete_Create('project_head','PROJECT_HEAD','PROJECT_HEAD','get_project','','PROJECT_ID','project_id','','3','200');" autocomplete="off">
			                 <span class="input-group-addon icon-ellipsis btnPointer" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_projects&project_id=search_demand.project_id&project_head=search_demand.project_head');"></span>
	                    </div>
	                </div>
	            </div> 
	            <div class="form-group" id="item-maxrows">
	            	<label class="col col-12">&nbsp;</label>
	                <div class="col col-12">
						<div class="col col-4 col-sm-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang_main no='125.Sayi_Hatasi_Mesaj'></cfsavecontent>
								<cfinput type="text" name="maxrows" value="#attributes.maxrows#" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:30px; text-align:center;">
			                </div>
			            </div>
			            <div class="col col-4 col-sm-12">  
			            	<div class="input-group">                      
			                	<cf_wrk_search_button is_excel="0" button_type="1">
			                </div>
			            </div> 
	                </div>
	            </div>  	               		
    		</div>    		    		
    	</div>
</cf_big_list_search_area>
</cf_big_list_search>
</cfform>
	<cf_big_list>
    	<thead>
        	<tr>
            	<th><cf_get_lang_main no='75.No'></th>
                <th><cf_get_lang no ='88.Talep'></th> 
                <th><cf_get_lang no ='81.Talep Türü'></th>
                <th><cf_get_lang_main no ='70.Aşama'></th>
                <th><cf_get_lang_main no ='344.Durum'></th>
                <th><cf_get_lang no ='84.Yayın Tarihi'></th>
               	<th><cf_get_lang_main no='162.Şirket'></th>
                <th><cf_get_lang_main no='166.Yetkili'></th>
                <th class="header_icn_none"><a href="index.cfm?fuseaction=worknet.list_demand&event=add" title="Ekle"><img src="/images/plus_list.gif" title="<cf_get_lang_main no='170.Ekle'>" alt="<cf_get_lang_main no='170.Ekle'>"></a></th>
            </tr>
        </thead>
        <tbody>
			<cfif getDemand.recordcount>
				<cfoutput query="getDemand" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <tr>
                        <td>#currentrow#</td>
                        <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_demand&event=upd&demand_id=#demand_id#" class="tableyazi">#demand_head#</a></td>
                        <td><cfif demand_type eq 1><cf_get_lang no ='79.Alım'><cfelse><cf_get_lang no ='80.Satim'></cfif></td>
                        	<cfset getProductProcess = createObject("component","V16.worknet.query.worknet_process").getProcess(fuseaction:attributes.fuseaction,process_row_id:getDemand.stage_id)/>
                        <td>#getProductProcess.stage#</td>
                        <td><cfif is_status eq 1><cf_get_lang_main no ='81.Aktif'><cfelse><cf_get_lang_main no ='82.Pasif'></cfif></td>
                        <td>#dateformat(start_date,dateformat_style)# <cfif len(finish_date)>- #dateformat(finish_date,dateformat_style)#</cfif></td>
                        <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_company&cpid=#company_id#" class="tableyazi">#fullname#</a></td>
                        <td><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.detail_partner&pid=#partner_id#" class="tableyazi">#partner_name#</a></td>
                    	<td width="15"><a href="index.cfm?fuseaction=worknet.list_demand&event=upd&demand_id=#demand_id#" title=" Güncelle "><img src="/images/update_list.gif" alt="<cf_get_lang_main no='52.Güncelle'>" title="<cf_get_lang_main no='52.Güncelle'>"></a></td>
                    </tr>
				</cfoutput>
			<cfelse>
				<tr>
					<td colspan="9"><cfif isdefined("attributes.form_submitted")><cf_get_lang_main no='72.Kayıt Bulunamadı'>!<cfelse><cf_get_lang_main no='289.Filtre Ediniz'>!</cfif></td>
			   </tr>
			</cfif>
       </tbody>
   </cf_big_list>
<cfif attributes.totalrecords gt attributes.maxrows>
	<cfset url_str = "">
	<cfif isDefined("attributes.form_submitted")>
		<cfset url_str = "#url_str#&form_submitted=#attributes.form_submitted#">
	</cfif>
	<cfif len(attributes.keyword)>
		<cfset url_str = "#url_str#&keyword=#attributes.keyword#">
	</cfif>
	<cfif len(attributes.company_id)>
		<cfset url_str = "#url_str#&company_id=#attributes.company_id#">
	</cfif>
	<cfif len(attributes.company_name)>
		<cfset url_str = "#url_str#&company_name=#attributes.company_name#">
	</cfif>
	<cfif len(attributes.demand_stage)>
		<cfset url_str = "#url_str#&demand_stage=#attributes.demand_stage#">
	</cfif>
	<cfif len(attributes.demand_type)>
		<cfset url_str = "#url_str#&demand_type=#attributes.demand_type#">
	</cfif>
	<cfif len(attributes.product_catid)>
		<cfset url_str = "#url_str#&product_catid=#attributes.product_catid#">
	</cfif>
	<cfif len(attributes.product_cat)>
		<cfset url_str = "#url_str#&product_cat=#attributes.product_cat#">
	</cfif>
	<cfif len(attributes.sector)>
		<cfset url_str = "#url_str#&sector=#attributes.sector#">
	</cfif>
	<cfif len(attributes.is_status)>
		<cfset url_str = "#url_str#&is_status=#attributes.is_status#">
	</cfif>
	<cfif len(attributes.start_date)>
		<cfset url_str = "#url_str#&start_date=#dateformat(attributes.start_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.finish_date)>
		<cfset url_str = "#url_str#&finish_date=#dateformat(attributes.finish_date,dateformat_style)#">
	</cfif>
	<cfif len(attributes.project_id)>
		<cfset url_str = "#url_str#&project_id=#attributes.project_id#">
	</cfif>
	<cfif len(attributes.project_head)>
		<cfset url_str = "#url_str#&project_head=#attributes.project_head#">
	</cfif>			
	<table cellpadding="0" cellspacing="0" width="98%" align="center" height="35">
		<tr>
			<td>
			  <cf_pages page="#attributes.page#" 
				maxrows="#attributes.maxrows#" 
				totalrecords="#attributes.totalrecords#" 
				startrow="#attributes.startrow#" 
				adres="#listgetat(attributes.fuseaction,1,'.')#.list_demand#url_str#">
			<td style="text-align:right"><cfoutput> <cf_get_lang_main no ='128.Toplam Kayıt'>:#getDemand.recordcount#&nbsp;-&nbsp;<cf_get_lang_main no ='169.Sayfa'>:#attributes.page#/#lastpage#</cfoutput> </td>
		</tr>
	</table>
</cfif>

<script language="javascript">
	function openProductCat()
	{
		AjaxPageLoad('<cfoutput>#request.self#</cfoutput>?fuseaction=worknet.selected_product_cat','showCategory',1,'Loading..');
	}
</script>
<cf_get_lang_set module_name="#lcase(listgetat(attributes.fuseaction,1,'.'))#">