<cfif isdefined('session.pp')>	
	<cfparam name="attributes.is_online" default="1">
    <cfparam name="attributes.is_catalog" default="0">
	<cfparam name="attributes.product_status" default="1">
    <cfparam name="attributes.page" default="1">
	<cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
	
    <cfset getFavorite = createObject("component","worknet.objects.worknet_objects").getFavorite(action_type:"product") />
    <cfset product_id_list = valuelist(getFavorite.action_id,',')>
    <cfif len(product_id_list)>
		<cfset getProduct = createObject("component","V16.worknet.query.worknet_product").getProduct(
				is_online:attributes.is_online,
				is_catalog:attributes.is_catalog,
				product_status:attributes.product_status,
				product_id_list:product_id_list
		) />
	<cfelse>
		<cfset getProduct.recordcount = 0>
	</cfif>
	<cfparam name="attributes.totalrecords" default="#getProduct.recordcount#">
	
	<div class="haber_liste">
		<div class="haber_liste_1">
			<div class="haber_liste_11"><h1><cf_get_lang no='36.Favori Ürünlerim'></h1></div>
		</div>
		<div class="haber_liste_2">
			<cfif getProduct.recordcount>
			<cfoutput query="getProduct" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
				<div class="haber_liste_21">
					<div class="uhaber_liste_211">
	                    <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_product&pid=#product_id#">
							<cfif len(path)>
								<cf_get_server_file output_file="product/#path#" output_server="#path_server_id#" output_type="0" image_width="100" alt="#product_name#">
							<cfelse>
								<img src="/images/no_photo.gif" alt="<cf_get_lang no='495.Yok'>">
							</cfif>
						</a>
					</div>
					<div class="uhaber_liste_212">
						<div class="uhaber_liste_2121">
							<span>#dateformat(record_date,dateformat_style)#</span>
                            <a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_product&pid=#product_id#"><b>#product_name#</b></a>
							<samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#company_id#" style="font-size:12px;color:A4A4A4; font-weight:bold;">#fullname#-#partner_name#</a></samp>
						</div>                        
					</div>
					<div class="uhaber_liste_213">
	                    <cfset getMemberStatus = createObject("component","worknet.objects.worknet_objects").getMemberStatus(
								member_id:company_id,
								member_type:'company'
							)>
						<cfif getMemberStatus eq false>
							<div class="uhaber_liste_2133"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_sent_message&member_id=#getProduct.partner_id#','medium')"><cf_get_lang no='142.Offline'></a></div>
						<cfelse>
							<div class="uhaber_liste_2132"><a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_video_conferans&targetUserID=#getMemberStatus#','video_conference');"><cf_get_lang no='56.Online'></a></div>
						</cfif>
					</div>
				</div>
			</cfoutput>
			<cfelse>
				<div class="haber_liste_21">
					<div class="haber_liste_212">
						<cf_get_lang_main no='72.Kayıt Bulunamadı'>!
					</div>
				</div>
			</cfif>
		</div>
		<div class="maincontent">
			<cfif attributes.totalrecords gt attributes.maxrows>
				<cfset urlstr="&is_online=#attributes.is_online#&is_catalog=#attributes.is_catalog#&product_status=#attributes.product_status#">
		
					
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
