<cfif isdefined('session.pp.userid')>
	<cfparam name="attributes.keyword" default="">
	<cfparam name="attributes.sector" default="">
	<cfparam name="attributes.product_cat" default="">
	<cfparam name="attributes.product_catid" default="">
    <cfparam name="attributes.product_stage" default="">
	<cfparam name="attributes.is_online" default="">
    <cfif attributes.fuseaction contains 'product'>
	    <cfparam name="attributes.is_catalog" default="0">
    <cfelse>
    	<cfparam name="attributes.is_catalog" default="1">
    </cfif>
	<cfparam name="attributes.product_status" default="">
	
	<cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	<cfset cmp = createObject("component","V16.worknet.query.worknet_product") />
	<cfset getProduct = cmp.getProduct(
			is_online:attributes.is_online,
			is_catalog:attributes.is_catalog,
			product_status:attributes.product_status,
			keyword:attributes.keyword,
			product_cat:attributes.product_cat,
			product_catid:attributes.product_catid,
			company_id:session.pp.company_id,
			company_name:session.pp.company,
			product_stage:attributes.product_stage
	) />
    <cfset getProcess = createObject("component","V16.worknet.query.worknet_process").getProcess(fuseaction:'worknet.list_product') />
	<cfparam name="attributes.totalrecords" default="#getProduct.recordcount#">
	<div class="haber_liste">
		<div class="haber_liste_1">
			<cfform name="search" action="#request.self#?fuseaction=#attributes.fuseaction#" method="post">
				<div class="haber_liste_11"><h1><cfif attributes.fuseaction contains 'product'><cf_get_lang no='109.Urunlerim'><cfelse><cf_get_lang no='173.Kataloglarim'></cfif>  <cfif getProduct.recordcount>(<cfoutput>#getProduct.recordcount#</cfoutput>)</cfif></h1></div>
				<div class="haber_liste_12" style="width:32px;">
					<input class="arama_btn" name="" type="submit" value="" style=" border:none;">
				</div>
                <div class="haber_liste_12" style="width:120px;">
					<select name="product_stage" id="product_stage" style="border:none;padding-bottom:3px; width:120px;">
						<option value=""><cf_get_lang_main no ='296.Tümü'></option>
                        <cfoutput query="getProcess">
							<option value="#process_row_id#" <cfif attributes.product_stage eq process_row_id>selected</cfif>>#stage#</option>
                        </cfoutput>
					</select>
				</div>
				<div class="haber_liste_12" style="width:85px;">
					<select name="product_status" id="product_status" style="border:none;padding-bottom:3px; width:80px;">
						<option value=""><cf_get_lang_main no ='296.Tümü'></option>
						<option value="1" <cfif attributes.product_status eq 1>selected</cfif>><cf_get_lang_main no ='81.Aktif'></option>
						<option value="0" <cfif attributes.product_status eq 0>selected</cfif>><cf_get_lang_main no ='82.Pasif'></option>
					</select>
				</div>
				<div class="haber_liste_12" style="width:210px;">
					<cfinput type="text" name="keyword" value="#attributes.keyword#" class="txt_10">
				</div>
			</cfform>
		</div>
		<div class="forum_1">
			<cfif attributes.fuseaction contains 'product'>
				<div class="dashboard_162_duzenle" style="margin-bottom: 11px;float: right;margin-right: 7px;"><a href="add_product"><span><samp><cf_get_lang_main no='1613.Ürün Ekle'></samp></span></a></div>
			<cfelse>
				<div class="dashboard_162_duzenle" style="margin-bottom:4px;float:right;"><a href="form_catalog"><span><samp><cf_get_lang no='175.Katalog Ekle'></samp></span></a></div>
			</cfif>
		</div>
		<div class="haber_liste_2">
	        <table width="100%" border="0" cellpadding="0" cellspacing="0" class="tablo">
               <tr class="mesaj_31">
                <td width="15" class="mesaj_311_1">No</td>
                <td class="mesaj_311_1"><cf_get_lang_main no='809.Ürün Adı'></td>
                <td class="mesaj_311_1"><cf_get_lang_main no='74.Kategori'></td>
				<td class="mesaj_311_1"><cf_get_lang_main no='487.Kaydeden'></td>
                <td width="75" class="mesaj_311_1"><cf_get_lang_main no='344.Durum'></td>
                <td width="100" class="mesaj_311_1"><cf_get_lang_main no='70.Asama'></td>
               </tr>
			<cfif getProduct.recordcount>
				<cfoutput query="getProduct" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
					<tr <cfif (currentrow mod 2) eq 0>class="mesaj_35"<cfelse>class="mesaj_34"</cfif>>
                        <td class="tablo1">#currentrow#</td>
                        <td class="tablo1">
                        	<cfif attributes.fuseaction contains 'product'>
	                            <a href="#request.self#?fuseaction=worknet.detail_product&pid=#product_id#">#product_name#</a>
                            <cfelse>
                            	<a href="#request.self#?fuseaction=worknet.form_catalog&pid=#product_id#">#product_name#</a>
                            </cfif>
                        </td>
                        <td class="tablo1">
                        	<cfset hierarchy_ = "">
							<cfset new_name = "">
							<cfloop list="#getProduct.HIERARCHY#" delimiters="." index="hi">
								<cfset hierarchy_ = ListAppend(hierarchy_,hi,'.')>
								<cfset getCat = cmp.getMainProductCat(hierarchy:hierarchy_)>
								<cfset new_name = ListAppend(new_name,getCat.PRODUCT_CAT,'>')>
							</cfloop>
							#new_name#
                        </td>
						<td class="tablo1">#partner_name#</td>
                        <td class="tablo1"><cfif product_status eq 1><cf_get_lang_main no ='81.Aktif'><cfelse><cf_get_lang_main no ='82.Pasif'></cfif></td>
                        <td class="tablo2" style="padding-left:5px;">#stage#</td>
                    </tr>
				</cfoutput>
			<cfelse>
				<tr class="mesaj_34">
                  <td class="tablo1" colspan="6"> <cf_get_lang_main no='72.Kayıt Bulunamadı'>!</td>
                </tr>
			</cfif>
           </table>
		</div>
		<div class="maincontent">
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfset urlstr="&keyword=#attributes.keyword#&product_stage=#attributes.product_stage#&product_cat=#attributes.product_cat#&product_catid=#attributes.product_catid#&is_online=#attributes.is_online#&product_status=#attributes.product_status#">
			
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
