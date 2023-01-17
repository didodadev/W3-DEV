<cfset url_str="">
<cfparam name="attributes.date1" default="01/#Month(now())#/#year(now())#">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.page" default="1">
<cfparam name="attributes.status" default="">
<cfparam name="attributes.keyword" default="">
<cfparam name="attributes.hierarchy" default="">
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfset url_str="keyword=#attributes.keyword#&status=#attributes.status#&hierarchy=#attributes.hierarchy#&branch_id=#attributes.branch_id#">
<cfif IsDefined('attributes.form_submit') and len(attributes.form_submit)>
<cfset url_str="#url_str#&form_submit=#attributes.form_submit#">
</cfif>
<cf_date tarih='attributes.date1'>
<!--- sorgu sirayi bozmayin  --->
<cfinclude template="../query/get_our_comp_and_branchs.cfm">
<cfif isdefined('attributes.form_submit')>
<cfinclude template="../query/get_other_payment_request.cfm">
<cfelse>
<cfset get_other_requests.recordcount = 0>
</cfif>
<cfquery name="GET_SPECIAL_DEFINITION" datasource="#DSN#">
	SELECT SPECIAL_DEFINITION_ID,SPECIAL_DEFINITION FROM SETUP_SPECIAL_DEFINITION WHERE SPECIAL_DEFINITION_TYPE = 2
</cfquery>
<cfparam name="attributes.totalrecords" default="#get_other_requests.recordcount#">

