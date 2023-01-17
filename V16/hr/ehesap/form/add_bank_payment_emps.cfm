<cfinclude template="../query/get_branch.cfm">
<cfquery name="get_related_company" datasource="#dsn#">
	SELECT DISTINCT
		RELATED_COMPANY
	FROM 
		BRANCH
	WHERE
		BRANCH_ID IS NOT NULL AND
		RELATED_COMPANY IS NOT NULL
		<cfif not session.ep.ehesap>
			AND BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code# )
		</cfif>
	ORDER BY 
		RELATED_COMPANY
</cfquery>
<cfquery name="GET_ACCOUNTS" datasource="#DSN#">
	SELECT
		*
	FROM
		SETUP_BANK_TYPES
	WHERE 
		EXPORT_TYPE IS NOT NULL
	ORDER BY
		BANK_NAME
</cfquery>
<cfquery name="get_our_companies" datasource="#DSN#">
	SELECT
		NICK_NAME,
		COMP_ID
	FROM
		OUR_COMPANY
	<cfif not session.ep.ehesap>
	WHERE
		COMP_ID IN (SELECT COMPANY_ID FROM BRANCH WHERE BRANCH_ID IN (SELECT BRANCH_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE EMPLOYEE_POSITION_BRANCHES.POSITION_CODE = #session.ep.position_code#))
	</cfif>
	ORDER BY
		NICK_NAME
</cfquery>
<cfparam name="attributes.pay_mon" default="#dateformat(now(),'MM')#"> 
<cfparam name="attributes.pay_year" default="#session.ep.period_year#">
<cfparam name="attributes.pay_date" default="#dateformat(now(),dateformat_style)#">
<cfparam name="attributes.modal_id" default="">
<cf_box title="#getLang('','settings',55750)#"  scroll="1" collapsable="1" resize="1" popup_box="#iif(isdefined("attributes.draggable"),1,0)#">
<cfform name="banka_emri" action="#request.self#?fuseaction=ehesap.emptypopup_add_bank_payment_emps" method="post">
			<cf_box_elements>
                	<div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" sort="true" index="1">
                    	<div class="form-group" id="item-firm_code">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53782.Firma Kodu'></label>
                            <div class="col col-8 col-xs-12">
                            	<select name="firm_code" id="firm_code" style="width:200px;">
                                    <option value="0"><cf_get_lang dictionary_id ='53783.Ana Şirket Kodunu Kullan'></option>
                                    <option value="1"><cf_get_lang dictionary_id ='53784.Şube Kodunu Kullan'></option>
                                </select>
                            </div>
						</div>
                    	<div class="form-group" id="item-branch_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57453.Şube'></label>
                            <div class="col col-8 col-xs-12">
                            	<select name="branch_id" id="branch_id" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <cfoutput query="get_branch">
                                        <option value="#branch_id#">#branch_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    	<div class="form-group" id="item-our_company_id">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57574.Şirket'></label>
                            <div class="col col-8 col-xs-12">
                            	<select name="our_company_id" id="our_company_id" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <cfoutput query="get_our_companies">
                                        <option value="#comp_id#">#NICK_NAME#</option>
                                    </cfoutput>
                                </select>
                            </div>
                        </div>
                    	<div class="form-group" id="item-bank_id">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='29449.Banka Hesabı'> *</label>
                            <div class="col col-8 col-xs-12">
                            	<select name="bank_id" id="bank_id" style="width:200px;">
                                    <option value=""><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
                                    <cfoutput query="get_accounts">
                                        <option value="#bank_id#;#bank_name#;#EXPORT_TYPE#">#bank_name#</option>
                                    </cfoutput>
                                </select>
                            </div>
						</div>
                    	<div class="form-group" id="item-pay_year">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'> *</label>
                            <div class="col col-8 col-xs-12">
								<div class="col col-6 col-xs-12">
                                    <select name="pay_year" id="pay_year">
                                        <cfloop from="#session.ep.period_year-1#" to="#session.ep.period_year+1#" index="i">
                                            <cfoutput>
                                            <option value="#i#"<cfif attributes.pay_year eq i> selected</cfif>>#i#</option>
                                            </cfoutput>
                                        </cfloop>
                                    </select>
								</div><div class="col col-6 col-xs-12">
                                    <select name="pay_mon" id="pay_mon">
                                        <cfloop from="1" to="12" index="i">
                                            <cfoutput><option value="#i#" <cfif attributes.pay_mon is i>selected</cfif> >#listgetat(ay_list(),i,',')#</option></cfoutput>
                                        </cfloop>
                                    </select>
                                </div>
                            </div>
                        </div>
                    	<div class="form-group" id="item-pay_date">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58851.Ödeme Tarihi'> *</label>
                            <div class="col col-8 col-xs-12">
                            	<div class="input-group">
                                	<cfinput validate="#validate_style#" required="yes" message="Ödeme Tarihi Girmelisiniz"type="text" name="pay_date" id="pay_date" value="#attributes.pay_date#" style="width:85px;">
                                	<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="pay_date"></span>
                                </div>
                            </div>
                        </div>
                    	<div class="form-group" id="item-PAYMENT_TYPE">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'></label>
                            <div class="col col-8 col-xs-12">
                            	<select name="PAYMENT_TYPE" id="PAYMENT_TYPE" style="width:85px">
                                    <option value="1"><cf_get_lang dictionary_id='58544.Sabit'></option>
                                    <option value="3"><cf_get_lang dictionary_id ='53558.Primli'></option>								
                                    <option value="2"><cf_get_lang dictionary_id='58204.Avans'></option>
                                    <option value="4"><cf_get_lang dictionary_id ='53785.Sabit Primli'></option>							
                                </select>
                            </div>
						</div>
                    	<div class="form-group" id="item-detail">
                            <label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='57629.Açıklama'></label>
                            <div class="col col-8 col-xs-12"> 
                            	<textarea name="detail" id="detail" style="width:200px;height:50px;"></textarea>
                            </div>
                        </div>
						<div class="form-group">
						<div class="col col-12 bold"><cf_get_lang dictionary_id ='53786.Avans Ödemesi İse'></div>
						</div>
                    	<div class="form-group" id="item-avans_startdate">
                        	<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id ='53787.Avans Aralığı'></label>
                            <div class="col col-8 col-xs-12">
								<div class="col col-6 col-xs-12">
									<div class="input-group">
                                	<cfsavecontent variable="message"><cf_get_lang dictionary_id ='53788.Avans Tarihi Girmelisiniz'></cfsavecontent>
                                    <cfinput validate="#validate_style#" message="#message#" type="text" name="avans_startdate" id="avans_startdate" value=""> 
                                	<span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="avans_startdate"></span>
									</div>
									</div><div class="col col-6 col-xs-12">
										<div class="input-group">
                                    <cfinput validate="#validate_style#" message="#message#" type="text" name="avans_finishdate" id="avans_finishdate" value=""> 
                                    <span class="input-group-addon btnPointer"><cf_wrk_date_image date_field="avans_finishdate"></span>
									</div>
								</div>
                            </div>
						</div>
                    </div>
                	<div class="col col-6 col-md-6 col-sm-6 col-xs-6" type="column" sort="true" index="2">
						<div class="form-group" id="item-related_company">
                        	<label class="col col-12 bold"><cf_get_lang dictionary_id ='53789.İlgili Şirketler'></label>
							<cfoutput query="get_related_company">
                                <label class="col col-12"><input type="checkbox" name="related_company" id="related_company#currentrow#" value="#related_company#"> #related_company# </label>
                            </cfoutput>
                        </div>
                    </div>
				</cf_box_elements>
                <cf_box_footer>
                    	<cf_workcube_buttons is_upd='0' add_function='kontrol()'>
				</cf_box_footer>
</cfform>
</cf_box>
<script type="text/javascript">
	function kontrol()
	{
		related_ = 0;
		if (document.getElementsByName('related_company').length != undefined) /* n tane*/
		{
			for (i=1; i <= document.getElementsByName('related_company').length; i++)
			{
				if(document.getElementById('related_company'+i).checked==true)
					related_ = 1;							
			}
		}
		else /* 1 tane*/
		{			
			if(document.getElementById('related_company').checked==true)
				related_ = 1;				
		}
		
		if(document.getElementById('firm_code').value =='1' && related_==1)
			{
				alert("<cf_get_lang dictionary_id ='53790.Şube Kodunu Kullanarak Oluşturduğunuz Ödemede İlgili Şirket Seçemezsiniz'>!");
				return false;
			}
			
		if(document.getElementById('firm_code').value =='1' && document.getElementById('branch_id').value =='')
			{
				alert("<cf_get_lang dictionary_id ='53791.Şube Kodunu Kullanarak Oluşturduğunuz Ödemede Şube Seçmelisiniz'>!");
				return false;
			}
		
		if (related_==0 && document.getElementById('branch_id').value =='' && document.getElementById('our_company_id').value =='')
		{
			alert("<cf_get_lang dictionary_id ='53792.İlişkili Şirket veya Şube Seçiniz'>!");
			return false;
		}
		
		if(document.getElementById('avans_startdate').value.length != 0 && document.getElementById('avans_finishdate').value.length == 0)
		{
			alert("<cf_get_lang dictionary_id ='53793.Avans Çıkış Tarihi Olmadan Giriş Tarihi Kullanamazsınız'>!");
			return false;
		}
	
		if(document.getElementById('avans_finishdate').value.length != 0 && document.getElementById('avans_startdate').value.length == 0)
		{
			alert("<cf_get_lang dictionary_id ='53794.Avans Giriş Tarihi Olmadan Çıkış Tarihi Kullanamazsınız'>!");
			return false;
		}
		
		if(document.getElementById('bank_id').value == '')
		{
			alert("<cf_get_lang dictionary_id='48830.Banka Hesabı Seçmelisiniz'>!");
			return false;
		}
		
		return true;
	}
</script>