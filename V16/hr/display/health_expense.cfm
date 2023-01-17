<cf_xml_page_edit fuseact="hr.health_expense_approve">
<cfif (not isDefined("x_rnd_nmbr")) or (isDefined("x_rnd_nmbr") and not len(x_rnd_nmbr))>
    <cfset x_rnd_nmbr = 2>
</cfif>
<cfset components = createObject('component','V16.hr.cfc.health_expense')>
<cfset money_components = createObject('component','V16.hr.cfc.assurance_type')>
<cfparam  name="attributes.expense_id" default = "#attributes.health_id#">
<cfif isdefined("attributes.health_id") and len(attributes.health_id)>
    <cfset HealthExpense= createObject("component","V16.myhome.cfc.health_expense") />
    <cfset get_health_expense_item_plans = HealthExpense.GET_EXPENSE(health_id : attributes.health_id) />
<cfelse>
    <cfset get_health_expense_item_plans = components.GET_HEALTH_EXPENSE_ITEM_PLANS(expense_id : attributes.expense_id)>
</cfif>
<cfset get_health_expense = components.GET_HEALTH_EXPENSE(expense_id : attributes.expense_id,type : 1 , health_id: attributes.health_id)><!--- Tedavi İşlemleri ---->
<cfset get_health_expense_drug = components.GET_HEALTH_EXPENSE(expense_id : attributes.expense_id,type : 2, health_id: attributes.health_id)><!--- İlaç ve Malzemeler ---->
<cfset get_money = money_components.GET_MONEY()>
<cfset get_assurance_limb = money_components.GET_HEALTH_ASSURANCE_TYPE_LIMB(assurance_id :len(get_health_expense_item_plans.assurance_id) ?  get_health_expense_item_plans.assurance_id : 0)>
<cfset get_health_expense_limb_ids = components.GET_HEALTH_EXPENSE_LIMB(health_id : attributes.health_id)>
<cfset savedLimbIDList = valueList(get_health_expense_limb_ids.LIMB_ID)>

<!--- Teminat Kullanımı --->
<cfif isdefined("attributes.assurance_id") and len(attributes.assurance_id)>
    <cfsavecontent variable="assurance_title"><cf_get_lang dictionary_id="60025.Teminat Kullanımı"></cfsavecontent>
<cfelse>
    <cfsavecontent variable="assurance_title">Teminat Kullanımlarını görüntüleyebilmek için Teminat Tipi seçmelisiniz!</cfsavecontent>
</cfif>
<cf_seperator id="use_of_assurance" header="#assurance_title#" is_closed="1">
<div id="use_of_assurance">
    <cfif isdefined("attributes.assurance_id") and len(attributes.assurance_id)>
        <cfinclude template="../../hr/display/list_use_of_assurance.cfm">
    </cfif>
