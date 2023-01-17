<cfif isdefined('session.pp')>	
    <cfparam name="attributes.is_online" default="1">
    <cfparam name="attributes.is_status" default="1">
    <cfparam name="attributes.my_demand" default="0">
    
    <cfparam name="attributes.page" default="1">
    <cfparam name="attributes.maxrows" default='#session_base.maxrows#'>
    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
    
    <cfset getFavorite = createObject("component","worknet.objects.worknet_objects").getFavorite(action_type:"demand") />
    <cfset demand_id_list = valuelist(getFavorite.action_id,',')>
    <cfif len(demand_id_list)>
		<cfset getDemand = createObject("component","V16.worknet.query.worknet_demand").getDemand(
				my_demand:attributes.my_demand,
				is_online:attributes.is_online,
				is_status:attributes.is_status,
				demand_id_list:demand_id_list
			) 
		/>
	<cfelse>
		<cfset getDemand.recordcount = 0>
	</cfif>
    <cfparam name="attributes.totalrecords" default="#getDemand.recordcount#">
    <div class="haber_liste">
        <div class="haber_liste_1">
            <div class="haber_liste_11"><h1><cf_get_lang no='233.Favori Taleplerim'></h1></div>
        </div>
        <div class="haber_liste_2">
            <cfif getDemand.recordcount>
                <cfoutput query="getDemand" maxrows="#attributes.maxrows#" startrow="#attributes.startrow#">
                    <div class="haber_liste_21">
                        <div class="uhaber_liste_211">
                            <a href="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#demand_id#">
                                <cfif len(ASSET_FILE_NAME1)>
                                    <cftry>
                                        <cfimage source="../../documents/member/#ASSET_FILE_NAME1#" name="myImage">
                                        <cfset imgInfo=ImageInfo(myImage)>
                                        <cfif imgInfo.width/imgInfo.height lt 100/70>
                                            <img src="../documents/member/#ASSET_FILE_NAME1#" height="70" />
                                        <cfelse>
                                            <img src="../documents/member/#ASSET_FILE_NAME1#" width="100" />
                                        </cfif>
                                        <cfcatch type="Any">
                                            <img src="/images/no_photo.gif" class="productImagea" height="70">
                                        </cfcatch>
                                    </cftry>
                                <cfelse>
                                    <img src="/images/no_photo.gif" height="70">
                                </cfif>
                            </a>
                        </div>
                        <div class="talep_liste_212">
                            <span>#dateformat(start_date,dateformat_style)# <cfif len(finish_date)>- #dateformat(finish_date,dateformat_style)#</cfif></span>
                            <a href="#request.self#?fuseaction=worknet.dsp_demand&demand_id=#demand_id#">
                                <cfif demand_type eq 1><cf_get_lang no ='79.Alım'><cfelse><cf_get_lang no ='80.Satım'></cfif> - #demand_head#
                            </a>
                            <cfif isdefined('session.pp')>
                                <samp><a href="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.dsp_member&cpid=#company_id#" style="font-size:12px;color:A4A4A4; font-weight:bold;">#fullname#-#partner_name#</a></samp>
                            </cfif>
                        </div>
                        <div class="uhaber_liste_213" style="float:right;">
                            <div class="talep_detay_21">
                                <a href="javascript://" onClick="windowopen('#request.self#?fuseaction=worknet.popup_add_demand_offer&demand_id=#demand_id#','medium')"><font color="FFFFFF" style="font-size:20px;"><cf_get_lang no='105.TEKLİF VER'></font></a>
                            </div>
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
                <cfset urlstr="&is_online=#attributes.is_online#&is_status=#attributes.is_status#&my_demand=#attributes.my_demand#">
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
