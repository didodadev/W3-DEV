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
<cfparam name="attributes.quote_year" default= "#session.ep.period_year#">
<cf_box title="#getLang('salesplan',23)#">
    <cfform name="form_basket" action="#request.self#?fuseaction=salesplan.emptypopup_add_sales_quote_sub_zone_based" method="post">
        <input type="hidden" name="sales_zone_id" id="sales_zone_id" value="<cfoutput>#attributes.sales_zone_id#</cfoutput>">
        <input type="hidden" name="branch_id" id="branch_id" value="<cfoutput>#attributes.branch_id#</cfoutput>">
        <input type="hidden" name="quote_year" id="quote_year" value="<cfoutput>#attributes.quote_year#</cfoutput>">
        <cf_box_elements vertical="1">						
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <div class="form-group"><cf_get_lang dictionary_id='57659.Satış Bölgesi'></div>
                <div class="form-group">
                    <cfinclude template="../query/get_sales_zone_name.cfm">
                    <input type="text"  name="sales_zone" id="sales_zone" value="<cfoutput>#GET_SALES_ZONE_NAME.sz_name#</cfoutput>" readonly>
                </div>
                <div class="form-group"><cf_get_lang dictionary_id='58472.Dönem'></div>
                <div class="form-group">								
                    <select name="quote_year_select" id="quote_year_select" , onchange="if (this.options[this.selectedIndex].value != 'null') { window.open(this.options[this.selectedIndex].value,'_self') }">
                        <cfoutput>
                            <cfloop from="#session.ep.period_year#" to="2020" index="i">
                                <option value="#request.self#?fuseaction=salesplan.popup_check_sales_quote_sub_zone_based&quote_year=#i#&branch_id=#attributes.branch_id#&sales_zone_id=#attributes.sales_zone_id#&sz_hierarchy=#GET_SALES_ZONE_NAME.SZ_HIERARCHY#" <cfif attributes.quote_year eq i>selected</cfif>>#i#</option>
                            </cfloop>
                        </cfoutput>
                    </select>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">
                <div class="form-group"><cf_get_lang no='12.İlgili Şube'></div>
                <div class="form-group">
                    <cfinclude template="../query/get_branch_name.cfm">
                    <input type="text" style="width:150px;" name="sales_zone" id="sales_zone" value="<cfoutput>#get_branch_name.branch_name#</cfoutput>" readonly>
                </div>
                <div class="form-group"><cf_get_lang_main no='217.Açıklama'></div>
                <div class="form-group" rowspan="3">
                    <textarea name="quote_detail" id="quote_detail" style="width:150px;height:45px;"></textarea>
                </div>
            </div>
            <div class="col col-4 col-md-4 col-sm-4 col-xs-12">								
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
        </cf_box_elements>
        <cfscript>
            son_toplam = 0;kolon_1 = 0;kolon_2 = 0;kolon_3 = 0;kolon_4 = 0;kolon_5 = 0;kolon_6 = 0;
            kolon_7 = 0;kolon_8 = 0;kolon_9 = 0;kolon_10 = 0;kolon_11 = 0;kolon_12 = 0;
        </cfscript>
        <cf_basket>
            <cf_grid_list>
                <cfquery name="get_quote_teams" datasource="#dsn#">
                    SELECT 
                        SZ_NAME, 
                        SZ_ID,
                        SZ_HIERARCHY,
                        RESPONSIBLE_BRANCH_ID,
                        B.BRANCH_NAME
                    FROM 
                        SALES_ZONES,
                        BRANCH B
                    WHERE 
                        SZ_ID <> #attributes.SALES_ZONE_ID# AND 
                        SZ_HIERARCHY+'.' LIKE '#attributes.sz_hierarchy#%' AND
                        B.BRANCH_ID = SALES_ZONES.RESPONSIBLE_BRANCH_ID
                </cfquery>
                <thead>
                    <tr>						 
                        <th width="75"><cf_get_lang dictionary_id='57489.Para Birimi'></th>
                        <th colspan="15">
                            <select name="money" id="money">
                                <cfoutput query="get_moneys">
                                    <option value="#MONEY#" <cfif session.ep.money is '#MONEY#'>selected</cfif>>#MONEY#</option>
                                </cfoutput>
                            </select>
                        </th>
                    </tr>
                    <tr>
                        <th><cf_get_lang dictionary_id='57453.Şube'></th>
                            <cfloop from="1" to="12" index="k">
                                <th align="center">
                                <cfoutput>#Listgetat(aylar,k)#</cfoutput>								  
                                </th>
                            </cfloop>
                        <th><cf_get_lang dictionary_id='58170.Satır Toplam'></th>
                    </tr> 
                </thead>
                <tbody>
                    <cfoutput query="get_quote_teams">
                        <cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
                            <input type="hidden" name="sz_ids" id="sz_ids" value="#get_quote_teams.SZ_ID#.#get_quote_teams.RESPONSIBLE_BRANCH_ID#"><!--- alt bölge ve şube id'leri birlikte tutuluyor ---> 
                            <tr >
                                <td>#SZ_NAME# / #BRANCH_NAME#</td>
                                    <cfloop from="1" to="12" index="k">
                                        <td>
                                            <cfinput passThrough = "onkeyup=""return(FormatCurrency(this,event));"" onBlur=""toplam_al(#sz_id#,#k#);""" type="text" name="team_#SZ_ID#_#k#" style="width:63px;" value="#tlformat(0)#" class="box">
                                        </td>
                                    </cfloop>
                                <td>
                                    <cfinput  type="text" name="toplam_#SZ_ID#" style="width:63px;" class="box" value="#tlformat(0)#">
                                </td>
                            </tr>
                        </cfif>
                    </cfoutput>
                    
                </tbody>
                <tfoot>
                    <tr>
                        <td align="right" style="text-align:right;"><cf_get_lang dictionary_id='53263.Toplamlar'></td>									
                        <cfloop from="1" to="12" index="m">
                            <td>
                                <input type="text" name="toplam_colon_<cfoutput>#m#</cfoutput>" id="toplam_colon_<cfoutput>#m#</cfoutput>" style="width:63px;" class="box" value="<cfoutput>#tlformat(evaluate("kolon_#m#"))#</cfoutput>" readonly>
                            </td>
                        </cfloop>
                        <td><input type="text" name="son_toplam" id="son_toplam" style="width:63px;" class="box" value="<cfoutput>#tlformat(son_toplam)#</cfoutput>" readonly></td>
                    </tr>
                </tfoot>
            </cf_grid_list>
        </cf_basket>
        
        <cf_box_footer>
            <cf_workcube_buttons is_upd='0' add_function='upd_form()'>
        </cf_box_footer>
    </cfform>
