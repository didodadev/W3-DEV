<!--- element adı --->
<cfparam name="attributes.name" default="">
<!--- element türü "input / Checkbox / hidden / Radio / Text / Textarea / Upload / Image / File / Icon / Selectbox / Multiselect / Switch" --->
<!--- dikkat icon eklerken value veya data kullanılmaz class attribute kullanılarak yapılmalıdır ---->
<cfparam name="attributes.type" default="text">
<!--- element tipi "money, alphanumeric, numeric, phone, zipcode, email, password, amount, percent, date, datetime" --->
<cfparam name="attributes.data_control" default="alphanumeric">
<cfparam name="attributes.hidecurrency" default="no">
<!--- para birimi select i için bir isim verilmelidir. Bu isim verilmez ise para birimi kutusu çıkmaz. --->
<cfparam name="attributes.currencyname" default="">
<cfparam name="attributes.currencyvalue" default="">
<cfparam name="attributes.onkeypress" default="">
<!--- css class " css.class" --->
<cfparam name="attributes.class" default="">
<!--- label "Dictionary_ID + Dictionary ID"--->
<cfparam name="attributes.label" default="">
<!--- placeholder "Dictionary_ID + Dictionary ID" --->
<cfparam name="attributes.placeholder" default="">
<!--- direk değer “asname.argument / session.variable / formula / variables ”--->
<cfparam name="attributes.value" default="">
<cfparam name="attributes.option" default="">
<cfparam name="attributes.option_manuel" default="">
<cfparam name="attributes.option_manuel_value" default="">
<!--- data bağlantı “asname.argument / session.variable / formula / variables / workdata.  ”--->
<cfparam name="attributes.data" default="">
<!--- autocomplete fonksiyonu “function and variables”--->
<cfparam name="attributes.autocomplete" default="">
<!--- threepoint “box/tab&widget/wo/external="link"&size=medium&variables=?”--->
<cfparam name="attributes.threepoint" default="">
<cfparam name="attributes.icon" default="">
<cfparam name="attributes.icon_boxhref" default="">
<cfparam name="attributes.Onclick_" default="">
<cfparam name="attributes.OnChange" default="">
<cfparam name="attributes.onblur" default="">
<cfparam name="attributes.maxlength" default="">
<cfparam name="attributes.required" default="">
<cfparam name="attributes.onkeyup" default="">
<!--- şifrelerken görünsün fakat herhangi bir işlem yapmaması için 0 gönderilir. --->
<cfparam name="attributes.hide" default="1">
<!--- extra buttonlar “icons"--->
<cfparam name="attributes.extra_button" default="">
<!--- extra func "box/tab&widget/wo/external="link"&size=medium&variables=? ”--->
<cfparam name="attributes.extra_function" default="">
<!--- path image ve file için --->
<cfparam name="attributes.path" default="">
<!--- js --->
<cfparam name="attributes.js" default="">
<!--- tips "Dictionary_ID+DictionaryID"--->
<cfparam name="attributes.tips" default="">
<!--- gdpr “1,2,3,4,5,6,7,8,9” --->
<cfparam name="attributes.gdpr" default="">
<cfparam name="attributes.readonly" default="">
<!--- duxide dikey form kullanmak için  --->
<cfparam name="attributes.is_vertical" default="0">
<cfparam name="attributes.unit" default="">
<cfparam name="attributes.validate" default="">
<cfparam name="attributes.message" default="">
<cfparam name="attributes.data_gdpr" default="">


<cfif isDefined("attributes.is_vertical") and attributes.is_vertical eq 1>
    <cfset class_ = 'col col-12 col-md-12 col-sm-12 col-xs-12'>
    <cfset class = 'col col-12 col-md-12 col-sm-12 col-xs-12'>
<cfelse>
    <cfset class_ = 'col col-4 col-md-4 col-sm-4 col-xs-12'>
    <cfset class = 'col col-8 col-md-8 col-sm-8 col-xs-12'>
