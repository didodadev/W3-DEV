<cfsavecontent variable="ay1"><cf_get_lang dictionary_id ='57592.Ocak'></cfsavecontent>
<cfsavecontent variable="ay2"><cf_get_lang dictionary_id ='57593.Şubat'></cfsavecontent>
<cfsavecontent variable="ay3"><cf_get_lang dictionary_id ='57594.Mart'></cfsavecontent>
<cfsavecontent variable="ay4"><cf_get_lang dictionary_id ='57595.Nisan'></cfsavecontent>
<cfsavecontent variable="ay5"><cf_get_lang dictionary_id ='57596.Mayıs'></cfsavecontent>
<cfsavecontent variable="ay6"><cf_get_lang dictionary_id ='57597.Haziran'></cfsavecontent>
<cfsavecontent variable="ay7"><cf_get_lang dictionary_id ='57598.Temmuz'></cfsavecontent>
<cfsavecontent variable="ay8"><cf_get_lang dictionary_id ='57599.Ağustos'></cfsavecontent>
<cfsavecontent variable="ay9"><cf_get_lang dictionary_id ='57600.Eylül'></cfsavecontent>
<cfsavecontent variable="ay10"><cf_get_lang dictionary_id ='57601.Ekim'></cfsavecontent>
<cfsavecontent variable="ay11"><cf_get_lang dictionary_id ='57602.Kasım'></cfsavecontent>
<cfsavecontent variable="ay12"><cf_get_lang dictionary_id ='57603.Aralık'></cfsavecontent>
<cfparam name="attributes.quote_year" default="#session.ep.period_year#">
<cfscript>
	aylar 		= '#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#';
	list_target = '#getlang('','IMS Hedefi Ekle',822)# ,#getlang('','Karlılık Hedefi Ekle',823)#,#getlang('','Ciro Hedefi Ekle',824)#,#getlang('','Tahsilat Hedefi Ekle',825)#';
</cfscript>
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="GET_TEAM_NAME" datasource="#dsn#">
	SELECT TEAM_NAME FROM SALES_ZONES_TEAM WHERE TEAM_ID = #attributes.ims_team_id#
</cfquery>
<cfquery name="GET_SALES_OTHER_QUOTES" datasource="#dsn#">
	SELECT 
		SQGR.QUOTE_MONTH,
		SQGR.SALES_INCOME,
		SQGR.ROW_MONEY
	FROM 
		SALES_QUOTES_GROUP SQ,
		SALES_QUOTES_GROUP_ROWS SQGR
	WHERE
		SQGR.SALES_QUOTE_ID = SQ.SALES_QUOTE_ID AND
		SQ.QUOTE_TYPE = 2 AND
		SQ.QUOTE_YEAR = #attributes.quote_year# AND
		SQ.SALES_ZONE_ID = #attributes.sales_zone_id# AND
		SQGR.TEAM_ID = #attributes.ims_team_id# 
	ORDER BY
		SQGR.QUOTE_MONTH ASC
</cfquery>
<cfquery name="GET_QUOTE_TEAMS" datasource="#dsn#">
	SELECT
		SZT.TEAM_ID,
		SZT.TEAM_NAME,
		SC.IMS_CODE,
		SC.IMS_CODE_NAME,
		IMC.IMS_ID				
	FROM
		SALES_ZONES_TEAM SZT,
		SALES_ZONES_TEAM_IMS_CODE IMC,
		SETUP_IMS_CODE SC
	WHERE
		SZT.TEAM_ID = #attributes.ims_team_id# AND
		SZT.SALES_ZONES = #sales_zone_id# AND
		SZT.TEAM_ID = IMC.TEAM_ID AND
		IMC.IMS_ID = SC.IMS_CODE_ID
	ORDER BY
		IMC.IMS_ID
</cfquery>
<cfsavecontent variable="title_">
	<cfoutput>#Listgetat(list_target,attributes.target_type)#</cfoutput>
