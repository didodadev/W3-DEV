<cf_xml_page_edit fuseact="ehesap.form_upd_program_parameters">
<cfif fusebox.use_period eq true>
    <cfset dsn_ei = dsn2>
<cfelse>
    <cfset dsn_ei = dsn>
</cfif>
<cfquery name="get_program_parameters" datasource="#dsn#">
	SELECT 
        SPP.*,
        EI.EXPENSE_ITEM_ID,
        EI.EXPENSE_ITEM_NAME, 
        EIR.EXPENSE_ITEM_ID AS RELATIVE_EXPENSE_ITEM_ID,
        EIR.EXPENSE_ITEM_NAME AS RELATIVE_EXPENSE_ITEM_NAME, 
        SPI.ODKES_ID,
        SPI.COMMENT_PAY,
        SPI2.COMMENT_PAY AS COMMENT_PAY_RELATIVE,
        EC.EXPENSE,
        SPIK.COMMENT_PAY AS PAYMENT_INTERRUPTION_NAME,
        SPIK2.COMMENT_PAY AS LIMIT_INTERRUPTION_NAME
    FROM SETUP_PROGRAM_PARAMETERS SPP
        LEFT JOIN #dsn_ei#.EXPENSE_ITEMS EI ON SPP.EXPENSE_ITEM_ID=EI.EXPENSE_ITEM_ID
        LEFT JOIN #dsn_ei#.EXPENSE_ITEMS EIR ON SPP.RELATIVE_EXPENSE_ITEM_ID=EIR.EXPENSE_ITEM_ID
        LEFT JOIN SETUP_PAYMENT_INTERRUPTION SPI ON SPI.ODKES_ID = SPP.SALARYPARAM_PAY_ID
        LEFT JOIN SETUP_PAYMENT_INTERRUPTION SPI2 ON SPI2.ODKES_ID = SPP.SALARYPARAM_PAY_ID_RELATIVE
        LEFT JOIN SETUP_PAYMENT_INTERRUPTION SPIK ON SPIK.ODKES_ID = SPP.PAYMENT_INTERRUPTION_ID
        LEFT JOIN SETUP_PAYMENT_INTERRUPTION SPIK2 ON SPIK2.ODKES_ID = SPP.LIMIT_INTERRUPTION_ID
        LEFT JOIN #dsn_ei#.EXPENSE_CENTER EC ON EC.EXPENSE_ID=SPP.EXPENSE_CENTER_ID
    WHERE PARAMETER_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.parameter_id#">
</cfquery>
<cfquery name="get_ch_types" datasource="#dsn#">
	SELECT * FROM SETUP_ACC_TYPE ORDER BY ACC_TYPE_NAME
</cfquery>
<cfquery name="get_company" datasource="#dsn#">
	SELECT COMP_ID,NICK_NAME FROM OUR_COMPANY WHERE COMP_STATUS = 1 ORDER BY NICK_NAME