</cfif>
<cfif thisTag.executionMode eq "start" and thisTag.hasEndTag eq "0">
    <cfif len(attributes.name) eq 0>
        <cfthrow message="Duxi element adı gereklidir!">
    </cfif>
    <cfset label_value = "">
    <cfif len(attributes.label)>
    <cfloop list="#attributes.label#" delimiters="+" index="i" item="c">
        <cfsavecontent variable="tmplabel">
            <cf_get_lang dictionary_id="#c#">
        </cfsavecontent>
        <cfset label_value = listAppend(label_value, tmplabel, " ")>
    </cfloop>
    </cfif>

    <cfset placeholder_value = "">
    <cfif len(attributes.placeholder)>
        <cfloop list="#attributes.placeholder#" delimiters="+" index="i" item="c">
            <cfsavecontent variable="tmplabel">
                <cf_get_lang dictionary_id="#c#">
            </cfsavecontent>
            <cfset placeholder_value = listAppend(placeholder_value, tmplabel, " ")>
        </cfloop>
    </cfif>

    <cfset tooltip_value = "">
    <cfif len(attributes.tips)>
        <cfloop list="#attributes.tips#" delimiters="+" index="i" item="c">
            <cfsavecontent variable="tmptooltip">
                <cf_get_lang dictionary_id="#c#">
            </cfsavecontent>
            <cfset tooltip_value = listAppend(tooltip_value, tmptooltip, " ")>
        </cfloop>
    </cfif>

    <cfset value_value = "">
    <cfif len(attributes.value) and attributes.type neq "selectbox">
        <cftry>
            <cfif isdefined("caller."&attributes.value)>
                <cfset value_value = evaluate("caller."&attributes.value)>
            <cfelseif isdefined(attributes.value)>
                <cfset value_value = evaluate(attributes.value)>
            <cfelse>
                <cfset value_value = attributes.value>
            </cfif>

            <cfcatch>
                <cfset value_value = attributes.value>
            </cfcatch>
        </cftry>
    </cfif>
    <cfif attributes.data_control eq "date" and len(value_value)>
        <cfset value_value = Dateformat(value_value,caller.dateformat_style)>
    </cfif>

    <cfset currency_value = session.ep.money>
    <cfif len(attributes.currencyvalue)>
        <cftry>
            <cfif isDefined("caller."&attributes.currencyvalue)>
                <cfset currency_value = evaluate("caller."&attributes.currencyvalue)>
            <cfelseif isDefined(attributes.currencyvalue)>
                <cfset currency_value = evaluate(attributes.currencyvalue)>
            <cfelse>
                <cfset currency_value = attributes.currencyvalue>
            </cfif>
            <cfcatch>
                <cfset currency_value = attributes.currencyvalue>
            </cfcatch>
        </cftry>
    </cfif>

    <cfset data_value = "">
    <cfif len(attributes.data)>
        <cfset data_value = evaluate("caller."&attributes.data)>
    </cfif>
    <cfif attributes.data_control eq "datetime" and len(data_value)>
        <cfset hour_value = hour(data_value)> 
        <cfset minute_value = minute(data_value)>
    </cfif>
    <cfif attributes.data_control eq "date" or attributes.data_control eq "datetime" and len(data_value)>
        <cfset data_value = Dateformat(data_value,caller.dateformat_style)>
    </cfif>
    <cfobject name="gdpr_" type="component" component="workdata.get_gdpr_control">
    <cfset caller.__control_gdpr = gdpr_.getComponentFunction()>
    <cfset control_gdpr = caller.__control_gdpr>
    <cfif len(attributes.gdpr)>
        <cfset data_value_ = '#data_value#'>
        <cfset value_value_ = '#value_value#'>
        <cfset label_value_ = '#label_value#'>
        <cfset caller.__get_gdpr = gdpr_.getComponentFunctionGDPR(gdpr_ : attributes.gdpr)>
        <cfset get_gdpr = caller.__get_gdpr>
        <cfif get_gdpr.recordcount>
            <cfset data_value = '#data_value_#'>
            <cfset value_value = '#value_value_#'>
            <cfset label_value = '#label_value_#'>
            <cfset attributes.data_gdpr = ''>
        <cfelse>
            <script>
                $('[name="<cfoutput>#attributes.name#_</cfoutput>"]').attr("readonly", true);$('[name="<cfoutput>#attributes.name#_</cfoutput>"]').attr('onclick','power_gdpr()');
            </script>
            <cfif attributes.hide eq 1>
                <cfset data_value = "#mid(data_value_,1,2)#*******">
                <cfset value_value = "#mid(value_value_,1,2)#*******">
                <cfset label_value = "#mid(label_value_,1,2)#*******">
                <cfset attributes.name = '#attributes.name#_'>
                <cfset attributes.data_gdpr = 1>
            </cfif>
        </cfif>
    </cfif>
    <cfset input_type = "text">
    <cfsavecontent variable="controldata">
        <cfoutput>
        <cfswitch expression="#attributes.data_control#">
            <cfcase value="isnumber"> <!--- add ve upd sayfalarında TC gibi sadece rakam kullanılacak alanlar için --->
                <cfset attributes.class = attributes.class>
                onblur="isNumber(this)" ;
                onkeyup="isNumber(this)";
            </cfcase>
            <cfcase value="money">
                <cfset attributes.class = attributes.class & " text-right">
                onblur="if((this.value.length == 0) || filterNum(this.value,#session.ep.our_company_info.sales_price_round_num#) <=0 ) this.value=commaSplit(1,#session.ep.our_company_info.sales_price_round_num#);" 
                onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"
            </cfcase>
            <cfcase value="unit">
                <cfset attributes.class = attributes.class & " text-right">
                onblur="if((this.value.length == 0) || filterNum(this.value,#session.ep.our_company_info.sales_price_round_num#) <=0 ) this.value=commaSplit(1,#session.ep.our_company_info.sales_price_round_num#);" 
                onkeyup="return(FormatCurrency(this,event,#session.ep.our_company_info.sales_price_round_num#));"
            </cfcase>
            <cfcase value="numeric">
                <cfset attributes.class = attributes.class & " text-right">
                <cfset input_type = "number">
            </cfcase>
            <cfcase value="phone">
                <cfset input_type = "phone">
            </cfcase>
            <cfcase value="email">
                <cfset input_type = "email">
            </cfcase>
            <cfcase value="password">
                <cfset input_type = "password">
            </cfcase>
            <cfcase value="amount">
                <cfset attributes.class = attributes.class & " text-right">
                <cfset input_type = "number">
            </cfcase>
            <cfcase value="percent">
                <cfset attributes.class = attributes.class & " text-right">
                <cfset input_type = "number">
            </cfcase>
        </cfswitch>
        </cfoutput>
    </cfsavecontent>

    <cfsavecontent variable="generated_content">
        <cfoutput>
        <cfswitch expression="#attributes.type#">
            <cfcase value="input,text">
                <input type="#input_type#" <cfif len(attributes.maxlength)> maxlength="#attributes.maxlength#" </cfif> <cfif len(attributes.onkeyup)> onkeyup="#attributes.onkeyup#" </cfif><cfif len(attributes.onkeypress)> onkeypress="#attributes.onkeypress#" </cfif> name="#attributes.name#" onblur="#attributes.onblur#" #controldata#  <cfif len(attributes.required)>required="#attributes.required#"</cfif><cfif len(attributes.readonly)>readonly</cfif> id="#attributes.name#" placeholder="#placeholder_value#" value="#len(attributes.data) ? data_value : value_value#" <cfif len(attributes.autocomplete)> autocomplete="off" <cfif len(attributes.gdpr) and not get_gdpr.recordcount> data-gdpr="1" </cfif> onFocus="#attributes.autocomplete#"</cfif> <cfif len(attributes.validate)> validate="#attributes.validate#" </cfif> <cfif len(attributes.message)> message="#attributes.message#" </cfif> onchange="#attributes.OnChange#" class="#attributes.class#" #attributes.js# data-gdpr=#attributes.data_gdpr#>
            </cfcase>
            <cfcase value="label"><!---Listede kullanabilmek için yazıldı--->
                <a href="javascript://" class="tableyazi"  name="#attributes.name#" id="#attributes.name#"  <cfif len(attributes.Onclick_)> onclick="windowopen('#attributes.Onclick_#','page')" </cfif>>#len(attributes.data) ? data_value : value_value#</a>
            </cfcase>
            <cfcase value="checkbox">
                <input type="checkbox" name="#attributes.name#" id="#attributes.name#" value="#value_value#" #data_value eq value_value ? "checked" : ""# class="#attributes.class#">
            </cfcase>
            <cfcase value="hidden">
                <input type="hidden" name="#attributes.name#" id="#attributes.name#" value="#len(attributes.data) ? data_value : value_value#" class="#attributes.class#">
            </cfcase>
            <cfcase value="radio">
                <input type="radio" name="#attributes.name#" id="#attributes.name#" value="#len(attributes.data) ? data_value : value_value#" class="#attributes.class#">
            </cfcase>
            <cfcase value="textarea">
                <textarea name="#attributes.name#" onblur="#attributes.onblur#" <cfif len(attributes.required)>required="#attributes.required#"</cfif> id="#attributes.name#" <cfif len(attributes.maxlength)> maxlength="#attributes.maxlength#" </cfif> <cfif len(attributes.validate)> validate="#attributes.validate#" </cfif> <cfif len(attributes.message)> message="#attributes.message#" </cfif>placeholder="#placeholder_value#" <cfif len(attributes.autocomplete)> autocomplete="off" onFocus="#attributes.autocomplete#"</cfif> class="#attributes.class#" #attributes.js#>#len(attributes.data) ? data_value : value_value#</textarea>
            </cfcase>
            <cfcase value="upload">
                <input type="file" name="#attributes.name#" id="#attributes.name#" placeholder="#placeholder_value#" class="#attributes.class#" #attributes.js#>
            </cfcase>
            <cfcase value="image">
                <img src="#len(attributes.data) ? attributes.path & data_value : value_value#" class="#attributes.class#">
            </cfcase>
            <cfcase value="file">
                <a href="#len(attributes.data) ? attributes.path & data_value : value_value#" target="_blank" class="#attributes.class#">#len(placeholder_value) ? placeholder_value : (len(attributes.data) ? data_value : value_value)#</a>
            </cfcase>
            <cfcase value="icon">
                <i class="#attributes.class#"></i>
            </cfcase>
            <cfcase value="selectbox">
                <select name="#attributes.name#" id="#attributes.name#" onchange="#attributes.OnChange#" onblur="#attributes.onblur#">
                    <cfif len(placeholder_value)>
                    <option value="">#placeholder_value#</option>
                    </cfif>
                    <cfif isDefined("attributes.secenek")>
                    </cfif>
                    <cfif isDefined("attributes.option") and len(attributes.option)>
                        <cfset selectdatasource = caller[listFirst(attributes.option, ".")]>
                        <cfset valuesource = listlast(attributes.value, ".")>
                        <cfset optionsource = listlast(attributes.option, ".")>
                        <cfloop query="selectdatasource">
                        <option value="#evaluate("selectdatasource.#valuesource#")#" #evaluate("selectdatasource.#valuesource#") eq data_value ? "selected" : ""#>#evaluate("selectdatasource.#optionsource#")#</option>
                        </cfloop>
                    <cfelseif isDefined("attributes.option_manuel") and len(attributes.option_manuel) and isDefined("attributes.option_manuel_value") and len(attributes.option_manuel_value)>
                        <cfset option_list = "">
                        <cfset value_list = "">
                        <cfset option_list = Listappend(option_list,attributes.option_manuel,',') />
                        <cfset value_list = Listappend(value_list,attributes.option_manuel_value,',') >
                        <cfloop list="#option_list#" index="i" item="k" delimiters=",">
                            <option value="#evaluate("value_list[#i#]")#" #evaluate("value_list[#i#]") eq data_value ? "selected" : ""#><cf_get_lang dictionary_id="#k#"></option>
                        </cfloop>
                    </cfif>
                </select>
            </cfcase>
            <cfcase value="switch">
                <div class="checkbox checbox-switch">
                    <label>
                        <input type="checkbox" name="#attributes.name#" id="#attributes.name#" value="1"<cfif (len(data_value) ? data_value : value_value) eq 1> checked</cfif>>
                        <span></span>
                    </label>
                </div>
            </cfcase>
            <cfcase value="label_gdpr">
                <label class="#attributes.class#">
                    #label_value#
                </label>
            </cfcase>
        </cfswitch>
        </cfoutput>
    </cfsavecontent>
    <!--- <cfsavecontent variable="duxioutput"> --->
    <cfif attributes.type eq "hidden" or (attributes.label eq "" and attributes.placeholder eq "") or attributes.type eq 'label_gdpr'>
        <cfoutput>#generated_content#</cfoutput>
    <cfelse>
        <div class="form-group" id="item_<cfoutput>#attributes.name#</cfoutput>">
            <div class="<cfoutput>#class_#</cfoutput>">
                <cfif attributes.required eq "yes">
                    <label><cfoutput>#label_value#*</cfoutput></label>
                <cfelse>
                    <label><cfoutput>#label_value#</cfoutput></label>
                </cfif>
            </div>
            <div class="<cfoutput>#class#</cfoutput>">
                <cfif len(attributes.threepoint) or len(attributes.icon) or len(attributes.tips) or (attributes.data_control eq "unit" and len(attributes.currencyname))or (attributes.data_control eq "money" and len(attributes.currencyname)) or attributes.data_control eq "date"  or attributes.data_control eq "datetime" or attributes.data_control eq "width">
                    <cfoutput>
                        <cfif attributes.data_control eq "datetime">
                            <div class="col col-6 col-md-6 col-sm-6 col-xs-12">
                                <div class="input-group">
                                    #generated_content#
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="#attributes.name#"></span>
                                </div>
                            </div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-6"><cf_wrkTimeFormat name="#attributes.name#_hour" value="#hour_value#"></div>
                            <div class="col col-3 col-md-3 col-sm-3 col-xs-6"><cf_wrkTimeFormat name="#attributes.name#_minute" value="#minute_value#"></div>
                        <cfelse>
                            <div class="input-group">
                                <cfif len(attributes.tips)>
                                    <div class="input-group_tooltip input-group_tooltip_v2" style="display: none;">#tooltip_value#</div>
                                </cfif>
                                #generated_content#
                                <cfif len(attributes.tips)>
                                    <span class="input-group-addon icon-question input-group-tooltip"></span>
                                </cfif>
                                <cfif attributes.data_control eq "unit">
                                    <cfif isDefined("caller.__duxiunit")>
                                        <cfset query_unit = caller.__duxiunit>
                                    <cfelse>
                                        <cfset comp    = createObject("component","V16.product.cfc.product_sample") />
                                        <cfset caller.__duxiunit = comp.GET_PRODUCT_UNIT()/>
                                        <cfset query_unit = caller.__duxiunit>
                                    </cfif>
                                    <span class="input-group-addon width">
                                        <select name="#attributes.currencyname#">
                                            <cfloop query="query_unit">
                                                <option value="#query_unit.unit_id#" <cfif query_unit.unit_id eq currency_value>selected</cfif>>#query_unit.unit#</option>
                                            </cfloop>
                                        </select>
                                    </span>
                                </cfif>
                                <cfif len(attributes.threepoint)>
                                    <span class="input-group-addon icon-ellipsis" href="javascript://" onclick="openBoxDraggable('#attributes.threepoint#')"></span>
                                </cfif>
                                <cfif attributes.data_control eq "money">
                                    <cfif isDefined("caller.__duximoney")>
                                        <cfset query_money = caller.__duximoney>
                                    <cfelse>
                                        <cfobject name="duximoney" type="component" component="workdata.get_money">
                                        <cfset caller.__duximoney = duximoney.getComponentFunction()>
                                        <cfset query_money = caller.__duximoney>
                                    </cfif>
                                    <span class="input-group-addon width">
                                        <select name="#attributes.currencyname#">
                                            <cfloop query="query_money">
                                            <option value="#query_money.MONEY#" <cfif query_money.MONEY eq currency_value>selected</cfif>>#query_money.MONEY#</option>
                                            </cfloop>
                                        </select>
                                    </span>
                                </cfif>
                                <cfif attributes.data_control eq "date">
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="#attributes.name#"></span>
                                </cfif>
                                <cfif attributes.data_control eq "text">
                                    <span class="input-group-addon btnPointer"><i class=""></span>
                                </cfif>
                                <cfif attributes.data_control eq "width">
                                    <span class="input-group-addon width">#attributes.unit#</span>
                                </cfif>
                                <cfif len(attributes.icon) >
                                    <span class="input-group-addon width" href="javascript://" onclick="openBoxDraggable('#attributes.icon_boxhref#')"><i class="fa #attributes.icon#"></i></span>
                                </cfif>
                            </div>
                        </cfif>
                    </cfoutput>
                <cfelse>
                    <cfoutput>#generated_content#</cfoutput>
                </cfif>
            </div>
        </div>
    </cfif>
    <!---
    </cfsavecontent>
    <cfset caller.duxiboxes[caller.last_box_id][attributes.name] = duxioutput>
    --->
</cfif>
<cfif thisTag.executionMode eq "end">
    <cfif attributes.label eq "">
        <cfoutput>#thisTag.GeneratedContent#</cfoutput>
        <!--- <cfset caller.duxiboxes[caller.last_box_id][attributes.name] = thisTag.GeneratedContent> --->
        <cfset thisTag.GeneratedContent="">
    <cfelse>
    <cfset label_value = "">
    <cfif len(attributes.label)>
    <cfloop list="#attributes.label#" delimiters="+" index="i" item="c">
        <cfsavecontent variable="tmplabel">
            <cf_get_lang dictionary_id="#c#">
        </cfsavecontent>
        <cfset label_value = listAppend(label_value, tmplabel, " ")>
    </cfloop>
    </cfif>
        <!--- <cfsavecontent variable="content"> --->
        <div class="form-group" id="item_<cfoutput>#attributes.name#</cfoutput>">
            <div class="<cfoutput>#class_#</cfoutput>">
                <label><cfoutput>#label_value#</cfoutput></label>
            </div>
            <div class="<cfoutput>#class#</cfoutput>">
                <cfoutput>#thisTag.GeneratedContent#</cfoutput>
                <cfset thisTag.GeneratedContent="">
            </div>
        </div>
        <!---
        </cfsavecontent>
        <cfset caller.duxiboxes[caller.last_box_id][attributes.name] = content>
        --->
    </cfif>
</cfif>
<cfif  attributes.type neq 'label'>
    <div class="gdpr_alert">
    <div style="display:none" class="ui-cfmodal ui-cfmodal__alert">
        <cf_box title="Uyarı" closable="0" resize="0">
            <div class="ui-cfmodal-close">×</div>
            <ul class="required_list"></ul>
        </cf_box>
    </div>
    </div>

    <script type="text/javascript">

        $('.ui-cfmodal-close').click(function(){
            $('.ui-cfmodal__alert').fadeOut();
        })
    
    function power_gdpr() {
        $('.ui-cfmodal__alert .required_list li').remove();
        $('.ui-cfmodal__alert .required_list').append('<li><cf_get_lang dictionary_id='34269.İşlem Yapmaya Yetkiniz yok'></li>');
        $('.ui-cfmodal__alert').fadeIn();
    }
    </script>
</cfif>