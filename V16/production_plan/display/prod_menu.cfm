<cfsavecontent variable="m_dil_1"><cf_get_lang dictionary_id='58464.uretim planlama'></cfsavecontent>
<cfsavecontent variable="m_dil_2"><cf_get_lang dictionary_id='36315.siparisler'></cfsavecontent>
<cfsavecontent variable="m_dil_3"><cf_get_lang dictionary_id='57527.Talepler'></cfsavecontent>
<cfsavecontent variable="m_dil_4"><cf_get_lang dictionary_id='57528.emirler'></cfsavecontent>
<cfsavecontent variable="m_dil_5"><cf_get_lang dictionary_id='58812.Üretimdekiler'></cfsavecontent>
<cfsavecontent variable="m_dil_13"><cf_get_lang dictionary_id='36376.Operasyonlar'></cfsavecontent>
<cfsavecontent variable="m_dil_6"><cf_get_lang dictionary_id='58135.sonuclar'></cfsavecontent>
<cfsavecontent variable="m_dil_7"><cf_get_lang dictionary_id='36318.cizelge'></cfsavecontent>
<cfsavecontent variable="m_dil_8"><cf_get_lang dictionary_id='36319.malzeme'></cfsavecontent>
<cfsavecontent variable="m_dil_9"><cf_get_lang dictionary_id='36320.urun agaclari'></cfsavecontent>
<cfsavecontent variable="m_dil_10"><cf_get_lang dictionary_id='29792.Görsel Tasarım'></cfsavecontent>
<cfsavecontent variable="m_dil_11"><cf_get_lang dictionary_id='36335.kalite'></cfsavecontent>
<cfsavecontent variable="m_dil_12"><cf_get_lang dictionary_id='57529.tanimlar'></cfsavecontent>
<cfset f_n_action_list = "prod.welcome*0*0*#m_dil_1#,prod.tracking*0*0*#m_dil_2#,prod.demands*0*0*#m_dil_3#,prod.order*0*0*#m_dil_4#,prod.order_new*0*0*#m_dil_4#,prod.in_productions*0*0*#m_dil_5#,prod.operations*0*0*#m_dil_13#,prod.list_results*0*0*#m_dil_6#,prod.graph_gant*0*0*#m_dil_7#,prod.list_materials_total*0*0*#m_dil_8#,prod.list_product_tree*0*0*#m_dil_9#,prod.product_tree_designer*0*0*#m_dil_10#,prod.list_quality_controls*0*0*#m_dil_11#,prod.list_definition*0*0*#m_dil_12#">
<cfoutput>
<cfswitch expression="#session.ep.design_id#">
<cfcase value="2">
	<div class="menus2">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
                            <!---<cfset c_f_ = 0>
                            <cfloop list="#f_n_action_list#" index="mcc">
                            <cfset link_type_ = listgetat(mcc,2,"*")>
                            <cfif len(mcc) and not listfindnocase(denied_pages,'#listgetat(mcc,1,"*")#')>
                                <cfset c_f_ = c_f_ + 1>
                                <td><cfif c_f_ eq 1>&nbsp;</cfif><cfif link_type_ is '0'><a href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=#listgetat(mcc,1,"*")#','prod',1,'İşleminiz Gerçekleştiriliyor! Lütfen Bekleyiniz!');" class="<cfif c_f_ eq 1>altbarheader<cfelse>altbar</cfif>">#listgetat(mcc,4,"*")#</a></cfif><cfif c_f_ eq 1>&nbsp;</cfif></td>
                            </cfif>
                            </cfloop>--->
                            <cfif not listfindnocase(denied_pages,'prod.welcome')>
                                <td><a href="#request.self#?fuseaction=prod.welcome" class="menus2_head"><cf_get_lang dictionary_id='58464.uretim planlama'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.tracking')>
                                <td><a href="#request.self#?fuseaction=prod.tracking" class="menus2_title"><cf_get_lang dictionary_id='36315.siparisler'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.demands')>
                                <td><a href="#request.self#?fuseaction=prod.demands" class="menus2_title"><cf_get_lang dictionary_id='57527.Talepler'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.order')>
                                <td><a href="#request.self#?fuseaction=prod.order" class="menus2_title"><cf_get_lang dictionary_id='57528.emirler'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.order_new')>
                                <td><a href="#request.self#?fuseaction=prod.order_new" class="menus2_title"><cf_get_lang dictionary_id='60567.Emirler Yeni'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.in_productions')>
                                <td><a href="#request.self#?fuseaction=prod.in_productions" class="menus2_title"><cf_get_lang dictionary_id='58812.Üretimdekiler'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.operations')>
                               <td><a href="#request.self#?fuseaction=prod.operations" class="menus2_title"><cf_get_lang dictionary_id='36376.Operasyonlar'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_results')>
                                <td><a href="#request.self#?fuseaction=prod.list_results" class="menus2_title"><cf_get_lang dictionary_id='58135.sonuclar'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.graph_gant')>
                                <td><a href="#request.self#?fuseaction=prod.graph_gant" class="menus2_title"><cf_get_lang dictionary_id='36318.cizelge'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_materials_total')>
                                <td><a href="#request.self#?fuseaction=prod.list_materials_total" class="menus2_title"><cf_get_lang dictionary_id='36319.malzeme'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_product_tree')>
                                <td><a href="#request.self#?fuseaction=prod.list_product_tree" class="menus2_title"><cf_get_lang dictionary_id='36320.urun agaclari'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.product_tree_designer')>
                                <td><a href="#request.self#?fuseaction=prod.product_tree_designer" class="menus2_title"><cf_get_lang dictionary_id='29792.Tasarım'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_quality_controlss')>
                                <td><a href="#request.self#?fuseaction=prod.list_quality_controls" class="menus2_title"><cf_get_lang dictionary_id='36335.kalite'></a></td>
                            </cfif>
                            <cfif not listfindnocase(denied_pages,'prod.list_definition')>
                                <td><a href="#request.self#?fuseaction=prod.list_definition" class="menus2_title"><cf_get_lang dictionary_id='57529.tanimlar'></a></td>
                            </cfif>
                        </tr>
                    </table>
                </td>
                <td style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm"></td>
            </tr>
        </table>
    </div>
