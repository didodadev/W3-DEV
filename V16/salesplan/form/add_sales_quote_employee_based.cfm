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
<cfset aylar = "#ay1#,#ay2#,#ay3#,#ay4#,#ay5#,#ay6#,#ay7#,#ay8#,#ay9#,#ay10#,#ay11#,#ay12#">
<cfinclude template="../query/get_moneys.cfm">
<cfquery name="get_team_name" datasource="#dsn#">
    SELECT
        TEAM_NAME
    FROM
        SALES_ZONES_TEAM
    WHERE
        TEAM_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_TEAM_ID#">
</cfquery>
<cfquery name="get_sales_other_quotes" datasource="#dsn#">
    SELECT 
        SQGR.QUOTE_MONTH,
        SQGR.SALES_INCOME,
        SQGR.ROW_MONEY
    FROM 
        SALES_QUOTES_GROUP SQ,
        SALES_QUOTES_GROUP_ROWS SQGR
    WHERE
        SQ.QUOTE_YEAR = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.quote_year#"> AND
        SQ.SALES_ZONE_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.sales_zone_id#"> AND
        SQ.QUOTE_TYPE = <cfqueryparam cfsqltype="cf_sql_integer" value="2"> AND
        SQGR.SALES_QUOTE_ID=SQ.SALES_QUOTE_ID AND
        SQGR.TEAM_ID= <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.EMPLOYEE_TEAM_ID#">
    ORDER BY
        SQGR.QUOTE_MONTH ASC