</div>
<!--- Tedavi ilaç ve uzuv ekleme güncelleme --->
<cfsavecontent variable="limbs_drugs_title"><cf_get_lang dictionary_id="60229.Tedavi ilaç ve uzuvlar"></cfsavecontent>
<cf_seperator id="limbs_and_drugs" header="#limbs_drugs_title#" is_closed="1">
<div id="limbs_and_drugs">
    <cfoutput>
        <div class="row form-inline">
            <div class="form-group">
                <label class = "bold"><cf_get_lang dictionary_id = "56031.Hasta"> :</label>
                <label>#get_emp_info(get_health_expense_item_plans.emp_id,0,0)# </label>
            </div>
            <div class="form-group">
                <label class = "bold"> <cf_get_lang dictionary_id = "57880.Belge No"> :</label>
                <label>#get_health_expense_item_plans.PAPER_NO# </label>
            </div>
            <div class="form-group">
                <label class = "bold"> <cf_get_lang dictionary_id = "58923.Belge Tutarı"> :</label>
                <label>#TLFormat(get_health_expense_item_plans.net_total_amount,x_rnd_nmbr)#</label>
            </div>
            <div class="form-group">
                <label class="bold"><cf_get_lang dictionary_id="57771.Detay"><cf_get_lang dictionary_id="57492.Toplam"> :</label>
                <label id="detail_total" name="detail_total">-</label>
            </div>
            <div class="form-group">
                <label id="detail_total_alert" style="display:none;color:red;width:300px;"><cf_get_lang dictionary_id="36235.Belge tutarı fazla olamaz."></label>
            </div>
        </div>
    </cfoutput>
    <div class="row">
        <div class="col col-9">
            <cfsavecontent  variable="title_1"><cf_get_lang dictionary_id = "35362.Tedavi İşlemler"></cfsavecontent>
            <cfset health_expense_count = 0>
            <cfset health_expense_drug_count = 0>
            <cf_grid_list margin="1">
                <thead>
                    <tr><td colspan="11"><b><cfoutput>#title_1#</cfoutput></b></td></tr>
                </thead>
                <thead>
                    <th style="text-align:center;width:25px;"><a href="javascript://" onClick="add_row_treatment(<cfif isdefined("attributes.health_id") and len(attributes.health_id)><cfoutput>'#attributes.health_id#'</cfoutput><cfelse><cfoutput>#attributes.expense_id#</cfoutput> </cfif>)"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a></th>
                    <th><cf_get_lang dictionary_id = "56623.Tedavi"></th>
                    <th><cf_get_lang dictionary_id = "57629.Açıklama"></th>
                    <th>Uzuv</th>
                    <th><cf_get_lang dictionary_id="33087.Liste Fiyatı"></th>
                    <th><cf_get_lang dictionary_id="32526.Alış Fiyatı"></th>
                    <th><cf_get_lang dictionary_id="57641.İskonto">%</th>
                    <th><cf_get_lang dictionary_id = "58082.Adet"></th>
                    <th><cf_get_lang dictionary_id = "57638.Birim Fiyat"></th>
                    <th style="width:120px !important;"><cf_get_lang dictionary_id = "57673.Tutar"></th>
                    <th><cf_get_lang dictionary_id = "58864.Para Br"></th>
                </thead>
                <tbody id="add_row_treatment_<cfif isdefined("attributes.health_id") and len(attributes.health_id)><cfoutput>#attributes.health_id#</cfoutput><cfelse><cfoutput>#attributes.expense_id#</cfoutput></cfif>">
                    <cfif get_health_expense.recordcount>
                        <cfset health_expense_count = get_health_expense.recordcount>
                        <cfoutput query = "get_health_expense">
                            <cfset money_type = money>
                            <tr id = "health_expense_#currentrow#" name = "health_expense_#currentrow#">
                                <td nowrap style="text-align:center;">
                                    <a style="cursor:pointer" onclick="del_expense_row('#currentrow#',#health_expense_id#,1);" ><img  src="images/delete_list.gif" border="0"></a>
                                </td>
                                <td nowrap>
                                    <input type="hidden" name="complaint_id_#currentrow#" id="complaint_id_#currentrow#" value="#COMPLAINT_ID#">
                                    <input type="text" class="boxtext" name="complaint_#currentrow#" id="complaint_#currentrow#" value="#complaint#" onfocus="AutoComplete_Create('complaint_#currentrow#','COMPLAINT','COMPLAINT','GetComplaint','<cfif len(get_health_expense_item_plans.assurance_id)>#get_health_expense_item_plans.assurance_id#</cfif>','COMPLAINT_ID,COMPLAINT','complaint_id_#currentrow#,complaint_#currentrow#');">
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_complaints&event=popUp&field_id=complaint_id_#currentrow#' +'&field_name=complaint_#currentrow#&field_price=complaint_list_price_#currentrow#&x_rnd_nmbr=#x_rnd_nmbr#<cfif len(get_health_expense_item_plans.assurance_id)>&assurance_id=#get_health_expense_item_plans.assurance_id#</cfif>','list')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                                </td>
                                <td nowrap>
                                    <input type = "text" id = "health_expense_code_#currentrow#" name = "health_expense_code_#currentrow#" value = "#HEALTH_EXPENSE_CODE#" class="boxtext">
                                </td>
                                <td nowrap>
                                    <select name="complaint_limb_#currentrow#" id="complaint_limb_#currentrow#" class="boxtext">
                                        <option value="">Uzuv Seçiniz</option>
                                        <cfloop query="get_assurance_limb">
                                            <option value="#LIMB_ID#" <cfif LIMB_ID eq get_health_expense.HEALTH_EXPENSE_LIMB>selected</cfif>>#LIMB_NAME#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td nowrap>
                                    <input style="width:120px;" type="text" id="complaint_list_price_#currentrow#" name="complaint_list_price_#currentrow#" class="box" value="#TLFormat(LIST_PRICE,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="formatInputs(this);calcTreatmentPrice(#currentrow#);">
                                </td>
                                <td nowrap>
                                    <input style="width:120px;" type="text" id="complaint_purchase_price_#currentrow#" name="complaint_purchase_price_#currentrow#" class="box" value="#TLFormat(PURCHASE_PRICE,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="formatInputs(this);calcTreatmentPrice(#currentrow#);">
                                </td>
                                <td nowrap>
                                    <input style="width:75px;" type="text" id="complaint_discount_#currentrow#" name="complaint_discount_#currentrow#" class="box" value="#TLFormat(DISCOUNT_RATE,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="formatInputs(this);calcTreatmentPrice(#currentrow#);">
                                </td>
                                <td nowrap>
                                    <input style="width:50px;" type = "text" id = "health_expense_amount_#currentrow#" name = "health_expense_amount_#currentrow#" class="box" value = "#TLFormat(HEALTH_EXPENSE_AMOUNT,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange ="tutar_hesapla(#currentrow#,1)">
                                </td>
                                <td nowrap>
                                    <input style="width:120px;" type = "text" id = "health_expense_price_#currentrow#" name = "health_expense_price_#currentrow#"  class="box" value = "#TLFormat(HEALTH_EXPENSE_PRICE,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#)); " onchange ="tutar_hesapla(#currentrow#,2)">
                                </td>
                                <td nowrap>
                                    <input style="width:120px;" type = "text" id = "health_expense_total_#currentrow#" name = "health_expense_total_#currentrow#"  class="box" value = "#TLFormat(HEALTH_EXPENSE_TOTAL,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange ="tutar_hesapla(#currentrow#,3)">
                                </td>
                                <td nowrap>
                                    <select disabled name="money_#currentrow#" id = "money_#currentrow#" style="width:57px;" class="boxtext">
                                        <cfloop query="get_money">
                                            <option value="#money#" <cfif money eq money_type>selected</cfif>>#money#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="9">
                        <b><cf_get_lang dictionary_id = "57492.Toplam"></b>
                        </td>
                        <td style="width:120px;" nowrap> <input style="width:120px;" type = "text" id = "total_treatment_<cfoutput>#attributes.expense_id#</cfoutput>" name = "total_treatment_<cfoutput>#attributes.expense_id#</cfoutput>"  class="box" value = "" readonly></td>
                        <td></td>
                    </tr>
                </tfoot>
            </cf_grid_list>
            <cfsavecontent  variable="title_2"><cf_get_lang dictionary_id = "35919.İlaç ve malzemeler"></cfsavecontent>
            <cf_grid_list margin="1">
                <thead>
                    <tr><td colspan="11"><b><cfoutput>#title_2#</cfoutput></b></td></tr>
                </thead>
                <thead>
                    <th style="text-align:center;width:25px;"><a href="javascript://" onClick="add_row_drug(<cfif isdefined("attributes.health_id") and len(attributes.health_id)><cfoutput>'#attributes.health_id#'</cfoutput><cfelse><cfoutput>#attributes.expense_id#</cfoutput></cfif>)"><i class="fa fa-plus" title="<cf_get_lang dictionary_id ='44630.Ekle'>"></i></a></th>
                    <th><cf_get_lang dictionary_id = "55884.İlaç">-<cf_get_lang dictionary_id = "32045.Malzeme"></th>
                    <th><cf_get_lang dictionary_id = "57629.Açıklama"></th>
                    <th>Uzuv</th>
                    <th><cf_get_lang dictionary_id="33087.Liste Fiyatı"></th>
                    <th><cf_get_lang dictionary_id="32526.Alış Fiyatı"></th>
                    <th><cf_get_lang dictionary_id="57641.İskonto">%</th>
                    <th><cf_get_lang dictionary_id = "58082.Adet"></th>
                    <th><cf_get_lang dictionary_id = "57638.Birim Fiyat"></th>
                    <th style="width:120px !important;"><cf_get_lang dictionary_id = "57673.Tutar"></th>
                    <th><cf_get_lang dictionary_id = "58864.Para Br"></th>
                </thead>
                <tbody id="add_row_drug_<cfif isdefined("attributes.health_id") and len(attributes.health_id)><cfoutput>#attributes.health_id#</cfoutput><cfelse><cfoutput>#attributes.expense_id#</cfoutput></cfif>">
                    <cfif get_health_expense_drug.recordcount>
                        <cfset health_expense_drug_count = get_health_expense_drug.recordcount>
                        <cfoutput query = "get_health_expense_drug">
                            <cfset money_type = money>
                            <tr id = "health_expense_drug_#currentrow#" name = "health_expense_drug_#currentrow#">
                                <td nowrap style="text-align:center;">
                                    <a style="cursor:pointer" onclick="del_expense_row('#currentrow#',#health_expense_id#,2);" ><img  src="images/delete_list.gif" border="0"></a>
                                </td>
                                <td nowrap>
                                    <input type="hidden" name="drug_id_#currentrow#" id="drug_id_#currentrow#" value="#DRUG_ID#">
                                    <input type="text" class="boxtext" name="drug_#currentrow#" id="drug_#currentrow#" value="#DRUG_MEDICINE#" >
                                    <a href="javascript://" onclick="windowopen('#request.self#?fuseaction=objects.popup_list_decision_medicines&medicine_id=1&field_name=drug_#currentrow#&field_id=drug_id_#currentrow#<cfif len(get_health_expense_item_plans.assurance_id)>&assurance_id=#get_health_expense_item_plans.assurance_id#</cfif>','list')"><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>
                                </td>
                                <td nowrap>
                                    <input type = "text" id = "health_expense_drug_code_#currentrow#" name = "health_expense_drug_code_#currentrow#" value = "#HEALTH_EXPENSE_CODE#" class="boxtext">
                                </td>
                                <td nowrap>
                                    <select name="drug_limb_#currentrow#" id="drug_limb_#currentrow#" class="boxtext">
                                        <option value="">Uzuv Seçiniz</option>
                                        <cfloop query="get_assurance_limb">
                                            <option value="#LIMB_ID#" <cfif LIMB_ID eq get_health_expense_drug.HEALTH_EXPENSE_LIMB>selected</cfif>>#LIMB_NAME#</option>
                                        </cfloop>
                                    </select>
                                </td>
                                <td nowrap>
                                    <input style="width:120px;" type="text" id="drug_list_price_#currentrow#" name="drug_list_price_#currentrow#" class="box" value="#TLFormat(LIST_PRICE,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="formatInputs(this);calcMedicationPrice(#currentrow#);">
                                </td>
                                <td nowrap>
                                    <input style="width:120px;" type="text" id="drug_purchase_price_#currentrow#" name="drug_purchase_price_#currentrow#" class="box" value="#TLFormat(PURCHASE_PRICE,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="formatInputs(this);calcMedicationPrice(#currentrow#);">
                                </td>
                                <td nowrap>
                                    <input style="width:75px;" type="text" id="drug_discount_#currentrow#" name="drug_discount_#currentrow#" class="box" value="#TLFormat(DISCOUNT_RATE,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange="formatInputs(this);calcMedicationPrice(#currentrow#);">
                                </td>
                                <td nowrap>
                                    <input style="width:50px;" type = "text" id = "health_expense_drug_amount_#currentrow#" name = "health_expense_drug_amount_#currentrow#" class="box" value = "#TLFormat(HEALTH_EXPENSE_AMOUNT,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange ="tutar_hesapla_drug(#currentrow#,1)">
                                </td>
                                <td nowrap>
                                    <input style="width:120px;" type = "text" id = "health_expense_drug_price_#currentrow#" name = "health_expense_drug_price_#currentrow#"  class="box" value = "#TLFormat(HEALTH_EXPENSE_PRICE,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#)); " onchange ="tutar_hesapla_drug(#currentrow#,2)">
                                </td>
                                <td nowrap>
                                    <input style="width:120px;" type = "text" id = "health_expense_drug_total_#currentrow#" name = "health_expense_drug_total_#currentrow#"  class="box" value = "#TLFormat(HEALTH_EXPENSE_TOTAL,x_rnd_nmbr)#" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#));" onchange ="tutar_hesapla_drug(#currentrow#,3)">
                                </td>
                                <td nowrap>
                                    <select disabled name="money_drug_#currentrow#" id = "money_drug_#currentrow#" style="width:57px;" class="boxtext">
                                        <cfloop query="get_money">
                                            <option value="#money#" <cfif money eq money_type>selected</cfif>>#money#</option>
                                        </cfloop>
                                    </select>
                                </td>
                            </tr>
                        </cfoutput>
                    </cfif>
                </tbody>
                <tfoot>
                    <tr>
                        <td colspan="9">
                        <b><cf_get_lang dictionary_id = "57492.Toplam"></b>
                        </td>
                        <td> <input style="width:120px;" type = "text" id = "total_treatment_drug_<cfoutput>#attributes.expense_id#</cfoutput>" name = "total_treatment_drug_<cfoutput>#attributes.expense_id#</cfoutput>"  class="box" value = "" readonly></td>
                        <td></td>
                    </tr>
                </tfoot>
            </cf_grid_list>
            <cf_grid_list margin="1">
                <thead>
                    <tr><td colspan="6"><b><cf_get_lang dictionary_id="59566.Uzuvlar"></b></td></tr>
                </thead>
                <thead>
                    <tr>
                        <th style="text-align:left;"><cf_get_lang dictionary_id="59566.Uzuvlar"></th>
                        <th style="text-align:left;width:75px;"><cf_get_lang dictionary_id="58909.MAX"></th>
                        <th style="text-align:left;width:125px;"><cf_get_lang dictionary_id="59996.Ödeme Limiti"></th>
                        <th style="width:25px;">%</th>
                        <th style="text-align:left;"><cf_get_lang dictionary_id="60682.Ölçüm-Derece"></th>
                        <th style="text-align:center;"><input type="checkbox" name="checkAll" id="checkAll"/></th>
                    </tr>
                </thead>
                <tbody>
                    <cfif get_assurance_limb.recordcount>
                        <cfoutput query="get_assurance_limb">
                            <cfif listFind(savedLimbIDList,limb_id)>
                                <cfset get_limbs_measurement = components.GET_LIMBS_MEASUREMENT(health_id : attributes.health_id, limb_id:limb_id)>
                            </cfif>
                            <tr>
                                <td>&nbsp;&nbsp;#LIMB_NAME#</td>
                                <td>&nbsp;&nbsp;#MAX#</td>
                                <td style="text-align:right;">#TLFormat(MONEY_LIMIT,x_rnd_nmbr)#</td>
                                <td style="width:25px;">&nbsp;&nbsp;#PAYMENT_RATE#</td>
                                <td nowrap>
                                    <input style="width:120px;text-align:left !important;" type = "text" id = "measurement_#currentrow#" name = "measurement_#currentrow#" class="box" value="<cfif listFind(savedLimbIDList,limb_id) and isdefined("get_limbs_measurement") and len(get_limbs_measurement.LIMB_MEASUREMENT)>#TLFormat(get_limbs_measurement.LIMB_MEASUREMENT,x_rnd_nmbr)#</cfif>" onKeyup="return(FormatCurrency(this,event,#x_rnd_nmbr#)); " onchange ="formatInputs(this)">
                                </td>
                                <td style="text-align:center;"><input class="checkControl" type="checkbox" name="chcProcess" id="chcProcess" row_id="#currentrow#" value="#limb_id#" <cfif listFind(savedLimbIDList,limb_id)>checked</cfif>/></td>
                            </tr>
                        </cfoutput>
                    <cfelse>
                        <tr>
                            <td colspan="6">&nbsp;&nbsp;<cf_get_lang dictionary_id ="57484. kayıt yok">!</td>
                        </tr>
                    </cfif>
                </tbody>
            </cf_grid_list>
        </div>
    </div>
    <div class="row formContentFooter" type="row">
        <div class="col col-12 col-xs-12 text-right" style="vertical-align:middle;">
            <!---<input type="button" id="saveButton" name="saveButton" onclick="addFunc()" style="float:right;" value="<cf_get_lang dictionary_id="57461.Kaydet">"/>--->
            <cf_workcube_buttons add_function='addFunc()'>
            <label id="save_info" name="save_info" style="display:none;float:right;"></label>
        </div>
    </div>
</div>
<script>
    var x_rnd_nmbr = <cfoutput>#x_rnd_nmbr#</cfoutput>;

    $('input[name=checkAll]').click(function(){
        if(this.checked){
            $('.checkControl').each(function(){
                $(this).prop("checked", true);
            });
        }
        else{
            $('.checkControl').each(function(){
                $(this).prop("checked", false);
            });
        }
    });
    health_expense_count = '<cfoutput>#health_expense_count#</cfoutput>';
    health_expense_drug_count = '<cfoutput>#health_expense_drug_count#</cfoutput>';
    paper_amount = '<cfoutput>#get_health_expense_item_plans.net_total_amount#</cfoutput>';
    total_calculate();
    function add_row_treatment(gelen_id) //Tedvi tipi satır ekleme
    {
        var newRow;
        health_expense_count++;
        newRow = document.getElementById("add_row_treatment_"+gelen_id).insertRow(document.getElementById("add_row_treatment_"+gelen_id).rows.length);	
        
        newRow.setAttribute("name","health_expense_" + health_expense_count);
        newRow.setAttribute("id","health_expense_" + health_expense_count);

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a style="cursor:pointer" class="boxtext" onclick="del_expense_row(' + health_expense_count + ','+"-1"+',1);" ><img  src="images/delete_list.gif" border="0"></a>';
        newCell.setAttribute("style","text-align:center");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="hidden" name="complaint_id_'+health_expense_count+'" id="complaint_id_'+health_expense_count+'" value=""><input type="text" name="complaint_'+health_expense_count+'" id="complaint_'+health_expense_count+'" class="boxtext" ><a href="javascript://" onClick="open_comp('+ health_expense_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
        newCell.setAttribute("nowrap","nowrap");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="health_expense_code_' + health_expense_count +'" id="health_expense_code_' + health_expense_count +'" value="" class="boxtext" >';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="complaint_limb_'+ health_expense_count +'" id = "complaint_limb_'+ health_expense_count +'" class="boxtext"><option value="">Uzuv Seçiniz</option><cfoutput query="get_assurance_limb"><option value="#LIMB_ID#">#LIMB_NAME#</option></cfoutput></select>';
        newCell.setAttribute("nowrap","nowrap");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:120px;" type="text" name="complaint_list_price_' + health_expense_count +'" id="complaint_list_price_' + health_expense_count +'" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onchange="formatInputs(this);calcTreatmentPrice(' + health_expense_count + ')">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:120px;" type="text" name="complaint_purchase_price_' + health_expense_count +'" id="complaint_purchase_price_' + health_expense_count +'" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onchange ="formatInputs(this);calcTreatmentPrice(' + health_expense_count + ')">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:75px;" type="text" name="complaint_discount_' + health_expense_count +'" id="complaint_discount_' + health_expense_count +'" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(100,x_rnd_nmbr)#</cfoutput>" onchange ="formatInputs(this);calcTreatmentPrice(' + health_expense_count + ')">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:50px;" type="text" name="health_expense_amount_' + health_expense_count +'" id="health_expense_amount_' + health_expense_count +'"  class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(1,x_rnd_nmbr)#</cfoutput>" onchange ="tutar_hesapla('+health_expense_count+',1)">';
        
        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:120px;" type="text" name="health_expense_price_' + health_expense_count +'" id="health_expense_price_' + health_expense_count +'" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onchange ="tutar_hesapla('+health_expense_count+',2)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:120px;"  type="text"  class="box" name="health_expense_total_' + health_expense_count +'" id="health_expense_total_' + health_expense_count +'" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onchange ="tutar_hesapla('+health_expense_count+',3)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select disabled name="money_'+ health_expense_count +'" class="boxtext" id = "money_'+ health_expense_count +'" style="width:57px;"><cfoutput query="get_money"><option value="#money#" <cfif money eq get_health_expense_item_plans.money>selected</cfif>>#money#</option></cfoutput></select>';
    
        open_comp(health_expense_count);
    }
    function add_row_drug(gelen_id) // İlaç ve malzeme satır ekleme
    {
        var newRow;
        health_expense_drug_count++;
        newRow = document.getElementById("add_row_drug_"+gelen_id).insertRow(document.getElementById("add_row_drug_"+gelen_id).rows.length);	
        
        newRow.setAttribute("name","health_expense_drug_" + health_expense_drug_count);
        newRow.setAttribute("id","health_expense_drug_" + health_expense_drug_count);

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<a style="cursor:pointer" class="boxtext" onclick="del_expense_row(' + health_expense_drug_count + ','+"-1"+',2);" ><img  src="images/delete_list.gif" border="0"></a>';
        newCell.setAttribute("style","text-align:center");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="hidden" name="drug_id_'+health_expense_drug_count+'" id="drug_id_'+health_expense_drug_count+'" value=""><input type="text" name="drug_'+health_expense_drug_count+'" id="drug_'+health_expense_drug_count+'" class="boxtext" ><a href="javascript://" onClick="open_drug('+ health_expense_drug_count +');" ><img src="/images/plus_thin.gif"  align="absmiddle" border="0"></a>';
        newCell.setAttribute("nowrap","nowrap");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input type="text" name="health_expense_drug_code_' + health_expense_drug_count +'" id="health_expense_drug_code_' + health_expense_drug_count +'" value="" class="boxtext" >';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select name="drug_limb_'+ health_expense_drug_count +'" id = "drug_limb_'+ health_expense_drug_count +'" class="boxtext"><option value="">Uzuv Seçiniz</option><cfoutput query="get_assurance_limb"><option value="#LIMB_ID#">#LIMB_NAME#</option></cfoutput></select>';
        newCell.setAttribute("nowrap","nowrap");

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:120px;" type="text" name="drug_list_price_' + health_expense_drug_count +'" id="drug_list_price_' + health_expense_drug_count +'" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onchange="formatInputs(this);calcMedicationPrice(' + health_expense_drug_count + ');">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:120px;" type="text" name="drug_purchase_price_' + health_expense_drug_count +'" id="drug_purchase_price_' + health_expense_drug_count +'" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onchange ="formatInputs(this);calcMedicationPrice(' + health_expense_drug_count + ');">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:75px;" type="text" name="drug_discount_' + health_expense_drug_count +'" id="drug_discount_' + health_expense_drug_count +'" class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" value="<cfoutput>#TLFormat(100,x_rnd_nmbr)#</cfoutput>" onchange ="formatInputs(this);calcMedicationPrice(' + health_expense_drug_count + ');">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:50px;" type="text" name="health_expense_drug_amount_' + health_expense_drug_count +'" id="health_expense_drug_amount_' + health_expense_drug_count +'" value="<cfoutput>#TLFormat(1,x_rnd_nmbr)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" class="box" onchange ="tutar_hesapla_drug('+health_expense_drug_count+',1)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:120px;" type="text" name="health_expense_drug_price_' + health_expense_drug_count +'" id="health_expense_drug_price_' + health_expense_drug_count +'" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>"  class="box" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));"  onchange ="tutar_hesapla_drug('+health_expense_drug_count+',2)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<input style="width:120px;" type="text"  class="box" name="health_expense_drug_total_' + health_expense_drug_count +'" id="health_expense_drug_total_' + health_expense_drug_count +'" value="<cfoutput>#TLFormat(0,x_rnd_nmbr)#</cfoutput>" onkeyup="return(FormatCurrency(this,event,<cfoutput>#x_rnd_nmbr#</cfoutput>));" onchange ="tutar_hesapla_drug('+health_expense_drug_count+',3)">';

        newCell = newRow.insertCell(newRow.cells.length);
        newCell.innerHTML = '<select disabled name="money_drug_'+ health_expense_drug_count +'" class="boxtext" id = "money_drug_'+ health_expense_drug_count +'" style="width:57px;"><cfoutput query="get_money"><option value="#money#" <cfif money eq get_health_expense_item_plans.money>selected</cfif>>#money#</option></cfoutput></select>';
    
        open_drug(health_expense_drug_count);
    }
    function open_comp(row_id)//Tedavi tipi seçimi
    {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_complaints&event=popUp&field_id=complaint_id_'+row_id +'&field_name=complaint_'+row_id+'&field_price=complaint_list_price_'+row_id+'&x_rnd_nmbr='+x_rnd_nmbr+'<cfif len(get_health_expense_item_plans.assurance_id)>&assurance_id=<cfoutput>#get_health_expense_item_plans.assurance_id#</cfoutput></cfif>','list');
    }
    function open_limb_comp(no)
    {
        AutoComplete_Create('limb_name_comp_' + no +'','LIMB_ID','LIMB_NAME','Get_SetupLimb','','LIMB_ID,LIMB_NAME','limb_id_comp_' + no +',limb_name_comp_' + no +'');
    }
    function open_limb_drug(no)
    {
        AutoComplete_Create('limb_name_drug_' + no +'','LIMB_ID','LIMB_NAME','Get_SetupLimb','','LIMB_ID,LIMB_NAME','limb_id_drug_' + no +',limb_name_drug_' + no +'');
    }
    function open_drug(row_id)//İlaç seçimi
    {
        windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_decision_medicines&medicine_id=1&field_name=drug_'+row_id+'&field_id=drug_id_'+row_id+'<cfif len(get_health_expense_item_plans.assurance_id)>&assurance_id=<cfoutput>#get_health_expense_item_plans.assurance_id#</cfoutput></cfif>','list')
    }
    function save_row_health_expense(record_cnt,type)//Satır ekleme  type : 1 -> tedavi işlemleri type:2 -> ilaç ve malzeme
    {
        expense_id = '<cfoutput>#attributes.expense_id#</cfoutput>';
        <cfif isdefined("attributes.health_id") and len(attributes.health_id)>health_id =<cfoutput>'#attributes.health_id#';</cfoutput></cfif>
        if(record_cnt != 0){
            for(row_num=1;row_num<=record_cnt;row_num++){
                if(type == 1 && document.getElementById("health_expense_"+row_num) != null){
                    if((document.getElementById("complaint_id_" + row_num).value != '') && (document.getElementById("complaint_" + row_num).value != '')){
                        complaint_id = document.getElementById("complaint_id_" + row_num).value;
                        drug_id = '';
                        health_expense_amount = filterNum(document.getElementById("health_expense_amount_" + row_num).value,x_rnd_nmbr);
                        health_expense_price = filterNum(document.getElementById("health_expense_price_" + row_num).value,x_rnd_nmbr);
                        health_expense_total = filterNum(document.getElementById("health_expense_total_" + row_num).value,x_rnd_nmbr);
                        money = document.getElementById("money_" + row_num).value;
                        health_expense_code = document.getElementById("health_expense_code_" + row_num).value;
                        limb_id = filterNum(document.getElementById("complaint_limb_" + row_num).value,x_rnd_nmbr);
                        list_price = filterNum(document.getElementById("complaint_list_price_" + row_num).value,x_rnd_nmbr);
                        purchase_price = filterNum(document.getElementById("complaint_purchase_price_" + row_num).value,x_rnd_nmbr);
                        discount_rate = filterNum(document.getElementById("complaint_discount_" + row_num).value,x_rnd_nmbr);
                        if(!total_calculate(1)) return false;
                    }
                    else{
                        alert("<cf_get_lang dictionary_id='58194.Zorunlu alan'>: <cf_get_lang dictionary_id='41534.Tedavi'>");
                        document.getElementById("complaint_" + row_num).focus();
                        return false;
                    }
                    $.ajax({ 
                        type:'POST',  
                        url:'V16/hr/cfc/health_expense.cfc?method=ADD_HEALTH_EXPENSE',  
                        data: { 
                            complaint_id : complaint_id,
                            drug_id : drug_id,
                            health_expense_amount : health_expense_amount,
                            health_expense_price : health_expense_price,
                            health_expense_total : health_expense_total,
                            health_expense_code : health_expense_code,
                            money : money,
                            expense_id : expense_id,
                            health_id : health_id,
                            limb_id : limb_id,
                            list_price : list_price,
                            purchase_price : purchase_price,
                            discount_rate : discount_rate
                        }
                    });
                }
                else if(type == 2 && document.getElementById("health_expense_drug_"+row_num) != null){
                    if((document.getElementById("drug_id_" + row_num).value != '') && (document.getElementById("drug_" + row_num).value != '')){
                        complaint_id = '';
                        drug_id = document.getElementById("drug_id_" + row_num).value;
                        health_expense_amount = filterNum(document.getElementById("health_expense_drug_amount_" + row_num).value,x_rnd_nmbr);
                        health_expense_price = filterNum(document.getElementById("health_expense_drug_price_" + row_num).value,x_rnd_nmbr);
                        health_expense_total = filterNum(document.getElementById("health_expense_drug_total_" + row_num).value,x_rnd_nmbr);
                        money = document.getElementById("money_drug_" + row_num).value;
                        health_expense_code = document.getElementById("health_expense_drug_code_" + row_num).value;
                        limb_id = filterNum(document.getElementById("drug_limb_" + row_num).value,x_rnd_nmbr);
                        list_price = filterNum(document.getElementById("drug_list_price_" + row_num).value,x_rnd_nmbr);
                        purchase_price = filterNum(document.getElementById("drug_purchase_price_" + row_num).value,x_rnd_nmbr);
                        discount_rate = filterNum(document.getElementById("drug_discount_" + row_num).value,x_rnd_nmbr);
                        if(!total_calculate(2)) return false;
                    }
                    else{
                        alert("<cf_get_lang dictionary_id='58194.Zorunlu alan'>: <cf_get_lang dictionary_id='42099.İlaç'>");
                        document.getElementById("drug_" + row_num).focus();
                        return false;
                    }
                    $.ajax({ 
                        type:'POST',  
                        url:'V16/hr/cfc/health_expense.cfc?method=ADD_HEALTH_EXPENSE',  
                        data: { 
                            complaint_id : complaint_id,
                            drug_id : drug_id,
                            health_expense_amount : health_expense_amount,
                            health_expense_price : health_expense_price,
                            health_expense_total : health_expense_total,
                            health_expense_code : health_expense_code,
                            money : money,
                            expense_id : expense_id,
                            health_id : health_id,
                            limb_id : limb_id,
                            list_price : list_price,
                            purchase_price : purchase_price,
                            discount_rate : discount_rate
                        }
                    });
                }
            }
        }
        else{
            return false;
        }
        return true;
    }
    function tutar_hesapla(row_id,type){//Tedavi işlemleri Satırlardaki toplam tutarların hepsinin toplamı
        health_expense_amount = filterNum(document.getElementById("health_expense_amount_" + row_id).value,x_rnd_nmbr);
        health_expense_price = filterNum(document.getElementById("health_expense_price_" + row_id).value,x_rnd_nmbr);
        health_expense_total = filterNum(document.getElementById("health_expense_total_" + row_id).value,x_rnd_nmbr);
        if(type == 1)
            health_expense_total = health_expense_amount * health_expense_price;
        if(type == 2)
            health_expense_total = health_expense_amount * health_expense_price;
        if(type == 3)
            health_expense_price = health_expense_total / health_expense_amount;
        
        document.getElementById("health_expense_total_" + row_id).value = commaSplit(health_expense_total,x_rnd_nmbr);
        document.getElementById("health_expense_amount_" + row_id).value = commaSplit(health_expense_amount,x_rnd_nmbr);
        document.getElementById("health_expense_price_" + row_id).value = commaSplit(health_expense_price,x_rnd_nmbr);

        total_calculate(1);
    }
    function tutar_hesapla_drug(row_id,type){//İlaç ve malzeme Satırlardaki toplam tutarların hepsinin toplamı
        health_expense_drug_amount = filterNum(document.getElementById("health_expense_drug_amount_" + row_id).value,x_rnd_nmbr);
        health_expense_drug_price = filterNum(document.getElementById("health_expense_drug_price_" + row_id).value,x_rnd_nmbr);
        health_expense_drug_total = filterNum(document.getElementById("health_expense_drug_total_" + row_id).value,x_rnd_nmbr);
        if(type == 1)
            health_expense_drug_total = health_expense_drug_amount * health_expense_drug_price;
        if(type == 2)
            health_expense_drug_total = health_expense_drug_amount * health_expense_drug_price;
        if(type == 3)
            health_expense_drug_price = health_expense_drug_total / health_expense_drug_amount;
        
        document.getElementById("health_expense_drug_total_" + row_id).value = commaSplit(health_expense_drug_total,x_rnd_nmbr);
        document.getElementById("health_expense_drug_amount_" + row_id).value = commaSplit(health_expense_drug_amount,x_rnd_nmbr);
        document.getElementById("health_expense_drug_price_" + row_id).value = commaSplit(health_expense_drug_price,x_rnd_nmbr);

        total_calculate(2);
    }
    function total_calculate(type){//Satır toplamları hesaplama type :1 -> tedavi işlemleri type:2 -> İlaç ve malzeme
        row_total = 0;
        row_total_drug = 0; 
        
        if(type == 1)
        {
            for(i = 1 ; i <= health_expense_count ; i++)
            {
                if(document.getElementById("health_expense_total_" + i))
                    row_total = row_total + parseFloat(filterNum(document.getElementById("health_expense_total_" + i).value,x_rnd_nmbr));
            }
            document.getElementById("total_treatment_<cfoutput>#attributes.expense_id#</cfoutput>").value = commaSplit(row_total,x_rnd_nmbr);
        }
        else if(type == 2){
            for(i = 1 ; i <= health_expense_drug_count ; i++)
            {  
                if(document.getElementById("health_expense_drug_total_" + i))
                    row_total_drug = row_total_drug + parseFloat(filterNum(document.getElementById("health_expense_drug_total_" + i).value,x_rnd_nmbr));
            }
            document.getElementById("total_treatment_drug_<cfoutput>#attributes.expense_id#</cfoutput>").value = commaSplit(row_total_drug,x_rnd_nmbr);
        }else{//Giriş
            for(i = 1 ; i <= health_expense_count ; i++)
            {
                row_total = row_total + parseFloat(filterNum(document.getElementById("health_expense_total_" + i).value,x_rnd_nmbr));
            }
            document.getElementById("total_treatment_<cfoutput>#attributes.expense_id#</cfoutput>").value = commaSplit(row_total,x_rnd_nmbr);

            for(i = 1 ; i <= health_expense_drug_count ; i++)
            {
                row_total_drug = row_total_drug + parseFloat(filterNum(document.getElementById("health_expense_drug_total_" + i).value,x_rnd_nmbr));
            }
            document.getElementById("total_treatment_drug_<cfoutput>#attributes.expense_id#</cfoutput>").value = commaSplit(row_total_drug,x_rnd_nmbr);
        }
        total_drug = filterNum(document.getElementById("total_treatment_drug_<cfoutput>#attributes.expense_id#</cfoutput>").value,x_rnd_nmbr);
        total_treatment = filterNum(document.getElementById("total_treatment_<cfoutput>#attributes.expense_id#</cfoutput>").value,x_rnd_nmbr);
        total = parseFloat(total_drug) + parseFloat(total_treatment);
        $('#detail_total').text(commaSplit(total,x_rnd_nmbr));
        if(paper_amount >= total){
            $('#detail_total_alert').hide();
        }

        <cfif isdefined("attributes.health_id") and len(attributes.health_id)>
            <cfif not len(get_health_expense_item_plans.invoice_no)>
                if(type == 1 || type == 2){
                    <cfif x_kdv_inpterrupt eq 1>
                        $('#amount_kdv_1').val(commaSplit(total,x_rnd_nmbr));
                        getReverseTotalAmount();
                    <cfelse>
                        $('#lastTotal').val(commaSplit(total,x_rnd_nmbr));
                        treatment_rate = document.getElementById('treatment_rate');
                        if(treatment_rate.value != '' && parseFloat(filterNum(treatment_rate.value,x_rnd_nmbr)) != 0){
                            calculationTreatmentAmount(treatment_rate);
                        }
                    </cfif>
                }
            </cfif>
        </cfif>

        return true;
    }
    function del_expense_row(row_count,id,type){//satır silme type : -1 eklenen satır silme
        if(confirm ("<cf_get_lang dictionary_id = '36628.Satırı silmek istediğinize emin misiniz?'> ? "))
        {
            if(id != '-1')//Var olan satır silme
            {
                $.ajax({ 
                    type:'POST',  
                    url:'V16/hr/cfc/health_expense.cfc?method=DEL_HEALTH_EXPENSE',  
                    data: { 
                        id : id
                    },
                    success: function (returnData) {
                        if(type == 1){
                            $( "[id = 'health_expense_"+row_count+"']" ).each(function( index ) {
                                $( this ).remove();
                                total_calculate(1);
                            });
                        }else{
                            $( "[id = 'health_expense_drug_"+row_count+"']" ).each(function( index ) {
                                $( this ).remove();
                                total_calculate(2);
                            });
                        }
                        return false;
                    },
                    error: function () 
                    {
                        console.log('CODE:8 please, try again..');
                        return false; 
                    }
                }); 
            }else{//Eklenen satır silme
                if(type == 1){
                    $( "[id = 'health_expense_"+row_count+"']" ).each(function( index ) {
                        $( this ).remove();
                        total_calculate(1);
                    });
                }else{
                    $( "[id = 'health_expense_drug_"+row_count+"']" ).each(function( index ) {
                        $( this ).remove();
                        total_calculate(2);
                    });
                }
            }
        }else return false;
    }
    function del_health_expense_rows_by_type() {
        expense_id = '<cfoutput>#attributes.expense_id#</cfoutput>';
        <cfif isdefined("attributes.health_id") and len(attributes.health_id)>health_id =<cfoutput>'#attributes.health_id#';</cfoutput></cfif>
        $.ajax({ 
            type:'POST',  
            url:'V16/hr/cfc/health_expense.cfc?method=DEL_ALL_HEALTH_EXPENSE',  
            async:false,
            data: { 
                health_id : health_id,
                expense_id : expense_id
            }
        });
    }
    function addFunc(){
        $('#save_info').css("display","none");
        total = parseFloat(filterNum($('#detail_total').text(),x_rnd_nmbr));
        if(paper_amount < total){
            $('#detail_total_alert').show();
            alert("<cf_get_lang dictionary_id = '36235.İlaç ve Malzemelerin ve Tedavi İşlemlerinin Toplam tutarı Belge Tutarına eşit olmalıdır.'>");
            return false;
        }
        else{
            
            $('#detail_total_alert').hide();
            del_health_expense_rows_by_type();
            save_row_health_expense(health_expense_count,1);
            save_row_health_expense(health_expense_drug_count,2);
            save_health_expense_limb();
            $('#save_info').css("display","block");
            $('#save_info').text('<cf_get_lang dictionary_id="58890.Kaydedildi.">');
            refresh_box('is_medicine_complation_box','<cfoutput>#request.self#?fuseaction=health.expense_detail&health_id=#attributes.health_id#&emp_id=#attributes.emp_id#<cfif isdefined("attributes.assurance_id") and len(attributes.assurance_id)>&assurance_id=#attributes.assurance_id#</cfif></cfoutput>','0');
            loadLimits();
            <!---Tedavi İlaç ve Uzuvlara göre belge tutarını güncelleme--->
            kontrol();
            document.add_health_expense.action = '<cfoutput>#request.self#?fuseaction=hr.emptypopup_upd_health_expense_approve</cfoutput>';
            document.add_health_expense.submit();
            return false;
        }
    }
    function save_health_expense_limb() {
        $('.checkControl').each(function(){
            if(this.checked){
                $.ajax({ 
                    type:'POST',
                    url:'V16/hr/cfc/health_expense.cfc?method=SAVE_LIMB',
                    data: { 
                        health_id : <cfoutput>'#attributes.health_id#'</cfoutput>,
                        limb_id : this.value,
                        measurement: filterNum($("#measurement_" + this.getAttribute("row_id")).val(),x_rnd_nmbr)
                    }
                });
            }
        });
    }
    function formatInputs(obj) {
        obj.value = obj.value != '' ? commaSplit(parseFloat(filterNum(obj.value,x_rnd_nmbr)),x_rnd_nmbr) : commaSplit(0,x_rnd_nmbr);
    }
    function calcTreatmentPrice(row_num){
        list_price = parseFloat(filterNum($('#complaint_list_price_' + row_num).val(),x_rnd_nmbr));
        purchase_price = parseFloat(filterNum($('#complaint_purchase_price_' + row_num).val(),x_rnd_nmbr));
        purchase_price_temp = ( (list_price != 0 && list_price != '' && purchase_price != 0 && purchase_price != '') ? (list_price < purchase_price ? list_price : purchase_price) : (purchase_price != 0 && purchase_price != '' ? purchase_price : (list_price != 0 && list_price != '' ? list_price : 0)) );
        discount_rate = parseFloat(filterNum($('#complaint_discount_' + row_num).val(),x_rnd_nmbr));
        if(purchase_price_temp != "" && discount_rate != ""){
            expense_price = wrk_round((purchase_price_temp * discount_rate) / 100,x_rnd_nmbr);
            $('#health_expense_price_' + row_num).val(commaSplit(expense_price,x_rnd_nmbr));
            tutar_hesapla(row_num,2);
        }
    }
    function calcMedicationPrice(row_num){
        list_price = parseFloat(filterNum($('#drug_list_price_' + row_num).val(),x_rnd_nmbr));
        purchase_price = parseFloat(filterNum($('#drug_purchase_price_' + row_num).val(),x_rnd_nmbr));
        purchase_price_temp = ( (list_price != 0 && list_price != '' && purchase_price != 0 && purchase_price != '') ? (list_price < purchase_price ? list_price : purchase_price) : (purchase_price != 0 && purchase_price != '' ? purchase_price : (list_price != 0 && list_price != '' ? list_price : 0)) );
        discount_rate = parseFloat(filterNum($('#drug_discount_' + row_num).val(),x_rnd_nmbr));
        if(purchase_price_temp != "" && discount_rate != ""){
            expense_price = wrk_round((purchase_price_temp * discount_rate) / 100,x_rnd_nmbr);
            $('#health_expense_drug_price_' + row_num).val(commaSplit(expense_price,x_rnd_nmbr));
            tutar_hesapla_drug(row_num,2);
        }
    }
</script>