</cfcase>
<cfcase value="3,4,7">
	<div class="menus2">
        <table width="100%" cellpadding="0" cellspacing="0">
            <tr>
                <td>
                    <table border="0" cellpadding="0" cellspacing="0">
                        <tr>
						<!---<cfset c_f_ = 0>
                        <cfloop list="#f_n_action_list#" index="mcc">
                        <cfset link_type_ = listgetat(mcc,2,"*")>
                        <cfif len(mcc) and not listfindnocase(denied_pages,'#listgetat(mcc,1,"*")#')>
                            <cfset c_f_ = c_f_ + 1>
                            <cfif c_f_ eq 1>&nbsp;</cfif><cfif link_type_ is '0'><a href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=#listgetat(mcc,1,"*")#','prod',1,'İşleminiz Gerçekleştiriliyor! Lütfen Bekleyiniz!');" class="<cfif c_f_ eq 1>titlebold<cfelse>txtsubmenu</cfif>">#listgetat(mcc,4,"*")# <cfif c_f_ neq 1 and c_f_ neq listlen(f_n_action_list)>:</cfif></a></cfif><cfif c_f_ eq 1>&nbsp;</cfif>
                        </cfif>
                        </cfloop>--->
                        <cfif not listfindnocase(denied_pages,'prod.welcome')>
                           <td> <a href="#request.self#?fuseaction=prod.welcome" class="menus2_head"><cf_get_lang dictionary_id='58464.uretim planlama'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.tracking')>
                            <td><a href="#request.self#?fuseaction=prod.tracking" class="menus2_title"><cf_get_lang dictionary_id='36315.siparisler'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.demands')>
                            <td><a href="#request.self#?fuseaction=prod.demands" class="menus2_title"><cf_get_lang dictionary_id='57527.Talepler'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.order')>
                            <td><a href="#request.self#?fuseaction=prod.order" class="menus2_title"><cf_get_lang dictionary_id='57528.emirler'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.order_new')>
                            <td><a href="#request.self#?fuseaction=prod.order_new" class="menus2_title"><cf_get_lang dictionary_id='60567.Emirler Yeni'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.in_productions')>
                           <td> <a href="#request.self#?fuseaction=prod.in_productions" class="menus2_title"><cf_get_lang dictionary_id='58812.Üretimdekiler'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.operations')>
                            <td><a href="#request.self#?fuseaction=prod.operations" class="menus2_title"><cf_get_lang dictionary_id='36376.Operasyonlar'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.list_results')>
                           <td> <a href="#request.self#?fuseaction=prod.list_results" class="menus2_title"><cf_get_lang dictionary_id='58135.sonuclar'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.graph_gant')>
                           <td> <a href="#request.self#?fuseaction=prod.graph_gant" class="menus2_title"><cf_get_lang dictionary_id='36318.cizelge'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.list_materials_total')>
                           <td> <a href="#request.self#?fuseaction=prod.list_materials_total" class="menus2_title"><cf_get_lang dictionary_id='36319.malzeme'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.list_product_tree')>
                           <td> <a href="#request.self#?fuseaction=prod.list_product_tree" class="menus2_title"><cf_get_lang dictionary_id='36320.urun agaclari'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.product_tree_designer')>
                            <td><a href="#request.self#?fuseaction=prod.product_tree_designer" class="menus2_title"><cf_get_lang dictionary_id='29792.Tasarım'></a></td>
                        </cfif>
                        <cfif not listfindnocase(denied_pages,'prod.list_quality_controls')>
                           <td> <a href="#request.self#?fuseaction=prod.list_quality_controls" class="menus2_title"><cf_get_lang dictionary_id='36335.kalite'></a></td>
                        </cfif>
						<cfif not listfindnocase(denied_pages,'prod.add_demand_assemption')>
							 <td> <a href="#request.self#?fuseaction=prod.add_demand_assemption" class="menus2_title"><cf_get_lang dictionary_id='36543.Talep Tahminleme'></a></td>
						</cfif>
                        <cfif not listfindnocase(denied_pages,'prod.list_definition')>
                           <td> <a href="#request.self#?fuseaction=prod.list_definition" class="menus2_title"><cf_get_lang dictionary_id='57529.tanimlar'></a></td>
                        </cfif>
                        </tr>
                    </table>
                </td>
                <td style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm"></td>
            </tr>
    	</table>
    </div>
