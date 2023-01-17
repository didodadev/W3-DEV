<cfif isdefined('session.pp.userid')>
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.demand_type" default="">
<cfparam name="attributes.is_status" default="">
<cfparam name="attributes.demand_stage" default="">
<cfparam name="attributes.product_cat" default="">
<cfparam name="attributes.product_catid" default="">
<cfparam name="attributes.start_date" default="">
<cfparam name="attributes.finish_date" default="">

<cfparam name="attributes.page" default="1">
<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>

<cfif len(attributes.start_date)><cf_date tarih = "attributes.start_date"></cfif>
<cfif len(attributes.finish_date)><cf_date tarih = "attributes.finish_date"></cfif>

<cfset cmp = createObject("component","V16.worknet.query.worknet_demand") />
<cfset getDemand = cmp.getDemand(
		my_demand:1,
		is_online:'',
		is_status:attributes.is_status,
		keyword:attributes.keyword,
		demand_type:attributes.demand_type,
		product_cat:attributes.product_cat,
		product_catid:attributes.product_catid,
		company_id:session.pp.company_id,
		company_name:session.pp.company,
		demand_stage:attributes.demand_stage,
		start_date:attributes.start_date,
		finish_date:attributes.finish_date
	) 
/>
<cfset getProcess = createObject("component","V16.worknet.query.worknet_process").getProcess(fuseaction:'worknet.list_demand') />
<cfparam name="attributes.totalrecords" default="#getDemand.recordcount#">

