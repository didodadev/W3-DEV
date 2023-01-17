﻿<cfset default_process_type = 113>
<cfquery name="get_default_departments" datasource="#dsn#">
	SELECT        
    	DEFAULT_MK_TO_RF_DEP, 
        DEFAULT_MK_TO_RF_LOC
	FROM            
    	EZGI_PDA_DEPARTMENT_DEFAULTS
	WHERE        
    	EPLOYEE_ID = #session.ep.userid#
</cfquery>
<cfif not get_default_departments.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='3141.Default Depo Ayarları Yapılmamış'>! <cf_get_lang_main no='2141.Sistem Yöneticisine Başvurun.'>");
		history.back();	
	</script>
</cfif>
<cfset default_departments = '#get_default_departments.DEFAULT_MK_TO_RF_DEP#'> <!---Depo seçiminde select satırına gelecek Lokasyonların depatmanları tanımlanır--->
<cfparam name="attributes.department_in_id" default="#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_DEP,2)#-#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_LOC,2)#">
<cfparam name="attributes.department_out_id" default="#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_DEP,2)#-#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_LOC,2)#">
<cfquery name="GET_ALL_LOCATION" datasource="#DSN#">
	SELECT        
    	D.DEPARTMENT_HEAD, 
        SL.DEPARTMENT_ID, 
        SL.LOCATION_ID, 
        SL.STATUS, 
        SL.COMMENT, 
        TBL.STORE_ID
	FROM            
    	STOCKS_LOCATION AS SL INNER JOIN
    	DEPARTMENT AS D ON SL.DEPARTMENT_ID = D.DEPARTMENT_ID INNER JOIN
      	BRANCH AS B ON D.BRANCH_ID = B.BRANCH_ID LEFT OUTER JOIN
     	(
        	SELECT        
            	STORE_ID, LOCATION_ID
         	FROM            
            	#dsn3_alias#.PRODUCT_PLACE
        	GROUP BY STORE_ID, LOCATION_ID
    	) AS TBL ON SL.LOCATION_ID = TBL.LOCATION_ID AND SL.DEPARTMENT_ID = TBL.STORE_ID
	WHERE        
    	D.DEPARTMENT_ID IN (#default_departments#) AND 
        SL.STATUS = 1 AND 
        TBL.STORE_ID IS NOT NULL
</cfquery>
<cfquery name="get_process_cat" datasource="#DSN3#">
	SELECT TOP (1)    
    	SPC.PROCESS_CAT_ID
	FROM         
    	SETUP_PROCESS_CAT AS SPC INNER JOIN
      	SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID INNER JOIN
    	SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
	WHERE     
    	SPC.PROCESS_TYPE = #default_process_type# AND 
        SPCF.FUSE_NAME = 'pda.form_add_ambar_fis' 
  	ORDER BY
    	SPC.PROCESS_CAT_ID DESC      
</cfquery>
<cfif not get_process_cat.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='3136.İşlem Kategorisi Tanımlayınız!'>");
		history.back();	
	</script>
</cfif>
<style type="text/css">
.boxtext {
	text-decoration: none;
	background-color: #e6e6fe;
	margin: 0px;
	padding: 0px;
	border-top-width: 0px;
	border-right-width: 0px;
	border-bottom-width: 0px;
	border-left-width: 0px;
}
.tablo {
	text-decoration: none;
	margin: 0px;
	padding: 0px;
	border-top-width: 1px;
	border-right-width: 0px;
	border-bottom-width: 1px;
	border-left-width: 0px;
	border-top-color: aec7f0;
	border-right-color: aec7f0;
	border-bottom-color: aec7f0;
	border-left-color: aec7f0;
}
</style>
<script language="javascript" type="text/javascript">
  var row_count = 0;
  var barcod = '';
  var stockid = '';
  var spectmainid = '';
  var stockcode = '';
  var amount = '';
  var ekle = 0;
  var cikar = 0;
  var islemtipi = 0;//0-ekle 1-çıkar
  var buton = 0;// <1-buton pasif, >0-buton aktif
</script>
<cfform name="form_basket">
  <cfinput id="process_cat_id" type="hidden" name="process_cat_id" value="#get_process_cat.process_cat_id#">
  <cfinput id="fis_tipi" type="hidden" name="fis_tipi" value="#default_process_type#">
  <input type="hidden" name="kuponlist" value="" />
  <input type="hidden" name="active_period" value="#session.ep.period_id#" />
  <div style="width:290px">
  <table cellpadding="2" cellspacing="1" align="left" class="color-border" width="99%">
    <tr class="color-list">
      <td colspan="4">
      	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="color-border">
          <tr class="color-list">
            <td align="center" width="40px"><cf_get_lang_main no='223.Miktar'></td>
            <td align="center" width="80px"><cf_get_lang_main no='221.Barkod'></td>
            <td align="center" width="70px"><cfoutput>#getLang('settings',1329)#</cfoutput></td>
            <td align="center" width="70px"><cfoutput>#getLang('main',3155)#</cfoutput></td>
       	  </tr>
          <tr class="color-list">
            <td><input id="add_other_amount" name="add_other_amount" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:40px; text-align:right" value="1" /></td>
            <td><input id="add_other_barcod" name="add_other_barcod" type="text" value="" style="width:80px;" ></td>
            <td><input id="add_out_shelf" name="add_out_shelf" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:70px;" value="" /></td>
            <td><input id="add_in_shelf" name="add_in_shelf" type="text" class="moneybox" onfocus="islemtipi=0;" style="width:70px;" value="" /></td>
          </tr>
          <tr class="color-list">
          	<td colspan="4">
              <table>
              	<tr>
                	<td style="height:15px"><cf_get_lang_main no='3156.Çıkış Raf Miktarı'></td>
                    <td id="shelf_select_td" style="display:none">
                        <select name="shelf_select" id="shelf_select" style="width:85px; text-align:center">
                            <option value=""><cf_get_lang_main no='3142.Ürün Rafları'></option>
                        </select>
                    </td>
                  </tr>
                </table>
			</td>
          </tr>
          <input id="del_other_amount" name="del_other_amount" type="hidden"  onfocus="islemtipi=1;" value="1" />
          <input id="del_other_barcod" name="del_other_barcod" type="hidden" value="" style="width:90px;" >
        </table>
      </td>
    </tr>
    <tr class="color-list">
      <td colspan="4">
      	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="color-border">
           <tr class="color-list">
            <td align="center" width="50%"><cf_get_lang_main no='1631.Çıkış Depo'></td>
            <td align="center" width="50%"><cfoutput>#getLang('objects',1268)#</cfoutput></td>
           </tr>
           <tr class="color-list">
            <td>
              <select name="txt_department_out" style="width:110px" onchange="document.getElementById('department_out').value = this.value">
                <cfoutput query="get_all_location" group="department_id">
                  <option disabled="disabled" value="#department_id#"<cfif attributes.department_out_id eq department_id>selected</cfif>>#department_head#</option>
                  <cfoutput>
                    <option <cfif not status>style="color:FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_out_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#
                    <cfif not status>
                      -
                      <cf_get_lang_main no='82.Pasif'>
                    </cfif>
                    </option>
                  </cfoutput> </cfoutput>
              </select>
          	</td>
            <td>
              <select name="txt_department_in" style="width:110px" onchange="document.getElementById('department_in').value = this.value">
                <cfoutput query="get_all_location" group="department_id">
                  <option disabled="disabled"  value="#department_id#"<cfif attributes.department_in_id eq department_id>selected</cfif>>#department_head#</option>
                  <cfoutput>
                    <option <cfif not status>style="color:FF0000"</cfif> value="#department_id#-#location_id#" <cfif attributes.department_in_id eq '#department_id#-#location_id#'>selected</cfif>>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;#comment#
                    <cfif not status>
                      -
                      <cf_get_lang_main no='82.Pasif'>
                    </cfif>
                    </option>
                  </cfoutput> </cfoutput>
              </select>
              </td>
          </tr>
        </table>
      </td>
    </tr>
    <tr class="color-list">
      <td width="55" align="center"><cf_get_lang_main no='221.Barkod'></td>
      <td width="25" align="right"><cf_get_lang_main no='223.Miktar'></td>
      <td width="50" align="left"><cfoutput>#getLang('settings',1329)#</cfoutput></td>
      <td width="50" align="left"><cf_get_lang_main no='3155.Giriş Rafı'></td>
    </tr>
    <tr class="color-list">
      <td align="left" colspan="4"><!---  kontrol edilen tablo--->
        <form name="product_row" id="product_row" method="post">
          <table name="table1" id="table1" border="0" cellpadding="0" cellspacing="0" width="100%" class="tablo">
          </table>
        </form>
        <!---  kontrol edilen tablo---></td>
    </tr>
    <tr class="color-list">
      <td colspan="6" align="right">
      	<input type="hidden" id="department_in" name="department_in" value="" />
      	<input type="hidden" id="row_count" name="row_count" value="0" />
        <input type="hidden" id="action_id" name="action_id" value="" />
        <input id="onay" name="Onay" value="<cf_get_lang_main no="49.Kaydet">" type="button" disabled="disabled" onClick="kontrol_kayit();" /></td>
        
    </tr>



  </table>
  </div>
</cfform>
<script language="javascript" type="text/javascript">
	document.getElementById('add_other_barcod').focus();
	setTimeout("document.getElementById('add_other_barcod').select();",1000);	
	function actionidolustur()
	{
	  var j = 0;
	  for(i=1;i<=row_count;i++)
	  {
		  if(document.getElementById('amount'+i).value > 0)
		  {
			if (j > 0)
			document.getElementById('action_id').value = document.getElementById('action_id').value + ',';
			document.getElementById('action_id').value = document.getElementById('action_id').value + i + '-';
			document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('stockid'+i).value + '-';
			document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('amount'+i).value + '-';
			document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('shelf_code_out'+i).value + '-';
			document.getElementById('action_id').value = document.getElementById('action_id').value + document.getElementById('shelf_code_in'+i).value
			j++;
		  }
		  document.getElementById('row_count').value = j;
	  }
	}

	function buton_kontrol()
	{
		if (islemtipi == 0)
			buton++;
		else if (buton>0)
			buton--;
		if (buton < 1)
			document.getElementById('onay').disabled = true;
		else
			document.getElementById('onay').disabled = false;
	}
	
	function get_stock(barcode)
    {
	 	/*shelf_code = '';*/ barcod = ''; stockid = ''; stockcode = ''; spectmainid = ''; //ilk önce sıfırlıyoruz
	 	k_= 0;
	 	if (k_ == 0)
     	{
			var new_sql = "SELECT SB.STOCK_ID,SB.BARCODE,PU.MAIN_UNIT,PU.MULTIPLIER, S.PRODUCT_NAME FROM STOCKS_BARCODES AS SB INNER JOIN PRODUCT_UNIT AS PU ON SB.UNIT_ID = PU.PRODUCT_UNIT_ID INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID WHERE SB.BARCODE= '"+barcode+"'";
		 	var get_product = wrk_query(new_sql,'dsn3');
		 	if (get_product.STOCK_ID == undefined)
		 	{
				ekle = 1;
				cikar = 1;
				k_=1;
				alert('<cf_get_lang_main no='3144.Ürün Bulunamadı'>');
		 	}
		 	else
		 	{	
				stockid = get_product.STOCK_ID;
				stockcode = get_product.PRODUCT_NAME;
				barcode = get_product.BARCODE;
				document.getElementById('add_out_shelf').focus();
				set_shelfs(stockid);
				buton_kontrol();
    		}
		}
		else
		{
			return false;
		}
	}

	function add_amount()
	{
	  document.getElementById('shelf_select_td').style.display='none';
	  if(row_count >0) /*ilk Satırdan sonrası*/
	  {
		  for(i=1;i<=row_count;i++)
		  {
			  if(document.getElementById('stockid'+i).value == stockid)
			  {
				  var stock_sql = "SELECT ISNULL(S.REAL_STOCK, 0) AS PRODUCT_STOCK FROM GET_STOCK_LAST_SHELF AS S INNER JOIN <cfoutput>#dsn3_alias#</cfoutput>.PRODUCT_PLACE AS P ON S.SHELF_NUMBER = P.PRODUCT_PLACE_ID WHERE P.SHELF_CODE = '"+document.getElementById('add_out_shelf').value+"' AND S.STOCK_ID ="+stockid;
				  var get_real_stock = wrk_query(stock_sql,'dsn2');
				  if(get_real_stock.PRODUCT_STOCK < document.getElementById('amount'+i).value - (-1 * amount))
				  {
					ekle=1;
					alert("<cf_get_lang_main no='3145.Yetersiz Stok'>. <cf_get_lang_main no='3154.Çıkış Rafındaki Stok Miktarı'>: "+get_real_stock.PRODUCT_STOCK);
					document.getElementById('add_other_amount').focus();
				  }
				  else
				  {
					  if(document.getElementById('stockid'+i).value == stockid && document.getElementById('shelf_code_out'+i).value == shelf_code_out && document.getElementById('shelf_code_in'+i).value == shelf_code_in)
					  {
						document.getElementById('amount'+i).value = document.getElementById('amount'+i).value - (-1 * amount);
						if (document.getElementById('frm_row'+i).style.display == 'none')
							document.getElementById('frm_row'+i).style.display='block';
						ekle=1;
					  }
				  }
			  }
		   }
	   }
	   else
	   {
		    var stock_sql = "SELECT ISNULL(S.REAL_STOCK, 0) AS PRODUCT_STOCK FROM GET_STOCK_LAST_SHELF AS S INNER JOIN <cfoutput>#dsn3_alias#</cfoutput>.PRODUCT_PLACE AS P ON S.SHELF_NUMBER = P.PRODUCT_PLACE_ID WHERE P.SHELF_CODE = '"+document.getElementById('add_out_shelf').value+"' AND S.STOCK_ID ="+stockid;
			var get_real_stock = wrk_query(stock_sql,'dsn2');
			if(get_real_stock.PRODUCT_STOCK < (amount*1))
			{
				ekle=1;
				alert("<cf_get_lang_main no='3145.Yetersiz Stok'>. <cf_get_lang_main no='3154.Çıkış Rafındaki Stok Miktarı'>: "+get_real_stock.PRODUCT_STOCK);
				document.getElementById('add_other_amount').focus();
			}
	   }
	}
	
	function add_row(barcode)
	{
		{
			  amount = document.getElementById('add_other_amount').value;
			  add_amount();
			  if (ekle == 0)
			  {
				row_count++;
				document.getElementById('row_count').value = row_count;
				var newRow;
				var newCell;	
				newRow = document.getElementById("table1").insertRow(document.getElementById("table1").rows.length);
				newRow.setAttribute("name","frm_row" + row_count);
				newRow.setAttribute("id","frm_row" + row_count);		
				newRow.setAttribute("NAME","frm_row" + row_count);
				newRow.setAttribute("ID","frm_row" + row_count);		
				
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="hidden" value="'+stockid+'" name="stockid'+row_count+'" id="stockid'+row_count+'" /><input type="hidden" value="'+spectmainid+'" name="spectmainid'+row_count+'" id="spectmainid'+row_count+'" /><input type="text" value="'+barcode+'" name="barcod'+row_count+'" id="barcod'+row_count+'" size="13" class="boxtext" readonly="yes" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" style="text-align:right" value="'+amount+'" name="amount'+row_count+'" id="amount'+row_count+'" size="5" class="boxtext" readonly="yes"  style="text-align:" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" value="'+shelf_code_out+'" name="shelf_code_out'+row_count+'" id="shelf_code_out'+row_count+'" size="12" class="boxtext" readonly="yes" style="text-align:right" />';
				newCell = newRow.insertCell();
				newCell.innerHTML = '<input type="text" value="'+shelf_code_in+'" name="shelf_code_in'+row_count+'" id="shelf_code_in'+row_count+'" size="12" class="boxtext" readonly="yes" style="text-align:right" />';
			  }
			  else
			  {
				 ekle = 0;
			  }
		}
	}
	function include(arr, obj) 
	{
    	for(var i=0; i<arr.length; i++) 
		{
        	if (arr[i] == obj) return true;
    	}
	}
</script>

<script language="JavaScript">
	document.onkeydown = checkKeycode
	function checkKeycode(e) 
	{
		var keycode;
		if (window.event) keycode = window.event.keyCode;
		else if (e) keycode = e.which;
		if (keycode == 13)
		{
			
			if (document.getElementById('add_other_barcod').value.length == '' && (document.getElementById('add_out_shelf').value.length >0 || document.getElementById('add_in_shelf').value.length > 0))
			{
				alert('<cf_get_lang_main no='3143.Önce Ürün Barkodu Okutunuz'>');
				document.getElementById('add_other_barcod').value = '';
				document.getElementById('add_other_shelf').value = '';
				document.getElementById('add_other_amount').value = 1;
				document.getElementById('add_other_barcod').focus();	
			}
			else
			{
				if (document.getElementById('add_out_shelf').value.length >0)
					search_shelf_out(document.getElementById('add_out_shelf').value);
				if(document.getElementById('add_in_shelf').value.length >0)
					search_shelf_in(document.getElementById('add_in_shelf').value);
				if(document.getElementById('add_in_shelf').value.length >0 && document.getElementById('add_out_shelf').value.length >0)		
				{
					if(document.getElementById('add_in_shelf').value == document.getElementById('add_out_shelf').value)
					{
						alert('<cf_get_lang_main no='3157.Giriş ve Çıkış Rafları Aynı Olamaz'>');
						document.getElementById('add_in_shelf').value = '';
						document.getElementById('add_in_shelf').focus();
						return false;
					}
					else	
					get_stock(document.getElementById('add_other_barcod').value);
				}
			}
		}
	}
	function search_shelf_out(shelf_8)
	{
		var cikis_depo = document.all.txt_department_out.value;
		var shelf_sql = "SELECT PRODUCT_PLACE_ID, STORE_ID, LOCATION_ID FROM PRODUCT_PLACE WHERE PLACE_STATUS = 1 AND SHELF_CODE = '"+shelf_8+"'";
		var get_shelf = wrk_query(shelf_sql,'dsn3');
		if(get_shelf.recordcount)
		{
			var cikis_depo_s = get_shelf.STORE_ID.toString()+'-'+get_shelf.LOCATION_ID.toString();
			if(cikis_depo != cikis_depo_s)
			{
					alert('<cf_get_lang_main no='3158.Seçtiğiniz Raf Çıkış Lokasyonunda Yoktur.'>!');	
					document.getElementById('add_other_barcod').value = '';
					document.getElementById('add_out_shelf').value = '';
					document.getElementById('add_other_barcod').focus();	
			}
			else
			{
				if (document.getElementById('add_other_barcod').value.length == 13)
				{
					var new_sql = "SELECT SB.STOCK_ID, SB.BARCODE, S.PRODUCT_NAME, PP.SHELF_CODE FROM STOCKS_BARCODES AS SB INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID INNER JOIN PRODUCT_PLACE_ROWS AS PPR ON S.PRODUCT_ID = PPR.PRODUCT_ID INNER JOIN PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID = PP.PRODUCT_PLACE_ID WHERE SB.BARCODE = '"+document.getElementById('add_other_barcod').value+"' AND PP.SHELF_CODE ='"+document.getElementById('add_out_shelf').value+"'";
		 			var get_product = wrk_query(new_sql,'dsn3');
					if (get_product.STOCK_ID == undefined)
					{
						alert('<cf_get_lang_main no='3149.Ürün Bu Rafa Tanıtılmamış'>');
						document.getElementById('add_out_shelf').value = '';
						document.getElementById('add_out_shelf').focus();
					}
					else
					{	
						document.getElementById('add_other_amount').disabled = true;
						document.getElementById('add_in_shelf').focus();
					}
				}
				else if (document.getElementById('add_other_barcod').value.length == 0)
				{
						document.getElementById('add_other_barcod').focus();	
				}
				else
				{
						alert('<cf_get_lang_main no='3150.Ürün Barkodu Hatalı'>');
						document.getElementById('add_other_barcod').value = '';
						document.getElementById('add_out_shelf').value = '';
						document.getElementById('add_in_shelf').value = '';
						document.getElementById('add_other_barcod').focus();
				}
			}
		}
		else
		{
			alert('<cf_get_lang_main no='3151.Seçtiğiniz Raf Hiç Tanımlanmamış'>!');
			document.getElementById('add_out_shelf').value = '';
			document.getElementById('add_in_shelf').value = '';
			document.getElementById('add_out_shelf').focus();
		}
	}
	function search_shelf_in(shelf_8)
	{
		var giris_depo = document.all.txt_department_in.value;
		var shelf_sql = "SELECT PRODUCT_PLACE_ID, STORE_ID, LOCATION_ID FROM PRODUCT_PLACE WHERE PLACE_STATUS = 1 AND SHELF_CODE = '"+shelf_8+"'";
		var get_shelf = wrk_query(shelf_sql,'dsn3');
		if(get_shelf.recordcount)
		{
			var giris_depo_s = get_shelf.STORE_ID.toString()+'-'+get_shelf.LOCATION_ID.toString();
			if(giris_depo != giris_depo_s)
			{
					alert('<cf_get_lang_main no='3148.Seçtiğiniz Raf Giriş Lokasyonunda Yoktur'>!');	
					document.getElementById('add_other_barcod').value = '';
					document.getElementById('add_in_shelf').value = '';
					document.getElementById('add_other_barcod').focus();	
			}
			else
			{
				if (document.getElementById('add_other_barcod').value.length == 13)
				{
					var new_sql = "SELECT SB.STOCK_ID, SB.BARCODE, S.PRODUCT_NAME, PP.SHELF_CODE FROM STOCKS_BARCODES AS SB INNER JOIN STOCKS AS S ON SB.STOCK_ID = S.STOCK_ID INNER JOIN PRODUCT_PLACE_ROWS AS PPR ON S.PRODUCT_ID = PPR.PRODUCT_ID INNER JOIN PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID = PP.PRODUCT_PLACE_ID WHERE SB.BARCODE = '"+document.getElementById('add_other_barcod').value+"' AND PP.SHELF_CODE ='"+document.getElementById('add_in_shelf').value+"'";
		 			var get_product = wrk_query(new_sql,'dsn3');
					if (get_product.STOCK_ID == undefined)
					{
						alert('<cf_get_lang_main no='3149.Ürün Bu Rafa Tanıtılmamış'>');
						document.getElementById('add_in_shelf').value = '';
						document.getElementById('add_in_shelf').focus();
					}
					else
					{	
						stockid = get_product.STOCK_ID;
						stockcode = get_product.PRODUCT_NAME;
						barcode = get_product.BARCODE;
						shelf_code_in = get_product.SHELF_CODE; 
						shelf_code_out = document.getElementById('add_out_shelf').value; 
						buton_kontrol();
						add_row(barcode);
						document.getElementById('add_other_barcod').value = '';
						document.getElementById('add_in_shelf').value = '';
						document.getElementById('add_out_shelf').value = '';
						document.getElementById('add_other_amount').disabled = false;
						document.getElementById('add_other_amount').value = 1;
						document.getElementById('add_other_barcod').focus();
					}
				}
				else if (document.getElementById('add_other_barcod').value.length == 0)
				{
						document.getElementById('add_other_barcod').focus();	
				}
				else
				{
						alert('<cf_get_lang_main no='3150.Ürün Barkodu Hatalı'>');
						document.getElementById('add_other_barcod').value = '';
						document.getElementById('add_in_shelf').value = '';
						document.getElementById('add_out_shelf').value = '';
						document.getElementById('add_other_barcod').focus();
				}
			}
		}
		else
		{
			alert('<cf_get_lang_main no='3151.Seçtiğiniz Raf Hiç Tanımlanmamış'>!');
			document.getElementById('add_in_shelf').value = '';
			document.getElementById('add_in_shelf').focus();
		}
	}
	function set_shelfs(xyz)
	{
		document.getElementById('shelf_select_td').style.display='';
		var product_shelfs = wrk_query("SELECT PP.SHELF_CODE, PPR.AMOUNT, PP.PRODUCT_PLACE_ID, ISNULL((SELECT REAL_STOCK FROM GET_STOCK_LAST_SHELF WHERE SHELF_NUMBER = PP.PRODUCT_PLACE_ID AND STOCK_ID = PPR.STOCK_ID),0) AS REAL_STOCK FROM <cfoutput>#dsn3_alias#</cfoutput>.PRODUCT_PLACE AS PP LEFT OUTER JOIN <cfoutput>#dsn3_alias#</cfoutput>.PRODUCT_PLACE_ROWS AS PPR ON PP.PRODUCT_PLACE_ID = PPR.PRODUCT_PLACE_ID WHERE PPR.STOCK_ID = "+xyz+" ORDER BY REAL_STOCK DESC","dsn2");
		var option_count = document.getElementById('shelf_select').options.length; 
		for(x=option_count;x>=0;x--)
			document.getElementById('shelf_select').options[x] = null;
		if(product_shelfs.recordcount != 0)
		{	
			for(var xx=0;xx<product_shelfs.recordcount;xx++)
			{
				document.getElementById('shelf_select').options[xx]=new Option(product_shelfs.SHELF_CODE[xx]+"-"+product_shelfs.REAL_STOCK[xx],product_shelfs.PRODUCT_PLACE_ID[xx],product_shelfs.AMOUNT[xx]);
			}
		}
		else
			document.getElementById('shelf_select').options[0] = new Option('Raf Tanımsız','');
	}
</script>
<script language="javascript" type="text/javascript">
		function kontrol_kayit()
		{
			if(form_basket.txt_department_in.value == "")
			{
				alert('<cf_get_lang_main no='311.Önce Depo Seçmelisiniz'>');
				return false;
			}
			else if(form_basket.txt_department_in.value.indexOf('-') == -1)
			{
				alert('<cf_get_lang_main no='3152.Lütfen giriş için doğru depo seçiniz'>');
				return false;
			}
			else
			{
			actionidolustur();
			window.location.href='<cfoutput>#request.self#</cfoutput>?fuseaction=pda.add_ambar_fis&change_shelf_fis=1&dep_in='+form_basket.txt_department_in.value+'&dep_out='+form_basket.txt_department_out.value+'&action_id='+document.getElementById('action_id').value+'&fis_tipi='+form_basket.fis_tipi.value+'&process_cat='+form_basket.process_cat_id.value;
			}
		}
		
</script>