</cfcase>
<cfdefaultcase>
	<table cellpadding="0" cellspacing="0" background="/images/top22back.gif" width="100%" height="27">
		<tr>
		  <td>
			<table border="0" cellpadding="0" cellspacing="0">
				<tr>
				<!---<cfset c_f_ = 0>
					<cfloop list="#f_n_action_list#" index="mcc">
					  <cfset link_type_ = listgetat(mcc,2,"*")>
						<cfif len(mcc) and not listfindnocase(denied_pages,'#listgetat(mcc,1,"*")#')>
							<cfset c_f_ = c_f_ + 1>
							<cfif c_f_ eq 1>
								<td align="center"><cfif link_type_ is '0'><a href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=#listgetat(mcc,1,"*")#','prod',1,'İşleminiz Gerçekleştiriliyor! Lütfen Bekleyiniz!');" class="topheader">#listgetat(mcc,4,"*")#</a></cfif></td>
							<cfelse>
								<td><img src="/images/button/sol.gif"></td>
								<td background="/images/button/back.gif"><cfif link_type_ is '0'><a href="javascript://" onclick="AjaxPageLoad('#request.self#?fuseaction=#listgetat(mcc,1,"*")#','prod',1,'İşleminiz Gerçekleştiriliyor! Lütfen Bekleyiniz!');" class="top2">#listgetat(mcc,4,"*")#</a></cfif></td>
								<td><img src="/images/button/sag.gif"></td>
							</cfif>
						</cfif>
					</cfloop>--->
					    <cfif not listfindnocase(denied_pages,'prod.welcome')>
							<td align="center">&nbsp;<a href="#request.self#?fuseaction=prod.welcome" class="topheader"><cf_get_lang dictionary_id='58464.uretim planlama'></a>&nbsp;</td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.tracking')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.tracking" class="top2"><cf_get_lang dictionary_id='36315.siparisler'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.demands')>
                        	<td width="7"><img src="/images/button/sol.gif"></td>
                            <td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.demands" class="txtsubmenu"><cf_get_lang dictionary_id='57527.Talepler'></a></td>
                            <td width="7"><img src="/images/button/sag.gif"></td>
                        </cfif>
						<cfif not listfindnocase(denied_pages,'prod.order')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.order" class="top2"><cf_get_lang dictionary_id='57528.emirler'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
                        	<cfif not listfindnocase(denied_pages,'prod.order_new')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.order_new" class="top2"><cf_get_lang dictionary_id='57528.emirler'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.in_productions')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.in_productions" class="top2"><cf_get_lang dictionary_id='58812.üretimdekiler'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.operations')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.operations" class="top2"><cf_get_lang dictionary_id='36376.Operasyonlar'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.list_results')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.list_results" class="top2"><cf_get_lang dictionary_id='58135.sonuclar'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.graph_gant')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.graph_gant" class="top2"><cf_get_lang dictionary_id='36318.cizelge'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.list_materials_total')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.list_materials_total" class="top2"><cf_get_lang dictionary_id='36319.malzeme'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.list_product_tree')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.list_product_tree" class="top2"><cf_get_lang dictionary_id='36320.urun agaclari'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
                        <cfif not listfindnocase(denied_pages,'prod.product_tree_designer')>
                            <td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.product_tree_designer" class="top2"><cf_get_lang dictionary_id='29792.Tasarım'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
                        </cfif>
						<cfif not listfindnocase(denied_pages,'prod.list_quality_controls')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.list_quality_controls" class="top2"><cf_get_lang dictionary_id='36335.kalite'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
						<cfif not listfindnocase(denied_pages,'prod.list_definition')>
							<td width="7"><img src="/images/button/sol.gif"></td>
							<td background="/images/button/back.gif"><a href="#request.self#?fuseaction=prod.list_definition" class="top2"><cf_get_lang dictionary_id='57529.tanimlar'></a></td>
							<td width="7"><img src="/images/button/sag.gif"></td>
						</cfif>
				</tr>
			</table>
		  </td>
		  <td align="right" style="text-align:right;"><cfinclude template="../../objects/display/favourites.cfm"></td>
		</tr>
	</table>
</cfdefaultcase>
</cfswitch>
</cfoutput> 
