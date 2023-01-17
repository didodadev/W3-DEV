<cf_xml_page_edit fuseact="ehesap.popup_form_add_ek_odenek_all">
<cfparam name="attributes.duty_type" default="">
<cfparam name="attributes.title_id" default="">
<cfparam name="attributes.func_id" default="">
<cfparam name="attributes.pos_cat_id" default="">
<cfparam name="attributes.branch_id" default="">
<cfparam name="attributes.department_id" default="">
<cfparam name="attributes.collar_type" default="">
<cfparam name="attributes.copy" default="">
<cfparam name="attributes.comment_pay_0" default="">
<cfparam name="attributes.odkes_id_0" default="">
<cfparam name="attributes.term_0" default="">
<cfparam name="attributes.start_sal_mon_0" default="">
<cfparam name="attributes.end_sal_mon_0" default="">
<cfparam name="attributes.inout_statue" default="2">
<cfscript>
	bu_ay_basi = CreateDate(year(now()),month(now()),1);
	bu_ay_sonu = DaysInMonth(bu_ay_basi);
</cfscript>
<cfparam name="attributes.startdate" default="1/#month(now())#/#year(now())#">
<cfparam name="attributes.finishdate" default="#bu_ay_sonu#/#month(now())#/#year(now())#">
<cfsavecontent variable="message"><cf_get_lang dictionary_id='57576.Çalışan'></cfsavecontent>
<cfsavecontent variable="message2"><cf_get_lang dictionary_id='53140.İşveren Vekili'></cfsavecontent>
<cfsavecontent variable="message3"><cf_get_lang dictionary_id='53550.İşveren'></cfsavecontent>
<cfsavecontent variable="message4"><cf_get_lang dictionary_id='53152.Sendikalı'></cfsavecontent>
<cfsavecontent variable="message5"><cf_get_lang dictionary_id='53178.Sözleşmeli'></cfsavecontent>
<cfsavecontent variable="message6"><cf_get_lang dictionary_id='53169.Kapsam Dışı'></cfsavecontent>
<cfsavecontent variable="message7"><cf_get_lang dictionary_id='53182.Kısmi İstihdam'></cfsavecontent>
<cfsavecontent variable="message8"><cf_get_lang dictionary_id='53199.Taşeron'></cfsavecontent>
<cfsavecontent variable="message9"><cf_get_lang dictionary_id='54055.Mavi Yaka'></cfsavecontent>
<cfsavecontent variable="message10"><cf_get_lang dictionary_id='54056.Beyaz Yaka'></cfsavecontent>
<cfset periods = createObject('component','V16.objects.cfc.periods')>
<cfset period_years = periods.get_period_year()>
<cfset get_departments_info = createObject('component','V16.hr.ehesap.cfc.get_branch_dept_info')><!--- Bütün departmanlar 20191003ERU --->
<cfset get_departments = get_departments_info.get_all_departments()>
<cfscript>
	duty_type = QueryNew("DUTY_TYPE_ID, DUTY_TYPE_NAME");
	QueryAddRow(duty_type,8);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",2,1);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message#",1);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",1,2);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message2#",2);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",0,3);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message3#",3);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",3,4);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message4#",4);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",4,5);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message5#",5);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",5,6);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message6#",6);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",6,7);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message7#",7);
	QuerySetCell(duty_type,"DUTY_TYPE_ID",7,8);
	QuerySetCell(duty_type,"DUTY_TYPE_NAME","#message8#",8);

	collar_type = QueryNew("COLLAR_TYPE_ID, COLLAR_TYPE_NAME");
	QueryAddRow(collar_type,2);
	QuerySetCell(collar_type,"COLLAR_TYPE_ID",1,1);
	QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#message9#",1);
	QuerySetCell(collar_type,"COLLAR_TYPE_ID",2,2);
	QuerySetCell(collar_type,"COLLAR_TYPE_NAME","#message10#",2);
</cfscript>
<cfquery name="all_pos_cats" datasource="#DSN#">
	SELECT 
		POSITION_CAT_ID,
		POSITION_CAT
	FROM
		SETUP_POSITION_CAT
	ORDER BY
		POSITION_CAT
</cfquery>
<cfinclude template="../query/get_ssk_offices.cfm">

<cfquery name="get_title" datasource="#dsn#">
	SELECT TITLE_ID,TITLE FROM SETUP_TITLE WHERE IS_ACTIVE = 1 ORDER BY TITLE