</cfquery>
<cfparam name="attributes.quote_year" default='#session.ep.period_year#'>
<cf_box title="#getLang('salesplan',62)#">
    <cfform name="form_basket" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_quote_employee_based" method="post">
        <input type="hidden" name="sales_zone_id" id="sales_zone_id" value="<cfoutput>#attributes.sales_zone_id#</cfoutput>">
        <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
        <input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#attributes.quote_year#</cfoutput>">
        <cf_box_elements vertical="1">
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <div class="form-group"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></div>
                <div class="form-group">
                    <cfinclude template="../query/get_sales_zone_name.cfm">
                    <input type="text"  name="sales_zone" id="sales_zone" value="<cfoutput>#GET_SALES_ZONE_NAME.sz_name#</cfoutput>" readonly>
                </div>
                <div class="form-group"><cf_get_lang dictionary_id='58472.Dönem'></div>
                <div class="form-group">
                    <select name="quote_year_select" id="quote_year_select" style="width:65px;" onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
                    <cfoutput>
                        <cfloop from="#session.ep.period_year#" to="2020" index="i">
                        <option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_customer_based&quote_year=#i#&team_id=#attributes.sales_zone_id#-#attributes.customer_team_id#-#attributes.branch_id#" <cfif attributes.quote_year eq i>selected</cfif>>#i#</option>
                        </cfloop>
                    </cfoutput>
                    </select>
                </div>
            </div>
            <div class="col col-3 col-md-3 col-sm-3 col-xs-12">
                <div class="form-group"><cf_get_lang dictionary_id='49274.İlgili Şube'></div>
                <div class="form-group">
                    <cfinclude template="../query/get_branch_name.cfm">
                    <input type="text"  name="sales_zone" id="sales_zone" value="<cfoutput>#get_branch_name.branch_name#</cfoutput>" readonly>
                </div>
                <div class="form-group"><cf_get_lang_main dictionary_id='57629.Açıklama'></div>
                <div class="form-group" rowspan="4">
                    <textarea name="quote_detail" id="quote_detail" style="width:150px;height:65px;"></textarea>
                </div>
            </div>
            <div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12">
                <div class="form-group">
                    <cf_get_lang dictionary_id='51960.Planlayan'>
                </div>
                <div class="input-group">
                    <input type="hidden" name="employee_id" id="employee_id" value="<cfoutput>#session.ep.userid#</cfoutput>">
                    <input type="text" name="employee_name" id="employee_name"  value="<cfoutput>#session.ep.name# #session.ep.surname#</cfoutput>" readonly>
                    <span class="input-group-addon icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_positions&field_emp_id=form_basket.employee_id&field_name=form_basket.employee_name','list');"></span>
                </div>
            </div>
            <div class="form-group col col-3 col-md-3 col-sm-3 col-xs-12">
                <div class="form-group"><cf_get_lang dictionary_id='41479.Takım Adı'></div>
                <div class="form-group"><input type="text"  name="team_name" id="team_name" value="<cfoutput>#get_team_name.team_name#</cfoutput>" readonly>
                </div>
            </div>
        </cf_box_elements>
        <cfscript>
        son_toplam = 0;kolon_1 = 0;kolon_2 = 0;kolon_3 = 0;kolon_4 = 0;kolon_5 = 0;kolon_6 = 0;
        
        kolon_7 = 0;kolon_8 = 0;kolon_9 = 0;kolon_10 = 0;kolon_11 = 0;kolon_12 = 0;
        </cfscript>
        <cfquery name="get_quote_teams" datasource="#dsn#">
            SELECT 
                SZT.TEAM_NAME, 
                SZR.POSITION_CODE, 
                SZT.TEAM_ID 
            FROM
                SALES_ZONES_TEAM SZT, 
                SALES_ZONES_TEAM_ROLES SZR 
            WHERE 
                SZT.TEAM_ID = #attributes.EMPLOYEE_TEAM_ID# AND 
                SZT.SALES_ZONES = #sales_zone_id# AND	
                SZT.TEAM_ID = SZR.TEAM_ID
        </cfquery>
        <cf_basket>
            <cf_grid_list>
                <thead>				
                <tr>
                        <th style="width:50px;"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                        <th colspan="15">
                            <select name="money" id="money">
                                <cfoutput query="get_moneys">
                                    <option value="#MONEY#" <cfif session.ep.money is '#MONEY#'>selected</cfif>>#MONEY#</option>
                                </cfoutput>
                            </select>
                        </th>
                    </tr>
                    <tr>
                        <th><cf_get_lang dictionary_id='58873.Satıcı'>
                            <input type="hidden" name="position_codes" id="position_codes" value="<cfoutput>#valuelist(get_quote_teams.position_code)#</cfoutput>">
                            <input type="hidden" name="team_ids" id="team_ids" value="<cfoutput>#valuelist(get_quote_teams.TEAM_ID)#</cfoutput>">
                        </th>
                        <cfloop from="1" to="12" index="k">
                            <th align="center"><cfoutput>#Listgetat(aylar,k)#</cfoutput> </th>
                        </cfloop>
                        <th><cf_get_lang dictionary_id='58170.Satır Toplam'></th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <td class="txtbold"><cf_get_lang dictionary_id='41467.Takım Hedefleri'></td>
                        <cfset toplam_other_quotes=0>
                        <cfif get_sales_other_quotes.recordcount>
                            <cfoutput query="get_sales_other_quotes">
                                <th>#tlformat(get_sales_other_quotes.SALES_INCOME,0)#</td>
                                <cfset toplam_other_quotes=toplam_other_quotes+get_sales_other_quotes.SALES_INCOME>
                            </cfoutput>
                            <td><cfoutput>#tlformat(toplam_other_quotes,0)#</cfoutput></th>
                        <cfelse>
                            <td colspan="13" align="center"><cf_get_lang dictionary_id='41563.Kayıtlı Takım Hedefi Yok'></td>
                        </cfif>
                    </tr>
                    <cfoutput query="get_quote_teams">
                        <tr>
                            <td>#get_emp_info(position_code,1,0)#/ #TEAM_NAME#</td>
                            <cfloop from="1" to="12" index="k">
                                <td><cfinput passThrough="onkeyup=""return(FormatCurrency(this,event,0));"" onFocus=""son_deger_degis(#team_id#,#position_code#,#k#);"" onBlur=""toplam_al(#team_id#,#position_code#,#k#);""" type="text" name="team_#TEAM_ID#_#position_code#_#k#" style="width:60px;" class="box" value="#tlformat(0,0)#" tabindex="#k#"></td>
                            </cfloop>
                            <td><cfinput  type="text" name="toplam_#TEAM_ID#_#position_code#" style="width:60px;"  class="box" value="#tlformat(0,0)#"></td>
                        </tr>
                    </cfoutput>
                </tbody>
                <tfoot>
                    <tr>
                        <td style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>
                        <cfloop from="1" to="12" index="m">
                            <td><input type="text" name="toplam_colon_<cfoutput>#m#</cfoutput>" id="toplam_colon_<cfoutput>#m#</cfoutput>" style="width:60px;" class="box" value="<cfoutput>#tlformat(evaluate("kolon_#m#"),0)#</cfoutput>" readonly></td>
                        </cfloop>
                        <td><input type="text" name="son_toplam" id="son_toplam" style="width:60px;" class="box" value="<cfoutput>#tlformat(son_toplam,0)#</cfoutput>" readonly></td>
                    </tr>
                </tfoot>
            </cf_grid_list>
        </cf_basket>
        <cf_popup_box_footer><cfif get_sales_other_quotes.recordcount><cf_workcube_buttons is_upd='0' add_function='upd_form()'></cfif></cf_popup_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function son_deger_degis(satir_id,kolon_adi,kolon_no)
{
    son_deger = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
    son_deger = filterNum(son_deger);
}
function upd_form()

