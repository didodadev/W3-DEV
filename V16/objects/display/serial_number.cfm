<cfset url_ = "">
<!--- deger bos gonderilmemelidir FA --->
<cfset is_store_param_ = " "><!---  AND DEPARTMENT_ID IS NOT NULL fbs 20120622 talep uzerine kaldirildi, sorun olmazsa 120 gune silinebilir --->
<cfif isdefined("attributes.is_store")>
	<cfset is_store_param_ = " AND DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.DEPARTMENT WHERE BRANCH_ID = #listgetat(session.ep.user_location,2,'-')#)">
</cfif>
<cfif isdefined("attributes.company_send_form")>
	<cfset url_ = "&company_send_form=#attributes.company_send_form#">
</cfif>
<cfif not isdefined("x_is_rma")>
	<cfset x_is_rma = 0>
</cfif>
<cfif not isdefined("x_is_company_search")>
	<cfset x_is_company_search = 0>
</cfif>
<cf_box_search>
		<cfif not isdefined("attributes.company_send_form")>
			<div class="form-group" id="item-product_serial_no">
				<input type="text" name="product_serial_no" id="product_serial_no" style="width:150px;" placeholder="<cfoutput><cf_get_lang dictionary_id='57637.Seri No'></cfoutput>" onkeyup="return(control_key(this,event));" value="<cfif isdefined("attributes.product_serial_no") and len(attributes.product_serial_no)><cfoutput>#attributes.product_serial_no#</cfoutput></cfif>">
			</div>
			<cfif isdefined("x_is_rma") and x_is_rma eq 1>
				<div class="form-group" id="item-rma_no">
					<input type="text" name="rma_no" id="rma_no" style="width:75px;" placeholder="<cfoutput><cf_get_lang dictionary_id='34260.RMA No'></cfoutput>" onkeyup="return(control_key(this,event));" value="<cfif isdefined("attributes.rma_no") and len(attributes.rma_no)><cfoutput>#attributes.rma_no#</cfoutput></cfif>">
				</div>
            </cfif>
			<cfif isdefined("x_is_company_search") and x_is_company_search eq 1>
				<div class="form-group" id="item-member_name">
					<div class="input-group">   
						<input type="hidden" name="company_id" id="company_id" value="">			 
						<input name="member_name" type="text" id="member_name"  style="width:150px;" placeholder="<cfoutput><cf_get_lang dictionary_id='57574.Şirket'></cfoutput>" value="" onfocus="AutoComplete_Create('member_name','MEMBER_NAME,MEMBER_PARTNER_NAME','MEMBER_NAME,MEMBER_PARTNER_NAME','get_member_autocomplete','\'1\',\'0\',\'0\',\'0\',\'2\',\'1\'','COMPANY_ID','company_id','','3','250');" autocomplete="off">
						<cfset str_linke_ait="&field_comp_id=all.company_id&field_member_name=all.member_name">
						<span class="input-group-addon icon-ellipsis btnPointer" onclick="windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=objects.popup_list_all_pars&is_period_kontrol=0<cfoutput>#str_linke_ait#</cfoutput>&select_list=7','list');"></span>
					</div>
				</div>		
			</cfif>
			<div class="form-group">
				<cf_wrk_search_button button_type="4" is_excel = "no" search_function="check_seri_no()">
			</div>
	<cfelse>
        <div class="form-group" id="item-product_serial_no">
		<cf_get_lang dictionary_id='57637.Seri No'>&nbsp;
		<input type="text" name="product_serial_no" id="product_serial_no" style="width:150px;" value="<cfoutput>#attributes.product_serial_no#</cfoutput>"readonly>
		</div>
	</cfif>
</cf_box_search>
	<div id="check_seri_layer" style="position:absolute; width:300px; display:none; height:100px; z-index:1;"></div>