</cfquery>
<cfinclude template="../query/get_ssk_offices.cfm">
<cf_catalystHeader>
<cfform name="form_add" method="post" action="#request.self#?fuseaction=ehesap.emptypopup_upd_program_parameters">
<input type="hidden" name="parameter_id" id="parameter_id" value="<cfoutput>#attributes.parameter_id#</cfoutput>">
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cf_box_elements>
            <div class="col col-6 col-xs-12" type="column" sort="true" index="1">
                <cf_seperator header="#getLang('','Bordro Bilgileri',63710)#" id="id_tanim">
                    <div class="row" id="id_tanim">
                    <div class="form-group" id="item-parameter_name">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58233.Tan??m"></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" id="parameter_name" name="parameter_name" maxlength="100" value="#get_program_parameters.parameter_name#">
                        </div>
                    </div>
                    <div class="form-group" id="item-date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58690.Tarih Aral??????"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="text" id="startdate" name="startdate" readonly="yes" validate="#validate_style#" value="#dateformat(get_program_parameters.startdate,dateformat_style)#"> 
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="startdate"></span>
                                <span class="input-group-addon no-bg"></span>
                                <cfinput type="text" id="finishdate" name="finishdate" readonly="yes" validate="#validate_style#" value="#dateformat(get_program_parameters.finishdate,dateformat_style)#">
                                <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="finishdate"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-cast_style">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54180.Hesaplama T??r??"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="cast_style" name="cast_style">
                                <!---<option value="0" <cfif get_program_parameters.cast_style eq 0>selected</cfif>>2008 <cf_get_lang no="1104.??ncesi SGK"></option>--->
                                <option value="1" <cfif get_program_parameters.cast_style eq 1>selected</cfif>>2008 <cf_get_lang dictionary_id="54057.Sonras?? SGK"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-tax_account_style">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54112.Gelir Vergisi Devir Durumu"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="tax_account_style" name="tax_account_style">
                                <option value="0" <cfif get_program_parameters.TAX_ACCOUNT_STYLE eq 0>selected</cfif>><cf_get_lang dictionary_id="54061.Grup ????i Devir"></option>
                                <option value="1" <cfif get_program_parameters.TAX_ACCOUNT_STYLE eq 1>selected</cfif>><cf_get_lang dictionary_id="54062.??irket ????i Devir"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-date">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64246.Bordronun ??lk G??n??'> / <cf_get_lang dictionary_id='64247.Bordronun Son G??n??'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="col col-6 col-xs-12">
                                <select id="first_day_month" name="first_day_month">
                                    <cfloop index="index" from="1" to="31">
                                        <cfoutput>
                                            <option value="#index#" <cfif get_program_parameters.first_day_month eq index>selected</cfif>>#index#</option>
                                        </cfoutput>
                                    </cfloop>                                
                                </select>
                            </div>
                            <div class="col col-6 col-xs-12">
                                <select id="last_day_month" name="last_day_month">
                                    <option value="0" <cfif get_program_parameters.last_day_month eq 0>selected</cfif>><cf_get_lang dictionary_id='64248.Ay??n Son G??n??'></option>

                                    <cfloop index="index" from="1" to="31">
                                        <cfoutput>
                                            <option value="#index#" <cfif get_program_parameters.last_day_month eq index>selected</cfif>>#index#</option>
                                        </cfoutput>
                                    </cfloop>                                
                                </select>
                            </div>
                        </div>
                    </div>
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="58650.Puantaj"></cfsavecontent>
                    <cf_seperator header="#message#" id="PUANTAJ">
                    <div class="row" id="PUANTAJ">
                        <div class="form-group" id="item-stamp_tax_binde">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54128.Damga Vergisi Bindesi"></label>
                            <div class="col col-8 col-xs-12">
                                <cfinput name="stamp_tax_binde" type="text" id="stamp_tax_binde" value="#TLFormat(get_program_parameters.stamp_tax_binde)#" message="Damga Vergisi Bindesi !" required="yes" onKeyUp="return(FormatCurrency(this,event));">
                            </div>
                        </div>
                        <div class="form-group" id="item-employment_start_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53983.Yeni ??stihdam Yasas??ndan"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="text" id="employment_start_date" name="employment_start_date" value="<cfoutput><cfif len(get_program_parameters.employment_start_date)>#dateformat(get_program_parameters.employment_start_date,dateformat_style)#</cfif></cfoutput>" readonly>
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="employment_start_date"></span>
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="54133.It??bari ??le"></span>
                                    <input type="text" name="employment_continue_time" id="employment_continue_time" onKeyUp="isNumber(this);" value="<cfoutput><cfif len(get_program_parameters.employment_continue_time)>#get_program_parameters.employment_continue_time#</cfif></cfoutput>">
                                    <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="58455.Y??l"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-is_agi_pay">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54134.AG?? ??ubelere Payla??t??r??ls??n m??"></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_agi_pay" name="is_agi_pay" value="1" <cfif get_program_parameters.is_agi_pay eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_add_virtual_all">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54145.Sanal Puantaja T??m Hesaplar Eklensin mi"></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_add_virtual_all" name="is_add_virtual_all" value="1" <cfif get_program_parameters.is_add_virtual_all eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_sgk_kontrol">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59508. ????verene Yans??t??ls??n?"></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_sgk_kontrol" name="is_sgk_kontrol" value="1" <cfif get_program_parameters.is_sgk_kontrol eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_add_5746_control">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59507. ????verene Yans??t??ls??n?"></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_add_5746_control" name="is_add_5746_control" value="1" <cfif get_program_parameters.is_add_5746_control eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_add_5746_control">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59505. fazla mesai dahil edilsin mi?"></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_add_5746_overtime" name="is_add_5746_overtime" value="1" <cfif get_program_parameters.is_5746_overtime eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_add_5746_control">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58458. haftal??k"><cf_get_lang dictionary_id="37319.max"><cf_get_lang dictionary_id="47539.Cal????ma Saati"></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_5746_working_hours" name="is_5746_working_hours" value="1"  <cfif get_program_parameters.is_5746_working_hours eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_add_4691_control">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59509.????verene Yans??t??ls??n"></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_add_4691_control" name="is_add_4691_control" value="1" <cfif get_program_parameters.is_add_4691_control eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_5746_salaryparam_pay">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59643.Ek ??denek Dahil Edilsin mi?"></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_5746_salaryparam_pay" name="is_5746_salaryparam_pay" value="1" <cfif get_program_parameters.is_5746_salaryparam_pay eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_5746_stampduty">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62761.5746 Damga Vergisi ??al????ana Yans??t??ls??n m???'></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_5746_stampduty" name="is_5746_stampduty" value="1" <cfif get_program_parameters.is_5746_stampduty eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_5746_with_agi">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='63057.5746 Hesab??ndan AGI hari?? olsun mu?'></label>
                            <label class="col col-8 col-xs-12"><input type="checkbox" id="is_5746_with_agi" name="is_5746_with_agi" value="1" <cfif get_program_parameters.is_5746_with_agi eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet"></label>
                        </div>
                        <div class="form-group" id="item-is_use_minimum_wage">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='64733.Asgari ??cret ??ndiriminden Muaf'></label>
                            <label class="col col-8 col-xs-12">
                                <input type="checkbox" name="is_use_minimum_wage" id="is_use_minimum_wage" value="1"<cfif get_program_parameters.is_use_minimum_wage eq 1> checked</cfif>> <cf_get_lang dictionary_id="57495.Evet">
                            </label>
                        </div>
                    </div>
                </div>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="29832.????ten ????k????"></cfsavecontent>
                <cf_seperator header="#message#" id="isten_cikis">
                <div class="row" id="isten_cikis">
                    <div class="form-group" id="item-FINISH_DATE_COUNT_TYPE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="54147.????k???? G??n?? Hesaplama ??ekli"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="FINISH_DATE_COUNT_TYPE" name="FINISH_DATE_COUNT_TYPE">
                                <option value="0" <cfif get_program_parameters.FINISH_DATE_COUNT_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id="54167.G??n Hesab??"></option>
                                <option value="1" <cfif get_program_parameters.FINISH_DATE_COUNT_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="58455.Y??l"> - <cf_get_lang dictionary_id="58724.Ay"> - <cf_get_lang dictionary_id="54167.G??n Hesab??"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-GROSS_COUNT_TYPE">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59731.??zin Hesab??"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="GROSS_COUNT_TYPE" name="GROSS_COUNT_TYPE">
                                <option value="0" <cfif get_program_parameters.GROSS_COUNT_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id="59732.Br??tten Hesapla"></option>
                                <option value="1" <cfif get_program_parameters.GROSS_COUNT_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="59733.Netten Hesapla"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-is_sureli_is_akdi_off">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59734.S??reli ???? Akdi A????m??nda ??hbar Hesaplans??n m??">?</label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" name="is_sureli_is_akdi_off" id="is_sureli_is_akdi_off" value="1" <cfif get_program_parameters.is_sureli_is_akdi_off eq 1>checked</cfif>> <cf_get_lang dictionary_id="57495.Evet">
                        </label>
                    </div>
                </div>

                <cfsavecontent variable="message"><cf_get_lang dictionary_id="53975.??hbar"></cfsavecontent>
                <cf_seperator header="#message#" id="ihbar">
                <div class="row" id="ihbar">
                    <div class="form-group" id="item-DENUNCIATION_1">
                        <label class="col col-4 col-xs-12"><cfoutput>#message#</cfoutput> 1</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfsavecontent variable="ihbaralt"><cf_get_lang dictionary_id="59737.??hbar alt s??n??r !"></cfsavecontent>
                                <cfinput name="DENUNCIATION_1_LOW" type="text" id="DENUNCIATION_1_LOW" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_1_LOW#" validate="integer" message="#ihbaralt# 1!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59735.g??nden"></span>	
                                <cfsavecontent variable="ihbar??st"><cf_get_lang dictionary_id="59738.??hbar ??st s??n??r !"></cfsavecontent>
                                <cfinput name="DENUNCIATION_1_HIGH" type="text" id="DENUNCIATION_1_HIGH" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_1_HIGH#" validate="integer" message="#ihbar??st# 1!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59736.g??ne"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group x-12">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="53975.??hbar"></cfsavecontent>
                                <cfinput name="DENUNCIATION_1" type="text" id="DENUNCIATION_1" value="#get_program_parameters.DENUNCIATION_1#"  onKeyUp="return(FormatCurrency(this,event));" message="#message# 1!" required="yes">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="58457.g??nl??k"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-DENUNCIATION_2">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53975.??hbar">2</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput name="DENUNCIATION_2_LOW" type="text" id="DENUNCIATION_2_LOW" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_2_LOW#" validate="integer" message="#ihbaralt# 2!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59735.g??nden"></span>	
                                <cfinput name="DENUNCIATION_2_HIGH" type="text" id="DENUNCIATION_2_HIGH" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_2_HIGH#" validate="integer" message="#ihbar??st# 2!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59736.g??ne"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group x-12">
                                <cfinput name="DENUNCIATION_2" type="text" id="DENUNCIATION_2" value="#get_program_parameters.DENUNCIATION_2#"  onKeyUp="return(FormatCurrency(this,event));" message="#message# 2!" required="yes">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="58457.g??nl??k"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-DENUNCIATION_3">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53975.??hbar"> 3</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput name="DENUNCIATION_3_LOW" type="text" id="DENUNCIATION_3_LOW" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_3_LOW#" validate="integer" message="#ihbaralt# 3!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59735.g??nden"></span>	
                                <cfinput name="DENUNCIATION_3_HIGH" type="text" id="DENUNCIATION_3_HIGH" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_3_HIGH#" validate="integer" message="#ihbar??st# 3!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59736.g??ne"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group x-12">
                                <cfinput name="DENUNCIATION_3" type="text" id="DENUNCIATION_3" value="#get_program_parameters.DENUNCIATION_3#"  onKeyUp="return(FormatCurrency(this,event));" message="#message# 3!" required="yes">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="58457.g??nl??k"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-DENUNCIATION_4">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53975.??hbar"> 4</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput name="DENUNCIATION_4_LOW" type="text" id="DENUNCIATION_4_LOW" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_4_LOW#" validate="integer" message="#ihbaralt# 4!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59735.g??nden"></span>	
                                <cfinput name="DENUNCIATION_4_HIGH" type="text" id="DENUNCIATION_4_HIGH" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_4_HIGH#" validate="integer" message="#ihbar??st# 4!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59736.g??ne"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group x-12">
                                <cfinput name="DENUNCIATION_4" type="text" id="DENUNCIATION_4" value="#get_program_parameters.DENUNCIATION_4#"  onKeyUp="return(FormatCurrency(this,event));" message="#message# 4!" required="yes">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="58457.g??nl??k"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-DENUNCIATION_5">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53975.??hbar"> 5</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput name="DENUNCIATION_5_LOW" type="text" id="DENUNCIATION_5_LOW" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_5_LOW#" validate="integer" message="#ihbaralt# 5!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59735.g??nden"></span>	
                                <cfinput name="DENUNCIATION_5_HIGH" type="text" id="DENUNCIATION_5_HIGH" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_5_HIGH#" validate="integer" message="#ihbar??st# 5!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59736.g??ne"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group x-12">
                                <cfinput name="DENUNCIATION_5" type="text" id="DENUNCIATION_5" value="#get_program_parameters.DENUNCIATION_5#"  onKeyUp="return(FormatCurrency(this,event));" message="#message# 5!" required="yes">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="58457.g??nl??k"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-DENUNCIATION_6">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53975.??hbar"> 6</label>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group">
                                <cfinput name="DENUNCIATION_6_LOW" type="text" id="DENUNCIATION_6_LOW" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_6_LOW#" validate="integer" message="#ihbaralt# 6!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59735.g??nden"></span>	
                                <cfinput name="DENUNCIATION_6_HIGH" type="text" id="DENUNCIATION_6_HIGH" onKeyUp="isNumber(this);" value="#get_program_parameters.DENUNCIATION_6_HIGH#" validate="integer" message="#ihbar??st# 6!" required="yes" maxlength="5">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="59736.g??ne"></span>
                            </div>
                        </div>
                        <div class="col col-4 col-xs-12">
                            <div class="input-group x-12">
                                <cfinput name="DENUNCIATION_6" type="text" id="DENUNCIATION_6" value="#get_program_parameters.DENUNCIATION_6#"  onKeyUp="return(FormatCurrency(this,event));" message="#message# 6!" required="yes">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="58457.g??nl??k"></span>
                            </div>
                        </div>
                    </div>
                </div>
                
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57490.G??n"></cfsavecontent>
                <cf_seperator header="#message#" id="g??n">
                <div class="row" id="g??n">
                    <div class="form-group" id="item-FULL_DAY">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59739.SGK G??n Kabulu"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="FULL_DAY" name="FULL_DAY">
                                <option value="1" <cfif get_program_parameters.FULL_DAY eq 1>selected</cfif>><cf_get_lang dictionary_id="41865.Tam"></option>
                                <option value="0" <cfif get_program_parameters.FULL_DAY eq 0>selected</cfif>><cf_get_lang dictionary_id="59740.Tam De??il"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-SSK_31_DAYS">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53245.SGK Matrah??"> 31 <cf_get_lang dictionary_id="59735.G??nden"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="SSK_31_DAYS" name="SSK_31_DAYS">
                                <option value="0" <cfif get_program_parameters.SSK_31_DAYS eq 0>selected</cfif>><cf_get_lang dictionary_id="57496.Hay??r"></option>
                                <option value="1" <cfif get_program_parameters.SSK_31_DAYS eq 1>selected</cfif>><cf_get_lang dictionary_id="57495.Evet"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-ssk_days_work_days">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57593.??ubat"> (<cf_get_lang dictionary_id="53816.Toplam SGK G??n??"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="ssk_days_work_days" name="ssk_days_work_days">
                                <option value="1" <cfif get_program_parameters.ssk_days_work_days eq 1>selected</cfif>><cf_get_lang dictionary_id="57496.Hay??r"></option>
                                <option value="0" <cfif get_program_parameters.ssk_days_work_days eq 0>selected</cfif>><cf_get_lang dictionary_id="57495.Evet"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-unpaid_permission_todrop_thirty">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59741.??cretsiz ??zinlerde Otuz G??ne D??????r??ls??n"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="unpaid_permission_todrop_thirty" name="unpaid_permission_todrop_thirty">
                                <option value="0" <cfif get_program_parameters.UNPAID_PERMISSION_TODROP_THIRTY eq 0>selected</cfif>><cf_get_lang dictionary_id="57496.Hay??r"></option>
                                <option value="1" <cfif get_program_parameters.UNPAID_PERMISSION_TODROP_THIRTY eq 1>selected</cfif>><cf_get_lang dictionary_id="57495.Evet"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-offtime_count_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59742.Tam g??n olmayan izinler"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="offtime_count_type" name="offtime_count_type">
                                <option value="0" <cfif get_program_parameters.OFFTIME_COUNT_TYPE eq 0>selected</cfif>><cf_get_lang dictionary_id="59743.G??nden D????"></option>
                                <option value="1" <cfif get_program_parameters.OFFTIME_COUNT_TYPE eq 1>selected</cfif>><cf_get_lang dictionary_id="59744.Hakedi??ten D????"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-IS_NOT_SGK_WORK_DAYS_30">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59745.SGK l?? olmayanlarda 30 G??nden Hesapla"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="IS_NOT_SGK_WORK_DAYS_30" name="IS_NOT_SGK_WORK_DAYS_30">
                                <option value="0" <cfif get_program_parameters.IS_NOT_SGK_WORK_DAYS_30 eq 0>selected</cfif>><cf_get_lang dictionary_id="57496.Hay??r"></option>
                                <option value="1" <cfif get_program_parameters.IS_NOT_SGK_WORK_DAYS_30 eq 1>selected</cfif>><cf_get_lang dictionary_id="57495.Evet"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-HOURLY_EMPLOYEE_WORK_DAYS_30">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65244.??ubat Ay?? Saatlik ??al????an??n SGK Matrah?? 30 G??n'></label>
                        <div class="col col-8 col-xs-12">
                            <select id="HOURLY_EMPLOYEE_WORK_DAYS_30" name="HOURLY_EMPLOYEE_WORK_DAYS_30">
                                <option value="0" <cfif get_program_parameters.HOURLY_EMPLOYEE_WORK_DAYS_30 eq 0>selected</cfif>><cf_get_lang dictionary_id="57496.Hay??r"></option>
                                <option value="1" <cfif get_program_parameters.HOURLY_EMPLOYEE_WORK_DAYS_30 eq 1>selected</cfif>><cf_get_lang dictionary_id="57495.Evet"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-employees_base_calc">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='65253.??al????an??n ??al????ma G??n?? 0 ise SGK Matrah?? 0 dan Hesapla'></label>
                        <div class="col col-8 col-xs-12">
                            <select id="employees_base_calc" name="employees_base_calc">
                                <option value="0" <cfif get_program_parameters.employees_base_calc eq 0>selected</cfif>><cf_get_lang dictionary_id="57496.Hay??r"></option>
                                <option value="1" <cfif get_program_parameters.employees_base_calc eq 1>selected</cfif>><cf_get_lang dictionary_id="57495.Evet"></option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-partial_work">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62266.K??smi ??stihdam ??al????ma G??n??'></label>
                        <div class="col col-8 col-xs-12">
                            <select id="partial_work" name="partial_work">
                                <cfloop index="i" from="1" to="31">
                                    <cfoutput><option value="#i#" <cfif i eq get_program_parameters.partial_work>selected</cfif>>#i#</option></cfoutput>
                                </cfloop>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-partial_worktime">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='62267.Maximum K??smi ??stihdam ??al????ma Saati'></label>
                        <div class="col col-8 col-xs-12">
                            <cfoutput><input  type="text" name="partial_worktime" id="partial_worktime" onKeyUp="control_partial(this);return(FormatCurrency(this,event,2));" value="#TLFormat(get_program_parameters.partial_work_time)#"></cfoutput>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-6 col-xs-12" type="column" sort="true" index="2">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="59208.Fazla Mesai"></cfsavecontent>
                <cf_seperator header="#message#" id="fazla_mesai">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="59746.Fazla Mesai Y??zdesi"></cfsavecontent>
                <div class="row" id="fazla_mesai">
                    <div class="form-group" id="item-EX_TIME_LIMIT">
                        <label class="col col-4 col-xs-12"><cfoutput>#message#</cfoutput></label>
                        <div class="col col-4 col-xs-12">
                            <cfinput type="text" id="EX_TIME_LIMIT" name="EX_TIME_LIMIT" onKeyUp="isNumber(this);" value="#get_program_parameters.EX_TIME_LIMIT#" validate="integer" message="#message#" required="yes">
                        </div>
                        <div class="col col-4 col-xs-12">
                            <select name="extra_time_style" id="extra_time_style">
                                <option value="0" <cfif get_program_parameters.extra_time_style eq 0>selected</cfif>><cf_get_lang dictionary_id="59747.F. Mesai Tam Hesapla"></option>
                                <option value="1" <cfif get_program_parameters.extra_time_style eq 1>selected</cfif>><cf_get_lang dictionary_id="59748.F. Mesai ??eyrekli Hesapla"></option>
                                <option value="2" <cfif get_program_parameters.extra_time_style eq 2>selected</cfif>><cf_get_lang dictionary_id="59749.F. Mesai Dakikal??k Hesapla"></option>
                                <option value="3" <cfif get_program_parameters.extra_time_style eq 3>selected</cfif>><cf_get_lang dictionary_id="59747.F. Mesai Tam Hesapla"> (<cf_get_lang dictionary_id="58458.Haftal??k">)</option>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-EX_TIME_PERCENT">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59208"> <cf_get_lang dictionary_id="53213.Limit"></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <span class="input-group-addon no-bg">'<cf_get_lang dictionary_id="59750.saatten az"> % </span>
                                <cfinput type="text" id="EX_TIME_PERCENT" name="EX_TIME_PERCENT" onKeyUp="isNumber(this);" value="#get_program_parameters.EX_TIME_PERCENT#" validate="integer" message="#message#" required="yes">
                                <span class="input-group-addon no-bg">'<cf_get_lang dictionary_id="59751.saatten fazla"> % </span>
                                <cfinput type="text" name="EX_TIME_PER_HIGH" onKeyUp="isNumber(this);" value="#get_program_parameters.EX_TIME_PERCENT_HIGH#" validate="integer" message="#message#" required="yes">
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-NIGHT_MULTIPLIER">
                        <cfsavecontent variable="gececalisma"><cf_get_lang dictionary_id='63709.Gece ??al????ma ??arpan??'></cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#gececalisma#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="NIGHT_MULTIPLIER" name="NIGHT_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.NIGHT_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#gececalisma#">
                        </div>
                    </div>
                    <div class="form-group" id="item-WEEKEND_MULTIPLIER">
                        <cfsavecontent variable="haftasonu"><cf_get_lang dictionary_id="59752.Hafta Sonu ??arpan??"></cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#haftasonu#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="WEEKEND_MULTIPLIER" name="WEEKEND_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.WEEKEND_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#haftasonu#">
                        </div>
                    </div>
                    <div class="form-group" id="item-OFFICIAL_MULTIPLIER">
                        <cfsavecontent variable="resmitatil"><cf_get_lang dictionary_id="59753.Resmi Tatil Mesai ??arpan??"></cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#resmitatil#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="OFFICIAL_MULTIPLIER" name="OFFICIAL_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.OFFICIAL_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#resmitatil#">
                        </div>
                    </div>
                                         <!---  Baslama--->
                     <!--- Buras??n??n sadece ismi de??i??ti ??mbata ??zel--Kodlar ezilmesin diye yoruma ald??m!!--                   
                    <div class="form-group" id="item-WEEKEND_MULTIPLIER">
                        <cfsavecontent variable="haftasonu">Genel Tatil Mesaisi(Saat)</cfsavecontent> <!---<cf_get_lang dictionary_id="59752.Hafta Sonu ??arpan??">--->
                        <label class="col col-4 col-xs-12"><cfoutput>#haftasonu#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="WEEKEND_MULTIPLIER" name="WEEKEND_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.WEEKEND_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#haftasonu#">
                        </div>
                    </div>
                    <div class="form-group" id="item-OFFICIAL_MULTIPLIER">
                        <cfsavecontent variable="resmitatil">Dini Bayram Mesaisi(Saat) </cfsavecontent> <!---<cf_get_lang dictionary_id="59753.Resmi Tatil Mesai ??arpan??">--->
                        <label class="col col-4 col-xs-12"><cfoutput>#resmitatil#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="OFFICIAL_MULTIPLIER" name="OFFICIAL_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.OFFICIAL_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#resmitatil#">
                        </div>
                    </div>--->
                    <cfif x_weekly_day_work eq 1>
                    <div class="form-group" id="item-WEEKEND_DAY_MULTIPLIER">
                        <cfsavecontent variable="gececalisma">Hafta Tatili ??al????mas??(G??n)</cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#gececalisma#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="WEEKEND_DAY_MULTIPLIER" name="WEEKEND_DAY_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.WEEKEND_DAY_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#gececalisma#"><!---Hafta tatili ??al????mas?? G??n Ek mesai--->
                        </div>
                    </div>
                    </cfif>
                    <cfif x_akdi_day_work eq 1>
                    <div class="form-group" id="item-AKDI_DAY_MULTIPLIER">
                        <cfsavecontent variable="haftasonugun">Akdi Tatil ??al????mas??(G??n)</cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#haftasonugun#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="AKDI_DAY_MULTIPLIER" name="AKDI_DAY_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.AKDI_DAY_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#haftasonugun#"><!---Akdi Tatil ??al????mas?? G??n Ek mesaisi---->
                        </div>
                    </div>
                    </cfif>
                    <cfif x_official_day_work eq 1>
                    <div class="form-group" id="item-OFFICIAL_DAY_MULTIPLIER">
                        <cfsavecontent variable="resmitatilgun">Resmi Tatil ??al????mas??(G??n)</cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#resmitatilgun#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="OFFICIAL_DAY_MULTIPLIER" name="OFFICIAL_DAY_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.OFFICIAL_DAY_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#resmitatilgun#"> <!---Resmi Tatil ??al????mas?? Ek mesaisi G??n--->
                        </div>
                    </div>
                    </cfif>
                    <cfif x_Arefe_day_work eq 1>
                    <div class="form-group" id="item-ARAFE_DAY_MULTIPLIER">
                        <cfsavecontent variable="arefecalismagun">Arefe ??al????mas??(G??n)</cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#arefecalismagun#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="ARAFE_DAY_MULTIPLIER" name="ARAFE_DAY_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.ARAFE_DAY_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#arefecalismagun#"><!---Arefe G??n?? ??al????mas?? Ek mesai--->
                        </div>
                    </div>
                   </cfif>
                   <cfif x_Dini_day_work eq 1>
                    <div class="form-group" id="item-DINI_DAY_MULTIPLIER">
                        <cfsavecontent variable="dinicalismagun">Dini Bayram ??al????mas??(G??n)</cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#dinicalismagun#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="DINI_DAY_MULTIPLIER" name="DINI_DAY_MULTIPLIER" type="text" value="#tlformat(get_program_parameters.DINI_DAY_MULTIPLIER,2)#"  onkeyup="return(FormatCurrency(this,event));" message="#dinicalismagun#"> <!---Dini Bayram G??n?? ??al????mas?? Ek mesaisi--->
                        </div>
                    </div>
                    </cfif>
                  <!---Muzaffer Bitis--->
                    <div class="form-group" id="item-OVERTIME_YEARLY_HOURS">
                        <cfsavecontent variable="yillikfazla"><cf_get_lang dictionary_id="59754.Y??ll??k Fazla Mesai Limiti"></cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#yillikfazla#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput id="OVERTIME_YEARLY_HOURS" name="OVERTIME_YEARLY_HOURS" type="text" maxlength="5" value="#tlformat(get_program_parameters.OVERTIME_YEARLY_HOURS,0)#" validate="integer" message="#yillikfazla#" required="yes" onKeyUp="return(FormatCurrency(this,event,0));">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="57491.saat"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-overtime_hours">
                        <cfsavecontent variable="gunlukfazla"><cf_get_lang dictionary_id="59755.G??nl??k Fazla Mesai Limiti"></cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#gunlukfazla#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput id="overtime_hours" name="overtime_hours" type="text" maxlength="5" value="#tlformat(get_program_parameters.overtime_hours,0)#" validate="integer" message="#gunlukfazla#" required="yes" onKeyUp="return(FormatCurrency(this,event,0));">
                                <span class="input-group-addon no-bg"><cf_get_lang dictionary_id="57491.saat"></span>
                            </div>
                        </div>
                    </div>
                </div>

                <cfsavecontent variable="message"><cf_get_lang dictionary_id="58204.Avans"></cfsavecontent>
                <cf_seperator header="#message#" id="avans">
                <div class="row" id="avans">
                    <div class="form-group" id="item-is_avans_off">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="58204.Avans"> <cf_get_lang dictionary_id="30111.Durumu"></label>
                        <label class="col col-8 col-xs-12">
                            <input type="checkbox" id="is_avans_off" name="is_avans_off" value="1" <cfif get_program_parameters.is_avans_off eq 1>checked</cfif>> <cf_get_lang dictionary_id="53653.Puantaja Gelmesin">
                        </label>
                    </div>
                    <div class="form-group" id="item-yearly_payment_count">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59756.Ard arda Girilebilecek Avans Talebi Say??s??"></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="59757.Avans Talebi Say??s?? 1 - 99 Aras?? Olmal??d??r">!</cfsavecontent>
                            <cfinput id="yearly_payment_count" name="yearly_payment_count" type="text" onKeyUp="isNumber(this);" range="1,999" maxlength="2" value="#get_program_parameters.yearly_payment_req_count#"  message="#message#" required="yes">
                        </div>
                    </div>
                    <div class="form-group" id="item-yearly_payment_limit">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59758.Y??ll??k Avans Talebi Limiti"></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="59759.Avans Limiti 1 - 99 Aras?? Olmal??d??r">!</cfsavecontent>
                            <cfinput id="yearly_payment_limit" name="yearly_payment_limit" type="text" onKeyUp="isNumber(this);" range="1,999" maxlength="2" value="#get_program_parameters.yearly_payment_req_limit#"  message="" required="yes">
                        </div>
                    </div>
                    <div class="form-group" id="item-limit_payment_request">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="52989.Avans Tutar Limiti"> %</label>
                        <div class="col col-8 col-xs-12">
                            <cfinput id="limit_payment_request" name="limit_payment_request" type="text" onKeyUp="isNumber(this);" maxlength="4" value="#get_program_parameters.limit_payment_request#">
                        </div>
                    </div>
                    <div class="form-group" id="item-account_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="account_code" id="account_code" value="#get_program_parameters.account_code#">
                                <cfinput type="Text" name="account_name" id="account_name" value="#get_program_parameters.account_name#" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add.account_code&field_name=form_add.account_name');"></span>
                            </div>
                        </div>
                    </div>
                    <cfif is_show_member eq 1>
                        <div class="form-group" id="item-company_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="company_id" id="company_id" value="<cfoutput>#get_program_parameters.company_id#</cfoutput>">
                                    <input type="hidden" name="consumer_id" id="consumer_id" value="<cfoutput>#get_program_parameters.consumer_id#</cfoutput>">
                                    <cfif len(get_program_parameters.company_id)>
                                        <cfinput name="member_name" id="member_name" type="text" value="#get_par_info(get_program_parameters.company_id,1,0,0)#" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete',''1,2','','0','0','2','0'','COMPANY_ID','company_id','','3','180','');">
                                    <cfelseif len(get_program_parameters.consumer_id)>
                                        <cfinput name="member_name" id="member_name" type="text" value="#get_cons_info(get_program_parameters.consumer_id,0,0,0)#" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete',''1,2','','0','0','2','0'','COMPANY_ID','company_id','','3','180','');">
                                    <cfelse>	
                                        <cfinput name="member_name" id="member_name" type="text" value="" onFocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete',''1,2','','0','0','2','0'','COMPANY_ID','company_id','','3','180','');">
                                    </cfif>
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=form_add.member_name&field_consumer=form_add.consumer_id&field_comp_id=form_add.company_id&field_member_name=form_add.member_name</cfoutput>')"></span>
                                </div>
                            </div>
                        </div>
                    <cfelse>
                        <div class="form-group" id="item-acc_type_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53329.Hesap Tipi"></label>
                            <div class="col col-8 col-xs-12">
                                <select id="acc_type_id" name="acc_type_id">
                                    <option value=""><cf_get_lang dictionary_id="57734.Se??iniz"></option>
                                    <cfoutput query="get_ch_types">
                                        <option value="#acc_type_id#" <cfif get_ch_types.acc_type_id eq get_program_parameters.acc_type_id or get_ch_types.acc_type_id eq -2>selected</cfif>>#acc_type_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    </cfif>
                </div>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="50070.??cra"></cfsavecontent>
                <cf_seperator header="#message#" id="icra">
                <div class="row" id="icra">
                    <div class="form-group" id="item-interruption_type">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59558.Kesinti Tipi"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="interruption_type" name="interruption_type">
                                <option value=""><cf_get_lang dictionary_id="57734.Se??iniz"></option>
                                <option value="0" <cfif get_program_parameters.interruption_type eq 0>selected</cfif>><cf_get_lang dictionary_id="59760.Agi Hari??"></option>
                                <option value="1" <cfif get_program_parameters.interruption_type eq 1>selected</cfif>><cf_get_lang dictionary_id="59761.Agi Dahil"></option>				
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-execution_acc_type_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="53329.Hesap Tipi"></label>
                        <div class="col col-8 col-xs-12">
                            <select id="execution_acc_type_id" name="execution_acc_type_id">
                                <option value=""><cf_get_lang dictionary_id="57734.Se??iniz"></option>
                                <cfoutput query="get_ch_types">
                                    <option value="#acc_type_id#" <cfif get_ch_types.acc_type_id eq get_program_parameters.execution_acc_type_id>selected</cfif>>#acc_type_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <div class="form-group" id="item-execution_account_code">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <cfinput type="hidden" name="execution_account_code" id="execution_account_code" value="#get_program_parameters.execution_account_code#" >
                                <cfinput type="text" name="execution_account_name" id="execution_account_name" value="#get_program_parameters.execution_account_name#" onFocus="AutoComplete_Create('execution_account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','execution_account_code,execution_account_name','','3','225');">
                                <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add.execution_account_code&field_name=form_add.execution_account_name');"></span>
                            </div>
                        </div>
                    </div>
                    <div class="form-group" id="item-execution_company_id">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57519.Cari Hesap'></label>
                        <div class="col col-8 col-xs-12">
                            <div class="input-group">
                                <input type="hidden" name="execution_company_id" id="execution_company_id" value="<cfoutput>#get_program_parameters.execution_company_id#</cfoutput>">
                                <input type="hidden" name="execution_consumer_id" id="execution_consumer_id" value="<cfoutput>#get_program_parameters.execution_consumer_id#</cfoutput>">
                                <cfif len(get_program_parameters.execution_company_id)>
                                    <cfinput name="execution_member_name" id="execution_member_name" type="text" value="#get_par_info(get_program_parameters.execution_company_id,1,0,0)#" onFocus="AutoComplete_Create('execution_member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','execution_company_id','','3','180','');">
                                <cfelseif len(get_program_parameters.execution_consumer_id)>
                                    <cfinput name="execution_member_name" id="execution_member_name" type="text" value="#get_cons_info(get_program_parameters.execution_consumer_id,0,0,0)#" onFocus="AutoComplete_Create('execution_member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','execution_company_id','','3','180','');">
                                <cfelse>	
                                    <cfinput name="execution_member_name" id="execution_member_name" type="text" value="" onFocus="AutoComplete_Create('execution_member_name','MEMBER_NAME,MEMBER_CODE','MEMBER_NAME,MEMBER_CODE,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1,2\',\'\',\'0\',\'0\',\'2\',\'0\'','COMPANY_ID','execution_company_id','','3','180','');">
                                </cfif>
                                <span class="input-group-addon btnPointer icon-ellipsis" onclick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_list_pars&select_list=2,3&field_comp_name=form_add.execution_member_name&field_consumer=form_add.execution_consumer_id&field_comp_id=form_add.execution_company_id&field_member_name=form_add.execution_member_name</cfoutput>')" title="<cf_get_lang dictionary_id='57519.Cari Hesap'>"></span>
                            </div>
                        </div>
                    </div>
                </div>

                <cfsavecontent variable="message"><cf_get_lang dictionary_id="29801.Zorunlu"> <cf_get_lang dictionary_id="58875.??al????anlar"></cfsavecontent>
                <cf_seperator header="#message#" id="zorunlu_calisan">
                <div class="row" id="zorunlu_calisan">
                    <div class="form-group" id="item-sakat_alt">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="59762.??al????an Alt S??n??r"></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="59763.Sakat Alt S??n??r">!</cfsavecontent>
                            <cfinput type="text" id="sakat_alt" name="sakat_alt" onKeyUp="isNumber(this);" required="yes" validate="integer" message="#message#" value="#get_program_parameters.sakat_alt#">
                        </div>
                    </div>
                    <div class="form-group" id="item-sakat_percent">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="59764.Sakat ??al????an Y??zdesi"></cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#message#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" id="sakat_percent" name="sakat_percent" onKeyUp="isNumber(this);" required="yes" validate="integer" message="#message#" value="#get_program_parameters.sakat_percent#">
                        </div>
                    </div>
                    <div class="form-group" id="item-eski_hukumlu_percent">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="59765.Eski H??k??ml?? Y??zdesi"></cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#message#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" id="eski_hukumlu_percent" name="eski_hukumlu_percent" onKeyUp="isNumber(this);" required="yes" validate="integer" message="#message#" value="#get_program_parameters.eski_hukumlu_percent#">
                        </div>
                    </div>
                    <div class="form-group" id="item-teror_magduru_percent">
                        <cfsavecontent variable="message"><cf_get_lang dictionary_id="59766.Ter??r Ma??duru Y??zdesi"></cfsavecontent>
                        <label class="col col-4 col-xs-12"><cfoutput>#message#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <cfinput type="text" id="teror_magduru_percent" name="teror_magduru_percent" onKeyUp="isNumber(this);" required="yes" validate="integer" message="#message#" value="#get_program_parameters.teror_magduru_percent#">
                        </div>
                    </div>
                </div>
                
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57453.??ube"></cfsavecontent>
                <cf_seperator header="#message#" id="sube">
                <div class="row" id="sube">
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-4 col-xs-12"><cfoutput>#message#</cfoutput></label>
                        <div class="col col-8 col-xs-12">
                            <select name="branch_id" id="branch_id" multiple>
                                <cfoutput query="get_company">
                                    <optgroup label="#nick_name#">
                                    <cfquery name="get_ssk_office" dbtype="query">
                                        SELECT * FROM get_ssk_offices WHERE COMPANY_ID = #get_company.COMP_ID[currentrow]# ORDER BY BRANCH_NAME
                                    </cfquery>
                                    <cfif get_ssk_office.recordcount>
                                        <cfloop from="1" to="#get_ssk_office.recordcount#" index="s">
                                            <option value="#get_ssk_office.branch_id[s]#" <cfif listfind(get_program_parameters.branch_ids,'#get_ssk_office.branch_id[s]#',',')>selected</cfif>>&nbsp;&nbsp;#get_ssk_office.branch_name[s]#</option>
                                        </cfloop>
                                    </cfif>
                                    </optgroup>					  
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                    <cfset cmp = createObject("component","V16.hr.ehesap.cfc.employee_puantaj_group")>
                    <cfset cmp.dsn = dsn/>
                    <cfset get_groups = cmp.get_groups()/>
                    <div class="form-group" id="item-puantaj_grup">
                        <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="56857.??al????an Grubu"></label>
                        <div class="col col-8 col-xs-12">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57734.Se??iniz"></cfsavecontent>
                            <cf_multiselect_check 
                                query_name="get_groups"  
                                name="group_id"
                                width="150" 
                                option_text="#message#" 
                                option_value="group_id"
                                option_name="group_name"
                                value="#get_program_parameters.group_ids#">			
                        </div>
                    </div>
                </div>
                <cfsavecontent variable="message"><cf_get_lang dictionary_id="33706.Sa??l??k Harcamalar??"></cfsavecontent>
                <cf_seperator header="#message#" id="saglik">
                    <div class="row" id="saglik">
                        <div class="form-group" id="item-payment_account_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57576.??al????an"> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="employee_account_code" id="employee_account_code" value="#get_program_parameters.employee_account_code#" >
                                    <cfinput type="Text" name="employee_account_code_name" id="employee_account_code_name" value="#get_program_parameters.employee_account_name#" onFocus="AutoComplete_Create('employee_account_code_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add.employee_account_code&field_name=form_add.employee_account_code_name');"></span>
                                </div>
                            </div>
                        </div> 
                        <div class="form-group" id="item-health_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="57576.??al????an"><cf_get_lang dictionary_id="58551.Gider Kalemi"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_wrk_expense_items form_name='form_add' expense_item_id='expense_item_id' expense_item_name='expense_item_name'>
                                    <input type="hidden" name="expense_item_id" id="expense_item_id" value="<cfoutput>#get_program_parameters.expense_item_id#</cfoutput>">
                                    <input type="text" name="expense_item_name" value="<cfoutput>#get_program_parameters.expense_item_name#</cfoutput>" onKeyUp="get_expense_item();">
                                    <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=form_add.expense_item_id&field_name=form_add.expense_item_name');"></a>                                       
                                </div>
                            </div>  
                        </div>    
                        <div class="form-group" id="item-expense_income_item_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58173.Gelir Kalemi'></label>
                            <div class="col col-8 col-xs-12">
                                <cfsavecontent variable="text"><cf_get_lang dictionary_id="57734.Se??iniz"></cfsavecontent>
                                <cf_wrk_budgetItem 
                                    name="expense_income_item_id"
                                    value="#get_program_parameters.EXPENSE_INCOME_ITEM_ID#"
                                    option_text="#text#"
                                    width="160"
                                    income_expense="1"
                                    class="txt">	
                            </div>
                        </div>
                        <div class="form-group" id="item-EXPENSE_CODE_NAME">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58460.Masraf Merkezi'></label>
                            <div class="col col-8 col-xs-12"> 
                                <div class="input-group">
                                    <input type="hidden" name="expense_center_id" id="expense_center_id" value="<cfoutput>#get_program_parameters.expense_center_id#</cfoutput>">
                                    <input type="Text" name="EXPENSE_CODE_NAME" value="<cfoutput>#get_program_parameters.expense#</cfoutput>">
                                    <span class="input-group-addon icon-ellipsis btnPointer" onClick="openBoxDraggable('<cfoutput>#request.self#?fuseaction=objects.popup_expense_center&is_invoice=1&field_id=form_add.expense_center_id&field_acc_code_name=form_add.EXPENSE_CODE_NAME</cfoutput>');"></span>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" id="item-relative_health_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="55109.??al????an yak??n??"><cf_get_lang dictionary_id="58551.Gider Kalemi"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cf_wrk_expense_items form_name='form_add' expense_item_id='relative_expense_item_id' expense_item_name='relative_expense_item_name'>
                                    <input type="hidden" name="relative_expense_item_id" id="relative_expense_item_id" value="<cfoutput>#get_program_parameters.relative_expense_item_id#</cfoutput>">
                                    <cfinput type="hidden" name="relative_health_account_code" id="relative_health_account_code" value="#get_program_parameters.health_account_code#" >
                                    <input type="text" name="relative_expense_item_name" value="<cfoutput>#get_program_parameters.relative_expense_item_name#</cfoutput>" onKeyUp="get_expense_item();">
                                    <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_exp_item&field_id=form_add.relative_expense_item_id&field_name=form_add.relative_expense_item_name&field_acc_name=form_add.relative_health_account_code');"></a>                                       
                                </div>
                            </div>  
                        </div>    
                        <!---<div class="form-group" id="item-account_code">
                            <label class="col col-6 col-xs-12"><cfoutput>#getLang('objects',1316)# </cfoutput><cf_get_lang_main no='1399.Muhasebe Kodu'></label>
                            <div class="col col-6 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="health_account_code" id="health_account_code" value="#get_program_parameters.health_account_code#" >
                                    <cfinput type="Text" name="health_account_code_name" id="health_account_code_name" value="#get_program_parameters.health_account_name#" onFocus="AutoComplete_Create('account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang_main no='1399.Muhasebe Kodu'>" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add.health_account_code&field_name=form_add.health_account_code_name','list');"></span>
                                </div>
                            </div>
                        </div>--->  
                        <div class="form-group" id="item-salaryparam_pay">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = "32189.Ek ??denek"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="salaryparam_pay_id" id="salaryparam_pay_id" value="<cfoutput>#get_program_parameters.salaryparam_pay_id#</cfoutput>">
                                    <input type="text" name="salaryparam_pay_name" id="salaryparam_pay_name" value="<cfoutput>#get_program_parameters.COMMENT_PAY#</cfoutput>" reandonly>
                                    <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_odenek','list');"></a>                                       
                                </div>
                            </div>  
                        </div>   
                        <cfif isdefined("is_show_salaryparam_pay_relative") and is_show_salaryparam_pay_relative eq 1>
                            <div class="form-group" id="item-salaryparam_pay2">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="55109.??al????an yak??n??"><cf_get_lang dictionary_id = "32189.Ek ??denek"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="salaryparam_pay_id2" id="salaryparam_pay_id2" value="<cfoutput>#get_program_parameters.salaryparam_pay_id_relative#</cfoutput>">
                                    <input type="text" name="salaryparam_pay_name2" id="salaryparam_pay_name2" value="<cfoutput>#get_program_parameters.COMMENT_PAY_RELATIVE#</cfoutput>" reandonly>
                                    <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_odenek&field_salaryparam_pay_id=form_add.salaryparam_pay_id2&field_salaryparam_pay_name=form_add.salaryparam_pay_name2','list');"></a>                                       
                                </div>
                            </div>  
                        </div>   
                        </cfif>  
                        <div class="form-group" id="item-payment_interruption">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = "53083.Kesinti"></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="payment_interruption_id" id="payment_interruption_id" value="<cfoutput>#get_program_parameters.payment_interruption_id#</cfoutput>">
                                    <input type="text" name="payment_interruption_name" id="payment_interruption_name" value="<cfoutput>#get_program_parameters.payment_interruption_name#</cfoutput>" reandonly>
                                    <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_kesinti&type=2&field_name=payment_interruption_name&field_id=payment_interruption_id');"></a>                                       
                                </div>
                            </div>  
                        </div> 
                        <div class="form-group" id="item-payment_account_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = "53083.Kesinti"> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="payment_account_code" id="payment_account_code" value="#get_program_parameters.PAYMENT_account_code#" >
                                    <cfinput type="Text" name="payment_account_code_name" id="payment_account_code_name" value="#get_program_parameters.PAYMENT_account_name#" onFocus="AutoComplete_Create('payment_account_code_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add.payment_account_code&field_name=form_add.payment_account_code_name');"></span>
                                </div>
                            </div>
                        </div>   
                        <div class="form-group" id="item-limit_interruption">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = "53083.Kesinti"> - <cf_get_lang dictionary_id='58621.Limit a????m??'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <input type="hidden" name="limit_interruption_id" id="limit_interruption_id" value="<cfoutput>#get_program_parameters.limit_interruption_id#</cfoutput>">
                                    <input type="text" name="limit_interruption_name" id="limit_interruption_name" value="<cfoutput>#get_program_parameters.limit_interruption_name#</cfoutput>" reandonly>
                                    <a href="javascript://" class="input-group-addon btnPointer icon-ellipsis" onClick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.popup_list_kesinti&type=2&field_name=limit_interruption_name&field_id=limit_interruption_id');"></a>                                       
                                </div>
                            </div>  
                        </div>   
                        <div class="form-group" id="item-limit_account_code">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id = "53083.Kesinti"> - <cf_get_lang dictionary_id='58621.Limit a????m??'> <cf_get_lang dictionary_id='58811.Muhasebe Kodu'></label>
                            <div class="col col-8 col-xs-12">
                                <div class="input-group">
                                    <cfinput type="hidden" name="limit_interruption_account_code" id="limit_interruption_account_code" value="#get_program_parameters.limit_interruption_account_code#" >
                                    <cfinput type="Text" name="limit_interruption_account_name" id="limit_interruption_account_name" value="#get_program_parameters.limit_interruption_account_name#" onFocus="AutoComplete_Create('limit_interruption_account_name','ACCOUNT_CODE,ACCOUNT_NAME','ACCOUNT_CODE,ACCOUNT_NAME','get_account_code','','ACCOUNT_CODE,ACCOUNT_NAME','account_code,account_name','','3','225');">
                                    <span class="input-group-addon btnPointer icon-ellipsis" title="<cf_get_lang dictionary_id='58811.Muhasebe Kodu'>" onclick="openBoxDraggable('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_account_plan&field_id=form_add.limit_interruption_account_code&field_name=form_add.limit_interruption_account_name');"></span>
                                </div>
                            </div>
                        </div>   
                    </div>
            </div>
        </cf_box_elements>
        <cf_box_footer>
            <div class="col col-6 col-xs-12"><cf_record_info query_name="get_program_parameters"></div>
            <div class="col col-6 col-xs-12">
                <cf_workcube_buttons is_upd='1' is_delete='1' delete_page_url='#request.self#?fuseaction=ehesap.emptypopup_del_program_parameters&parameter_id=#parameter_id#' add_function="control()">
            </div>
        </cf_box_footer>
    </cf_box>
</div>
</cfform>
<script type="text/javascript">
function control()
{
	if(!$('#parameter_name').val().length){
		alertObject({ message: "<cfoutput><cf_get_lang dictionary_id='54327.Tan??m Girmelisiniz'> ! </cfoutput>"})
		return false;
	}
	if(!$('#startdate').val().length){
		alertObject({ message: "<cfoutput><cf_get_lang dictionary_id='58745.Ba??lama Tarihi girmelisiniz'> ! </cfoutput>"})
		return false;
	}
	if(!$('#finishdate').val().length){
		alertObject({ message: "<cfoutput><cf_get_lang dictionary_id='57739.Biti?? Tarihi girmelisiniz'> ! </cfoutput>"})
		return false;
	}
	if(!$('#stamp_tax_binde').val().length){
		alertObject({ message: "<cfoutput><cf_get_lang dictionary_id='58194.Zorunlu Alan'><cf_get_lang dictionary_id='54128.Damga Vergisi Bindesi'> ! </cfoutput>"})
		return false;
	}
	if(document.all.branch_id.value == "" && document.all.group_id.value == "")
	{
		alert("<cf_get_lang dictionary_id='60735.??ube ya da ??al????an grubu Se??melisiniz'>!");
		return false;
	}
    partial_worktime = filterNum(form_add.partial_worktime.value);
    if(partial_worktime > 232.5)
    {
        alert("<cf_get_lang dictionary_id='62278.K??smi ??stihdan ??al????ma Saati En Fazla 232,5 olmal??d??r!'>");
        return false;
    }
	UnformatFields();
	return true;
}
function add_row(is_damga,is_issizlik,ssk,tax,is_kidem,show,comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,from_salary,row_id_,is_ehesap,is_ayni_yardim,SSK_EXEMPTION_RATE,TAX_EXEMPTION_RATE,TAX_EXEMPTION_VALUE,money,comment_pay_id,SSK_EXEMPTION_TYPE,is_income,comment_type,factor_type,is_not_execution,is_rd_damga,is_rd_gelir,is_rd_ssk)
{
    document.getElementById("salaryparam_pay_id").value = comment_pay_id;
    document.getElementById("salaryparam_pay_name").value = comment_pay;
    return true;
}
function add_row_interruption(from_salary, show, comment_pay, period_pay, method_pay, term, start_sal_mon, end_sal_mon, amount_pay, calc_days,is_ehesap,total_get,account_code,company_id,company_name,account_name,consumer_id,money,acc_type_id,satir_tax,odkes_id,field_name,field_id)
{
    document.getElementById(field_id).value = odkes_id;
    document.getElementById(field_name).value = comment_pay;
    return true;
}
function UnformatFields()
{
	form_add.WEEKEND_MULTIPLIER.value = filterNum(form_add.WEEKEND_MULTIPLIER.value);
	form_add.NIGHT_MULTIPLIER.value = filterNum(form_add.NIGHT_MULTIPLIER.value);
	form_add.OFFICIAL_MULTIPLIER.value = filterNum(form_add.OFFICIAL_MULTIPLIER.value);
	form_add.stamp_tax_binde.value = filterNum(form_add.stamp_tax_binde.value);
    form_add.partial_worktime.value = filterNum(form_add.partial_worktime.value);
}
function control_partial(partial_time)
{
    partial_worktime = filterNum(form_add.partial_worktime.value);
    if(partial_worktime > 232.5)
    {
        alert("<cf_get_lang dictionary_id='62278.K??smi ??stihdan ??al????ma Saati En Fazla 232,5 olmal??d??r!'>");
        return false;
    }
}
</script>