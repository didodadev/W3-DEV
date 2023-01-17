<cfparam name="attributes.page" default=1>
<cfif isdefined("is_submitted")>
	<cf_date tarih = "attributes.start_date">
	<cfquery name="get_fileimports_total" datasource="#DSN2#">
		SELECT 
			FIT.FILE_IMPORTS_TOTAL_ID,
			FIT.PROCESS_DATE,
			FIT.STOCK_AMOUNT,
			FIT.FILE_AMOUNT,
			FIT.SPECT_MAIN_ID,
			FIT.SHELF_NUMBER,
			FIT.DELIVER_DATE,
            FIT.LOT_NO,
			S.PRODUCT_NAME,
			S.PROPERTY
		FROM
			FILE_IMPORTS_TOTAL FIT,
			#dsn3_alias#.STOCKS S
		WHERE 
			FIT.FIS_ID IS NULL AND
			S.STOCK_ID = FIT.STOCK_ID AND
			FIT.DEPARTMENT_ID = #attributes.department_id# AND
			FIT.DEPARTMENT_LOCATION = #attributes.location_id# AND
			FIT.PROCESS_DATE =  #attributes.start_date# AND
			(FIT.FILE_AMOUNT-FIT.STOCK_AMOUNT) <> 0
		ORDER BY
			(FIT.FILE_AMOUNT-FIT.STOCK_AMOUNT)  DESC
	</cfquery>
	<cfset arama_yapilmali = 0>
<cfelse>
	<cfset arama_yapilmali = 1>
	<cfset get_fileimports_total.recordcount=0>
</cfif>
<cfparam name="attributes.page" default=1>
<cfparam name="attributes.maxrows" default=100>
<cfparam name="attributes.totalrecords" default=#get_fileimports_total.recordcount#>
<cfset attributes.startrow=((attributes.page-1)*attributes.maxrows)+1>
<cfif isdate(attributes.start_date)>
	<cfset attributes.start_date = dateformat(attributes.start_date, dateformat_style)>
</cfif>
<cfif get_fileimports_total.recordcount>
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
</cfif>
<cfquery name="get_department" datasource="#dsn#">
	SELECT 	
		D.DEPARTMENT_HEAD,
		SL.COMMENT 
	FROM
		DEPARTMENT D,
		STOCKS_LOCATION SL
	WHERE
		D.DEPARTMENT_ID = SL.DEPARTMENT_ID AND
		D.DEPARTMENT_ID = #attributes.department_id# AND
		SL.LOCATION_ID = #attributes.location_id#
</cfquery>