</cfsavecontent>
<cf_box title="#title_#">
    <cfform name="form_basket" method="post" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_quote_ims_based">
        <input type="hidden" name="sales_zone_id" id="sales_zone_id" value="<cfoutput>#attributes.sales_zone_id#</cfoutput>">
        <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
        <input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#attributes.quote_year#</cfoutput>">
        <input type="hidden" name="target_type" id="target_type" value="<cfoutput>#attributes.target_type#</cfoutput>">
        <input type="hidden" name="ims_team_id" id="ims_team_id" value="<cfoutput>#attributes.ims_team_id#</cfoutput>">
        <cf_box_elements vertical="1">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <div class="form-group"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></div>
                <div class="form-group" ><cfinclude template="../query/get_sales_zone_name.cfm">
                <input type="text" name="sales_zone" id="sales_zone" value="<cfoutput>#get_sales_zone_name.sz_name#</cfoutput>" readonly ></div>
                <div class="form-group" ><cf_get_lang dictionary_id='41613.Hedef Tipi'> *</div>
                <div class="form-group"><select name="target_type_select" id="target_type_select" onChange="window.open(this.options[this.selectedIndex].value,'_self')" style="width:100px">
						<cfoutput>
                            <cfloop from="1" to="#listlen(list_target)#" index="i">
                                <option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_ims_based&target_type=#i#&team_id=#attributes.sales_zone_id#-#attributes.ims_team_id#-#attributes.branch_id#&quote_year=#attributes.quote_year#&is_submit=1" <cfif attributes.target_type eq i>selected</cfif>>#Listgetat(list_target,i)#</option>
                          </cfloop>
                        </cfoutput>			  
                    </select>
                </div>
            </div>
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <div class="form-group"><cf_get_lang dictionary_id='49274.İlgili Şube'></div>
                <div class="form-group"><cfinclude template="../query/get_branch_name.cfm">
                    <input type="text" name="sales_zone" id="sales_zone" value="<cfoutput>#get_branch_name.branch_name#</cfoutput>" readonly ></div>
                <div class="form-group"><cf_get_lang dictionary_id='58472.Dönem'> *</div>
                <div class="form-group"><select name="quote_year_select" id="quote_year_select" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }" style="width:100px;">
						<cfoutput>
                            <cfloop from="#session.ep.period_year#" to="#session.ep.period_year+10#" index="i">
                                <option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_ims_based&quote_year=#i#&team_id=#attributes.sales_zone_id#-#attributes.ims_team_id#-#attributes.branch_id#&target_type=#attributes.target_type#&is_submit=1" <cfif attributes.quote_year eq i>selected</cfif>>#i#</option>
                            </cfloop>
                        </cfoutput>
              	    </select>
                </div>
            </div>
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <div class="form-group"><cf_get_lang dictionary_id='41479.Takım Adı'></div>
                <div class="form-group">
					<input type="text" name="team_name" id="team_name" value="<cfoutput>#get_team_name.team_name#</cfoutput>" readonly >	
				</div>
				<div class="form-group">
					<div class="form-group">
						<cf_get_lang dictionary_id='51960.Planlayan'>
					</div>
					<div class="input-group">
						<input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
						<input type="text" name="employee_name" id="employee_name" value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly >
						<span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.employee_id&field_name=form_basket.employee_name','list');"></span>
					</div>
				</div>
                
            </div>
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                
				<div class="form-group"><cf_get_lang_main dictionary_id='57629.Açıklama'>
					<div class="form-group" rowspan="4"><textarea name="quote_detail" id="quote_detail" style="width:200px;height:45px;"></textarea></div>
            </div>
        </cf_box_elements>
        <cf_basket>
        <cf_grid_list>
          <thead>
              <tr>
                <th style="width:50px;"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                <th colspan="100">
                  <select name="money" id="money">
                    <cfoutput query="get_moneys">
                      <option value="#money#" <cfif session.ep.money is '#money#'>selected</cfif>>#money#</option>
                    </cfoutput>
                  </select>
                </th>
              </tr>
              <tr>
                <th>
                  <input type="hidden" name="ims_ids" id="ims_ids" value="<cfoutput>#valuelist(get_quote_teams.ims_id)#</cfoutput>">
                  <input type="hidden" name="team_ids" id="team_ids" value="<cfoutput>#valuelist(get_quote_teams.team_id)#</cfoutput>">
                  <input type="hidden" name="ims_codes" id="ims_codes" value="<cfoutput>#valuelist(get_quote_teams.ims_code)#</cfoutput>">
                </th>
                <cfset im = 0>
                <cfloop from="1" to="12" index="k">
                  <th colspan="3"><cfoutput>#Listgetat(aylar,k)#</cfoutput></th>
                  <cfif k mod 3 eq 0>
                    <cfset im = im + 1>
                    <th colspan="3"><cfoutput>#im#</cfoutput>. <cf_get_lang dictionary_id='50800.Çeyrek'></th>
                  </cfif>
                </cfloop>
                <th colspan="3" nowrap><cf_get_lang dictionary_id='821.12 Aylık Ortalama'></th>
                <th colspan="3" nowrap style="display:none;"><cf_get_lang dictionary_id='58170.Satır Toplam'></th>
              </tr>
              <tr>
                <th>&nbsp;</th>
              <cfloop from="1" to="12" index="k">
                <th><cf_get_lang dictionary_id='57951.Hedef'></th>
                <th><cf_get_lang dictionary_id='51389.Gerçekleşen'></th>
                <th>%</th>
              <cfif k mod 3 eq 0>
                <th><cf_get_lang dictionary_id='57951.Hedef'></th>
                <th><cf_get_lang dictionary_id='51389.Gerçekleşen'></th>
                <th>%</th>
              </cfif>
              </cfloop>
                <th><cf_get_lang dictionary_id='57951.Hedef'></th>
                <th><cf_get_lang dictionary_id='51389.Gerçekleşen'></th>
                <th>%</th>
                <th style="display:none;"><cf_get_lang dictionary_id='57951.Hedef'></th>
                <th style="display:none;"><cf_get_lang dictionary_id='51389.Gerçekleşen'></th>
                <th style="display:none;">%</th>
              </tr>
           </thead>
           <tbody>
              <tr>
                <td class="txtbold"><cf_get_lang dictionary_id='41566.Brickler'></td>
                <cfset toplam_other_quotes=0>
              <cfif get_sales_other_quotes.recordcount>
                <cfoutput query="get_sales_other_quotes">
                <td width="75" nowrap><cf_get_lang no='41567.Depo Satışı'></td>
                <cfset toplam_other_quotes=toplam_other_quotes+get_sales_other_quotes.sales_income>
                <td width="75" nowrap><cf_get_lang dictionary_id='41570.Pazar Toplamı'></td>
                <td width="45"><cf_get_lang dictionary_id='41569.Pazar Payı'> %</td>
                </cfoutput>
                <td width="75" nowrap><cf_get_lang dictionary_id='41567.Depo Satışı'></td>
                <td width="75" nowrap><cf_get_lang dictionary_id='41570.Pazar Toplamı'></td>
                <td width="45"><cf_get_lang dictionary_id='41569.Pazar Payı'> %</td>
              <cfelse>
                <td colspan="100" align="center"><cf_get_lang no='118.Kayıtlı Takım Hedefi Yok'></td>
              </cfif>
              </tr>
              <cfoutput query="get_quote_teams">
              <tr>
                <td nowrap="nowrap" class="txtbold">#ims_code# - #ims_code_name#</td>
              <cfset imsd = 0>
              <cfloop from="1" to="12" index="k">
                <td nowrap width="75"><cfinput type="text" name="teammarket_#team_id#_#ims_id#_#k#" onkeyup="return(FormatCurrency(this,event,2));" onBlur="toplam_al_team(#team_id#,#ims_id#,#k#);" onFocus="son_deger_degis_team(#team_id#,#ims_id#,#k#);" style="width:100%;" class="box" value="0" tabindex="#k#"></td>
                <td nowrap width="75"><cfinput type="text" name="team_#team_id#_#ims_id#_#k#" passThrough = "onkeyup=""return(FormatCurrency(this,event,2));"" onFocus=""son_deger_degis(#team_id#,#ims_id#,#k#);"" onBlur=""toplam_al(#team_id#,#ims_id#,#k#);""" style="width:100%;" value="0" class="box" tabindex="#k#"></td>
                <td nowrap width="50"><cfinput type="text" name="teamortalama_#team_id#_#ims_id#_#k#" value="0" class="box" readonly style="width:100%;"></td>
              <cfif k mod 3 eq 0>
              <cfset imsd = imsd + 1>
                <td nowrap width="75"><cfinput type="text" name="quarter_teammarket_#team_id#_#ims_id#_#imsd#"  readonly style="width:100%;" class="box" value="0"></td>
                <td nowrap width="75"><cfinput type="text" name="quarter_team_#team_id#_#ims_id#_#imsd#" readonly style="width:100%;" value="0" class="box"></td>
                <td nowrap width="50"><cfinput type="text" name="quarter_teamortalama_#team_id#_#ims_id#_#imsd#" value="0" class="box" readonly style="width:100%;"></td>
              </cfif>
              </cfloop>
                <td nowrap><cfinput type="text" name="ortalama_toplammarket_#team_id#_#ims_id#" value="0" class="box" readonly style="width:100%;"></td>
                <td><cfinput type="text" name="ortalama_toplam_#team_id#_#ims_id#" value="0" class="box" readonly style="width:100%;"></td>
                <td><cfinput type="text" name="ortalama_toplamortalama_#team_id#_#ims_id#" value="0" class="box" readonly style="width:100%;"></td>
                <td nowrap style="display:none;"><cfinput type="text" name="toplammarket_#team_id#_#ims_id#" value="0" class="box" readonly style="width:100%;"></td>
                <td style="display:none;"><cfinput type="text" name="toplam_#team_id#_#ims_id#" value="0" class="box" readonly style="width:100%;"></td>
                <td style="display:none;"><cfinput type="text" name="toplamortalama_#team_id#_#ims_id#" value="0" class="box" readonly style="width:100%;"></td>
              </tr>
              </cfoutput>
              <cfoutput>
              <tr>
                <td nowrap="nowrap" class="txtbold"><cfoutput>#get_team_name.team_name#</cfoutput></td>
              <cfset imsk = 0>
              <cfloop from="1" to="12" index="k">
                <td nowrap width="75"><cfinput type="text" name="teammarket_#attributes.ims_team_id#_YY_#k#" onkeyup="return(FormatCurrency(this,event,2));" onBlur="toplam_al_team(#attributes.ims_team_id#,'YY',#k#,2);" onFocus="son_deger_degis_team(#attributes.ims_team_id#,'YY',#k#);" style="width:100%;" class="box" value="0" tabindex="#k#"></td>
                <td nowrap width="75"><cfinput type="text" name="team_#attributes.ims_team_id#_YY_#k#" onkeyup="return(FormatCurrency(this,event,2));" onFocus="son_deger_degis(#attributes.ims_team_id#,'YY',#k#);" onBlur="toplam_al(#attributes.ims_team_id#,'YY',#k#);" style="width:100%;" value="0" class="box" tabindex="#k#"></td>
                <td nowrap width="50"><cfinput type="text" name="teamortalama_#attributes.ims_team_id#_YY_#k#" value="0" class="box" readonly style="width:100%;"></td>
                <cfif k mod 3 eq 0>
                <cfset imsk = imsk + 1>
                <td nowrap width="75"><cfinput type="text" name="quarter_teammarket_#attributes.ims_team_id#_YY_#imsk#" readonly style="width:100%;" class="box" value="0"></td>
                <td nowrap width="75"><cfinput type="text" name="quarter_team_#attributes.ims_team_id#_YY_#imsk#" readonly style="width:100%;" value="0" class="box"></td>
                <td nowrap width="50"><cfinput type="text" name="quarter_teamortalama_#attributes.ims_team_id#_YY_#imsk#" value="0" class="box" readonly style="width:100%;"></td>
              </cfif>
              </cfloop>
                <td nowrap><cfinput type="text" name="ortalama_toplammarket_#attributes.ims_team_id#_YY" value="0" class="box" readonly style="width:100%;"></td>
                <td><cfinput type="text" name="ortalama_toplam_#attributes.ims_team_id#_YY" value="0" class="box" readonly style="width:100%;"></td>
                <td><cfinput type="text" name="ortalama_toplamortalama_#attributes.ims_team_id#_YY" value="0" class="box" readonly style="width:100%;"></td>
                <td nowrap style="display:none;"><cfinput type="text" name="toplammarket_#attributes.ims_team_id#_YY" value="0" class="box" readonly style="width:100%;"></td>
                <td style="display:none;"><cfinput type="text" name="toplam_#attributes.ims_team_id#_YY" value="0" class="box" readonly style="width:100%;"></td>
                <td style="display:none;"><cfinput type="text" name="toplamortalama_#attributes.ims_team_id#_YY" value="0" class="box" readonly style="width:100%;"></td>
              </tr>
              </cfoutput>
           </tbody>
           <tfoot>
              <tr>
                <td class="txtbold"><cf_get_lang no='119.Toplamlar'></td>
              <cfset imsm = 0>
              <cfloop from="1" to="12" index="m">
                <td nowrap><input type="text" name="toplammarket_colon_<cfoutput>#m#</cfoutput>" id="toplammarket_colon_<cfoutput>#m#</cfoutput>" style="width:100%;" class="box" value="0" readonly></td>
                <td><input type="text" name="toplam_colon_<cfoutput>#m#</cfoutput>" id="toplam_colon_<cfoutput>#m#</cfoutput>" style="width:100%;" class="box" value="0" readonly></td>
                <td><input type="text" name="toplamortalama_colon_<cfoutput>#m#</cfoutput>" id="toplamortalama_colon_<cfoutput>#m#</cfoutput>" value="0" class="box" style="width:100%;" readonly></td>
                <cfif m mod 3 eq 0>
                <cfset imsm = imsm + 1>
                <td nowrap><input type="text" name="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplammarket_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="0" readonly></td>
                <td><input type="text" name="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplam_colon_<cfoutput>#imsm#</cfoutput>" style="width:100%;" class="box" value="0" readonly></td>
                <td><input type="text" name="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" id="quarter_toplamortalama_colon_<cfoutput>#imsm#</cfoutput>" value="0" class="box" style="width:100%;" readonly></td>
                </cfif>
              </cfloop>
                <td nowrap width="75"><input type="text" name="ortalama_son_toplam_market" id="ortalama_son_toplam_market" style="width:100%;" class="box" value="0" readonly></td>
                <td nowrap width="75"><input type="text" name="ortalama_son_toplam" id="ortalama_son_toplam" style="width:100%;" class="box" value="0" readonly></td>
                <td nowrap width="50"><input type="text" name="ortalama_son_toplam_ortalama" id="ortalama_son_toplam_ortalama" style="width:100%;" class="box" value="0" readonly></td>
                <td nowrap width="75" style="display:none;"><input type="text" name="son_toplam_market" id="son_toplam_market" style="width:100%;" class="box" value="0" readonly></td>
                <td nowrap width="75" style="display:none;"><input type="text" name="son_toplam" id="son_toplam" style="width:100%;" class="box" value="0" readonly></td>
                <td nowrap width="50" style="display:none;"><input type="text" name="son_toplam_ortalama" id="son_toplam_ortalama" style="width:100%;" class="box" value="0" readonly></td>
              </tr>
            </tfoot>
        </cf_grid_list>
        </cf_basket>
        <cf_box_footer>
			<cfif get_sales_other_quotes.recordcount><cf_workcube_buttons is_upd='0' add_function='upd_form()'></cfif>
            <cf_workcube_buttons is_upd='0' add_function='upd_form()'>
       </cf_box_footer>
  </cfform>