<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
    <cf_box>
        <cfform action="#request.self#?fuseaction=ehesap.list_other_payment_requests"  name="myform" method="post" >
            <input type="hidden" name="form_submit" id="form_submit" value="1">
            <cf_box_search>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                    <cfinput name="keyword" id="keyword" placeholder="#message#" value="#attributes.keyword#" style="width:100px;" maxlength="50">
                </div>
                <div class="form-group">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id="57761.Hiyerarşi"></cfsavecontent>
                    <cfinput name="hierarchy" id="hierarchy" placeholder="#message#" value="#attributes.hierarchy#" style="width:100px;" maxlength="50">
                    <cfset attributes.date1=dateformat(attributes.date1,dateformat_style)>
                    <cfset url_str="#url_str#&date1=#attributes.date1#">
                </div>
                <div class="form-group small">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                    <cfinput type="text" name="maxrows" id="maxrows" value="#attributes.maxrows#" onKeyUp="isNumber(this)" required="yes" validate="integer" range="1,999" message="#message#" maxlength="3" style="width:25px;">
                </div>
                <div class="form-group">
                    <cf_wrk_search_button button_type="4">
                </div>
            </cf_box_search>
            <cf_box_search_detail>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                    <div class="form-group" id="item-date1">
                        <label class="col col-12"><cf_get_lang dictionary_id='57692.İşlem'> <cf_get_lang dictionary_id="58053.Başlagıç Tarihi"></label>
                        <div class="col col-12">
                            <div class="input-group">
                                <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57692.İşlem'> <cf_get_lang dictionary_id="58053.Başlagıç Tarihi"></cfsavecontent>
                                <cfinput value="#attributes.date1#" validate="#validate_style#" maxlength="10" required="Yes"message="#message#" type="text" name="date1" id="date1" style="width:65px;">
                                <span class="input-group-addon"><cf_wrk_date_image date_field="date1"></span>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                    <div class="form-group" id="item-branch_id">
                        <label class="col col-12"><cf_get_lang dictionary_id='57453.Şube'></label>
                        <div class="col col-12">
                            <select name="branch_id" id="branch_id">
                                <option value=""><cf_get_lang dictionary_id='57453.Şube'></option>
                                <cfoutput query="get_our_comp_and_branchs">
                                    <option value="#branch_id#"<cfif attributes.branch_id eq branch_id> selected</cfif>>#branch_name#</option>
                                </cfoutput>
                            </select>
                        </div>
                    </div>
                </div>
                <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                    <div class="form-group" id="item-status">
                        <label class="col col-12"><cf_get_lang dictionary_id='57756.Durum'></label>
                        <div class="col col-12">
                            <select name="status" id="status">
                                <option value=""><cf_get_lang dictionary_id='57756.Durum'></option>										
                                <option <cfif attributes.status eq 1 >selected</cfif> value="1"><cf_get_lang dictionary_id='53121.Kabul'></option>
                                <option <cfif attributes.status eq 0 >selected</cfif> value="0"><cf_get_lang dictionary_id='57617.Red'></option>
                            </select>
                        </div>
                    </div>
                </div>
            </cf_box_search_detail>
        </cfform>
    </cf_box>
    <cfsavecontent variable="message"><cf_get_lang dictionary_id="53538.Taksitli Avans Talepleri"></cfsavecontent>
    <cf_box title="#message#" uidrop="1" hide_table_column="1">
        <form name="form" method="post">
            <cf_grid_list>    
                <input type="hidden" name="other_payment_ids" id="other_payment_ids" value=""> 
                <thead>
                    <tr> 
                        <th width="30"><cf_get_lang dictionary_id='58577.Sıra'></th>
                        <th><cf_get_lang dictionary_id='54265.TC No'></th>
                        <th><cf_get_lang dictionary_id='57576.Çalışan'></th>
                        <th><cf_get_lang dictionary_id ='57629.Açıklama'></th>
                        <th style="text-align:right;"><cf_get_lang dictionary_id='57673.Tutar'></th>
                        <th><cf_get_lang dictionary_id = "41129.Süreç/Aşama"></th>
                        <th><cf_get_lang dictionary_id="45459.Ödeme Durumu"></th>
                        <th><cf_get_lang dictionary_id ='54064.Taksit Sayısı'></th>
                        <th><cf_get_lang dictionary_id='57742.Tarih'></th>
                        <!-- sil -->
                        <th width="20"><a href="javascript://" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=ehesap.list_other_payment_requests&event=add','medium')"><i class="fa fa-plus" title="<cf_get_lang dictionary_id='44630.Ekle'>" alt="<cf_get_lang dictionary_id='44630.Ekle'>"></i></th>
                        <!-- sil -->
                        <th width="20" class="header_icn_none text-center"><input type="checkbox" name="all_check" id="all_check" onclick="javascript:hepsi();"></th>

                    </tr>
                </thead>
                <tbody>
                    <cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
                    <cfif get_other_requests.recordcount>
                        <cfoutput query="get_other_requests" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#"> 
                            <tr>
                                <td>#currentrow#</td>
                                <td><cf_duxi type="label" name="TC_IDENTY_NO" id="TC_IDENTY_NO" value="#TC_IDENTY_NO#" hint="TC Kimlik No" gdpr="2"></td>
                                <td>#employee_name# #employee_surname#</td>
                                <td>
                                    <cfif isnumeric(IS_VALID)>
                                        <cfset MY_SEND="windowopen('#request.self#?fuseaction=ehesap.list_other_payment_requests&event=det&id=#SPGR_ID#','small');">
                                        <cfelse>
                                        <cfset MY_SEND="windowopen('#request.self#?fuseaction=ehesap.list_other_payment_requests&event=upd&id=#SPGR_ID#','medium');">
                                    </cfif>
                                    <a href="javascript://" class="tableyazi" onClick="#MY_SEND#">#DETAIL#</a>
                                </td>
                                <td style="text-align:right;"><cf_duxi name='tutar' class="tableyazi" type="label" value="#TLFormat(AMOUNT_GET)#" gdpr="7"></td>
                                <td><cf_workcube_process type="color-status" process_stage="#PROCESS_STAGE#"></td>
                                <td><cfif len(action_id)><font color="green"><cf_get_lang dictionary_id="33793.Ödendi"></font><cfelse><font color="red"><cf_get_lang dictionary_id="33792.Ödenmedi"></font></cfif></td>
                                <td align="center">#TAKSIT_NUMBER#</td>
                                <td>#dateformat(RECORD_DATE,dateformat_style)#</td>
                                <!-- sil --><td><a href="javascript://" onClick="#MY_SEND#"><i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>" alt="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a></td><!-- sil -->
                                <td style="text-align:center;">
                                    <cfif IS_VALID eq 1> <!---sadece onaylanmis olanlari getirmesi icin --->
                                        <cfif not len(action_id)> <!---ödeme yada giden havale işlem kaydı yok ise secime izin ver--->
                                            <input type="checkbox" name="is_sec" id="is_sec" value="#spgr_id#">
                                        <cfelse>
                                            <input type="checkbox" name="is_sec" id="is_sec" checked="checked" value="0" disabled="disabled">
                                        </cfif>
                                    <cfelse>
                                        <input type="checkbox" name="is_sec" id="is_sec" value="0" disabled="disabled">
                                    </cfif>
                                </td>
                            </tr>
                        </cfoutput> 
                        <cfelse>
                            <tr>
                                <td colspan="8"><cfif isdefined('attributes.form_submit')><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id='57701.Filtre Ediniz'>!</cfif></td>
                            </tr>
                    </cfif>
                </tbody>
            </cf_grid_list> 
        </form>
        <cf_paging page="#attributes.page#"
            maxrows="#attributes.maxrows#"
            totalrecords="#attributes.totalrecords#"
            startrow="#attributes.startrow#"
            adres="ehesap.list_other_payment_requests&#url_str#">
    </cf_box>
    <cf_box>
		<div class="ui-info-bottom flex-end">
			<cf_box_elements>
				<cfoutput>
						<div class="form-group">
							<select name="payment_type_id" id="payment_type_id">
								<option value=""><cf_get_lang dictionary_id='58928.Ödeme Tipi'></option>
								<cfloop query="get_special_definition">
									<option value="#special_definition_id#">#get_special_definition.special_definition#</option>
								</cfloop>
							</select>
						</div>
						<div class="form-group">
							<a href="javascript://" id="btn" name="btn" onclick="pencere_ac(1)" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='57835.Giden Havale'></a>
						</div>
						<div class="form-group">
							<a href="javascript://" id="btn2" name="btn2" onclick="pencere_ac(2)" class="ui-btn ui-btn-success"><cf_get_lang dictionary_id='57847.Ödeme'></a>
						</div>
				</cfoutput>
			</cf_box_elements>
		</div>
	</cf_box>