{
    UnformatFields();
    <cfoutput query="get_quote_teams">
        for(var i=1; i<=12; i++)			
        {
        if(eval("form_basket.team_#TEAM_ID#_#position_code#_"+i).value == '')
        eval("form_basket.team_#TEAM_ID#_#position_code#_"+i).value=0;
        }
    </cfoutput>	
    return true;
}

function UnformatFields()
    {	
        <cfoutput query="get_quote_teams">
            for(var i=1; i<=12; i++)			
            { 
            eval("form_basket.team_#TEAM_ID#_#position_code#_"+i).value = filterNum(eval("form_basket.team_#TEAM_ID#_#position_code#_"+i).value);
            }
        </cfoutput>
        for(var y=1; y<=12; y++)			
            {
            eval("form_basket.toplam_colon_"+y).value = filterNum(eval("form_basket.toplam_colon_"+y).value);
            }
    }

function toplam_al(satir_id,kolon_adi,kolon_no)
{
        gelen_satir_toplam = eval("form_basket.toplam_" + satir_id + "_" + kolon_adi).value;
        gelen_satir_toplam = filterNum(gelen_satir_toplam);
        gelen_input = eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no + ".value");
        gelen_input = filterNum(gelen_input);
        gelen_kolon_toplam = eval("form_basket.toplam_colon_" + kolon_no).value;
        gelen_kolon_toplam = filterNum(gelen_kolon_toplam);
        son_toplam = form_basket.son_toplam.value;
        son_toplam = filterNum(son_toplam);
        
        
        son_toplam = (son_toplam + gelen_input) - son_deger;
        gelen_kolon_toplam = (gelen_kolon_toplam + gelen_input) - son_deger;
        gelen_satir_toplam = (gelen_satir_toplam + gelen_input) - son_deger;
        
        gelen_input = commaSplit(gelen_input,0);
        gelen_satir_toplam = commaSplit(gelen_satir_toplam,0);
        gelen_kolon_toplam = commaSplit(gelen_kolon_toplam,0);
        son_toplam = commaSplit(son_toplam,0);
        
        eval("form_basket.toplam_" + satir_id + "_" + kolon_adi).value = gelen_satir_toplam;
        eval("form_basket.toplam_colon_" + kolon_no).value = gelen_kolon_toplam;
        eval("form_basket.team_" + satir_id + "_" + kolon_adi + "_" + kolon_no).value = gelen_input;
        form_basket.son_toplam.value = son_toplam;
}
</script>
    