<div class="haber_liste">
	<div class="haber_liste_1">
		<cfform name="search_demand" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.my_demand" method="post">
			<div class="haber_liste_11"><h1><cf_get_lang no='134.TALEPLERİM'> <cfif getDemand.recordcount>(<cfoutput>#getDemand.recordcount#</cfoutput>)</cfif></h1></div>
			<div class="haber_liste_12" style="width:32px;">
				<input class="arama_btn" name="" type="submit" value="" style=" border:none;">
			</div>
            <div class="haber_liste_12" style="width:180px;margin-right: 1px;">
				<input type="text" name="start_date" id="start_date" value="<cfif len(attributes.start_date)><cfoutput>#dateformat(attributes.start_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:70px; float:left;height: 26px;">
				<cf_wrk_date_image date_field="start_date">
				<input type="text" name="finish_date" id="finish_date" value="<cfif len(attributes.finish_date)><cfoutput>#dateformat(attributes.finish_date,dateformat_style)#</cfoutput></cfif>" maxlength="10" style="width:70px; float:left; margin-left:5px;height: 26px;">
				<cf_wrk_date_image date_field="finish_date">
			</div>
			<div class="haber_liste_12" style="width:100px;margin-right: 3px;">
                <select name="demand_stage" id="demand_stage" style="border:none;padding-bottom:3px; width:100px;">
                    <option value=""><cf_get_lang_main no='70.Asama'></option>
                    <cfoutput query="getProcess">
                        <option value="#process_row_id#" <cfif attributes.demand_stage eq process_row_id>selected</cfif>>#stage#</option>
                    </cfoutput>
                </select>
            </div>
			<div class="haber_liste_12" style="width:98px;margin-right: 4px;">
				<select name="demand_type" id="demand_type" style="border:none;padding-bottom:3px; width: 98px;">
					<option value=""><cf_get_lang no="81.Talep Türü"></option>
					<option value="1" <cfif attributes.demand_type eq 1>selected</cfif>><cf_get_lang no ='79.Alım'></option>
					<option value="2" <cfif attributes.demand_type eq 2>selected</cfif>><cf_get_lang no ='80.Satım'></option>
				</select>
			</div>
			<div class="haber_liste_12" style="width:85px;margin-right: 1px;">
				<select name="is_status" id="is_status" style="border:none;padding-bottom:3px; width:80px;">
					<option value=""><cf_get_lang_main no='344.Durum'></option>
					<option value="1" <cfif attributes.is_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
					<option value="0" <cfif attributes.is_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
				</select>
			</div>
			<div class="haber_liste_12" style="width: 190px;margin-right: 5px;">
				<cfinput type="text" name="keyword" style="width:190px;" value="#attributes.keyword#" class="txt_10">
			</div>
		</cfform>
	</div>
	<div class="forum_1">
		<div class="dashboard_162_duzenle" style="margin-bottom: 11px;float: right;margin-right: 6px;"><a href="add_demand"><span><samp><cf_get_lang no='124.Talep Ekle'></samp></span></a></div>
	</div>
	<div class="haber_liste_2">
		 <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
           <tr class="mesaj_31">
            <td width="15" class="mesaj_311_1"><cf_get_lang_main no='75.No'></td>
            <td class="mesaj_311_1"><cf_get_lang no='88.Talep'></td>
            <!---<td class="mesaj_311_1"><cf_get_lang_main no='74.Kategori'></td>--->
            <td class="mesaj_311_1"><cf_get_lang no="81.Talep Türü"></td> 
			<td class="mesaj_311_1"><cf_get_lang_main no='487.Kaydeden'></td>
            <td width="75" class="mesaj_311_1"><cf_get_lang_main no='344.Durum'></td>
            <td width="100" class="mesaj_311_1"><cf_get_lang_main no='70.Asama'></td>
           </tr>
		<cfif getDemand.recordcount>
			<cfoutput query="getDemand" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
                    <td class="tablo1">#currentrow#</td>
                    <td class="tablo1">
                        <a href="#request.self#?fuseaction=worknet.detail_demand&demand_id=#demand_id#">#demand_head#</a>
                    </td>
                    <!---<td class="tablo1">
                       <cfset getProductCat = cmp.getProductCat(demand_id:demand_id) />
						<cfif getProductCat.recordcount>
                            <cfloop query="getProductCat">
                                <cfset hierarchy_ = "">
                                <cfset new_name = "">
                                <cfloop list="#HIERARCHY#" delimiters="." index="hi">
                                    <cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
                                    <cfset getCat = createObject("component","V16.worknet.query.worknet_product").getMainProductCat(hierarchy:hierarchy_)>
                                    <cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
                                </cfloop>
                                #new_name#
                            </cfloop>
                        </cfif>
                    </td>--->
                    <td class="tablo1"><cfif demand_type eq 1><cf_get_lang no ='79.Alım'><cfelse><cf_get_lang no ='80.Satım'></cfif></td>
					<td class="tablo1">#partner_name#</td>
                    <td class="tablo1"><cfif is_status eq 1><cf_get_lang_main no ='81.Aktif'><cfelse><cf_get_lang_main no ='82.Pasif'></cfif></td>
                    <td class="tablo2" style="padding-left:5px;">#stage#</td>
                </tr>
			</cfoutput>
		<cfelse>
			<tr class="mesaj_34">
              <td class="tablo1" colspan="7"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
            </tr>
		</cfif>
       </table>
	</div>
	
	<div class="maincontent">
		<cfif attributes.totalrecords gt attributes.maxrows>
			<cfset urlstr="&keyword=#attributes.keyword#&demand_stage=#attributes.demand_stage#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#&demand_type=#attributes.demand_type#&is_status=#attributes.is_status#">
		
					  <cf_paging page="#attributes.page#" 
						page_type="1"
						maxrows="#attributes.maxrows#" 
						totalrecords="#attributes.totalrecords#" 
						startrow="#attributes.startrow#" 
						adres="#attributes.fuseaction##urlstr#">
					
		</cfif>
	</div>
</div>
<cfelseif isdefined("session.ww.userid")>
	<script>
		alert('Bu sayfaya erişmek için firma çalışanı olarak giriş yapmanız gerekmektedir!');
		history.back();
	</script>
	<cfabort>
<cfelse>
	<cfinclude template="member_login.cfm">
</cfif>
