<!--- Detail_Company.cfm sayfasindan ajax ile cagriliyor --->
<cfsetting showdebugoutput="no">
<cfquery name="Get_Company_Info" datasource="#dsn#">
	SELECT FULLNAME,ISPOTANTIAL FROM COMPANY WHERE COMPANY_ID = #attributes.cpid#
</cfquery>
<cfset fullname_ = Replace(Get_Company_Info.Fullname,'"','','all')>
<script type="text/javascript">
	document.getElementById('member_head').innerHTML = '<cf_get_lang_main no="45.Müşteri"> : <cfoutput>#fullname_#</cfoutput><cfif Get_Company_Info.ispotantial eq 1> - <cf_get_lang_main no="165.Potansiyel"></cfif>';
</script>
<cfoutput>
	<ul class="ui-list">
		<li>
			<a href="#request.self#?fuseaction=crm.popup_company_summary&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_summary" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no='105.Özet Bilgi'>
				</div>
			</a>
		</li>
		<li>
			<a href="#request.self#?fuseaction=crm.popup_general_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_general_info" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang_main no='568.Genel Bilgiler'>
				</div>
			</a>
		</li>
		<li>
			<a href="#request.self#?fuseaction=crm.popup_upd_consumer_branch&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_upd_consumer_branch" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no='161.İlişkili Şubelerimiz'>
				</div>
			</a>
		</li>
		<li>
			<a href="javascript://" target="member_frame" onclick="show_hide('anlasma_detay')">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no ='98.Anlasma Yonetimi'>
				</div>
				<div class="ui-list-right">
					<i class="fa fa-chevron-down"></i>
				</div>
			</a>
			<ol id="anlasma_detay" style="display:none">
				<li>
					<a href="#request.self#?fuseaction=crm.popup_list_consumer_branch&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_list_consumer_branch" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no ='99.Ezcane Kategori Bilgileri'>
						</div>
					</a>
				</li>
				<li>
					<a href="#request.self#?fuseaction=crm.popup_list_branch_contracts_new&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_list_branch_contracts_new" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang_main no='25.Anlaşmalar'>
						</div>
					</a>
				</li>
				<!--- <li>
					<a href="javascript://" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no ='106.Sayım Sonuçları'>
						</div>
					</a>
				</li>
				<li>
					<a href="javascript://" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no ='111.Envanter Sonuçları'>
						</div>
					</a>
				</li>							
			 --->
			</ol>
		</li>
		
		<li>
			<a href="#request.self#?fuseaction=crm.popup_company_activity_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_activity_info" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no='179.Faaliyet Bilgileri'>
				</div>
			</a>
		</li>
		<li>
			<a href="#request.self#?fuseaction=crm.popup_list_visit_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_list_visit_info" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no='178.Ziyaret Bilgileri'>
				</div>
			</a>
		</li>
		<li>
			<a href="#request.self#?fuseaction=crm.popup_company_operation_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_operation_info" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no='156.Operasyon Bilgileri'>
				</div>
			</a>
		</li>
		<li>
			<a href="#request.self#?fuseaction=crm.popup_company_complaint_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_complaint_info" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no='180.Şikayet Bilgileri'>
				</div>
			</a>
		</li>
		<li>
			<a href="#request.self#?fuseaction=crm.popup_company_risk_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_risk_info" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no='547.Risk Yönetimi'>
				</div>
			</a>
		</li>
		<li>
			<a href="#request.self#?fuseaction=crm.popup_list_securefund&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_list_securefund" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no='552.Teminat Yönetimi'>
				</div>
			</a>
		</li>
		<li>
			<a href="#request.self#?fuseaction=crm.popup_list_company_requests&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_list_company_requests" target="member_frame">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang_main no='115.Talepler'>
				</div>
			</a>
		</li>
		<li>
			<a href="javascript://" target="member_frame" onclick="show_hide('other_info')">
				<div class="ui-list-left">
					<span class="ui-list-icon ctl-018-monitor"></span>
					<cf_get_lang no ='112.Diğer Bilgiler'>
				</div>
				<div class="ui-list-right">
					<i class="fa fa-chevron-down"></i>
				</div>
			</a>
			<ol id="other_info" style="display:none" >
				<li>
					<a href="#request.self#?fuseaction=crm.popup_special_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_special_info" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no='69.Eczacı Bilgileri'>
						</div>
					</a>
				</li>
				<li>
					<a href="#request.self#?fuseaction=crm.popup_company_assistance_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_assistance_info" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no='160.Yardımcı Personel Bilgileri'>
						</div>
					</a>
				</li>
				<li>
					<a href="#request.self#?fuseaction=crm.popup_company_act_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_act_info" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no='177.Etkinlik Bilgileri'>
						</div>
					</a>
				</li>
				<li>
					<a href="#request.self#?fuseaction=crm.popup_company_rival_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_rival_info" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no='176.Rakip Bilgileri'>
						</div>
					</a>
				</li>
				<li>
					<a href="#request.self#?fuseaction=crm.popup_company_work_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_work_info" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no='128.Çalışma Bilgileri'>
						</div>
					</a>
				</li>
				<li>
					<a href="#request.self#?fuseaction=crm.popup_company_action_plan&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_action_plan" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no ='113.Eylem Planı'>
						</div>
					</a>
				</li>
				<cfif get_module_user(40)>
					<li>
						<a href="#request.self#?fuseaction=crm.popup_company_service_info&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_company_service_info" target="member_frame">
							<div class="ui-list-left">
								<span class="ui-list-icon ctl-018-monitor"></span>
								<cf_get_lang no='172.Kargo Bilgileri'>
							</div>
						</a>
					</li>
				</cfif>
				<li>
					<a href="#request.self#?fuseaction=objects.popup_list_comp_add_info&info_id=#attributes.cpid#&type_id=-1&iframe=1&frame_fuseaction=popup_list_comp_add_info&is_nonpopup=1&is_musteri=1" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no='171.Ek Bilgiler'>
						</div>
					</a>
				</li>
				<li>
					<a href="#request.self#?fuseaction=crm.popup_dsp_company_docs&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_dsp_company_docs" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no='170.Notlar Belgeler'>
						</div>
					</a>
				</li>
				<li>
					<a href="#request.self#?fuseaction=crm.popup_dsp_prdouct_analysis&cpid=#attributes.cpid#&iframe=1&frame_fuseaction=popup_dsp_prdouct_analysis" target="member_frame">
						<div class="ui-list-left">
							<span class="ui-list-icon ctl-018-monitor"></span>
							<cf_get_lang no='761.Ürün Analiz'>
						</div>
					</a>
				</li>
			</ol>
		</li>	
					
	</ul>
</cfoutput>