<cfoutput>
	<script type="text/javascript">
		function control_key(fld,e)
		{
			if(window.Event)
			{
				if(e.keyCode)
					whichCode = e.keyCode;
				else if(e.which)
					whichCode = e.which;
				if(whichCode==13)
				{
					check_seri_no();
				}
			}
			else
				return false;
		}
		function check_seri_no()
		{
			<cfif x_is_company_search eq 0 and x_is_rma eq 0>
				if(document.getElementById('product_serial_no').value.length==0)
				{
					alert("<cf_get_lang dictionary_id='33774.Seri No Girmelisiniz'>");
					return false;
				}
			<cfelseif x_is_company_search eq 1 and x_is_rma eq 0>
				if(document.getElementById('product_serial_no').value.length==0 && (document.getElementById('company_id').value.length==0 || document.getElementById('member_name').value.length==0))
				{
					alert("<cf_get_lang dictionary_id='32685.Seri No veya Cari Hesap Seçmelisiniz'>");
					return false;
				}
			<cfelseif x_is_company_search eq 0 and x_is_rma eq 1>
				if(document.getElementById('product_serial_no').value.length==0 && document.getElementById('rma_no').value.length==0)
				{
					alert("<cf_get_lang dictionary_id='32692.Seri No veya Rma No Girmelisiniz'>");
					return false;
				}
			<cfelseif x_is_company_search eq 1 and x_is_rma eq 1>
				if(document.getElementById('product_serial_no').value.length==0 && document.getElementById('rma_no').value.length==0 && (document.getElementById('company_id').value.length==0 || document.getElementById('member_name').value.length==0))
				{
					alert("<cf_get_lang dictionary_id='32692.Seri No veya Rma No Girmelisiniz'>");
					return false;
				}
			</cfif>
			
			<cfif x_is_rma eq 1 and not isdefined("attributes.company_send_form")>
				this_rma_no = document.getElementById('rma_no').value;
			<cfelse>
				this_rma_no = '';
			</cfif>
			
			<cfif x_is_company_search eq 0 or isdefined("attributes.company_send_form")>
				this_seri_no = document.getElementById('product_serial_no').value;
				if(this_rma_no == '')
				{
					var listParam = this_seri_no + '*' + '#is_store_param_#';
					get_serial_ = wrk_safe_query("obj_get_serial",'dsn3',0,listParam);
				}
				else
				{
					var listParam = this_seri_no + '*' + this_rma_no + '#is_store_param_#';
					get_serial_ = wrk_safe_query("obj_get_serial_2",'dsn3',0,listParam);
				}
				if(get_serial_.recordcount==1)
				{
					window.location.href="#request.self#?fuseaction=objects.serial_no&event=det&product_serial_no="+this_seri_no+"&seri_stock_id="+get_serial_.STOCK_ID+"#url_#&rma_no="+this_rma_no;
				}
				else
				{
					_show_(this_seri_no);
				}
			<cfelse>
				this_seri_no = document.getElementById('product_serial_no').value;
				this_company_id = document.getElementById('company_id').value;
			
				if(this_rma_no != '')
					rma_add = " AND RMA_NO = '" + this_rma_no + "'";
				else
					rma_add = '';
			
				if(this_seri_no!='' && this_company_id != '')
				{
					var listParam = this_seri_no + "*" + this_company_id + "*" + rma_add + "*" + "#is_store_param_#";
					get_serial_ = wrk_safe_query("obj_get_serial_3",'dsn3',0,listParam);
				}
				else if(this_seri_no!='' && this_company_id == '')
				{
					var listParam = this_seri_no + "*" + "#is_store_param_#" + "*" + rma_add;
					get_serial_ = wrk_safe_query("obj_get_serial_4",'dsn3',0,listParam);
				}
				else if(this_seri_no=='' && this_company_id != '')
				{
					var listParam = this_company_id + "*" + this_company_id + "*" + "#is_store_param_#" + "*" + rma_add;
					get_serial_ = wrk_safe_query("obj_get_serial_5",'dsn3',0,listParam);
				}
				else
					get_serial_ = wrk_safe_query('obj_get_serial_rma','dsn3',0,this_rma_no);
					
				if(get_serial_.recordcount==1)
				{
					window.location.href="#request.self#?fuseaction=objects.serial_no&product_serial_no="+this_seri_no+"&seri_stock_id="+get_serial_.STOCK_ID+"#url_#&rma_no="+this_rma_no;
				}
				else
				{
					_show_comp_(this_seri_no,this_company_id,this_rma_no);
				}
			</cfif>
			return false;
		}
		function _show_(this_seri_no_)
		{
			if(document.getElementById('check_seri_layer') != undefined)
			{
				goster(check_seri_layer);
				AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_check_seri_no#url_#&serial_no='+encodeURIComponent(this_seri_no_),'check_seri_layer');
			
			}
			else
				setTimeout('_show_("'+this_seri_no_+'")',20);
		}
		
		function _show_comp_(this_seri_no_,this_company_id,this_rma_no)
		{
			if(document.getElementById('check_seri_layer') != undefined)
			{
				goster(check_seri_layer);
				AjaxPageLoad('#request.self#?fuseaction=objects.emptypopup_check_seri_no#url_#&serial_no='+encodeURIComponent(this_seri_no_)+'&company_id='+this_company_id+'&rma_no='+this_rma_no,'check_seri_layer');
			}
			else
				setTimeout('_show_comp_("'+this_seri_no_+','+this_company_id+','+this_rma_no+'")',20);
		}
		document.getElementById('product_serial_no').focus();
		<cfif isdefined("attributes.product_serial_no") and not isdefined("attributes.seri_stock_id") and not isdefined("attributes.only_service")>
			check_seri_no();
		</cfif>
	</script>
</cfoutput>
