<cf_xml_page_edit>
<cfparam name="attributes.start_date" default="#now()#" >
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.department_id" default="">
<cfif isdefined("attributes.is_submitted")>
	<cf_date tarih = "attributes.start_date">
	<cfquery name="get_fileimports_total_sayim" datasource="#DSN2#">
		SELECT 
			FITS.*,
			ISNULL(IS_TOTAL_STOCK_FIS,0) IS_FIS,
			D.DEPARTMENT_HEAD,
			SL.COMMENT
		FROM
			FILE_IMPORTS_TOTAL_SAYIMLAR FITS,
			#dsn_alias#.DEPARTMENT D,
			#dsn_alias#.STOCKS_LOCATION SL
		WHERE 
			D.DEPARTMENT_ID = FITS.DEPARTMENT_ID AND
			D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
			SL.LOCATION_ID = FITS.DEPARTMENT_LOCATION AND
			FITS.PROCESS_DATE =  #attributes.start_date#
			<cfif isdefined("attributes.department_id") and listlen(attributes.department_id,'-') eq 1>
				AND FITS.DEPARTMENT_ID = #attributes.department_id#
			<cfelseif isdefined("attributes.department_id") and listlen(attributes.department_id,'-') eq 2>
				AND FITS.DEPARTMENT_ID = #listfirst(attributes.department_id,'-')#
				AND FITS.DEPARTMENT_LOCATION = #listlast(attributes.department_id,'-')#
			<cfelse>
				<cfif session.ep.our_company_info.is_location_follow eq 1>
					AND
					(
						CAST(FITS.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(FITS.DEPARTMENT_LOCATION AS NVARCHAR) IN (SELECT LOCATION_CODE FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
						OR
						FITS.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM #dsn_alias#.EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
					)
				</cfif>
			</cfif>
	</cfquery>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset get_fileimports_total_sayim.recordcount=0>
</cfif>
<cfquery name="get_user_process_cat1" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.IS_ACCOUNT,
		SPC.IS_DEFAULT
	FROM
		SETUP_PROCESS_CAT_ROWS AS SPCR,
		SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_TYPE = 115 AND
		(
			(SPCR.POSITION_CODE=#session.ep.POSITION_CODE# AND SPCR.POSITION_CODE=EP.POSITION_CODE) OR
			(EP.POSITION_CODE=#session.ep.POSITION_CODE# AND SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID)
		)
	ORDER BY
		SPC.PROCESS_CAT
</cfquery>
<cfquery name="get_user_process_cat2" datasource="#dsn3#">
	SELECT
		DISTINCT
		SPC.PROCESS_CAT_ID,
		SPC.PROCESS_CAT,
		SPC.PROCESS_TYPE,
		SPC.IS_ACCOUNT,
		SPC.IS_DEFAULT
	FROM
		SETUP_PROCESS_CAT_ROWS AS SPCR,
		SETUP_PROCESS_CAT_FUSENAME AS SPCF,
		#dsn_alias#.EMPLOYEE_POSITIONS AS EP,
		SETUP_PROCESS_CAT SPC
	WHERE
		SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID AND
		SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID AND
		SPC.PROCESS_TYPE = 112 AND
		(
			(SPCR.POSITION_CODE=#session.ep.POSITION_CODE# AND SPCR.POSITION_CODE=EP.POSITION_CODE) OR
			(EP.POSITION_CODE=#session.ep.POSITION_CODE# AND SPCR.POSITION_CAT_ID=EP.POSITION_CAT_ID)
		)
	ORDER BY
		SPC.PROCESS_CAT
</cfquery>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default='#session.ep.maxrows#'>
<cfparam name="attributes.totalrecords" default=#get_fileimports_total_sayim.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
</cfif>
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT 
		D.DEPARTMENT_HEAD,
		SL.DEPARTMENT_ID,
		SL.LOCATION_ID,
		SL.STATUS,
		SL.COMMENT
	FROM 
		STOCKS_LOCATION SL,
		DEPARTMENT D,
		BRANCH B
	WHERE
		D.IS_STORE <> 2 AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		D.DEPARTMENT_STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID AND
		B.COMPANY_ID = <cfqueryparam cfsqltype="cf_sql_integer" value="#session.ep.company_id#">
		<cfif session.ep.our_company_info.is_location_follow eq 1>
			AND
			(
				CAST(D.DEPARTMENT_ID AS NVARCHAR) + '-' + CAST(SL.LOCATION_ID AS NVARCHAR) IN (SELECT LOCATION_CODE FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code#)
				OR
				D.DEPARTMENT_ID IN (SELECT DEPARTMENT_ID FROM EMPLOYEE_POSITION_BRANCHES WHERE POSITION_CODE = #session.ep.position_code# AND LOCATION_ID IS NULL)
			)
		</cfif>
	ORDER BY
		D.DEPARTMENT_HEAD,
		COMMENT
</cfquery>
<div class="col col-12 col-md-12 col-sm-12 col-xs-12">
	<cf_box>
		<cfform name="list_sayimlar" method="post" action="">
			<input type="hidden" name="is_submitted" id="is_submitted" value="1">
			<cf_box_search> 
				<div class="form-group">
					<div class="input-group">
						<cfsavecontent variable="message"><cf_get_lang dictionary_id ='58053.Başlangıç Tarihi'></cfsavecontent>
						<cfinput type="text" name="start_date" value="#attributes.start_date#" style="width:65px;" validate="#validate_style#" maxlength="10" message="#message#" required="yes" placeholder="#message#">
						<span class="input-group-addon"><cf_wrk_date_image date_field="start_date"></span>
					</div>
				</div>
				<div class="form-group">
					<select name="department_id" id="department_id" style="width:250;">
						<option value=""><cf_get_lang dictionary_id='58763.Depo'></option>
						<cfoutput query="get_all_location" group="department_id">
							<option value="#department_id#"<cfif attributes.department_id eq department_id> selected</cfif>>#department_head#</option>
							<cfoutput>
								<option <cfif not status>style="color:##FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_id eq '#department_id#-#location_id#'>selected</cfif>>#comment#<cfif not status> - <cf_get_lang dictionary_id='57494.Pasif'></cfif></option>
							</cfoutput>
						</cfoutput>
					</select>
				</div>
				<div class="form-group">
					<cf_wrk_search_button button_type="4">
				</div>
			</cf_box_search>
		</cfform>
	</cf_box>

	<cfsavecontent variable="message"><cf_get_lang dictionary_id='36099.Birleştirilmiş Belgeler'></cfsavecontent>
	<cf_box title="#message#" uidrop="1" hide_table_column="1">
		<cf_grid_list> 
			<thead>
				<tr>
					<th><cf_get_lang dictionary_id='57742.Tarih'></th>
					<th><cf_get_lang dictionary_id='58763.Depo'></th>
					<th><cf_get_lang dictionary_id='57483.Kayıt'></th>
				<cfif xml_is_update_act eq 1>
					<th width="20"></th>
				</cfif>
					<th width="20"></th>
					<th width="20"></th>
				<cfif xml_is_stock_fis eq 1>
					<th width="20"></th>
					<th width="20" class="header_icn_none text-center"><input type="checkbox" name="allSelectDemand" id="allSelectDemand" onClick="wrk_select_all('allSelectDemand','row_sayim');"></th>
				</cfif>
				</tr>
			</thead>
			<tbody>
				<cfif get_fileimports_total_sayim.recordcount>	
					<cfset employee_id_list=''>
					<cfoutput query="get_fileimports_total_sayim" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<cfif len(record_emp) and not listfind(employee_id_list,record_emp)>
							<cfset employee_id_list=listappend(employee_id_list,record_emp)>
						</cfif>
					</cfoutput>
					<cfif len(employee_id_list)>
						<cfset employee_id_list=listsort(employee_id_list,"numeric","ASC",",")>
						<cfquery name="get_emp_detail" datasource="#dsn#">
							SELECT
								EMPLOYEE_NAME,
								EMPLOYEE_SURNAME
							FROM
								EMPLOYEES
							WHERE
								EMPLOYEE_ID IN (#employee_id_list#)
							ORDER BY
								EMPLOYEE_ID
						</cfquery>
					</cfif>
					<form name="upd_all_action" method="post" action="<cfoutput>#request.self#?</cfoutput>fuseaction=pos.emptypopup_add_total_stock_fis">		
					<cfoutput query="get_fileimports_total_sayim" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
						<tr>
							<td width="50">#dateformat(PROCESS_DATE,dateformat_style)#</td>
							<td width="320">#DEPARTMENT_HEAD# (#COMMENT#)</td>
							<td width="320">#get_emp_detail.EMPLOYEE_NAME[listfind(employee_id_list,RECORD_EMP,',')]# #get_emp_detail.EMPLOYEE_SURNAME[listfind(employee_id_list,RECORD_EMP,',')]#</td>
							<cfif xml_is_update_act eq 1>
								<td align="center" style="width:15px; text-align:center;">
									<a href="#request.self#?fuseaction=pos.form_upd_sayim&file_import_id=#FILE_IMPORTS_TOTAL_SAYIM_ID#">
									<i class="fa fa-pencil" title="<cf_get_lang dictionary_id='57464.Güncelle'>"></i></a>
								</td>
							</cfif>
							<td align="center" style="width:15px; text-align:center;">
								<a href="#request.self#?fuseaction=pos.list_fileimports_total&is_submitted=1&department_id=#DEPARTMENT_ID#&location_id=#DEPARTMENT_LOCATION#&start_date=#start_date#"><img src="/images/workdevwork.gif" title="<cf_get_lang dictionary_id='36100.Fiş Oluşturma'>"></a>
							</td>
							<cfif xml_is_stock_fis eq 1>
								<td align="center" style="width:15px; text-align:center;">
									<cfif is_fis eq 1>
										<a href="javascript://" onClick="del_stock_fis(#FILE_IMPORTS_TOTAL_SAYIM_ID#);">
										<i class="fa fa-minus" title="<cf_get_lang dictionary_id='36016.Stok Fişlerini Sil'>"></i></a>
									</cfif>
								</td>
							</cfif>
							<td align="center" style="width:15px; text-align:center;">
								<cfif is_fis eq 0>
									<a href="javascript://" onClick="belge_sil('#DEPARTMENT_ID#','#DEPARTMENT_LOCATION#','#dateformat(process_date,dateformat_style)#');"> <i class="fa fa-minus" title="<cf_get_lang dictionary_id ='36101.Birleştirilmiş Belgeleri Sil'>"></i></a>					
								</cfif>
							</td>
							<cfif xml_is_stock_fis eq 1>
								<td align="center" style="width:15px; text-align:center;">
									<input type="checkbox" name="row_sayim" id="row_sayim" value="#FILE_IMPORTS_TOTAL_SAYIM_ID#" <cfif is_fis eq 1>disabled</cfif>>
								</td>
							</cfif>
						</tr>
					</cfoutput>
				</tbody>
				<tfoot>
					<cfif xml_is_stock_fis eq 1>
						<tr>
							<td colspan="8" align="right" style="text-align:right">
								<!---<table width="100%">
									<tr>
										<td>--->
											<cf_get_lang dictionary_id='36003.Sayım Fişi İşlem Tipi'>
											<select name="process_cat1" id="process_cat1" style="width:150;">
												<option value="" selected><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<cfoutput query="get_user_process_cat1">
													<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
												</cfoutput>
											</select>
											
											<cf_get_lang dictionary_id='36005.Fire Fişi İşlem Tipi'>
											<select name="process_cat2" id="process_cat2" style="width:150;">
												<option value="" selected><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
												<cfoutput query="get_user_process_cat2">
													<option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
												</cfoutput>
											</select>
									<!--- </td>
										<td style="text-align:right">--->
											<input type="hidden" name="file_id_list" id="file_id_list" value="">
											<input type="hidden" name="del_file_id" id="del_file_id" value="">
											<cfsavecontent variable="message"><cf_get_lang dictionary_id='36881.Stok Fişi Oluştur'></cfsavecontent>
											<input type="button" name="list_button" id="list_button" value="<cfoutput>#message#</cfoutput>" onClick="add_stock_fis();">
										<!---</td>
									</tr>
								</table>--->
								<div id="user_message_demand"></div>
							</td>
						</tr>
					</cfif>
				</tfoot>
				</form>
				<cfelse>
					<tbody>
						<tr>
							<td colspan="9"><cfif arama_yapilmali neq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
						</tr>
					</tbody>
				</cfif>
			</tbody>
		</cf_grid_list>
		<cfif attributes.totalrecords and (attributes.totalrecords gt attributes.maxrows)>
			<cfset url_string = ''>
			<cfif isdefined("attributes.startdate") and len(attributes.startdate)>
				<cfset url_string = '#url_string#&startdate=#dateformat(attributes.startdate,dateformat_style)#'>
			</cfif>
			<cfif isdefined("attributes.department_id") and len(attributes.department_id)>
				<cfset url_string = '#url_string#&department_id=#dateformat(attributes.department_id,dateformat_style)#'>
			</cfif>
			<cf_paging page="#attributes.page#"
				maxrows="#attributes.maxrows#"
				totalrecords="#attributes.totalrecords#"
				startrow="#attributes.startrow#"
				adres="pos.list_sayim#url_string#">
		</cfif>
	</cf_box>
</div>
<script type="text/javascript">
	function belge_sil(department_id,location_id,process_date)
	{
		if(confirm("<cf_get_lang dictionary_id ='36102.Birleştirilmiş Belgeleri Silmek İstediğinizden Emin Misiniz? Önceden Oluşturduğunuz Fişleri Silmeniz Gerekmektedir'>!"))
		{
			windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=pos.emptypopup_del_file_imports_total&department_id='+department_id+'&location_id='+location_id+'&start_date='+process_date,'small'); 
		}
	}
	function del_stock_fis(entry_id)
	{
		if(confirm("<cf_get_lang dictionary_id ='36029.Belge İçin Oluşturulan Stok Fişleri Silinecektir, emin misiniz ?'>"))
		{
			document.upd_all_action.del_file_id.value = entry_id;
			user_message = 'Stok Fişleri Siliniyor Lütfen Bekleyiniz !';
			AjaxFormSubmit(upd_all_action,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
			return true;
		}
	}
	function add_stock_fis()
	{
		var is_selected=0;
		if(document.all.process_cat1.value == '')
		{
			alert("<cf_get_lang dictionary_id ='36025.Lütfen Sayım Fişi İşlem Tipi Seçiniz'> !");
			return false;
		}
		if(document.all.process_cat2.value == '')
		{
			alert("<cf_get_lang dictionary_id ='36027.Lütfen Fire Fişi İşlem Tipi Seçiniz'> !");
			return false;
		}
		if(document.getElementsByName('row_sayim').length > 0)
		{
			var sayim_list="";
			if(document.getElementsByName('row_sayim').length ==1)
			{
				if(document.getElementById('row_sayim').checked==true){
					is_selected=1;
					sayim_list+=document.all.row_sayim.value+',';
				}
			}	
			else
			{
				for (i=0;i<document.getElementsByName('row_sayim').length;i++)
				{
					if(document.all.row_sayim[i].checked==true)
					{ 
						sayim_list+=document.all.row_sayim[i].value+',';
						is_selected=1;
					}
				}		
			}
			if(is_selected==1)
			{
				if(confirm("<cf_get_lang dictionary_id='36023.Seçtiğiniz Belgeler İçin Stok Fişi Oluşturulacaktır, Emin misiniz?'>"))
				{
					if(list_len(sayim_list,',') > 1)
					{
						document.upd_all_action.list_button.disabled = true;
						document.upd_all_action.file_id_list.value = sayim_list;
						user_message = 'Stok Fişleri Ekleniyor Lütfen Bekleyiniz !';
						AjaxFormSubmit(upd_all_action,'user_message_demand',1,user_message,'<cf_get_lang dictionary_id="58786.Tamamlandı">!','','',1);
						return false;
					}
				}
				else
					return false;
			}
			else
			{
				alert("<cf_get_lang dictionary_id='36018.Lütfen Belge Seçiniz'>!");
				return false;
			}
		}			
	}
</script>