</cfquery>
<cfquery name="get_func" datasource="#dsn#">
	SELECT UNIT_ID,UNIT_NAME FROM SETUP_CV_UNIT WHERE IS_ACTIVE = 1 ORDER BY UNIT_NAME
</cfquery>
<cfsavecontent variable="secmessage"><cf_get_lang dictionary_id="57734.Seçiniz"></cfsavecontent>
<cf_catalystHeader>
<cf_box>
	<cfform name="add_ext_salary_search" action="#request.self#?fuseaction=ehesap.list_payments&event=det" method="post">
		<input type="hidden" name="is_submitted" id="is_submitted" value="1">
		<div class="row ui-form-list" type="row">
			<div class="col col-5 col-md-6 col-sm-6 col-xs-12" type="column" index="1" sort="true">
				<div class="form-group" id="item-pos_cat_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='59004.Pozisyon Tipi'></label>
					<div class="col col-8 col-xs-12 ">
						<cf_multiselect_check 
							query_name="all_pos_cats"  
							name="pos_cat_id"
							width="150" 
							option_text="#secmessage#"
							option_value="POSITION_CAT_ID"
							option_name="POSITION_CAT"
							value="#attributes.pos_cat_id#">
					</div>
				</div>
				<div class="form-group" id="item-collar_type">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='54054.yaka tipi'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check 
							query_name="collar_type"  
							name="collar_type"
							width="100" 
							option_text="#secmessage#"
							option_value="COLLAR_TYPE_ID"
							option_name="COLLAR_TYPE_NAME"
							value="#attributes.collar_type#">
					</div>
				</div>
				<div class="form-group" id="item-branch_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57453.Şube'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check 
							query_name="get_ssk_offices"  
							name="branch_id"
							width="150" 
							option_text="#secmessage#"
							option_value="BRANCH_ID"
							option_name="BRANCH_NAME"
							value="#attributes.branch_id#">
					</div>
				</div>
				<div class="form-group" id="item-department_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57572.Departman'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check 
							query_name="get_departments"  
							name="department_id"
							width="150" 
							option_text="#secmessage#"
							option_value="DEPARTMENT_ID"
							option_name="DEPARTMENT_HEAD"
							value="#attributes.department_id#">
					</div>
				</div>
				<div class="form-group" id="item-duty_type">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58538.Görev Tipi'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check 
							query_name="duty_type"  
							name="duty_type"
							width="120" 
							option_text="#secmessage#"
							option_value="DUTY_TYPE_ID"
							option_name="DUTY_TYPE_NAME"
							value="#attributes.duty_type#">
					</div>
				</div>
				<div class="form-group" id="item-func_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58701.Fonksiyon'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check 
							query_name="get_func"  
							name="func_id"
							width="120" 
							option_text="#secmessage#"
							option_value="UNIT_ID"
							option_name="UNIT_NAME"
							value="#attributes.func_id#">
					</div>
				</div>
				<div class="form-group" id="item-title_id">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57571.Ünvan'></label>
					<div class="col col-8 col-xs-12">
						<cf_multiselect_check 
							query_name="get_title"  
							name="title_id"
							width="120" 
							option_text="#secmessage#"
							option_value="TITLE_ID"
							option_name="TITLE"
							value="#attributes.title_id#">
					</div>
				</div>
			</div>
			<div class="col col-5 col-md-6 col-sm-6 col-xs-12" type="column" index="2" sort="true">
				<div class="form-group" id="item-copy">
					<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='51198.Ek Ödenek Kopyalama'></label>
					<div class="col col-8 col-xs-12">
						<input type="checkbox" name="copy" id="copy" value="1" onclick="change_filter();" <cfif isdefined("attributes.copy") and len(attributes.copy)>checked</cfif>>
					</div>
				</div>
				<div id="special_code" <cfif isdefined("attributes.copy") and len(attributes.copy)> style="display:none;"</cfif>>
					<div class="form-group medium" id="item-hierarchy">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57789.Özel Kod'></label>
						<div class="col col-8 col-xs-12">
							<input type="text" id="hierarchy" name="hierarchy" style="width:150px" value="<cfif isdefined('attributes.hierarchy') and len(attributes.hierarchy)><cfoutput>#attributes.hierarchy#</cfoutput></cfif>">
						</div>
					</div>
					<div class="form-group medium" id="item-inout_statue">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id="55539.Çalışma Durumu"></label>
						<div class="col col-8 col-xs-12">
							<select name="inout_statue" id="inout_statue" style="width:120px">
								<option value="3"><cf_get_lang dictionary_id='29518.Girişler ve Çıkışlar'></option>
								<option value="1"<cfif attributes.inout_statue eq 1> selected</cfif>><cf_get_lang dictionary_id='58535.Girişler'></option>
								<option value="0"<cfif attributes.inout_statue eq 0> selected</cfif>><cf_get_lang dictionary_id='58536.Çıkışlar'></option>
								<option value="2"<cfif attributes.inout_statue eq 2> selected</cfif>><cf_get_lang dictionary_id='55905.Aktif Çalışanlar'></option>
							</select>
						</div>
					</div>
					<div class="form-group medium" id="item-inout_statue">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='30513.Marital Status'></label>
						<div class="col col-8 col-xs-12">
							<select name="is_single" id="is_single" style="width:120px">
								<option value=""><cf_get_lang dictionary_id="57734.Seçiniz"></option>
								<option value="1"><cf_get_lang dictionary_id='30501.Married'></option>
								<option value="0"><cf_get_lang dictionary_id='30694.Single'></option>
							</select>
						</div>
					</div>
					<div class="form-group medium" id="item-startdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='58053.Başlangıç Tarihi'></cfsavecontent>
								<cfif isdefined('attributes.startdate') and isdate(attributes.startdate)>
									<cfinput type="text" name="startdate" id="startdate" style="width:100px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.startdate,dateformat_style)#">
								<cfelse>
									<cfinput type="text" name="startdate" id="startdate" style="width:100px;" maxlength="10" validate="#validate_style#" message="#message#" >
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="startdate"></span>
							</div>
						</div>
					</div>
					<div class="form-group medium" id="item-finishdate">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57700.Bitiş Tarihi'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfsavecontent variable="message"><cf_get_lang dictionary_id="57471.Eksik Veri"> : <cf_get_lang dictionary_id='57700.Bitiş Tarihi'></cfsavecontent>
								<cfif isdefined("attributes.finishdate") and isdate(attributes.finishdate)>
									<cfinput type="text" name="finishdate" id="finishdate" style="width:100px;" maxlength="10" validate="#validate_style#" message="#message#" value="#dateformat(attributes.finishdate,dateformat_style)#">
								<cfelse>
									<cfinput type="text" name="finishdate" id="finishdate" style="width:100px;" maxlength="10" validate="#validate_style#" message="#message#" >
								</cfif>
								<span class="input-group-addon"><cf_wrk_date_image date_field="finishdate"></span>
							</div>
						</div>
					</div>
				</div>
				<div id="copy_div" <cfif not(isdefined("attributes.copy") and len(attributes.copy))>style="display:none;"</cfif>><!--- Ek Ödenek Kopyalama 20191002ERU --->
					<div class="form-group medium" id="item-comment_pay">
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='53290.Ödenek Türü'></label>
						<div class="col col-8 col-xs-12">
							<div class="input-group">
								<cfoutput>
									<input type="hidden" value="#attributes.odkes_id_0#" name="odkes_id_0" id="odkes_id_0" />
									<input type="text" name="comment_pay_0" id="comment_pay_0" style="width:150px;" value="#attributes.comment_pay_0#" readonly >
									<span class="input-group-addon icon-ellipsis btnPointer" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_list_odenek','medium');"></span>
								</cfoutput>
							</div>
						</div>
					</div>
					<div class="form-group medium" id="item-title" >
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='58472.Dönem'></label>
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57501.Başlangıç'></label>
						<label class="col col-4 col-xs-12"><cf_get_lang dictionary_id='57502.Bitiş'></label>									
					</div>
					<div class="form-group medium" id="item-term_0">
						<div class="col col-4 col-xs-12">
							<select name="term_0" id="term_0">
								<cfloop from="#period_years.period_year[1]#" to="#period_years.period_year[period_years.recordcount]+3#" index="i">
								<cfoutput>
									<option value="#i#"<cfif len(attributes.term_0) and attributes.term_0 eq i>selected<cfelseif year(now()) eq i> selected</cfif>>#i#</option>
								</cfoutput>
								</cfloop>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<select name="start_sal_mon_0" id="start_sal_mon_0">
								<cfloop from="1" to="12" index="j">
									<cfoutput><option value="#j#" <cfif len(attributes.start_sal_mon_0) and attributes.start_sal_mon_0 eq j>selected</cfif>>#listgetat(ay_list(),j,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>
						<div class="col col-4 col-xs-12">
							<select name="end_sal_mon_0" id="end_sal_mon_0" style="width:100%;">
								<cfloop from="1" to="12" index="j">
									<cfoutput><option value="#j#" <cfif len(attributes.end_sal_mon_0) and attributes.end_sal_mon_0 eq j>selected</cfif>>#listgetat(ay_list(),j,',')#</option></cfoutput>
								</cfloop>
							</select>
						</div>									
					</div>
				</div>
			</div>
		</div>
		<cf_box_footer>
			<div>
				<cfsavecontent variable="buttonName"><cf_get_lang dictionary_id="57911.Çalıştır"></cfsavecontent>
				<cf_wrk_search_button button_type="2" button_name="#buttonName#" add_function="control();">
			</div>
		</cf_box_footer>
	</cfform>