</div>
<script type="text/javascript">
    document.getElementById('keyword').focus();
    function pencere_ac(deger)
	{ 
		var sayac = 0;
		var money_control = 1;  
		var money_temp = '';
		<cfif get_other_requests.recordcount>
			<cfif get_other_requests.recordcount gt 1>
				if(form.is_sec != undefined)
				{
					for(i=0;i<form.is_sec.length;i++) 
					{
						if(form.is_sec[i] != undefined && document.form.is_sec[i].disabled != true && form.is_sec[i].checked == true)
						{
							sayac ++;
							if(document.getElementById('other_payment_ids').value.length==0) ayirac=''; else ayirac=',';
							document.getElementById('other_payment_ids').value=document.getElementById('other_payment_ids').value+ayirac+document.form.is_sec[i].value;
							if (money_temp == '')
								money_temp = $('#money_'+document.form.is_sec[i].value).val();
							if (money_temp != undefined && money_temp.length && money_temp != $('#money_'+document.form.is_sec[i].value).val())
								money_control = 0;
						}
					}
				}
				else if(document.form.is_sec.value != undefined && document.form.is_sec.value != 0 && document.form.is_sec.disabled != true)
				{
					sayac ++;
					document.getElementById('other_payment_ids').value = document.form.is_sec.value;
				}
			<cfelse>
				if(document.form.is_sec.value != undefined && document.form.is_sec.value != 0 && document.form.is_sec.disabled != true)
				{
					sayac ++;
					document.getElementById('other_payment_ids').value = document.form.is_sec.value;
				}
			</cfif>
			if (money_control == 0)
			{
				alert("<cf_get_lang dictionary_id='54615.Seçtiğiniz satırların para birimi aynı olmalıdır'>. <cf_get_lang dictionary_id='33877.Lütfen kontrol ediniz !'>");
				return false;
			}
			else if(sayac == 0)
			{
				alert("<cf_get_lang dictionary_id='57471.Eksik Veri'> : <cf_get_lang dictionary_id='57692.İşlem'>");
				return false;
			}
			else{
			windowopen('','wide','select_list_window');
			if(deger == 1)
			{
				form.action='<cfoutput>#request.self#?fuseaction=bank.form_add_gidenh&event=addMulti</cfoutput>';
			}
			else if (deger == 2)
			{
				form.action='<cfoutput>#request.self#?fuseaction=cash.form_add_cash_payment&event=addMulti</cfoutput>';
			}
			form.target='select_list_window';
			form.submit();
			document.getElementById('other_payment_ids').value='';
			}
		</cfif>
	}
    function hepsi()
	{
		if (document.getElementById('all_check').checked)
			{
		<cfif get_other_requests.recordcount gt 1>	
			for(i=0;i<form.is_sec.length;i++) 
			{
				form.is_sec[i].checked = true;
			}
		<cfelseif get_other_requests.recordcount eq 1>
			form.is_sec.checked = true;
		</cfif>
			}
		else
			{
		<cfif get_other_requests.recordcount gt 1>	
			for(i=0;i<form.is_sec.length;i++) 
			{
				form.is_sec[i].checked = false;
			}
		<cfelseif get_other_requests.recordcount eq 1>
			form.is_sec.checked = false;
		</cfif>
			}
	}
</script>