<cfsavecontent variable="message"><cf_get_lang dictionary_id='36110.Sayım Sonucu Ekle (Yürüyen Stokların Birleşmiş Belgelerinden)'></cfsavecontent>
<cf_box title="#message#">
	<cfform name="sayim_fis" action="#request.self#?fuseaction=pos.emptypopup_file_import_total_sayim" method="post">
		<cf_grid_list>
		  <thead>
			  <tr>
				  <td class="txtbold">&nbsp;&nbsp;<cfoutput>#get_department.department_head#&nbsp;(#get_department.comment#)</cfoutput></td>
			  </tr>
			  <cfif get_fileimports_total.recordcount>
			  <tr>
				  <td style="text-align:right;" class="txtbold"><cf_get_lang dictionary_id ='36111.Sayım İçin'>
					  <select name="process_cat1" id="process_cat1" style="width:150px;">
						  <option value="" selected><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						  <cfoutput query="get_user_process_cat1">
							  <option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
						  </cfoutput>
					  </select>
					  <cf_get_lang dictionary_id ='36112.Fire İçin'>
					  <select name="process_cat2" id="process_cat2" style="width:150px;">
						  <option value="" selected><cf_get_lang dictionary_id ='57734.Seçiniz'></option>
						  <cfoutput query="get_user_process_cat2">
							  <option value="#PROCESS_CAT_ID#">#PROCESS_CAT#</option>
						  </cfoutput>
					  </select>
				  </td>
			  </tr> 
			  </cfif>
		  </thead>
	  </cf_grid_list>
	   <cf_grid_list>
		  <thead>
			  <tr>
				  <th width="75"><cf_get_lang dictionary_id ='57742.Tarih'></th>
				  <th width="75"><cf_get_lang dictionary_id ='57657.Ürün'></th>
				  <th width="75"><cf_get_lang dictionary_id='45420.Main Spec ID'></th>
				  <th width="75"><cf_get_lang dictionary_id ='36088.Raf'></th>
				  <th width="130"><cf_get_lang dictionary_id ='36089.Son Kullanma Tarihi'></th>
				  <th width="130"><cf_get_lang dictionary_id='45498.Lot No'></th>
				  <th><cf_get_lang dictionary_id ='36113.Olması Gereken Stok Toplam'></th>
				  <th width="150"><cf_get_lang dictionary_id ='36114.Sayılan Toplam'></th>
				  <th width="15" class="header_icn_none"><cfif get_fileimports_total.recordcount><input type="checkbox" name="herkes" id="herkes" value="1" onclick="check_all(this.checked);"></cfif></th>
			  </tr>
		  </thead>
		  <tbody>
		  <cfif get_fileimports_total.recordcount>	
			  <input type="hidden" name="islem_tarihi" id="islem_tarihi" value="<cfoutput>#dateformat(get_fileimports_total.PROCESS_DATE,dateformat_style)#</cfoutput>">
			  <cfoutput query="get_fileimports_total" startrow="#attributes.startrow#" maxrows="#attributes.maxrows#">
				  <tr>
					  <td>#dateformat(PROCESS_DATE,dateformat_style)#</td>
					  <td>#PRODUCT_NAME# - #PROPERTY#</td>
					  <td>#SPECT_MAIN_ID#</td>
					  <td>#SHELF_NUMBER#</td>
					  <td>#dateformat(DELIVER_DATE,dateformat_style)#</td>
					  <td>#lot_no#</td>
					  <td>#STOCK_AMOUNT#</td>            
					  <td>#FILE_AMOUNT#</td>
					  <td width="15"><input type="checkbox" name="file_import_total" id="file_import_total" value="#FILE_IMPORTS_TOTAL_ID#"></td>
				  </tr>
			  </cfoutput>
		  <cfelse>
			  <tr>
				  <td colspan="9"><cfif arama_yapilmali neq 1><cf_get_lang dictionary_id='57484.Kayıt Bulunamadı'>!<cfelse><cf_get_lang dictionary_id ='57701.Filtre Ediniz'>!</cfif></td>
			  </tr>
		  </cfif>
		  </tbody>
		  <cfif get_fileimports_total.recordcount>
			  <tfoot>
				  <tr>
					  <td colspan="10" style="text-align:right;">
						  <cfsavecontent variable="alert"><cf_get_lang dictionary_id ='36115.Fiş Ekle'></cfsavecontent>
						  <cf_workcube_buttons is_upd='0' insert_info = '#alert#' add_function='kontrol()' type_format="1">
					  </td>
				  </tr>
			  </tfoot>
		  </cfif>
	  </cf_grid_list>
   </cfform>
</cf_box>
    
<script type="text/javascript">
	function check_all(deger)
	{
		<cfif get_fileimports_total.recordcount gt 1>
			for(i=0; i<sayim_fis.file_import_total.length; i++)
			sayim_fis.file_import_total[i].checked = deger;
		<cfelseif get_fileimports_total.recordcount eq 1>
			sayim_fis.file_import_total.checked = deger;
		</cfif>
	}
	function kontrol()
	{
		x=document.sayim_fis.process_cat1.selectedIndex;
		y=document.sayim_fis.process_cat2.selectedIndex;
		if((document.sayim_fis.process_cat1[x].value=='') || (document.sayim_fis.process_cat2[y].value==''))
		{
			alert("<cf_get_lang dictionary_id ='36116.Sayım ve Fire Fişleri İçin İşlem Tipi Seçiniz'>!");
			return false;
		}
		else
			return true;
	}
</script>