</cf_box>
<script type="text/javascript">
	function change_filter(){//Ek Ödenek Kopyalama Div'i için eklenmiştir. 20191001ERU
		if(add_ext_salary_search.copy.checked == true){
			copy_div.style.display = '';
			special_code.style.display = 'none';
			row_count = 1;
		}else{
			special_code.style.display = '';
			copy_div.style.display = 'none';
		}
	}
	function control(){//Ek Ödenek Kopyalama İşlemi ise Özel Kod, Çalışma Durumu, Başlangıç Ve Bitiş tarihleri boşaltılıyor.
		if(add_ext_salary_search.copy.checked == true){
			document.getElementById("hierarchy").value  = '';
			document.getElementById("inout_statue").value  = '';
			document.getElementById("startdate").value  = '';
			document.getElementById("finishdate").value  = '';
			toplam_hesapla();
		}else{
			document.getElementById("odkes_id_0").value  = '';
			document.getElementById("comment_pay_0").value  = '';
		
			document.getElementById("start_sal_mon_0").value  = '';	
			document.getElementById("end_sal_mon_0").value  = '';
		}
	}
		function add_row(is_damga,is_issizlik,ssk,tax,is_kidem,show,comment_pay,period_pay,method_pay,term,start_sal_mon,end_sal_mon,amount_pay,calc_days,from_salary,row_id_,ehesap,ayni_yardim,ssk_exemption_rate,tax_exemption_rate,tax_exemption_value,money,odkes_id,ssk_exemption_type)
	{
		if(row_count == 0 )
		{
			alert("<cf_get_lang dictionary_id='53611.Satır Eklemediniz'>!");
			return false;
		}
		
		if(row_id_ != undefined && row_id_ != '' && row_id_ != '0')
		{	
			document.getElementById('show'+row_id_).value = show;
			document.getElementById('odkes_id'+row_id_).value = odkes_id;
			document.getElementById('comment_pay'+row_id_).value=comment_pay;
			document.getElementById('start_sal_mon'+row_id_).value=start_sal_mon;
			document.getElementById('end_sal_mon'+row_id_).value=end_sal_mon;
			document.getElementById('amount_pay'+row_id_).value=amount_pay;
			document.getElementById('term'+row_id_).value=term;
			toplam_hesapla();
		}
		else if(row_id_ != undefined && row_id_ == '0')
		{
			document.getElementById('show0').value=show;
			hepsi(row_count,'show');
			goster(show);
			document.getElementById('odkes_id0').value = odkes_id;
			hepsi(row_count,'odkes_id');
			document.getElementById('comment_pay0').value=comment_pay;
			hepsi(row_count,'comment_pay');
			document.getElementById('term0').value=term;
			hepsi(row_count,'term');
			document.getElementById('start_sal_mon0').value=start_sal_mon;
			hepsi(row_count,'start_sal_mon');
			document.getElementById('end_sal_mon0').value=end_sal_mon;
			hepsi(row_count,'end_sal_mon');
			document.getElementById('amount_pay0').value=amount_pay;
			hepsi(row_count,'amount_pay');
			toplam_hesapla();
		}else{
			document.getElementById('odkes_id_0').value = odkes_id;
			document.getElementById('comment_pay_0').value=comment_pay;
		}
	}
</script>