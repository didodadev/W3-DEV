<cfparam name="attributes.puantaj_type" default="-1">
<cfparam name="x_puantaj_day" default="0">
<cfparam name="attributes.x_puantaj_lock_permission" default="">
<cfsetting showdebugoutput="no">
<cfif not isdefined("attributs.startrow")>
	<cfparam name="attributes.page" default=1>
	<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
	<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
</cfif>
<cfif isdefined("attributes.puantaj_id")>
	<cfinclude template="../query/get_puantaj.cfm">
	<cfset attributes.puantaj_id = get_puantaj.puantaj_id>
	<cfset attributes.sal_mon = get_puantaj.sal_mon>
	<cfset attributes.sal_year = get_puantaj.sal_year>
	<cfset attributes.ssk_office = "#get_puantaj.ssk_office#-#get_puantaj.ssk_office_no#">
	<cfset attributes.branch_id = get_puantaj.ssk_branch_id>
	<cfif fusebox.use_period>
		<cfif get_puantaj.recordcount>
			<cfquery name="get_dekont" datasource="#dsn#">
				SELECT PUANTAJ_ID FROM EMPLOYEES_PUANTAJ_CARI_ACTIONS WHERE PUANTAJ_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#get_puantaj.puantaj_id#">
			</cfquery>
		<cfelse>
			<cfset get_dekont.recordcount = 0>
		</cfif>
	</cfif>
	<table>
		<tr>
			<cfoutput>
			<td nowrap="nowrap">
				<cfif attributes.x_select_process eq 1>
					<cf_workcube_process is_upd='0' process_cat_width='100' is_detail="1" select_value="#get_puantaj.stage_row_id#">
					<a href="javascript://" onClick="update_process();"><img src="/images/transfer.gif" title="<cf_get_lang dictionary_id='40821.Aşamayı Güncelle'>" border="0" align="absmiddle"></a> 
					<div id="process_div"></div>
				<cfelse>
					<input type="hidden" name="process_stage" id="process_stage" value="">
				</cfif>
			</td>
			<cfif GET_PUANTAJ.IS_ACCOUNT NEQ 1 and GET_PUANTAJ.IS_BUDGET NEQ 1>
				<cfif get_puantaj.is_locked eq 0><!--- kilitli olmamalı --->
					<cfif x_puantaj_day neq 0>
						<cfif (((attributes.sal_year eq year(now())) and (attributes.sal_mon eq (month(now())-1) ) and (x_puantaj_day gte day(now())) ) or ( (attributes.sal_year eq year(now())) and (attributes.sal_mon eq month(now())) ) )>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='53030.Eski Bilgiler Kaybedilecek Puantajlar Yeniden Oluşturulacak Emin misiniz'></cfsavecontent>
							<!--- <a href="##" onClick="if (confirm('#message#')) create_puantaj(); else return false;"><img src="/images/refer.gif" title="<cf_get_lang dictionary_id='53230.Yeniden Oluştur'>"></a> --->
							<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#getLang('','Yeniden Oluştur','53230')#" extraFunction='create_puantaj()' right="0">
						</cfif>
					<cfelse>
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='53030.Eski Bilgiler Kaybedilecek Puantajlar Yeniden Oluşturulacak Emin misiniz'></cfsavecontent>
							<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#getLang('','Yeniden Oluştur','53230')#" extraFunction='create_puantaj()' right="0">

						<!--- <a href="##" onClick="if (confirm('#message#')) create_puantaj(); else return false;"><img src="/images/refer.gif" title="<cf_get_lang dictionary_id='53230.Yeniden Oluştur'>"></a> --->
					</cfif>
				</cfif>
			</cfif>
			<td nowrap="nowrap">
				<cfif get_puantaj.is_lock_control eq 1><!--- kilide mudahale edilebilir--->
					<!--- Kilitle, Kilidi Kaldır. --->
					<cfif get_puantaj.is_locked EQ 1>
						<cfif get_module_power_user(48)>
							<cfif not len(attributes.x_puantaj_lock_permission) or listfind(attributes.x_puantaj_lock_permission,session.ep.userid,',') gt 0>
								<a href="##" onClick="unlock_send();">
									<i class="col fa-lg mt-2 fa fa-lock font-red" title="<cf_get_lang dictionary_id ='53046.Puantaj Kilidi Kaldır'>"></i>
								</a>
							<cfelse>
								<a href="##">
									<i class="col fa-lg mt-2 fa fa-lock font-red" title="<cf_get_lang dictionary_id ='53046.Puantaj Kilidi Kaldır'>"></i>
								</a>
							</cfif>
						<cfelse>
							<!--- ehesap olmayan kilidi görür --->
							<a href="##">
								<i class="col fa-lg mt-2 fa fa-lock font-red" title="<cf_get_lang dictionary_id='53759.Puantaj Kilitli'>"></i>
							</a>
						</cfif>
					<cfelse>
						<!--- kilitlenebilir --->
						<cfif not (isdefined("attributes.x_puantaj_lock_permission") and len(attributes.x_puantaj_lock_permission)) or listfind(attributes.x_puantaj_lock_permission,session.ep.userid,',') gt 0>
							<a href="##" onClick="lock_send();">
								<i class="col fa-lg mt-2 fa fa-unlock font-green-jungle" title="<cf_get_lang dictionary_id ='53104.Puantajı Kilitle'>"></i>								
							</a>
						<cfelse>
							<a href="##">
								<i class="col fa-lg mt-2 fa fa-unlock font-green-jungle" title="<cf_get_lang dictionary_id ='53104.Puantajı Kilitle'>"></i>								
							</a>
						</cfif>
					</cfif>
				<cfelseif get_puantaj.is_lock_control eq 0><!--- kilide mudahale edilemez--->
					<cfif get_puantaj.is_locked EQ 1>
						<a href="##"><i class="col fa-lg mt-2 fa fa-lock font-red" title="<cf_get_lang dictionary_id ='53759.Puantaj Kilitli'>"></i></a>
					<cfelse>
						<a href="##">
							<i class="col fa-lg mt-2 fa fa-unlock font-green-jungle" title="<cf_get_lang dictionary_id ='53104.Puantajı Kilitle'>"></i>								
						</a>
					</cfif>
				</cfif>
				<cfif get_module_power_user(48) and get_puantaj.is_locked neq 1>
                    <input type="hidden" name="puantaj_account_date" id="puantaj_account_date" value="<cfoutput>#dateFormat(CREATEDATE(get_puantaj.sal_year,get_puantaj.sal_mon,daysinmonth(CREATEDATE(GET_PUANTAJ.sal_year,GET_PUANTAJ.SAL_MON,1))),dateformat_style)#</cfoutput>">
                    <cfsavecontent variable="message"><cf_get_lang dictionary_id ='53118.Puantajlar (varsa bağlı muhasebe ve bütçe fişleriyle birlikte) silinecek, emin misiniz?'></cfsavecontent>
					<a href="javascript://" onClick="if (confirm('#message#')) delet_puantaj(); else return false;">
						<i class="col fa-lg mt-2 fa fa-trash font-grey-gallery" title="<cf_get_lang dictionary_id ='53163.Puantajı Sil'>"></i>
					</a>
				</cfif>
				<cfif fusebox.use_period>
					<cfif get_dekont.recordcount>
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_upd_collacted_dekont&puantaj_id=#get_puantaj.puantaj_id#&sal_year=#attributes.sal_year#','wide','winCollactedDekont');"><i class="col fa-lg mt-2 fa fa-money font-grey-gallery" title="<cf_get_lang dictionary_id ='53264.Ücret Dekontu Güncelle'>"></i></a>
					<cfelse>	
						<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_collacted_dekont&puantaj_id=#get_puantaj.puantaj_id#','wide','winCollactedDekont');"><i class="col fa-lg mt-2 fa fa-money font-grey-gallery" title="<cf_get_lang dictionary_id ='53265.Ücret Dekontu Ekle'>"></i></a>
					</cfif>
				</cfif>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_puantaj_to_muhasebe&puantaj_id=#get_puantaj.puantaj_id#','list','winPuantajMuhasebe');"><i class="col fa-lg mt-2 fa fa-list-alt font-grey-gallery" title="<cf_get_lang dictionary_id='54325.Muhasebe Aktarımı'>"></i></a>
				<cfif fusebox.use_period>
					<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_add_puantaj_to_budget&puantaj_id=#get_puantaj.puantaj_id#','list','winPuantajBudget');"><i class="col fa-lg mt-2 fa fa-bar-chart font-grey-gallery" title="<cf_get_lang dictionary_id='54326.Bütçe Aktarımı'>"></i></a>
				</cfif>
				<!---<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popupflush_view_puantaj_print&style=all&puantaj_id=#get_puantaj.puantaj_id#&SSK_OFFICE=#attributes.SSK_OFFICE#&HIERARCHY=&SAL_YEAR=#attributes.SAL_YEAR#&SAL_MON=#attributes.SAL_MON#','page');"><img align="absmiddle" src="/images/copy.gif" title="<cf_get_lang no='285.Toplu Olarak Yazdır'>" border="0"></a>--->
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popupflush_view_puantaj_print_pdf&puantaj_type=#get_puantaj.puantaj_type#&puantaj_id=#get_puantaj.puantaj_id#&SSK_OFFICE=#attributes.SSK_OFFICE#&HIERARCHY=&SAL_YEAR=#attributes.SAL_YEAR#&SAL_MON=#attributes.SAL_MON#','page');"><i class="col fa-lg mt-2 fa fa-file-pdf-o font-grey-gallery" title="<cf_get_lang dictionary_id ='53270.PDF Ön İzlemeli Yazdır'>"></i></a>
				<a href="javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_send_puantaj_mails&puantaj_id=#get_puantaj.puantaj_id#','small');"><i class="col fa-lg mt-2 fa fa-envelope font-grey-gallery" title="<cf_get_lang dictionary_id ='53276.Puantajı Mail Olarak Gönder'>"></i></a>				
			</td>
			<td>
				<cfif isdefined('x_payment_day') and x_payment_day eq 1><!--- Ödeme Günü --->
					<!---<input type="text" name="payment_day" id="payment_day" style="width:75px !important;"  value="#dateFormat(get_puantaj.payment_date,dateformat_style)#">   
					<span style="position:relative"><cf_wrk_date_image date_field="payment_day"></span>--->
					<a href = "javascript://" onClick="windowopen('#request.self#?fuseaction=ehesap.popup_payment_day&puantaj_id=#get_puantaj.puantaj_id#','small');" ><i class="col fa-lg mt-2 fa fa-calendar font-grey-gallery" title = "<cf_get_lang dictionary_id = '54821.Ödeme Günü'>"></i></a>
				</cfif>
			</td>
			</cfoutput>
			<!--- <cfif len(get_puantaj.puantaj_id) and len(get_puantaj.recordcount)>
				<cf_workcube_file_action pdf='0' mail='0' doc='1' print='0' tag_module='puantaj_list_layer' is_ajax='1'>
			</cfif> --->
		</tr>
	</table>
	<script type="text/javascript">
		function unlock_send()
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_to_lock&puantaj_id=#get_puantaj.puantaj_id#&lock=1&x_select_process=#x_select_process#&x_payment_day=#x_payment_day#<cfif isdefined("attributes.x_puantaj_lock_permission")>&x_puantaj_lock_permission=#attributes.x_puantaj_lock_permission#</cfif>&branch_id=#attributes.branch_id#</cfoutput>','menu_puantaj_1','0',"<cf_get_lang dictionary_id ='53283.Puantaj Kilidi Kaldırılıyor'>");
		}
		function lock_send()
		{
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_to_lock&puantaj_id=#get_puantaj.puantaj_id#&lock=0&x_select_process=#x_select_process#&x_payment_day=#x_payment_day#<cfif isdefined("attributes.x_puantaj_lock_permission")>&x_puantaj_lock_permission=#attributes.x_puantaj_lock_permission#</cfif>&branch_id=#attributes.branch_id#</cfoutput>','menu_puantaj_1','0',"<cf_get_lang dictionary_id ='53284.Puantaj Kilitleniyor'>");
		}
		function delet_puantaj()
		{
			//işlem tarihi kontrolü
			if(!chk_period(document.getElementById('puantaj_account_date'), 'İşlem')) return false;

			sal_year_ = document.employee.sal_year.value;
			sal_mon_ = document.employee.sal_mon.value;
			<!---			branch_id_ = list_getat(document.employee.ssk_office.value,3,'-');--->
			branch_id_ = document.employee.ssk_office.value;
			ssk_statue = $("#ssk_statue").val();//ssk durumu
			statue_type = $("#statue_type").val();
			statue_type_individual = $("#statue_type_individual").val();

			var listParam = sal_mon_ + "*" + sal_year_ + "*" + branch_id_  + "*" + '<cfoutput>#attributes.puantaj_type#</cfoutput>'+ "*" +ssk_statue+"*"+statue_type+"*"+statue_type_individual;
			get_puantaj2_ = wrk_safe_query("hr_get_puantaj_2",'dsn',0,listParam);
			
			if(get_puantaj2_.recordcount>0)
			{
				alert("<cf_get_lang dictionary_id ='53184.Şube İçin İleri Tarihli Bir Puantaj Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız'>!");
				return false;
			}
			//harcırah kontrolü
			var listParam_2 = sal_mon_+'*'+sal_year_+'*'+branch_id_;
			get_puantaj_2 = wrk_safe_query('hr_control_expense_puantaj_3','dsn',0,listParam_2);
			if(get_puantaj_2.recordcount>0)
			{
				alert("<cf_get_lang dictionary_id='41551.Şube İçin İleri Tarihli Bir Harcırah Kaydı Var Geçmiş Tarihli Puantaj Çalıştıramazsınız'>!");
				return false;
			}
			AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_delet_puantaj&puantaj_id=#get_puantaj.puantaj_id#&x_select_process=#x_select_process#&x_payment_day=#x_payment_day#</cfoutput>'+ "&ssk_statue=" +ssk_statue+"&statue_type="+statue_type+"&statue_type_individual="+statue_type_individual,'menu_puantaj_1','1'," <cf_get_lang no ='345.Puantaj Siliniyor'>");			
		}
		function update_process()
		{		
			if (process_cat_control())
			{
				if(confirm("Aşama Güncellenecek Emin misiniz") == true)
					AjaxPageLoad('<cfoutput>#request.self#?fuseaction=ehesap.emptypopup_puantaj_process_update&puantaj_id=#get_puantaj.puantaj_id#&process_stage=</cfoutput>'+document.getElementById('process_stage').value,'process_div');
			}
		}
	</script>
<cfelse>
	<cfif x_select_process eq 1>
		<cf_workcube_process is_upd='0' process_cat_width='100' is_detail="0">
	<cfelse>
		<input type="hidden" name="process_stage" id="process_stage" value="">
	</cfif>
	<cf_workcube_buttons update_status="0" extraButton="1" extraButtonText="#getLang('','Puantaj Oluştur',64038)#" extraFunction='create_puantaj()'>
</cfif>