</cf_box>
<script type="text/javascript">
function upd_form(){
	x = (200 - form_basket.quote_detail.value.length);
	if(x < 0){ 
		alert ("<cf_get_lang_main no='217.Açıklama'> "+ ((-1) * x) +" Karakter Uzun");
		return false;
	}	
	UnformatFields();
	<cfoutput query="get_quote_teams">
	for(var i=1; i<=12; i++){
		if(eval("form_basket.team_#team_id#_#ims_id#_"+i).value == '')
			eval("form_basket.team_#team_id#_#ims_id#_"+i).value = 0;
		if(eval("form_basket.teammarket_#team_id#_#ims_id#_"+i).value == '')
			eval("form_basket.teammarket_#team_id#_#ims_id#_"+i).value = 0;
	}
	</cfoutput>
	<cfoutput>
	for(var i=1; i<=12; i++){
		if(eval("form_basket.team_#attributes.ims_team_id#_YY_"+i).value == '')
			eval("form_basket.team_#attributes.ims_team_id#_YY_"+i).value = 0;
		if(eval("form_basket.teammarket_#attributes.ims_team_id#_YY_"+i).value == '')
			eval("form_basket.teammarket_#attributes.ims_team_id#_YY_"+i).value = 0;
	}
	</cfoutput>
	return true;
}
function UnformatFields(){	
	<cfoutput query="get_quote_teams">
	for(var i=1; i<=12; i++){ 
		eval("form_basket.team_#team_id#_#ims_id#_"+i).value = filterNum(eval("form_basket.team_#team_id#_#ims_id#_"+i).value);
		eval("form_basket.teammarket_#team_id#_#ims_id#_"+i).value = filterNum(eval("form_basket.teammarket_#team_id#_#ims_id#_"+i).value);
	}
	</cfoutput>
	<cfoutput>
	for(var i=1; i<=12; i++){ 
		eval("form_basket.team_#attributes.ims_team_id#_YY_"+i).value = filterNum(eval("form_basket.team_#attributes.ims_team_id#_YY_"+i).value);
		eval("form_basket.teammarket_#attributes.ims_team_id#_YY_"+i).value = filterNum(eval("form_basket.teammarket_#attributes.ims_team_id#_YY_"+i).value);
	}
	</cfoutput>	
}
function son_deger_degis(satir_id,kolon_adi,kolon_no)
{
	son_deger = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	son_deger = filterNum(son_deger);
}
function toplam_al(satir_id,kolon_adi,kolon_no)
{
	gelen_satir_toplam_partner = eval("form_basket.toplammarket_" + satir_id + "_" + kolon_adi).value;
	gelen_satir_toplam_partner = filterNum(gelen_satir_toplam_partner);
	gelen_satir_toplam = eval("form_basket.toplam_" + satir_id + "_" + kolon_adi).value;
	gelen_satir_toplam = filterNum(gelen_satir_toplam);
	
	gelen_input_partner = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	gelen_input_partner = filterNum(gelen_input_partner);
	gelen_input = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	gelen_input = filterNum(gelen_input);
	
	gelen_kolon_toplam_partner = eval("form_basket.toplammarket_colon_" + kolon_no).value;
	gelen_kolon_toplam_partner = filterNum(gelen_kolon_toplam_partner);
	gelen_kolon_toplam = eval("form_basket.toplam_colon_" + kolon_no).value;
	gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
	
	son_toplam_partner = form_basket.son_toplam_market.value;
	son_toplam_partner = filterNum(son_toplam_partner);
	son_toplam = form_basket.son_toplam.value;
	son_toplam = filterNum(son_toplam);
			
	son_toplam = (son_toplam + gelen_input) - son_deger;
	gelen_kolon_toplam = (gelen_kolon_toplam + gelen_input) - son_deger;
	gelen_satir_toplam = (gelen_satir_toplam + gelen_input) - son_deger;
	
	if(gelen_input_partner > 0)
		ay_ortalama = (100 * gelen_input) / gelen_input_partner;
	else
		ay_ortalama = 0;
	
	if(gelen_satir_toplam_partner > 0)
		satir_ortalama = (100 * gelen_satir_toplam) / gelen_satir_toplam_partner;
	else
		satir_ortalama = 0;
	
	if(gelen_kolon_toplam_partner > 0)
		kolon_ortalama = (100 * gelen_kolon_toplam) / gelen_kolon_toplam_partner;
	else
		kolon_ortalama = 0;
	
	if(son_toplam_partner > 0)
		son_toplam_ortalama = (100 * son_toplam) / son_toplam_partner;
	else
		son_toplam_ortalama = 0;
	
	if((kolon_no == 1) || (kolon_no == 2) || (kolon_no == 3)){
		ceyrekdeger = 1;
		ortalamatoplanacak1 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_1.value");
		ortalamatoplanacak2 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_2.value");
		ortalamatoplanacak3 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_3.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak1) + filterNum(ortalamatoplanacak2) + filterNum(ortalamatoplanacak3))/3;
	}
	else if((kolon_no == 4) || (kolon_no == 5) || (kolon_no == 6)){
		ceyrekdeger = 2;
		ortalamatoplanacak4 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_4.value");
		ortalamatoplanacak5 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_5.value");
		ortalamatoplanacak6 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_6.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak4) + filterNum(ortalamatoplanacak5) + filterNum(ortalamatoplanacak6))/3;
	}
	else if((kolon_no == 7) || (kolon_no == 8) || (kolon_no == 9)){	
		ceyrekdeger = 3;
		ortalamatoplanacak7 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_7.value");
		ortalamatoplanacak8 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_8.value");
		ortalamatoplanacak9 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_9.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak7) + filterNum(ortalamatoplanacak8) + filterNum(ortalamatoplanacak9))/3;
	}
	else if((kolon_no == 10) || (kolon_no == 11) || (kolon_no == 12)){
		ceyrekdeger = 4;
		ortalamatoplanacak10 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_10.value");
		ortalamatoplanacak11 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_11.value");
		ortalamatoplanacak12 = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_12.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak10) + filterNum(ortalamatoplanacak11) + filterNum(ortalamatoplanacak12))/3;
	}
	/*eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(ilkceyrekortalam,2);*/
	gelenceyrekgerceklesen = eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	gelenceyrekgerceklesen = filterNum(gelenceyrekgerceklesen);
	
	degereski = eval("form_basket.quarter_team_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	degereski = filterNum(degereski);
	/*gelenceyrektoplam = eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	gelenceyrektoplam = filterNum(gelenceyrektoplam);*/
	
	ceyrekdegertoplam = eval("form_basket.quarter_toplam_colon_" + ceyrekdeger).value;
	ceyrekdegertoplam = filterNum(ceyrekdegertoplam);

	ceyrekdegertoplam = ceyrekdegertoplam + ilkceyrekortalama - degereski; 
	
	if(gelenceyrekgerceklesen > 0)
		yuzdegerceklesen = (100 * ilkceyrekortalama) / gelenceyrekgerceklesen;
	else
		yuzdegerceklesen = 0;
	
	eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(gelenceyrekgerceklesen,2);
	eval("form_basket.quarter_team_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(ilkceyrekortalama,2);
	eval("form_basket.quarter_teamortalama_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(yuzdegerceklesen,2);
	eval("form_basket.quarter_toplam_colon_" + ceyrekdeger).value = commaSplit(ceyrekdegertoplam,2);
	
	ortalama_son_toplam_ = commaSplit(son_toplam/12);
	deger_ortalama_toplam = commaSplit(gelen_satir_toplam/12);
	gelen_input = commaSplit(gelen_input,2);
	gelen_satir_toplam = commaSplit(gelen_satir_toplam,2);
	gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,2);
	son_toplam = commaSplit(son_toplam,2);
	ay_ortalama = commaSplit(ay_ortalama,2);
	satir_ortalama = commaSplit(satir_ortalama,2);
	kolon_ortalama = commaSplit(kolon_ortalama,2);
	son_toplam_ortalama = commaSplit(son_toplam_ortalama,2);
	
	eval("form_basket.ortalama_toplam_" + satir_id + "_" + kolon_adi).value = deger_ortalama_toplam;
	eval("form_basket.toplam_" + satir_id + "_" + kolon_adi).value = gelen_satir_toplam;
	eval("form_basket.toplam_colon_" + kolon_no).value = gelen_kolon_toplam;
	eval("form_basket.teamortalama_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = ay_ortalama;
	eval("form_basket.toplamortalama_" + satir_id + "_" + kolon_adi).value = satir_ortalama;
	eval("form_basket.ortalama_toplamortalama_" + satir_id + "_" + kolon_adi).value = satir_ortalama;
	eval("form_basket.toplamortalama_colon_" + kolon_no).value = kolon_ortalama;
	eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = gelen_input;
	form_basket.son_toplam_ortalama.value = son_toplam_ortalama;
	form_basket.son_toplam.value = son_toplam;
	form_basket.ortalama_son_toplam.value = ortalama_son_toplam_;
	
}
function son_deger_degis_team(satir_id,kolon_adi,kolon_no)
{
	son_deger_market = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	son_deger_market = filterNum(son_deger_market);
}
function toplam_al_team(satir_id,kolon_adi,kolon_no,type)
{
	
	gelen_satir_toplam = eval("form_basket.toplammarket_" + satir_id + "_" + kolon_adi).value;
	gelen_satir_toplam = filterNum(gelen_satir_toplam);
	gelen_satir_toplam_partner = eval("form_basket.toplam_" + satir_id + "_" + kolon_adi).value;
	gelen_satir_toplam_partner = filterNum(gelen_satir_toplam_partner);
	
	gelen_input = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	gelen_input = filterNum(gelen_input);
	gelen_input_partner = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
	gelen_input_partner = filterNum(gelen_input_partner);
	
	gelen_kolon_toplam = eval("form_basket.toplammarket_colon_" + kolon_no).value;
	gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
	gelen_kolon_toplam_partner = eval("form_basket.toplam_colon_" + kolon_no).value;
	gelen_kolon_toplam_partner = filterNum(gelen_kolon_toplam_partner);
	
	son_toplam = form_basket.son_toplam_market.value;
	son_toplam = filterNum(son_toplam);
	son_toplam_partner = form_basket.son_toplam.value;
	son_toplam_partner = filterNum(son_toplam_partner);
			
	son_toplam = (son_toplam + gelen_input) - son_deger_market;
	gelen_kolon_toplam = (gelen_kolon_toplam + gelen_input) - son_deger_market;
	gelen_satir_toplam = (gelen_satir_toplam + gelen_input) - son_deger_market;

	if(gelen_input > 0)
		ay_ortalama = (100 * gelen_input_partner) / gelen_input;
	else
		ay_ortalama = 0;
	
	if(gelen_satir_toplam > 0)
		satir_ortalama = (100 * gelen_satir_toplam_partner) / gelen_satir_toplam;
	else
		satir_ortalama = 0;
	
	if(gelen_kolon_toplam > 0)
		kolon_ortalama = (100 * gelen_kolon_toplam_partner) / gelen_kolon_toplam;
	else
		kolon_ortalama = 0;
	
	if(son_toplam > 0)
		son_toplam_ortalama = (100 * son_toplam_partner) / son_toplam;
	else
		son_toplam_ortalama = 0;
	
	if((kolon_no == 1) || (kolon_no == 2) || (kolon_no == 3)){
		ceyrekdeger = 1;
		ortalamatoplanacak1 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_1.value");
		ortalamatoplanacak2 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_2.value");
		ortalamatoplanacak3 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_3.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak1) + filterNum(ortalamatoplanacak2) + filterNum(ortalamatoplanacak3))/3;
	}
	else if((kolon_no == 4) || (kolon_no == 5) || (kolon_no == 6)){
		ceyrekdeger = 2;
		ortalamatoplanacak4 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_4.value");
		ortalamatoplanacak5 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_5.value");
		ortalamatoplanacak6 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_6.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak4) + filterNum(ortalamatoplanacak5) + filterNum(ortalamatoplanacak6))/3;
	}
	else if((kolon_no == 7) || (kolon_no == 8) || (kolon_no == 9)){	
		ceyrekdeger = 3;
		ortalamatoplanacak7 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_7.value");
		ortalamatoplanacak8 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_8.value");
		ortalamatoplanacak9 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_9.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak7) + filterNum(ortalamatoplanacak8) + filterNum(ortalamatoplanacak9))/3;
	}
	else if((kolon_no == 10) || (kolon_no == 11) || (kolon_no == 12)){
		ceyrekdeger = 4;
		ortalamatoplanacak10 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_10.value");
		ortalamatoplanacak11 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_11.value");
		ortalamatoplanacak12 = eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_12.value");
		ilkceyrekortalama = (filterNum(ortalamatoplanacak10) + filterNum(ortalamatoplanacak11) + filterNum(ortalamatoplanacak12))/3;
	}
	/*eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(ilkceyrekortalam,2);*/
	gelenceyrekgerceklesen = eval("form_basket.quarter_team_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	gelenceyrekgerceklesen = filterNum(gelenceyrekgerceklesen);
	
	degereski = eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	degereski = filterNum(degereski);
		
	/*gelenceyrektoplam = eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value;
	gelenceyrektoplam = filterNum(gelenceyrektoplam);*/
	
	ceyrekdegertoplam = eval("form_basket.quarter_toplammarket_colon_" + ceyrekdeger).value;
	ceyrekdegertoplam = filterNum(ceyrekdegertoplam);

	ceyrekdegertoplam = ceyrekdegertoplam + ilkceyrekortalama - degereski; 
	
	if(gelenceyrekgerceklesen > 0)
		yuzdegerceklesen = (100 * gelenceyrekgerceklesen) / ilkceyrekortalama;
	else
		yuzdegerceklesen = 0;
	
	eval("form_basket.quarter_teammarket_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(ilkceyrekortalama,2);
	eval("form_basket.quarter_team_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(gelenceyrekgerceklesen,2);
	eval("form_basket.quarter_teamortalama_" + satir_id + "_" + kolon_adi + "_" + ceyrekdeger).value = commaSplit(yuzdegerceklesen,2);
	eval("form_basket.quarter_toplammarket_colon_" + ceyrekdeger).value = commaSplit(ceyrekdegertoplam,2);
	
	ortalama_son_toplam_ = commaSplit(son_toplam/12);
	deger_ortalama_toplam = commaSplit(gelen_satir_toplam/12);
	gelen_input = commaSplit(gelen_input,2);
	gelen_satir_toplam = commaSplit(gelen_satir_toplam,2);
	gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,2);
	son_toplam = commaSplit(son_toplam,2);
	ay_ortalama = commaSplit(ay_ortalama,2);
	satir_ortalama = commaSplit(satir_ortalama,2);
	kolon_ortalama = commaSplit(kolon_ortalama,2);
	son_toplam_ortalama = commaSplit(son_toplam_ortalama,2);
	
	eval("form_basket.ortalama_toplammarket_" + satir_id + "_" + kolon_adi).value = deger_ortalama_toplam;
	eval("form_basket.toplammarket_" + satir_id + "_" + kolon_adi).value = gelen_satir_toplam;
	eval("form_basket.toplammarket_colon_" + kolon_no).value = gelen_kolon_toplam;
	eval("form_basket.teamortalama_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = ay_ortalama;
	eval("form_basket.toplamortalama_" + satir_id + "_" + kolon_adi).value = satir_ortalama;
	eval("form_basket.ortalama_toplamortalama_" + satir_id + "_" + kolon_adi).value = satir_ortalama;
	eval("form_basket.toplamortalama_colon_" + kolon_no).value = kolon_ortalama;
	eval("form_basket.teammarket_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = gelen_input;
	form_basket.son_toplam_ortalama.value = son_toplam_ortalama;
	form_basket.son_toplam_market.value = son_toplam;
	form_basket.ortalama_son_toplam_market.value = ortalama_son_toplam_;
}
</script>