</cf_box>
<script type="text/javascript">
function upd_form()
{
    UnformatFields();
    <cfoutput query="get_quote_teams">
        <cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>
        for(var i=1; i<=12; i++)			
        { 
        if(eval("form_basket.team_#SZ_ID#_"+i).value == '')
        eval("form_basket.team_#SZ_ID#_"+i).value=0;
        }
    </cfif>
    </cfoutput>	
    return true;
}

function UnformatFields()
    {	
        <cfoutput query="get_quote_teams">
            <cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>

            for(var i=1; i<=12; i++)			
            { 
            eval("form_basket.team_#SZ_ID#_"+i).value = filterNum(eval("form_basket.team_#SZ_ID#_"+i).value);
            }
        </cfif>			
        </cfoutput>
        for(var y=1; y<=12; y++)			
            {
            eval("form_basket.toplam_colon_"+y).value = filterNum(eval("form_basket.toplam_colon_"+y).value);
            }
    }


function reformat()
{
    <cfoutput query="get_quote_teams">
            <cfif (listlen(ListCompare(replace(get_quote_teams.sz_hierarchy, '.', ',', 'all'),replace(attributes.sz_hierarchy, '.', ',', 'all')), ',') eq 1)>

            for(var i=1; i<=12; i++)			
            { 
            eval("form_basket.team_#SZ_ID#_"+i).value = commaSplit(eval("form_basket.team_#SZ_ID#_"+i).value);
            }
        </cfif>
    </cfoutput>
            for(var y=1; y<=12; y++)			
            {
            eval("form_basket.toplam_colon_"+y).value = commaSplit(eval("form_basket.toplam_colon_"+y).value);
            }
            
            form_basket.son_toplam.value = commaSplit(form_basket.son_toplam.value);
            
    return true;
}

function toplam_al(satir_id,kolon_adi)
{
    upd_form();
        <cfloop from="1" to="12" index="my_ay">
        <cfoutput>
            M#my_ay# = eval(eval("form_basket.team_" + satir_id + "_#my_ay#.value"));
        </cfoutput>
        </cfloop>	
        eval("form_basket.toplam_" + satir_id).value = (M1 + M2 + M3 + M4 + M5 + M6 + M7 + M8 + M9 + M10 + M11 + M12);
        eval("form_basket.toplam_" + satir_id).value = commaSplit(eval("form_basket.toplam_" + satir_id).value);
        
        
        toplam_k = 0;	
        <cfoutput query="get_quote_teams">
            K#sz_id# = eval(eval("form_basket.team_#sz_id#_" + kolon_adi + ".value"));
            toplam_k = toplam_k + K#sz_id#;
        </cfoutput>	
        eval("form_basket.toplam_colon_" + kolon_adi).value = toplam_k;
        
        
        son_toplam = 0;
        <cfloop from="1" to="12" index="ay">
        <cfoutput>
            C#ay# = eval(form_basket.toplam_colon_#ay#.value);
            son_toplam = son_toplam + C#ay#;
        </cfoutput>
        </cfloop>					
        form_basket.son_toplam.value = son_toplam;			
    return reformat();
}
</script>
        