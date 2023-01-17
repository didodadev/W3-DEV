﻿<cf_get_lang_set module_name="stock">
<cfsetting showdebugoutput="yes">
<cfset default_fire_process_type = 112>
<cfset default_sayim_process_type = 115>
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
		<!---history.back();	--->
	</script>
    <cfabort>
</cfif>
<cfset default_departments = '#get_default_departments.DEFAULT_MK_TO_RF_DEP#'> <!---Depo seçiminde select satırına gelecek Lokasyonların depatmanları tanımlanır--->
<cfparam name="attributes.department_in_id" default="#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_DEP,2)#-#ListGetAt(get_default_departments.DEFAULT_MK_TO_RF_LOC,2)#">
<cfparam name="attributes.raf" default="">
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
		D.DEPARTMENT_ID IN (#default_departments#) AND
		SL.DEPARTMENT_ID = D.DEPARTMENT_ID AND
		SL.STATUS = 1 AND
		D.BRANCH_ID = B.BRANCH_ID
</cfquery>

<cfquery name="get_process_cat_sayim" datasource="#DSN3#">
	SELECT TOP (1)    
    	SPC.PROCESS_CAT_ID
	FROM         
    	SETUP_PROCESS_CAT AS SPC INNER JOIN
      	SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID INNER JOIN
    	SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
	WHERE     
    	SPC.PROCESS_TYPE = #default_sayim_process_type# AND 
        SPCF.FUSE_NAME = 'pda.form_add_ambar_fis' 
  	ORDER BY
    	SPC.PROCESS_CAT_ID DESC      
</cfquery>
<cfif not get_process_cat_sayim.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1835.Sayım Fişi'> <cf_get_lang_main no='3136.İşlem Kategorisi Tanımlayınız!'>");
		<!---history.back();	--->
	</script>
    <cfabort>
</cfif>

<cfquery name="get_process_cat_fire" datasource="#DSN3#">
	SELECT TOP (1)    
    	SPC.PROCESS_CAT_ID
	FROM         
    	SETUP_PROCESS_CAT AS SPC INNER JOIN
      	SETUP_PROCESS_CAT_FUSENAME AS SPCF ON SPC.PROCESS_CAT_ID = SPCF.PROCESS_CAT_ID INNER JOIN
    	SETUP_PROCESS_CAT_ROWS AS SPCR ON SPC.PROCESS_CAT_ID = SPCR.PROCESS_CAT_ID
	WHERE     
    	SPC.PROCESS_TYPE = #default_fire_process_type# AND 
        SPCF.FUSE_NAME = 'pda.form_add_ambar_fis' 
  	ORDER BY
    	SPC.PROCESS_CAT_ID DESC      
</cfquery>
<cfif not get_process_cat_fire.recordcount>
	<script type="text/javascript">
		alert("<cf_get_lang_main no='1832.Fire Fişi'> <cf_get_lang_main no='3136.İşlem Kategorisi Tanımlayınız!'>");
		<!---history.back();	--->
	</script>
    <cfabort>
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
<cfif isdefined('attributes.form_submitted')>
	<cfquery name="GET_REAL_STOCKS" datasource="#dsn3#">
    	SELECT        
        	ISNULL((
            	SELECT        
                	REAL_STOCK
              	FROM            
                	#dsn2_alias#.GET_STOCK_LAST_SHELF
            	WHERE        
                	SHELF_NUMBER = PP.PRODUCT_PLACE_ID AND 
                    STOCK_ID = PPR.STOCK_ID
          	), 0) AS REAL_STOCK, 
            PP.PRODUCT_PLACE_ID,
            SB.BARCODE, 
            SB.STOCK_ID
		FROM            
        	STOCKS_BARCODES AS SB INNER JOIN
         	PRODUCT_PLACE_ROWS AS PPR ON SB.STOCK_ID = PPR.STOCK_ID RIGHT OUTER JOIN
          	PRODUCT_PLACE AS PP ON PPR.PRODUCT_PLACE_ID = PP.PRODUCT_PLACE_ID
		WHERE        
        	PP.STORE_ID = #ListGetAt(attributes.department_in_id,1,'-')# AND 
            PP.LOCATION_ID = #ListGetAt(attributes.department_in_id,2,'-')# AND 
            PP.SHELF_CODE = '#attributes.raf#'
		ORDER BY 
        	REAL_STOCK DESC
    </cfquery>
    <cfquery name="get_department_head" dbtype="query">
    	SELECT COMMENT FROM GET_ALL_LOCATION WHERE DEPARTMENT_ID = #ListGetAt(attributes.department_in_id,1,'-')# AND LOCATION_ID = #ListGetAt(attributes.department_in_id,2,'-')#
    </cfquery>
</cfif>

<cfform name="add_stock_count" id="add_stock_count" method="post" action="" enctype="multipart/form-data"> 
  <cfinput name="form_submitted" value="1" type="hidden">
  <cfinput id="sayim_process_cat_id" type="hidden" name="sayim_process_cat_id" value="#get_process_cat_sayim.process_cat_id#">
  <cfinput id="fire_process_cat_id" type="hidden" name="fire_process_cat_id" value="#get_process_cat_fire.process_cat_id#">
   <div style="width:290px">
  <table cellpadding="2" cellspacing="1" align="left" class="color-border" width="99%">
    <tr>
      <td colspan="5" class="color-list" height="20" align="center"><b><cf_get_lang_main no='2891.Depo Raf Düzenleme'></b></td>
    </tr>
    <tr class="color-list">
      <td colspan="5">
      	<table border="0" cellpadding="0" cellspacing="0" width="100%" class="color-border">
           	<tr class="color-list">
            	<td align="center" width="40"><b><cf_get_lang_main no="1351.Depo"></b></td>
            	<td width="100">
					<cfif isdefined('attributes.form_submitted')>
                        <cfoutput>#get_department_head.COMMENT#</cfoutput>
                        <input type="hidden" name="department_in_id" value="<cfoutput>#attributes.department_in_id#</cfoutput>">
                    <cfelse>
                          <select id="department_in_id" name="department_in_id" style="width:110px" onchange="document.getElementById('department_in').value = this.value">
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
                    </cfif>
               	</td>
                <td align="center" width="30"><b><cfoutput>#getLang('prod',401)#</cfoutput></b></td>
                <td width="70">
                	<cfoutput>
                	<cfif isdefined('attributes.form_submitted')>
                    	#attributes.raf#
                    	<input id="raf" name="raf" type="hidden" value="#attributes.raf#">
                    <cfelse>
                    	<input id="raf" name="raf" type="text"  style="width:65px; text-align:left" onKeyPress="return noenter()"> 
                    </cfif>
                    </cfoutput>
                </td>
          	</tr>
        </table>
      </td>
    </tr>
    <tr class="color-list">
      <td width="30" align="center"><cf_get_lang_main no='1165.Sıra'></td>
      <td width="70" align="center"><cf_get_lang_main no='221.Barkod'></td>
      <td width="35" align="right"><cf_get_lang_main no='223.Miktar'></td>
      <td width="35" align="right"><cfoutput>#getLang('myhome',1283)#</cfoutput></td>
      <td width="35" align="right"><cf_get_lang_main no='272.Sonuç'></td>
    </tr>
	<cfif isdefined('attributes.form_submitted')>
      	<cfif GET_REAL_STOCKS.recordcount>
        	<input type="hidden" id="row_count" name="row_count" value="<cfoutput>#GET_REAL_STOCKS.recordcount#</cfoutput>" />
            <input type="hidden" id="product_place_id" name="product_place_id" value="<cfoutput>#GET_REAL_STOCKS.PRODUCT_PLACE_ID#</cfoutput>" />
			<cfoutput query="GET_REAL_STOCKS">
              	<tr class="color-list">	
                	<input type="hidden" name="stock_id#currentrow#" id="stock_id#currentrow#" style="width:30px" value="#STOCK_ID#">
                    <td style="text-align:right">
                    	<cfif REAL_STOCK eq 0>
                        	<a style="cursor:pointer" onclick="delete_stock_id(#GET_REAL_STOCKS.PRODUCT_PLACE_ID#,#STOCK_ID#);"><img src="images/delete_list.gif"  title="#getLang('main',3163)#" border="0" style=" vertical-align:bottom"></a>
                        </cfif>
                        #currentrow#
                    </td>
                    <td>#BARCODE#</td>
                    <td style="text-align:right">
                    	#TlFormat(REAL_STOCK,0)#
                    	<input type="hidden" name="old_amount#currentrow#" id="old_amount#currentrow#" style="width:30px" value="#REAL_STOCK#">
                    </td>
                    <td style="text-align:right">
                    	<input type="text" name="new_amount#currentrow#" id="new_amount#currentrow#" value="#TlFormat(REAL_STOCK,0)#" style="width:30px; text-align:right" onChange="calc_amount(#currentrow#,#real_stock#,this.value)" onKeyPress="return noenter()">
                    </td>
                    <td style="text-align:right">
                    	<input type="text" name="calc_amount#currentrow#" id="calc_amount#currentrow#" class="boxtext" value="0" readonly style="width:30px; text-align:right">
                    </td>
             	</tr>
       		</cfoutput>
     	<cfelse>
        	<tr class="color-list">	
            	<td colspan="5"><cf_get_lang_main no='72.Kayıt Yok'></td> 	
           	</tr>
      	</cfif>
   	<cfelse>
    	<tr class="color-list">	
     		<td colspan="5"><cf_get_lang_main no='289.Filtre Ediniz'></td>
        </tr> 
   	</cfif>
    <tr class="color-list">
      <td colspan="5" align="right">
      	<cfif not isdefined('attributes.form_submitted')>
        	<input id="ara" name="ara" value="   <cf_get_lang_main no="153.Ara">   " type="button" onClick="search_self();" /></td>
        <cfelse>
            
            <input id="onay" name="Onay" style="display:none" value="<cf_get_lang_main no="49.Kaydet">" type="button" disabled="disabled" onClick="kontrol_kayit();" /></td>
        </cfif>
    </tr>
  </table>
  </div>
</cfform>
<script language="javascript" type="text/javascript">
	document.getElementById('raf').focus();
	setTimeout("document.getElementById('add_other_amount').select();",1000);	
	function search_self()
	{
		raf = document.getElementById('raf').value;
		depo = document.getElementById('department_in_id').value;
		var new_sql = "SELECT PRODUCT_PLACE_ID FROM EZGI_PRODUCT_PLACE WHERE DEPO = '"+depo+"' AND SHELF_CODE = '"+raf+"' AND PLACE_STATUS = 1";
		var get_raf = wrk_query(new_sql,'dsn3');
		if (get_raf.PRODUCT_PLACE_ID== undefined)
		{
			alert('Bu Lokasyonda '+raf+' Raf Tanımı Yoktur!');
			document.getElementById('raf').focus();
		}
		else
		{
			document.getElementById("add_stock_count").submit();
		}
	}
	function kontrol_kayit()
	{
		sor=confirm('<cf_get_lang_main no='3165.Kaydetmek İstiyor Musunuz?'>');
		if (sor == true)
		{
			document.getElementById("add_stock_count").action = "<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_add_ezgi_stock_update_file";
			document.getElementById("add_stock_count").submit();
		}
		else
		return false;
		
	}
	function delete_stock_id(product_place_id,stock_id)
	{
		windowopen('<cfoutput>#request.self#</cfoutput>?fuseaction=pda.emptypopup_del_ezgi_product_place_stock&product_place_id='+product_place_id+'&stock_id='+stock_id,'small');	
	}
	function calc_amount(calcrow,oldvalue,newvalue)
	{
		document.getElementById('calc_amount'+calcrow).value = newvalue-oldvalue;	
		document.getElementById('onay').style.display = '';
		document.getElementById('onay').disabled = false;
	}
	function noenter() 
	{
  		return !(window.event && window.event.keyCode == 13);
	}
</script>