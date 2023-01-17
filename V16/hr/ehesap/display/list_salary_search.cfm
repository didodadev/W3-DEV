<cfscript>
	duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
	QueryAddRow(duty_type,9);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('main',164)#",1);//çalışan
	QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',194)#",2);//işveren vekili
	QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',604)#",3);//işveren
	QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',206)#",4);//Sendikalı
	QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',232)#",5);//Sözleşmeli
	QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',223)#",6);//Kapsam Dışı
	QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',236)#",7);//Kısmi İstihdam
	QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',253)#",8);//Taşeron
	QuerySetCell(duty_type,"DUTY_TYPE_ID",8,9);//derece-kademe
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#getLang('ehesap',1233)#/#getLang('main',1298)#",9);
</cfscript>
<cf_box>
    <cfform name="search" method="post" action="#request.self#?fuseaction=#listgetat(attributes.fuseaction,1,'.')#.list_salary" onsubmit="control_();">
        <cf_box_search>
            <cfinclude template="../query/get_ssk_offices.cfm">
            <div class="form-group">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57460.Filtre'></cfsavecontent>
                <cfinput type="text" name="keyword" placeholder="#message#" style="width:100px;" value="#attributes.keyword#" maxlength="50">
            </div>
            <div class="form-group">
                <select name="salary_month" id="salary_month">
                    <cfloop from="1" to="12" index="i">
                        <cfset ay_bu=ListGetAt(ay_list(),i)>
                        <cfoutput><option value="#i#" <cfif attributes.salary_month eq i>Selected</cfif> >#ay_bu#</option></cfoutput>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <select name="salary_year" id="salary_year">
                    <cfloop from="#year(now())-3#" to="#year(now())+3#" index="i">
                        <cfoutput>
                            <option value="#i#"<cfif attributes.salary_year eq i> selected</cfif>>#i#</option>
                        </cfoutput>
                    </cfloop>
                </select>
            </div>
            <div class="form-group">
                <select name="branch_id" id="branch_id" onChange="showDepartment(this.value)">
                    <option value="all" <cfif isdefined("attributes.branch_id") and attributes.branch_id is 'all'>selected</cfif>><cf_get_lang dictionary_id='29434.Şubeler'></option>
                    <cfoutput query="get_ssk_offices" group="nick_name">
                        <optgroup label="#nick_name#"></optgroup>
                        <cfoutput>
                            <option value="#BRANCH_ID#"<cfif isdefined("attributes.branch_id") and (attributes.branch_id eq branch_id)> selected</cfif>>#BRANCH_NAME#</option>
                        </cfoutput>
                    </cfoutput>
                </select>
            </div>
            <div class="form-group" id="DEPARTMENT_PLACE">
                <select name="department" id="department" style="width:150px;">
                    <option value=""><cf_get_lang dictionary_id='57572.Departman'></option>
                    <cfif isdefined('attributes.branch_id') and isnumeric(attributes.branch_id)>
                        <cfquery name="get_departmant" datasource="#dsn#">
                            SELECT 
                                BRANCH_ID, 
                                DEPARTMENT_ID, 
                                DEPARTMENT_HEAD, 
                                ADMIN1_POSITION_CODE, 
                                ADMIN2_POSITION_CODE, 
                                HIERARCHY 
                            FROM 
                                DEPARTMENT 
                            WHERE 
                                BRANCH_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#attributes.branch_id#"> 
                            ORDER BY 
                                DEPARTMENT_HEAD
                        </cfquery>
                        <cfoutput query="get_departmant">
                            <option value="#DEPARTMENT_ID#"<cfif isdefined('attributes.department') and (attributes.department eq get_departmant.DEPARTMENT_ID)>selected</cfif>>#DEPARTMENT_HEAD#</option>
                        </cfoutput>
                    </cfif>
                </select>
            </div>
            <div class="form-group">
                <select name="collar_type" id="collar_type">
                    <option value=""><cf_get_lang dictionary_id='54054.Yaka Tipi'></option>
                    <option value="1"<cfif attributes.collar_type eq 1> selected</cfif>><cf_get_lang dictionary_id='54055.Mavi Yaka'></option> 
                    <option value="2"<cfif attributes.collar_type eq 2> selected</cfif>><cf_get_lang dictionary_id='54056.Beyaz Yaka'></option>
                </select>
            </div>
            <div class="form-group">
                <select name="status_isactive" id="status_isactive">
                    <option value="1"<cfif isDefined('attributes.status_isactive') and (attributes.status_isactive eq 1)> selected</cfif>><cf_get_lang dictionary_id='57493.Aktif'></option>
                    <option value="0"<cfif isDefined('attributes.status_isactive') and (attributes.status_isactive eq 0)> selected</cfif>><cf_get_lang dictionary_id='57494.Pasif'></option>  
                </select>
            </div>
            <div class="form-group small">
                <cfsavecontent variable="message"><cf_get_lang dictionary_id='57537.Sayi_Hatasi_Mesaj'></cfsavecontent>
                <cfinput type="text" name="maxrows" style="width:25px;" value="#attributes.maxrows#" validate="integer" range="1,250" required="yes" onKeyUp="isNumber(this)" maxlength="3" message="#message#">  
            </div>
            <div class="form-group">
                <cf_wrk_search_button button_type="4">
                <cf_workcube_file_action pdf='1' mail='1' doc='1' print='1'>
            </div>
        </cf_box_search>
        <cf_box_search_detail>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="1" sort="true">
                <div class="form-group" id="item-hierarchy">
                    <label class="col col-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
                    <div class="col col-12">
                        <cfinput type="text" name="hierarchy" style="width:70px;" value="#attributes.hierarchy#" maxlength="50">
                    </div>
                </div>
                <div class="form-group" id="item-status_sabit_prim">
                    <label class="col col-12"><cf_get_lang dictionary_id='58928.Ödeme Tipi'></label>
                    <div class="col col-12">
                        <select name="status_sabit_prim" id="status_sabit_prim">
                            <option value=""><cf_get_lang dictionary_id='58928.Ödeme Tipi'></option>
                            <option value="0"<cfif isDefined('attributes.status_sabit_prim') and (attributes.status_sabit_prim eq 0)> selected </cfif>><cf_get_lang dictionary_id ='58544.Sabit'></option>
                            <option value="1"<cfif isDefined('attributes.status_sabit_prim') and (attributes.status_sabit_prim eq 1)> selected </cfif>><cf_get_lang dictionary_id ='53558.Primli'></option>  
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-ssk_status">
                    <label class="col col-12"><cf_get_lang dictionary_id ='53606.SSK Durumu'></label>
                    <div class="col col-12">
                        <select name="ssk_status" id="ssk_status">
                            <option value=""><cf_get_lang dictionary_id ='53606.SSK Durumu'></option>
                            <option value="1"<cfif isDefined('attributes.ssk_status') and (attributes.ssk_status eq 1)> selected</cfif>><cf_get_lang dictionary_id ='54046.SSK lı Çalışan'></option>
                            <option value="0"<cfif isDefined('attributes.ssk_status') and (attributes.ssk_status eq 0)> selected</cfif>><cf_get_lang dictionary_id ='54047.SSK lı Olmayan'></option>  
                        </select>
                    </div>
                </div>
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="2" sort="true">
                <div class="form-group" id="item-DEFECTION_LEVEL">
                    <label class="col col-12"><cf_get_lang dictionary_id ='35266.Sakatlık Derecesi'></label>
                    <div class="col col-12">
                        <select name="DEFECTION_LEVEL" id="DEFECTION_LEVEL">
                            <option value=""><cf_get_lang dictionary_id ='35266.Sakatlık Derecesi'></option>
                            <option value="0" <cfif attributes.defection_level eq 0>selected</cfif>><cf_get_lang dictionary_id='58546.Yok'></option>
                            <option value="1" <cfif attributes.defection_level eq 1>selected</cfif>>1</option>
                            <option value="2" <cfif attributes.defection_level eq 2>selected</cfif>>2</option>
                            <option value="3" <cfif attributes.defection_level eq 3>selected</cfif>>3</option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-ssk_statute">
                    <label class="col col-12"><cf_get_lang dictionary_id ='53553.sGK statu'></label>
                    <div class="col col-12">
                        <select name="ssk_statute" id="ssk_statute" style="width:130px;">
                            <option value=""><cf_get_lang dictionary_id ='53553.sGK statu'></option>
                            <cfset count_ = 0>
                            <cfloop list="#list_ucret()#" index="ccn">
                                <cfset count_ = count_ + 1>
                                <cfoutput><option value="#ccn#" <cfif attributes.ssk_statute eq ccn>selected</cfif>>#listgetat(list_ucret_names(),count_,'*')#</option></cfoutput>
                            </cfloop>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-lower_salary_range">
                    <label class="col col-12"><cf_get_lang dictionary_id='52948.Maaş Aralığı'></label>
                    <div class="col col-12">
                        <div class="input-group">
                            <cfinput type="text" name="lower_salary_range" style="width:80px;" value="#attributes.lower_salary_range#" onkeyup="return(FormatCurrency(this,event));"/>
                            <span class="input-group-addon no-bg">-</span>
                            <cfinput type="text" name="upper_salary_range" style="width:80px;" value="#attributes.upper_salary_range#" onkeyup="return(FormatCurrency(this,event));"/>
                        </div>
                    </div>
                </div>
            </div>
            <div class="col col-3 col-md-4 col-sm-6 col-xs-12" type="column" index="3" sort="true">
                <div class="form-group" id="item-SALARY_TYPE">
                    <label class="col col-12"><cf_get_lang dictionary_id="53714.Ücret Yöntemi"></label>
                    <div class="col col-12">
                        <select name="SALARY_TYPE" id="SALARY_TYPE" style="width:130px;">
                            <option value=""><cf_get_lang dictionary_id="38983.Ücret Yöntemi"></option>
                            <option value="2" <cfif attributes.salary_type eq 2>selected</cfif>><cf_get_lang dictionary_id='58724.Ay'></option>
                            <option value="1" <cfif attributes.salary_type eq 1>selected</cfif>><cf_get_lang dictionary_id='57490.Gün'></option>
                            <option value="0" <cfif attributes.salary_type eq 0>selected</cfif>><cf_get_lang dictionary_id='57491.Saat'></option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="item-duty_type">
                    <label class="col col-12"><cf_get_lang dictionary_id="58538.Görev Tipi"></label>
                    <div class="col col-12">
                        <cf_multiselect_check 
                        query_name="duty_type"  
                        name="duty_type"
                        width="135" 
                        option_value="DUTY_TYPE_ID"
                        option_name="DUTY_TYPE_NAME"
                        value="#attributes.duty_type#"
                        option_text="#getLang('main',1126)#">
                    </div>
                </div>
                <div class="form-group" id="item-law_numbers">
                    <label class="col col-12"><cf_get_lang dictionary_id="39087.Kanun Maddeleri"></label>
                    <div class="col col-12">
                        <select name="law_numbers" id="law_numbers" style="width:120px;" onchange="date_view();">
                            <option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
                            <option value="5921"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '5921'>selected</cfif>>5921</option>
                            <option value="574680"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '574680'>selected</cfif>>5746 (% 80)</option>
                            <option value="574690"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '574690'>selected</cfif>>5746 (% 90)</option>
                            <option value="574695"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '574695'>selected</cfif>>5746 (% 95)</option>
                            <option value="5746100"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '5746100'>selected</cfif>>5746 (% 100)</option>
                            <option value="6111" <cfif len(attributes.law_numbers) and attributes.law_numbers eq '6111'>selected</cfif>>6111</option>
                            <option value="5084"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '5084'>selected</cfif>>5084 (<cf_get_lang dictionary_id ='53986.Teşvik Yasası'>)</option>
                            <option value="5763" onchange="" <cfif len(attributes.law_numbers) and attributes.law_numbers eq '5763'>selected</cfif>>5763 (<cf_get_lang dictionary_id ='54136.Yeni İstihdam'>)</option>
                            <option value="6486"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '6486'>selected</cfif>>6486 (<cf_get_lang dictionary_id="45455.İlave Teşviki">)</option>
                            <option value="6322"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '6322'>selected</cfif>>6322 (<cf_get_lang dictionary_id="45453.Yatırım Teşviki">)</option>
                            <option value="25510"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '25510'>selected</cfif>>25510 (<cf_get_lang dictionary_id="45455.İlave Teşviki">)</option>
                            <option value="4691"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '4691'>selected</cfif>>4691 (% 100)</option>
                            <option value="14857"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '14857'>selected</cfif>>14857 ( %100 <cf_get_lang dictionary_id="45431.Engelli Teşviki"> )</option>
                            <option value="6645" <cfif len(attributes.law_numbers) and attributes.law_numbers eq '6645'>selected</cfif>>6645 ( <cf_get_lang dictionary_id="45432.İşbaşı Eğitim Teşviki"> )</option>
                            <option value="46486"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '46486'>selected</cfif>>46486</option>
                            <option value="56486"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '56486'>selected</cfif>>56486</option>
                            <option value="66486"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '66486'>selected</cfif>>66486</option>
                            <option value="68750" <cfif len(attributes.law_numbers) and attributes.law_numbers eq '68750'>selected</cfif>>687 (%50)</option>
                            <option value="687100" <cfif len(attributes.law_numbers) and attributes.law_numbers eq '687100'>selected</cfif>>687 (%100)</option>
                            <option value="17103" <cfif len(attributes.law_numbers) and attributes.law_numbers eq '17103'>selected</cfif>>17103 (<cf_get_lang dictionary_id="45435.İmalat ve Bilişim">)</option>
                            <option value="27103" <cfif len(attributes.law_numbers) and attributes.law_numbers eq '27103'>selected</cfif>>27103 (<cf_get_lang dictionary_id="45430.Diğer Sektörler">)</option>
                            <option value="37103" <cfif len(attributes.law_numbers) and attributes.law_numbers eq '37103'>selected</cfif>>37103 (<cf_get_lang dictionary_id="45618.Bir Senden Bir Benden">)</option>
                            <option value="ARGE80"<cfif len(attributes.law_numbers) and attributes.law_numbers eq 'ARGE80'>selected</cfif>>ARGE 5746 (% 80)</option>
                            <option value="ARGE90"<cfif len(attributes.law_numbers) and attributes.law_numbers eq 'ARGE90'>selected</cfif>>ARGE 5746 (% 90)</option>
                            <option value="ARGE95"<cfif len(attributes.law_numbers) and attributes.law_numbers eq 'ARGE95'>selected</cfif>>ARGE 5746 (% 95)</option>
                            <option value="ARGE100"<cfif len(attributes.law_numbers) and attributes.law_numbers eq 'ARGE100'>selected</cfif>>ARGE 5746 (% 100)</option>
                            <option value="7252"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '7252'>selected</cfif>>7252</option>
                            <option value="17256"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '17256'>selected</cfif>>17256</option>
                            <option value="27256"<cfif len(attributes.law_numbers) and attributes.law_numbers eq '27256'>selected</cfif>>27256</option>
                        </select>
                    </div>
                </div>
                <div class="form-group" id="date_" <cfif not listfind('6111,5763',attributes.law_numbers,',')>style="display:none"</cfif>>
                    <label class="col col-12"><cf_get_lang dictionary_id="39087.Kanun Maddeleri"></label>
                    <div class="col col-12">
                        <div class="input-group">
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
                            <cfif len(attributes.law_startdate)>
                                <cfinput type="text" name="law_startdate" id="law_startdate" value="#dateformat(attributes.law_startdate,dateformat_style)#" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
                            <cfelse>
                                <cfinput type="text" name="law_startdate" id="law_startdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
                            </cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="law_startdate"></span>
                            <span class="input-group-addon no-bg"></span>
                            <cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
                            <cfif len(attributes.law_finishdate)>
                                <cfinput type="text" name="law_finishdate" id="law_finishdate" value="#dateformat(attributes.law_finishdate,dateformat_style)#" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
                            <cfelse>
                                <cfinput type="text" name="law_finishdate" id="law_finishdate" style="width:65px;" maxlength="10" validate="#validate_style#" message="#message#" >
                            </cfif>
                            <span class="input-group-addon"><cf_wrk_date_image date_field="law_finishdate"></span>
                        </div>
                    </div>
                </div>
            </div>
        </cf_box_search_detail>
    </cfform>
</cf_box>